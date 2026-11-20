# TerraPeer Mobile

Aplikasi mobile **TerraPeer** berbasis Flutter, dibuat untuk Proyek Akhir Semester mata kuliah Pemrograman Berbasis Platform (PBP) Fasilkom UI, Gasal 2026/2027 — **Kelompok 5F**.

· **Situs web (PWS):** <https://muhammad-farel52-terrapeer.pws.cs.ui.ac.id/>
· **Repositori situs web:** [PBP-Terrapeer-2026/TerraPeer](https://github.com/PBP-Terrapeer-2026/TerraPeer)
· **Desain:** [Figma TerraPeer](https://www.figma.com/design/fZa8nxPXXGqgu0ytl6WFhY/Terrapeer)
· **APK:** _menyusul_

## Anggota Kelompok

| Nama | NPM | GitHub |
| --- | --- | --- |
| Jotham Seanvedi Takin Allo | 2506584161 | [`seanve1`](https://github.com/seanve1) |
| Ayyasi | 2506550482 | [`Asepgunawan112`](https://github.com/Asepgunawan112) |
| Muhammad Farel Ammar | 2506585731 | [`marlioboro`](https://github.com/marlioboro) |
| Nashri Khalid | 2506657131 | [`nashrikhalid`](https://github.com/nashrikhalid) |
| Adinda Pika Fauziah | 2506533646 | [`pikadinda`](https://github.com/pikadinda) |

## Deskripsi Aplikasi

**TerraPeer** adalah asisten berkebun pribadi yang membantu pengguna menanam tumbuhan sesuai kondisi lingkungannya. Aplikasi ini adalah versi mobile dari situs web TerraPeer (Proyek Tengah Semester), dan memakai data yang sama.

Alur penggunaan:
1. Pengguna membuat profil ruang tanam (Garden Setup).
2. TerraPeer merekomendasikan tanaman yang cocok, lalu pengguna menyusun rencana kebun (Garden Planning).
3. Tanaman yang sudah ditanam dipantau tahap pertumbuhannya (My Plants).
4. Pengguna menjalankan tugas perawatan harian dengan konteks cuaca (Plant Care).
5. Perkembangan tanaman dicatat dalam timeline (Garden Journal).

## Modul dan Pembagian Kerja

| Modul | Penanggung Jawab | Fungsi | Endpoint DRF |
| --- | --- | --- | --- |
| Garden Setup | Jotham Seanvedi Takin Allo | Mengelola profil ruang tanam: jenis ruangan, lokasi, durasi cahaya, media tanam, frekuensi perawatan. | `/api/v1/spaces/` |
| Garden Planning | Ayyasi | Rekomendasi tanaman berdasarkan ruang tanam serta pengelolaan garden plan, tanaman, dan pot. | `/api/v1/plans/` |
| My Plants | Muhammad Farel Ammar | Mengelola tanaman yang sudah ditanam beserta tahap pertumbuhan (Growing, Flowering, Fruiting, Harvesting, Finished) dan statusnya. | `/api/v1/my-plants/` |
| Plant Care | Nashri Khalid | Mengelola tugas perawatan (menyiram, memangkas, nutrisi, panen) dengan informasi cuaca. | `/api/v1/care-tasks/` |
| Garden Journal | Adinda Pika Fauziah | Mencatat perkembangan tanaman (pertumbuhan, pembungaan, panen, masalah) dalam bentuk timeline. | `/api/v1/journal-entries/` |

Semua endpoint modul mendukung `GET` (list & detail), `POST`, `PUT`/`PATCH`, dan `DELETE`, serta mewajibkan autentikasi. Token didapat dari `POST /api/v1/auth/token/` (body: `username`, `password`).

## Peran Pengguna

1. **Guest**: pengguna yang belum login. Hanya dapat melihat informasi umum aplikasi serta halaman login dan registrasi.
2. **Registered User**: pengguna yang sudah login. Dapat memakai seluruh fitur dan hanya dapat mengakses serta mengelola datanya sendiri (ruang tanam, garden plan, tanaman, tugas perawatan, jurnal).

## Alur Integrasi Data dengan Situs Web (PWS)

Situs web Django: https://muhammad-farel52-terrapeer.pws.cs.ui.ac.id

```
Flutter (widget) ──HTTP + token──▶ Django REST Framework (/api/v1/...) ──▶ database situs web
        ▲                                        │
        └──────────── respons JSON ◀─────────────┘
```

1. Seluruh data disimpan di database situs web Django dari Proyek Tengah Semester. Aplikasi tidak menyimpan data statis.
2. Setiap modul menyediakan endpoint **Django REST Framework** (serializer + viewset) di proyek Django, di bawah prefix `/api/v1/`.
3. Pengguna login dari aplikasi; Django mengembalikan token yang dikirim di header `Authorization: Token <token>` pada setiap request berikutnya. Setiap endpoint hanya mengembalikan data milik pengguna tersebut.
4. Aplikasi memanggil endpoint secara asinkron (`GET`/`POST`/`PUT`/`PATCH`/`DELETE`). Base URL diatur di `lib/core/config/env.dart`.
5. Respons JSON diubah menjadi model Dart, lalu ditampilkan oleh widget. Data yang diubah dari aplikasi langsung terlihat di situs web, dan sebaliknya.

## Sumber Data dan API Publik

Data utama berasal dari database situs web TerraPeer (diakses lewat endpoint DRF di atas). Situs web memakai API publik berikut di sisi server, sehingga hasilnya ikut tersedia untuk aplikasi mobile:

| API | Dipakai oleh |
| --- | --- |
| [Open-Meteo Geocoding](https://open-meteo.com/en/docs/geocoding-api) | Garden Setup, Garden Planning |
| [Open-Meteo Forecast](https://open-meteo.com/en/docs) | Garden Planning, Plant Care |
| [Perenual](https://www.perenual.com/docs/api) | My Plants, Garden Planning |

## Desain

Figma: [TerraPeer](https://www.figma.com/design/fZa8nxPXXGqgu0ytl6WFhY/Terrapeer) (password akses: `TerrapeerPBP5F`). Warna dan tipografi aplikasi mengikuti design system yang sama dengan situs web.

## Unduh Aplikasi

Tautan APK: _menyusul_

## Menjalankan Proyek

```bash
flutter pub get
flutter run                     # memakai situs web di PWS
flutter test
```

Untuk memakai server Django lokal dari emulator Android:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

## Arsitektur

Aplikasi memakai **Clean Architecture** per fitur. Setiap modul punya tiga lapisan, dan dependensi hanya mengarah ke dalam (`presentation` → `domain` ← `data`):

| Lapisan | Isi | Boleh import |
| --- | --- | --- |
| `domain/` | Entity (kelas Dart murni) dan repository abstrak | Tidak ada (tanpa Flutter, tanpa HTTP) |
| `data/` | Model JSON, data source (panggilan API lewat `ApiClient`), implementasi repository | `domain/`, `core/` |
| `presentation/` | Provider (`ChangeNotifier`: state loading / data / error), pages, widgets | `domain/`, `core/` |

Layanan bersama dibuat sekali di `main.dart` (composition root) lalu dibagikan dengan **Provider**. Modul `auth` adalah contoh lengkap ketiga lapisan.

```
lib/
├── main.dart                   # composition root: membuat ApiClient, AuthProvider
├── app.dart                    # MultiProvider + MaterialApp.router + tema
├── core/                       # dipakai bersama oleh semua modul
│   ├── config/env.dart         # base URL API (bisa diganti dengan --dart-define)
│   ├── network/                # ApiClient (token, JSON, timeout) + ApiException (parser error DRF)
│   ├── storage/                # penyimpanan token login
│   ├── router/                 # go_router: route, guard login, transisi halaman
│   ├── theme/                  # warna & tipografi (sama dengan situs web)
│   └── widgets/                # app shell (drawer / navigation rail), loading / error / empty view
└── features/
    ├── auth/                   # login, logout, sesi (contoh referensi)
    ├── home/
    ├── garden_setup/           # Jotham
    ├── garden_planning/        # Ayyasi
    ├── my_plants/              # Farel
    ├── plant_care/             # Nashri
    └── garden_journal/         # Adinda
        ├── domain/{entities, repositories}/
        ├── data/{models, datasources, repositories}/
        └── presentation/{providers, pages, widgets}/
```

### Navigasi dan autentikasi

- **Responsif:** drawer di ponsel, navigation rail di tablet/layar lebar (≥ 840 px), dengan transisi fade antarhalaman.
- **Guest** hanya bisa membuka Home dan Login. Membuka modul lain akan diarahkan ke Login, lalu otomatis kembali ke modul tersebut setelah berhasil masuk.
- **Token** disimpan di perangkat sehingga pengguna tetap login setelah aplikasi ditutup. Jika server membalas `401` (token kedaluwarsa), pengguna otomatis keluar.

### Memanggil API dari modul

```dart
// data/datasources/my_plants_remote_data_source.dart
final json = await apiClient.get('/my-plants/');          // GET list
await apiClient.post('/my-plants/', body: plant.toJson()); // POST create
```

Setiap kegagalan dilempar sebagai `ApiException` (berisi `message`, `statusCode`, dan `fieldErrors` per field dari serializer DRF), sehingga semua modul menampilkan error dengan cara yang sama.

## Pengujian

```bash
flutter analyze
flutter test
```

Test mencakup navigasi (drawer, navigation rail, kartu Home), alur login (validasi form, kredensial salah, redirect kembali ke modul, logout, token kedaluwarsa), aturan redirect, dan parser error DRF.

## Aturan Kolaborasi

- **Jangan push langsung ke `main`.** Semua perubahan masuk lewat Pull Request dan wajib di-review minimal satu anggota lain.
- Nama branch: `feat/<modul>`, `fix/<modul>`, `docs/<topik>`, `chore/<topik>` (contoh: `feat/my-plants`).
- Pesan commit mengikuti [Conventional Commits](https://www.conventionalcommits.org/): `feat(my-plants): add plant list page`, `fix(router): ...`, `docs: ...`.
- Kerjakan modulmu di `lib/features/<modul>/`. Perubahan di `lib/core/` dibahas dulu di grup karena memengaruhi semua modul.
- Pakai warna dan gaya dari `Theme.of(context)`, bukan warna yang di-hardcode.
- Pakai `LoadingView`, `ErrorView`, dan `EmptyView` dari `lib/core/widgets/state_views.dart` agar tampilan konsisten.
- Navigasi selalu memakai konstanta `AppRoutes`, misalnya `context.go(AppRoutes.myPlants)`.
- Jalankan `flutter analyze` dan `flutter test` sebelum membuka PR.

## AI Usage Disclosure

Tim memakai alat AI sebagai asisten, bukan pengganti pemahaman. Semua perubahan masuk lewat pull request, di-review anggota lain, dan diuji (`flutter analyze`, `flutter test`).

### Base template, My Plants — Muhammad Farel Ammar

- **Alat:** Claude (Anthropic).
- **Penggunaan:** membantu menyusun base template aplikasi (struktur folder per modul, tema dari design token situs web, routing `go_router` dengan drawer/navigation rail responsif, widget state bersama, widget test) dan README.
- **Strategi prompt:** memberikan ketentuan tugas dan rubrik secara lengkap, meminta perubahan kecil yang di-commit bertahap dengan Conventional Commits, dan meminta setiap perubahan dibuktikan dengan `flutter analyze` dan `flutter test` di mesin sendiri.
- **Keterbatasan yang ditemukan dan perbaikan manual:**
  - Kode awal belum pernah dikompilasi oleh AI; `google_fonts` 9 ternyata membangun helper `TextTheme`-nya di atas paket `material_ui` yang tipenya berbeda dari `TextTheme` Flutter, sehingga tema diubah untuk menerapkan font per `TextStyle`.
  - Kartu modul di halaman Home awalnya memakai tinggi tetap dan overflow 4 px; ditemukan oleh widget test lalu diganti menjadi grid yang tingginya mengikuti konten.
  - AI tidak memiliki akses push ke GitHub; semua push, review, dan merge dilakukan anggota tim.

### Garden Setup — Jotham Seanvedi Takin Allo

TODO

### Garden Planning — Ayyasi
- Fitur Garden Planning dipakai untuk membuat rencana penanaman. Aplikasi akan memunculkan rekomendasi tanaman yang berbeda berdasarkan input tempat pengguna. Setelah mendapat input pengguna, server akan mencocokan cuaca tempat dari API weather forecasting yang akan diteruskan ke API perenual untuk memunculkan rekomendasi tanamannya. Setelah mendapat rekomendasi tanaman, user bisa memasukkan tanaman yang ada ke dalam keranjang bernama "garden plan".

TODO

### Plant Care — Nashri Khalid

Plant Care membantu pengguna merencanakan dan mencatat perawatan tanaman aktif miliknya, seperti menyiram, memangkas, atau memeriksa kondisi daun. Setiap tugas terhubung ke satu tanaman sehingga pengguna dapat melihat pekerjaan yang perlu dilakukan dan riwayat perawatannya.

Cakupan modul Plant Care meliputi:

- **Daftar dan detail tugas.** Setiap tugas memuat judul, jenis tindakan, tanggal pelaksanaan, status (`Pending` atau `Completed`), serta instruksi opsional. Tugas yang masih tertunda diurutkan dari jadwal paling awal dan diberi tanda `Overdue` jika tanggalnya sudah lewat.
- **Pembuatan dan perubahan jadwal.** Pengguna dapat membuat tugas sekali jalan atau berulang setiap beberapa hari, misalnya menyiram setiap tiga hari. Jadwal, instruksi, dan interval tugas yang masih tertunda dapat diubah. Interval minimal satu hari.
- **Penyelesaian dan pengulangan.** Saat tugas ditandai selesai, sistem mencatat waktu penyelesaiannya. Untuk tugas berulang pada tanaman yang masih aktif, sistem membuat satu tugas berikutnya sesuai interval.
- **Penghapusan.** Menghapus tugas berulang yang masih tertunda menghentikan rangkaiannya dan mempertahankan riwayat tugas selesai. Menghapus satu catatan yang sudah selesai hanya menghapus catatan tersebut.
- **Filter per tanaman.** Pengguna dapat menggabungkan filter waktu (semua tanggal, hari ini, atau mendatang) dengan status tugas untuk melihat pekerjaan yang relevan.
- **Prakiraan cuaca.** Data Open-Meteo memberikan konteks perawatan berdasarkan lokasi dan zona waktu kebun, termasuk suhu minimum dan maksimum, peluang hujan, serta perkiraan curah hujan harian.

Data tugas tersimpan di database Django TerraPeer. Endpoint Django REST Framework `/api/v1/care-tasks/` menyediakan operasi baca, tambah, ubah, dan hapus dengan akses terbatas pada tugas milik pengguna yang sudah login. Halaman Flutter menggunakan API client bersama untuk mengambil daftar tugas dan menampilkan judul, tanggal, serta statusnya.

### Garden Journal — Adinda Pika Fauziah

TODO
