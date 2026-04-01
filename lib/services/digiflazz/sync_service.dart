import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';

import '../../data/daos/produk_dao.dart';
import '../../data/database/app_database.dart';
import 'digiflazz_client.dart';
import 'digiflazz_config.dart';
import 'digiflazz_models.dart';

/// Hasil sinkronisasi produk.
class SyncResult {
  final int totalDariApi;
  final int totalDisimpan;
  final int totalDiSkip;
  final String pesan;

  const SyncResult({
    required this.totalDariApi,
    required this.totalDisimpan,
    required this.totalDiSkip,
    required this.pesan,
  });
}

/// Progress sinkronisasi untuk UI.
class SyncProgress {
  final int total;
  final int current;
  final String status;

  const SyncProgress({
    required this.total,
    required this.current,
    required this.status,
  });

  double get percentage => total > 0 ? (current / total).clamp(0.0, 1.0) : 0.0;
}

/// Service untuk sinkronisasi produk Digiflazz ke database lokal & Cloud.
class SyncService {
  final DigiflazzClient _client;
  final ProdukDao _produkDao;
  final DigiflazzConfig _config;
  final FirebaseFirestore _db;

  SyncService({
    required DigiflazzClient client,
    required ProdukDao produkDao,
    required DigiflazzConfig config,
    FirebaseFirestore? db,
  }) : _client = client,
       _produkDao = produkDao,
       _config = config,
       _db = db ?? FirebaseFirestore.instance;

  /// Sinkronisasi daftar produk dari Digiflazz ke database lokal & Cloud secara bertahap.
  Future<SyncResult> sinkronisasiProduk({
    bool includePasca = true,
    void Function(SyncProgress)? onProgress,
  }) async {
    int totalApi = 0;
    int totalSimpan = 0;
    int totalSkip = 0;
    final List<String> feedback = [];

    // --- 1. PRABAYAR ---
    try {
      final resPrepaid = await _prosesSync('prepaid', onProgress);
      totalApi += resPrepaid.totalDariApi;
      totalSimpan += resPrepaid.totalDisimpan;
      totalSkip += resPrepaid.totalDiSkip;
      feedback.add('Prabayar: ${resPrepaid.totalDisimpan} produk diupdate.');
    } catch (e) {
      final err = e.toString().replaceAll('Exception: ', '').trim();
      feedback.add('Prabayar gagal: $err');
    }

    // --- 2. PASCABAYAR ---
    if (includePasca) {
      // Jeda 3 detik untuk mencegah terkena Rate Limit API Digiflazz
      onProgress?.call(const SyncProgress(total: 0, current: 0, status: 'Menyiapkan sinkronisasi pascabayar... (Digiflazz membatasi 1 request per 5 menit)'));
      await Future.delayed(const Duration(seconds: 3));

      try {
        final resPasca = await _prosesSync('pasca', onProgress);
        totalApi += resPasca.totalDariApi;
        totalSimpan += resPasca.totalDisimpan;
        totalSkip += resPasca.totalDiSkip;
        feedback.add('Pascabayar: ${resPasca.totalDisimpan} produk diupdate.');
      } catch (e) {
        final err = e.toString().replaceAll('Exception: ', '').trim();
        // Beri warning Rate Limit yang lebih jelas jika Digiflazz menolak
        feedback.add('Pascabayar dibatasi: $err (Maks. 1x / 5 Menit)');
      }
    }

    if (totalApi == 0 && totalSimpan == 0 && totalSkip == 0 && feedback.any((f) => f.contains('gagal') || f.contains('dibatasi'))) {
      // Jika KEDUANYA gagal secara total, lempar sebagai Exception untuk ditangkap dan menjadi pesan merah
      throw Exception(feedback.join(' | '));
    }

    return SyncResult(
      totalDariApi: totalApi,
      totalDisimpan: totalSimpan,
      totalDiSkip: totalSkip,
      pesan: feedback.join('\\n'),
    );
  }

  /// Helper untuk memproses sinkronisasi per kategory.
  Future<_SyncStats> _prosesSync(
    String cmd,
    void Function(SyncProgress)? onProgress,
  ) async {
    final markupGlobal = await _config.getMarkupGlobal();
    
    onProgress?.call(const SyncProgress(
      total: 0,
      current: 0,
      status: 'Menghubungi API...',
    ));
    
    final response = await _client.ambilDaftarHarga(cmd: cmd);
    final semuaProdukFromApi = response.data;

    if (semuaProdukFromApi.isEmpty) return const _SyncStats(0, 0, 0);

    final existingProdukList = await _produkDao.ambilSemuaProduk();
    final existingMap = {for (final p in existingProdukList) p.kodeDigiflazz: p};

    final produkUntukUpdate = <ProdukDigiflazz>[];
    int countIdentik = 0;

    for (final pApi in semuaProdukFromApi) {
      if (!pApi.buyerProductStatus) continue;
      final pExisting = existingMap[pApi.buyerSkuCode];
      
      bool perluUpdate = false;
      if (pExisting == null) {
        perluUpdate = true;
      } else {
        if (pExisting.hargaBeli != pApi.price ||
            pExisting.nama != pApi.productName ||
            pExisting.kategori != _normalizeKategori(pApi.category)) {
          perluUpdate = true;
        } else {
          countIdentik++;
        }
      }
      if (perluUpdate) produkUntukUpdate.add(pApi);
    }

    if (produkUntukUpdate.isEmpty) {
      return _SyncStats(semuaProdukFromApi.length, 0, semuaProdukFromApi.length - countIdentik + countIdentik);
    }

    final companions = produkUntukUpdate.map((pApi) {
      final pExisting = existingMap[pApi.buyerSkuCode];
      return _mapToProdukCompanion(pApi, markupGlobal, existing: pExisting);
    }).toList();

    await _produkDao.upsertProdukBatch(companions);
    await _syncToFirestore(produkUntukUpdate, existingMap, markupGlobal, cmd == 'prepaid', onProgress);

    return _SyncStats(semuaProdukFromApi.length, produkUntukUpdate.length, 0);
  }

