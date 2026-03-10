# ⚡ NiagaRea

**NiagaRea** adalah aplikasi mobile **Buku Ledger (Pencatatan) Pulsa Digital** yang dirancang khusus untuk pemilik konter. Aplikasi ini memungkinkan pengguna mencatat transaksi penjualan pulsa/token dari **manapun provider-nya** (Provider-Agnostic) dengan akurasi tinggi (FIFO), sambil menyediakan akses opsional ke stok produk dari NiagaRea sebagai solusi pengadaan barang yang terintegrasi.

## 📖 Konsep NiagaRea: Catat Dari Mana Saja

Aplikasi ini beroperasi dengan filosofi "Buku Catatan Mandiri":
1.  **Asisten Pencatatan Universal**: Fokus utama adalah sebagai buku catatan digital untuk melacak modal, harga jual, dan profit dari transaksi provider manapun (fisik, aplikasi lain, atau chip).
2.  **Penyedia Produk Opsional**: NiagaRea menyediakan integrasi stok produk digital (via Digiflazz). User bebas memilih untuk membeli stok dari NiagaRea guna otomatisasi pencatatan atau tetap menggunakan provider luar.
3.  **Transparansi Modal & Markup**: Jika menggunakan stok NiagaRea, harga beli sudah mencakup markup keuntungan NiagaRea. Jika menggunakan provider lain, user tetap bisa menginput modal secara manual per siklus deposit.
4.  **Akurasi Keuntungan (FIFO)**: Keuntungan tetap dihitung otomatis berdasarkan stok deposit yang digunakan, siapapun provider-nya.

## ✅ Fitur yang Sudah Diimplementasikan

- **Manajemen Saldo Terpisah**: Dashboard membedakan secara visual antara **"Saldo Anda"** (Modal Reseller) dan **"Saldo Stok"** (Hanya untuk Admin untuk memantau deposit di Digiflazz).
- **Alur Top-up Terintegrasi**: Layar top-up yang dilengkapi instruksi transfer bank manual dan proses verifikasi admin.
- **Hidden Admin Entry**: Fitur administratif (kredensial API, sinkronisasi, antrian transaksi) tersembunyi lewat *Long Press* pada info versi di Pengaturan untuk menjaga fokus Reseller.
- **Mekanisme Markup Global**: Admin dapat mengatur margin keuntungan perusahaan yang otomatis diterapkan pada seluruh katalog produk saat sinkronisasi.
- **FIFO Engine**: Logika konsumsi saldo stok berdasarkan urutan deposit terlama (First-In-First-Out).
- **Offline First**: Menggunakan database reaktif **Drift (SQLite)**, memastikan operasional tetap berjalan meskipun koneksi internet provider stok bermasalah.
- **Transaction Queue**: Antrian transaksi otomatis yang mencoba mengirim ulang data ke provider stok saat koneksi tersedia kembali.

## 🔜 Roadmap (Belum Diimplementasikan)

- [ ] **Otomatisasi Verifikasi Pembayaran**: Integrasi dengan API Mutasi Bank untuk aktivasi saldo top-up instan.
- [ ] **Cetak Struk/Receipt**: Dukungan cetak struk via printer Bluetooth Thermal untuk pelanggan.
- [ ] **Laporan Bisnis Bulanan**: Grafik analitik performa penjualan dan total profit perusahaan dalam format PDF/Excel.
- [ ] **Notifikasi Real-time**: Push notification untuk status transaksi dan peringatan saldo limit.
- [ ] **Manajemen Pelanggan & Piutang**: Fitur manajemen pelanggan lebih mendalam dengan batas kredit (Credit Limit).
- [ ] **Cloud Sync & Backup**: Sinkronisasi data antar perangkat dan backup otomatis ke cloud (Firebase/Supabase).

## 🚀 Teknologi yang Digunakan

- **Flutter**: Framework UI modern untuk pengalaman mobile yang mulus.
- **Riverpod**: Sinkronisasi state aplikasi yang kuat dan testable.
- **Drift (SQLite)**: Database lokal reaktif untuk performa tinggi.
- **Digiflazz API (Aggregator)**: Integrasi backend provider stok untuk data produk real-time.

## 🛠️ Panduan Pengembangan

### Prasyarat
- Flutter SDK (Versi stabil terbaru)
- Dart SDK

### Langkah Instalasi
1. Clone repositori:
   ```bash
   git clone https://github.com/rasyiqi-code/niagarea.git
   ```
2. Instal dependensi:
   ```bash
   flutter pub get
   ```
3. Generate kode database (DAO & Tables):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. Jalankan aplikasi:
   ```bash
   flutter run
   ```

## 🔐 Keamanan Admin
Akses area admin dilindungi PIN. Gunakan *Long Press* pada label versi aplikasi di menu Pengaturan untuk memicu dialog login admin. (PIN Default: `123456`)

---
*Developed with Passion & 🧠 by Rasyiqi-code*
