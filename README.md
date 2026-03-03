# ⚡ NiagaRea

**NiagaRea** adalah aplikasi **Pencatatan & Penjualan Pulsa/Token** berbasis mobile yang dirancang dengan model bisnis **Aggregator B2B**. Aplikasi ini memungkinkan pemilik usaha (NiagaRea) menyediakan stok pulsa kepada jaringan Reseller/Counter Owner dengan sistem pencatatan yang akurat, mandiri, dan *Offline-First*.

## 📖 Konsep Bisnis NiagaRea

Aplikasi ini beroperasi dengan alur kerja sebagai berikut:
1.  **NiagaRea sebagai Provider**: NiagaRea menyetor deposit besar ke provider stok (Digiflazz) sebagai modal master.
2.  **User (Counter Owner)**: Reseller melakukan top-up dana ke rekening NiagaRea. Dana ini kemudian dicatat sebagai **Saldo/Modal** mereka di aplikasi.
3.  **Mekanisme Markup**: Admin can set a global profit margin. Saat sinkronisasi produk, "Harga Beli" yang dilihat Reseller sudah mencakup markup keuntungan untuk NiagaRea.
4.  **Perhitungan Profit (FIFO)**: Keuntungan Reseller dihitung secara otomatis berdasarkan selisih Harga Jual dan Modal (FIFO), memastikan data keuangan yang sangat akurat.

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
