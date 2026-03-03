# ⚡ NiagaRea

**NiagaRea** adalah aplikasi **Buku Catatan Pulsa & Token** berbasis mobile yang dirancang dengan pendekatan *Offline-First*. Aplikasi ini membantu pengusaha pulsa kecil-kecilan untuk mencatat stok, transaksi, dan menghitung keuntungan secara otomatis menggunakan metode **FIFO (First-In-First-Out)**.

## ✨ Fitur Utama

- **Pencatatan Stok (Siklus)**: Kelola modal deposit Anda per siklus untuk perhitungan profit yang akurat.
- **Katalog Produk Dinamis**: Sinkronisasi produk dari provider stok atau tambahkan produk manual.
- **Manajemen Transaksi**: Catat penjualan dengan pilihan status bayar (Lunas/Utang) dan pelanggan.
- **Perhitungan Profit FIFO**: Keuntungan dihitung secara otomatis berdasarkan harga beli stok di siklus yang sedang berjalan.
- **Akses Kontrol Admin (Hidden Entry)**: Fitur administratif (Sync API, Pengaturan PIN, Antrian) tersembunyi untuk menjaga kebersihan UI pengguna biasa.
- **Offline First**: Data tersimpan secara lokal di database SQLite (Drift), sehingga aplikasi tetap fungsional tanpa koneksi internet.

## 🛡️ Akses Admin

Untuk menjaga kerahasiaan pengaturan provider, fitur admin disembunyikan di balik "Pintu Rahasia":
1. Buka menu **Pengaturan**.
2. Tekan lama (**Long Press**) pada nama aplikasi atau nomor versi di bagian bawah layar.
3. Masukkan PIN Admin (Default: `123456`).

## 🚀 Teknologi yang Digunakan

- **Flutter**: Framework UI lintas platform.
- **Riverpod**: State management.
- **Drift (SQLite)**: Database lokal yang kuat dan reaktif.
- **Digiflazz API (Opsional)**: Integrasi provider stok untuk sinkronisasi produk dan transaksi otomatis.

## 🛠️ Pengembangan

### Prasyarat
- Flutter SDK (Versi terbaru disarankan)
- Dart SDK

### Cara Menjalankan
1. Clone repositori:
   ```bash
   git clone https://github.com/rasyiqi-code/niagarea.git
   ```
2. Instal dependensi:
   ```bash
   flutter pub get
   ```
3. Jalankan build runner untuk generate file database/dao:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. Jalankan aplikasi:
   ```bash
   flutter run
   ```

## 📝 Lisensi
Aplikasi ini dikembangkan untuk penggunaan internal dan pembelajaran. Silakan hubungi pengembang untuk detail lisensi lebih lanjut.

---
*Dikembangkan dengan ❤️ oleh Rasyiqi-code*
