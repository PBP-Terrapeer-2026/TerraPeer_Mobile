# TerraPeer Mobile

Aplikasi mobile **TerraPeer** berbasis Flutter, dibuat untuk Proyek Akhir Semester mata kuliah Pemrograman Berbasis Platform (PBP) Fasilkom UI, Gasal 2026/2027.

## Anggota Kelompok

| Nama | NPM |
| --- | --- |
| Jotham Seanvedi Takin Allo | TODO |
| Ayyasi | TODO |
| Muhammad Farel Ammar | TODO |
| Nashri Khalid | TODO |
| Adinda Pika Fauziah | TODO |

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

## Desain

Figma: [TerraPeer](https://www.figma.com/design/fZa8nxPXXGqgu0ytl6WFhY/Terrapeer?)

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

## Struktur Kode

```
lib/
├── main.dart
├── app.dart                    # MaterialApp + router + tema
├── core/                       # dipakai bersama oleh semua modul
│   ├── config/env.dart         # base URL API
│   ├── router/                 # go_router, daftar route & destinasi navigasi
│   ├── theme/                  # warna & tipografi (sama dengan situs web)
│   └── widgets/                # app shell (drawer/rail), loading/error/empty view
└── features/
    ├── home/
    ├── garden_setup/           # Jotham
    ├── garden_planning/        # Ayyasi
    ├── my_plants/              # Farel
    ├── plant_care/             # Nashri
    └── garden_journal/         # Adinda
        ├── data/models/        # model JSON
        ├── data/services/      # pemanggilan API
        └── presentation/       # pages & widgets
```

Navigasi responsif: drawer di ponsel, navigation rail di tablet/layar lebar.

## Aturan Kolaborasi

- **Jangan push langsung ke `main`.** Semua perubahan masuk lewat Pull Request dan wajib di-review minimal satu anggota lain.
- Nama branch: `feat/<modul>`, `fix/<modul>`, `docs/<topik>`, `chore/<topik>` (contoh: `feat/my-plants`).
- Pesan commit mengikuti [Conventional Commits](https://www.conventionalcommits.org/): `feat(my-plants): add plant list page`, `fix(router): ...`, `docs: ...`.
- Kerjakan modulmu di `lib/features/<modul>/`. Perubahan di `lib/core/` dibahas dulu di grup karena memengaruhi semua modul.
- Pakai warna dan gaya dari `Theme.of(context)`, bukan warna yang di-hardcode.
- Pakai `LoadingView`, `ErrorView`, dan `EmptyView` dari `lib/core/widgets/state_views.dart` agar tampilan konsisten.
- Navigasi selalu memakai konstanta `AppRoutes`, misalnya `context.go(AppRoutes.myPlants)`.
- Jalankan `flutter analyze` dan `flutter test` sebelum membuka PR.

## Penggunaan AI

TODO: tools AI yang digunakan, untuk apa, prompt/strategi, keterbatasan yang ditemukan, dan perbaikan manual yang dilakukan.
