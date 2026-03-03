import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:niagarea/services/digiflazz/digiflazz_client.dart';
import 'package:niagarea/services/digiflazz/digiflazz_config.dart';

class MockDio extends Mock implements Dio {}

class MockDigiflazzConfig extends Mock implements DigiflazzConfig {}

void main() {
  late DigiflazzClient client;
  late MockDio mockDio;
  late MockDigiflazzConfig mockConfig;

  setUp(() {
    mockDio = MockDio();
    mockConfig = MockDigiflazzConfig();
    client = DigiflazzClient(config: mockConfig, dio: mockDio);

    // Mock default credentials
    when(() => mockConfig.getUsername()).thenAnswer((_) async => 'user123');
    when(() => mockConfig.getApiKey()).thenAnswer((_) async => 'key123');
    when(() => mockConfig.isTestMode()).thenAnswer((_) async => false);
  });

  group('DigiflazzClient - cekSaldo', () {
    test('berhasil mengembalikan SaldoResponse', () async {
      final mockData = {
        'data': {'username': 'user123', 'deposit': 50000},
      };

      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          data: mockData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await client.cekSaldo();

      expect(result.deposit, 50000);
      verify(() => mockDio.post(any(), data: any(named: 'data'))).called(1);
    });

    test('melempar DigiflazzException jika credential kosong', () async {
      when(() => mockConfig.getUsername()).thenAnswer((_) async => '');

      expect(
        () => client.cekSaldo(),
        throwsA(
          predicate(
            (e) =>
                e is DigiflazzException &&
                e.type == DigiflazzErrorType.noCredential,
          ),
        ),
      );
    });

    test('melempar DigiflazzException jika koneksi timeout', () async {
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(
        () => client.cekSaldo(),
        throwsA(
          predicate(
            (e) =>
                e is DigiflazzException && e.type == DigiflazzErrorType.timeout,
          ),
        ),
      );
    });
  });

  group('DigiflazzClient - ambilDaftarHarga', () {
    test('berhasil mengembalikan DaftarHargaResponse', () async {
      final mockData = {
        'data': [
          {
            'product_name': 'XL 10k',
            'category': 'Pulsa',
            'brand': 'XL',
            'buyer_sku_code': 'xld10',
            'price': 10500,
            'buyer_product_status': true,
            'seller_product_status': true,
            'unlimited_stock': true,
            'stock': 100,
            'multi': true,
            'type': 'prepaid',
          },
        ],
      };

      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          data: mockData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await client.ambilDaftarHarga();

      expect(result.data.length, 1);
      expect(result.data.first.productName, 'XL 10k');
      expect(result.data.first.buyerSkuCode, 'xld10');
    });
  });

  group('DigiflazzClient - kirimTransaksi', () {
    test('berhasil mengembalikan TransaksiDigiflazzResponse', () async {
      final mockData = {
        'data': {
          'ref_id': 'uuid-1',
          'customer_no': '08123',
          'buyer_sku_code': 'xld10',
          'status': 'Pending',
          'message': 'Transaksi diproses',
          'price': 10500,
          'tele': '08123',
          'sn': '',
        },
      };

      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          data: mockData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await client.kirimTransaksi(
        buyerSkuCode: 'xld10',
        customerNo: '08123',
        refId: 'uuid-1',
      );

      expect(result.refId, 'uuid-1');
      expect(result.status, 'Pending');
      expect(result.price, 10500);
    });

    test('mengirim field testing: true jika mode testing aktif', () async {
      when(() => mockConfig.isTestMode()).thenAnswer((_) async => true);

      final mockData = {
        'data': {'status': 'Success'},
      };

      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          data: mockData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      await client.kirimTransaksi(
        buyerSkuCode: 'xld10',
        customerNo: '08123',
        refId: 'uuid-2',
      );

      // Verifikasi data yang dikirim mengandung 'testing': true
      final captured = verify(
        () => mockDio.post(any(), data: captureAny(named: 'data')),
      ).captured;

      expect(captured.length, 1);
      final data = captured.last as Map;
      expect(data['testing'], true);
    });
  });
}