  /// Tarik semua produk dari Firestore ke database lokal (Restore).
  Future<int> pullFromFirestore({
    void Function(SyncProgress)? onProgress,
  }) async {
    onProgress?.call(const SyncProgress(total: 0, current: 0, status: 'Menghubungi Cloud Firestore...'));

    final snapshot = await _db.collection('products').get();
    final docs = snapshot.docs;

    if (docs.isEmpty) return 0;

    onProgress?.call(SyncProgress(total: docs.length, current: 0, status: 'Memulihkan data...'));

    final companions = docs.map((doc) => _mapFromFirestore(doc.data())).toList();
    await _produkDao.upsertProdukBatch(companions);

    return docs.length;
  }

  /// Sinkronisasi produk ke Cloud Firestore.
  Future<void> _syncToFirestore(
    List<ProdukDigiflazz> produkList,
    Map<String, Produk> existingMap,
    int markup,
    bool isPrepaid,
    void Function(SyncProgress)? onProgress,
  ) async {
    const int batchSize = 100;
    for (var i = 0; i < produkList.length; i += batchSize) {
      final batch = _db.batch();
      final end = (i + batchSize < produkList.length) ? i + batchSize : produkList.length;
      final subList = produkList.sublist(i, end);
      
      for (final produk in subList) {
        final docRef = _db.collection('products').doc(produk.buyerSkuCode);
        final pExisting = existingMap[produk.buyerSkuCode];
        batch.set(docRef, _mapToFirestore(produk, markup, isPrepaid, existing: pExisting), SetOptions(merge: true));
      }
      await batch.commit();
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  Map<String, dynamic> _mapToFirestore(
    ProdukDigiflazz produk,
    int markup,
    bool isPrepaid, {
    Produk? existing,
  }) {
    int finalPrice = (existing != null && existing.hargaJual > 0) ? existing.hargaJual : (produk.price + markup);
    String finalStatus = 'non-aktif';
    if (existing != null) {
      finalStatus = existing.aktif ? 'aktif' : 'non-aktif';
    }

    return {
      'sku': produk.buyerSkuCode,
      'name': produk.productName,
      'category': _normalizeKategori(produk.category),
      'brand': produk.brand,
      'price': finalPrice,
      'desc': produk.desc,
      'status': finalStatus,
      'isPrepaid': isPrepaid,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  ProdukTableCompanion _mapFromFirestore(Map<String, dynamic> data) {
    final status = data['status'] as String? ?? 'non-aktif';
    return ProdukTableCompanion(
      kodeDigiflazz: Value(data['sku'] ?? ''),
      nama: Value(data['name'] ?? ''),
      kategori: Value(data['category'] ?? 'Lainnya'),
      brand: Value(data['brand'] ?? ''),
      hargaBeli: Value(0),
      hargaJual: Value(data['price'] ?? 0),
      aktif: Value(status == 'aktif'),
      deskripsi: Value(data['desc'] ?? ''),
      lastUpdated: Value(DateTime.now()),
    );
  }

  ProdukTableCompanion _mapToProdukCompanion(
    ProdukDigiflazz produk,
    int markup, {
    Produk? existing,
  }) {
    final bool isAktif = existing?.aktif ?? false;
    final int finalHargaJual = (existing != null && existing.hargaJual > 0) ? existing.hargaJual : (produk.price + markup);

    return ProdukTableCompanion(
      kodeDigiflazz: Value(produk.buyerSkuCode),
      nama: Value(produk.productName),
      kategori: Value(_normalizeKategori(produk.category)),
      brand: Value(produk.brand),
      hargaBeli: Value(produk.price),
      hargaJual: Value(finalHargaJual),
      aktif: Value(isAktif),
      deskripsi: Value(produk.desc),
      lastUpdated: Value(DateTime.now()),
    );
  }

  String _normalizeKategori(String kategoriApi) {
    final lower = kategoriApi.toLowerCase();
    if (lower.contains('pulsa')) return 'Pulsa';
    if (lower.contains('data')) return 'Paket Data';
    if (lower.contains('token') || lower.contains('pln')) return 'Token Listrik';
    if (lower.contains('tagihan') || lower.contains('pasca')) return 'Pascabayar';
    if (lower.contains('e-money') || lower.contains('emoney')) return 'E-Money';
    if (lower.contains('game') || lower.contains('voucher')) return 'Voucher Game';
    return kategoriApi.isNotEmpty ? kategoriApi : 'Lainnya';
  }
}

class _SyncStats {
  final int totalDariApi;
  final int totalDisimpan;
  final int totalDiSkip;
  const _SyncStats(this.totalDariApi, this.totalDisimpan, this.totalDiSkip);
}
