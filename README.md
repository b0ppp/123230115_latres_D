# Toko Online - Raja

Aplikasi toko online Flutter menggunakan data produk dari [dummyjson.com](https://dummyjson.com/products).

**NIM:** 123230115  
**Nama:** T.M. Kalladara Raja Lingga AS

---

## Struktur Folder

```
lib/
├── main.dart                  # Entry point: inisialisasi Hive, GetX, cek status login
│
├── models/
│   ├── product.dart           # Model data produk dari API dummyjson
│   ├── cart_item.dart         # Model Hive untuk item di keranjang belanja
│   └── cart_item.g.dart       # Generated adapter Hive untuk CartItem
│
├── controllers/               # GetX Controllers (State Management)
│   ├── auth_controller.dart   # Kelola login, logout, cek sesi (SharedPreferences)
│   ├── product_controller.dart# Fetch & simpan list produk dari API
│   ├── detail_controller.dart # Fetch detail produk, kelola qty selector
│   └── cart_controller.dart   # Kelola keranjang belanja per user (Hive)
│
├── pages/                     # Halaman UI
│   ├── login_page.dart        # Halaman login (username bebas, password = NIM)
│   ├── main_page.dart         # Wrapper Bottom Navigation Bar (Home & Profile)
│   ├── home_page.dart         # Daftar produk + info username + tombol cart
│   ├── detail_page.dart       # Detail produk + qty selector + Add to Cart
│   ├── cart_page.dart         # Keranjang belanja per user + hapus item
│   └── profile_page.dart      # Info user + deskripsi + tombol logout
│
└── services/
    └── api_service.dart       # HTTP request ke dummyjson.com/products
```

---

## Library yang Digunakan

| Library | Fungsi |
|---|---|
| `hive` + `hive_flutter` | Local database untuk keranjang belanja |
| `shared_preferences` | Menyimpan sesi login user |
| `http` | HTTP request ke API eksternal |
| `get` (GetX) | State management, navigasi |
| `cached_network_image` | Menampilkan gambar produk dari URL |

---

## Fitur Aplikasi

- **Login** — username bebas, password wajib NIM
- **Persistent Login** — tidak perlu login ulang selama belum logout
- **Home** — daftar produk dari `dummyjson.com/products`
- **Detail Produk** — info lengkap, pilih qty, tambah ke keranjang
- **Cart** — keranjang belanja terpisah per username, bisa hapus item
- **Profile** — info user, deskripsi, tombol logout

---

## Cara Run

```bash
flutter pub get
flutter pub run build_runner build   # generate Hive adapter (jika diperlukan)
flutter run
```
