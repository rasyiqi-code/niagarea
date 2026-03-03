import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:niagarea/data/daos/produk_dao.dart';
import 'package:niagarea/data/database/app_database.dart';
import 'package:niagarea/services/digiflazz/digiflazz_client.dart';
import 'package:niagarea/services/digiflazz/digiflazz_models.dart';
import 'package:niagarea/services/digiflazz/sync_service.dart';

class MockDigiflazzClient extends Mock implements DigiflazzClient {}

class MockProdukDao extends Mock implements ProdukDao {}

void main() {
  late SyncService syncService;
  late MockDigiflazzClient mockClient;
  late MockProdukDao mockDao;

  setUp(() {
    mockClient = MockDigiflazzClient();
    mockDao = MockProdukDao();
    syncService = SyncService(client: mockClient, produkDao: mockDao);

    registerFallbackValue(<ProdukTableCompanion>[]);
  });

  group('SyncService - sinkronisasiProduk', () {
    test('berhasil memfilter produk aktif dan simpan ke DAO', () async {
      final mockData = [
        const ProdukDigiflazz(
          productName: 'XL 10k',
          category: 'Pulsa XL',
          brand: 'XL',
          buyerSkuCode: 'xld10',
          price: 10500,
          buyerProductStatus: true,
        ),
        const ProdukDigiflazz(
          productName: 'Indosat 5k',
          category: 'Data Indosat',
          brand: 'Indosat',
          buyerSkuCode: 'id5',
          price: 5200,
          buyerProductStatus: false, // Non-aktif
        ),
      ];

      when(
        () => mockClient.ambilDaftarHarga(cmd: any(named: 'cmd')),
      ).thenAnswer((_) async => DaftarHargaResponse(data: mockData));

      when(() => mockDao.upsertProdukBatch(any())).thenAnswer((_) async => {});

      final result = await syncService.sinkronisasiProduk();

      expect(result.totalDariApi, 2);
      expect(result.totalDisimpan, 1);
      expect(result.totalDiSkip, 1);

      // Verifikasi DAO dipanggil dengan list berisi 1 companion
      final captured = verify(
        () => mockDao.upsertProdukBatch(captureAny()),
      ).captured;
      final companions = captured.last as List<ProdukTableCompanion>;

      expect(companions.length, 1);
      expect(companions.first.kodeDigiflazz.value, 'xld10');
      expect(companions.first.nama.value, 'XL 10k');
      // Verifikasi normalisasi kategori
      expect(companions.first.kategori.value, 'Pulsa');
    });

    test('simpanSemuaStatus: true akan menyimpan semua produk', () async {
      final mockData = [
        const ProdukDigiflazz(
          productName: 'P1',
          category: 'C1',
          brand: 'B1',
          buyerSkuCode: 'k1',
          price: 1000,
          buyerProductStatus: false,
        ),
      ];

      when(
        () => mockClient.ambilDaftarHarga(cmd: any(named: 'cmd')),
      ).thenAnswer((_) async => DaftarHargaResponse(data: mockData));
      when(() => mockDao.upsertProdukBatch(any())).thenAnswer((_) async => {});

      final result = await syncService.sinkronisasiProduk(
        simpanSemuaStatus: true,
      );

      expect(result.totalDisimpan, 1);
      expect(result.totalDiSkip, 0);
    });

    test('menangani response kosong dari API', () async {
      when(
        () => mockClient.ambilDaftarHarga(cmd: any(named: 'cmd')),
      ).thenAnswer((_) async => const DaftarHargaResponse(data: []));

      final result = await syncService.sinkronisasiProduk();

      expect(result.totalDariApi, 0);
      expect(result.totalDisimpan, 0);
      verifyNever(() => mockDao.upsertProdukBatch(any()));
    });
  });

  group('SyncService - Normalisasi Kategori', () {
    test('memetakan kategori Digiflazz ke kategori lokal', () async {
      // Kita uji via sinkronisasiProduk karena _normalizeKategori private
      final testCases = {
        'Pulsa Reguler': 'Pulsa',
        'Data 24 Jam': 'Paket Data',
        'Token PLN': 'Token Listrik',
        'E-Money Mandiri': 'E-Money',
        'Voucher Mobile Legends': 'Voucher Game',
        'Asing': 'Asing', // No mapping
      };

      for (final entry in testCases.entries) {
        final mockData = [
          ProdukDigiflazz(
            productName: 'P',
            category: entry.key,
            brand: 'B',
            buyerSkuCode: 'K',
            price: 100,
            buyerProductStatus: true,
          ),
        ];

        when(
          () => mockClient.ambilDaftarHarga(cmd: any(named: 'cmd')),
        ).thenAnswer((_) async => DaftarHargaResponse(data: mockData));
        when(
          () => mockDao.upsertProdukBatch(any()),
        ).thenAnswer((_) async => {});

        await syncService.sinkronisasiProduk();

        final captured = verify(
          () => mockDao.upsertProdukBatch(captureAny()),
        ).captured;
        final companions = captured.last as List<ProdukTableCompanion>;

        expect(
          companions.first.kategori.value,
          entry.value,
          reason: 'Gagal memetakan ${entry.key}',
        );
      }
    });
  });
}
