import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:niagarea/data/daos/antrian_dao.dart';
import 'package:niagarea/data/daos/transaksi_dao.dart';
import 'package:niagarea/data/database/app_database.dart';
import 'package:niagarea/domain/fifo/fifo_engine.dart';
import 'package:niagarea/services/digiflazz/digiflazz_client.dart';
import 'package:niagarea/services/digiflazz/digiflazz_models.dart';
import 'package:niagarea/services/digiflazz/transaction_queue_service.dart';

class MockDigiflazzClient extends Mock implements DigiflazzClient {}

class MockAntrianDao extends Mock implements AntrianDao {}

class MockFifoEngine extends Mock implements FifoEngine {}

class MockTransaksiDao extends Mock implements TransaksiDao {}

void main() {
  late TransactionQueueService queueService;
  late MockDigiflazzClient mockClient;
  late MockAntrianDao mockDao;
  late MockFifoEngine mockFifo;
  late MockTransaksiDao mockTransaksiDao;

  setUp(() {
    mockClient = MockDigiflazzClient();
    mockDao = MockAntrianDao();
    mockFifo = MockFifoEngine();
    mockTransaksiDao = MockTransaksiDao();
    queueService = TransactionQueueService(
      client: mockClient,
      antrianDao: mockDao,
      transaksiDao: mockTransaksiDao,
      fifoEngine: mockFifo,
    );

    registerFallbackValue(const AntrianDigiflazzTableCompanion());
    when(() => mockTransaksiDao.updateStatusKirim(any(), any())).thenAnswer(
      (_) async => true,
    );
  });

  group('TransactionQueueService - tambahDanKirim', () {
    test('berhasil menambah ke antrian dan kirim sukses', () async {
      when(() => mockDao.tambahKeAntrian(any())).thenAnswer((_) async => 1);
      when(
        () => mockClient.kirimTransaksi(
          buyerSkuCode: any(named: 'buyerSkuCode'),
          customerNo: any(named: 'customerNo'),
          refId: any(named: 'refId'),
        ),
      ).thenAnswer(
        (_) async => const TransaksiDigiflazzResponse(
          refId: 'r1',
          buyerSkuCode: 'p1',
          customerNo: '081',
          price: 1000,
          message: 'Sukses',
          status: 'Sukses',
        ),
      );

      when(
        () => mockDao.updateStatusKirim(any(), any(), any()),
      ).thenAnswer((_) async => true);

      await queueService.tambahDanKirim(
        idTransaksi: 10,
        kodeProduk: 'p1',
        tujuan: '081',
      );

      verify(() => mockDao.tambahKeAntrian(any())).called(1);
      verify(
        () => mockClient.kirimTransaksi(
          buyerSkuCode: 'p1',
          customerNo: '081',
          refId: any(named: 'refId'),
        ),
      ).called(1);
      verify(() => mockDao.updateStatusKirim(1, 'sukses', any())).called(1);
      verifyNever(() => mockFifo.rollbackKonsumsi(any()));
    });

    test('gagal kirim (API Gagal) -> panggil rollback FIFO', () async {
      when(() => mockDao.tambahKeAntrian(any())).thenAnswer((_) async => 2);
      when(
        () => mockClient.kirimTransaksi(
          buyerSkuCode: any(named: 'buyerSkuCode'),
          customerNo: any(named: 'customerNo'),
          refId: any(named: 'refId'),
        ),
      ).thenAnswer(
        (_) async => const TransaksiDigiflazzResponse(
          refId: 'r2',
          buyerSkuCode: 'p2',
          customerNo: '082',
          price: 1000,
          message: 'Gagal',
          status: 'Gagal', // Status eksplisit Gagal
        ),
      );

      when(
        () => mockDao.updateStatusKirim(any(), any(), any()),
      ).thenAnswer((_) async => true);
      when(() => mockFifo.rollbackKonsumsi(any())).thenAnswer((_) async => {});

      await queueService.tambahDanKirim(
        idTransaksi: 20,
        kodeProduk: 'p2',
        tujuan: '082',
      );

      verify(() => mockDao.updateStatusKirim(2, 'gagal', any())).called(1);
      verify(() => mockFifo.rollbackKonsumsi(20)).called(1);
    });

    test('error koneksi -> biarkan pending (tidak rollback)', () async {
      when(() => mockDao.tambahKeAntrian(any())).thenAnswer((_) async => 3);
      when(
        () => mockClient.kirimTransaksi(
          buyerSkuCode: any(named: 'buyerSkuCode'),
          customerNo: any(named: 'customerNo'),
          refId: any(named: 'refId'),
        ),
      ).thenThrow(
        const DigiflazzException('Timeout', type: DigiflazzErrorType.timeout),
      );

      await queueService.tambahDanKirim(
        idTransaksi: 30,
        kodeProduk: 'p3',
        tujuan: '083',
      );

      // Status tetap pending (default saat insert), kirimUlang akan dicoba nanti
      verifyNever(() => mockDao.updateStatusKirim(any(), any(), any()));
      verifyNever(() => mockFifo.rollbackKonsumsi(any()));
    });
  });

  group('TransactionQueueService - prosesSemuaPending', () {
    test('memproses list transaksi pending', () async {
      final pendingList = <AntrianDigiflazz>[
        AntrianDigiflazz(
          id: 1,
          idTransaksi: 101,
          kodeProduk: 'p1',
          tujuan: 'n1',
          refId: 'r1',
          statusKirim: 'pending',
          responseApi: '',
          createdAt: DateTime.now(),
        ),
      ];

      when(() => mockDao.ambilPending()).thenAnswer((_) async => pendingList);
      when(() => mockDao.hitungPending()).thenAnswer((_) async => 0);
      when(
        () => mockClient.kirimTransaksi(
          buyerSkuCode: any(named: 'buyerSkuCode'),
          customerNo: any(named: 'customerNo'),
          refId: any(named: 'refId'),
        ),
      ).thenAnswer(
        (_) async => const TransaksiDigiflazzResponse(
          refId: 'r1',
          buyerSkuCode: 'p1',
          customerNo: 'n1',
          price: 1000,
          message: 'Sukses',
          status: 'Sukses',
        ),
      );
      when(
        () => mockDao.updateStatusKirim(any(), any(), any()),
      ).thenAnswer((_) async => true);

      final result = await queueService.prosesSemuaPending();

      expect(result.sukses, 1);
      expect(result.pending, 0);
      verify(() => mockDao.updateStatusKirim(1, 'sukses', any())).called(1);
    });
  });
}
