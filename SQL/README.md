# SQL Retail Analytics Portfolio

Analisis SQL end-to-end untuk data e-commerce retail fashion, mencakup **Sales Performance** dan **Financial Analysis** — dibangun sebagai portfolio transisi dari background Akuntansi menuju Data Analyst.

## 📌 Business Problem

Perusahaan retail fashion membutuhkan visibilitas terhadap performa penjualan (produk terlaris, tren revenue, kontribusi customer) dan kesehatan keuangan (gross profit margin, dampak refund terhadap profit) untuk mendukung pengambilan keputusan bisnis.

## 🗂️ Dataset

Dataset berupa **star schema** dengan 1 tabel fakta dan 11 tabel dimensi:

| Tabel | Deskripsi |
|---|---|
| `orders_transaction` | Tabel fakta — detail tiap transaksi order |
| `customers` | Data customer, termasuk membership tier |
| `products` / `subproducts` | Produk dan variannya (ukuran, warna) |
| `city_province_region` | Data geografis kota/provinsi/region |
| `employees` | Data karyawan (sales representative) |
| `payment_methods`, `order_status` | Tabel referensi metode pembayaran & status order |
| `inventory` | Stok per gudang |
| `suppliers` | Data pemasok |
| `marketing_campaigns` | Data kampanye pemasaran |
| `return_orders` | Data pengembalian/refund |
| `date` | Tabel dimensi waktu |

_Catatan: data pada repo ini adalah data sintetis/latihan, bukan data perusahaan nyata._

## 🛠️ Tools

- **PostgreSQL** — database engine
- **DBeaver Community** — SQL client

## 🗺️ Skema Database

<!-- TODO: tempel screenshot ER Diagram dari DBeaver di sini -->
`screenshots/er_diagram.png`

## 📊 Project 1 — Sales Analysis

File: [`sql/02_sales_analysis.sql`](sql/02_sales_analysis.sql)

| # | Business Question | Key Insight |
|---|---|---|
| 1 | Berapa total revenue, total order, dan average order value? | _TODO: isi hasil angka & insight_ |
| 2 | Bagaimana tren revenue bulanan dan growth-nya? | _TODO_ |
| 3 | Produk apa yang paling laris (revenue & quantity)? | _TODO_ |
| 4 | Siapa 10 customer dengan kontribusi revenue terbesar? | _TODO_ |
| 5 | Bagaimana revenue breakdown per kategori produk? | _TODO_ |
| 6 | Bagaimana distribusi customer & revenue per membership tier? | _TODO_ |
| 7 | Kota/region mana penyumbang revenue terbesar? | _TODO_ |

## 💰 Project 2 — Financial Analysis

File: [`sql/03_financial_analysis.sql`](sql/03_financial_analysis.sql)

| # | Business Question | Key Insight |
|---|---|---|
| 1 | Berapa total revenue, COGS, gross profit, dan margin keseluruhan? | Total revenue Rp13.726.244.064, COGS Rp7.377.536.294, gross profit Rp6.348.707.770, **gross profit margin 46,25%** |
| 2 | Bagaimana tren gross profit margin per bulan? | _TODO: apakah margin cenderung stabil, membaik, atau memburuk?_ |
| 3 | Produk apa yang paling & paling tidak menguntungkan? | _TODO_ |
| 4 | Seberapa besar dampak refund terhadap net profit? | _TODO_ |

## 🚀 Cara Menjalankan

1. Buat database PostgreSQL baru.
2. Jalankan `sql/01_setup_schema.sql` untuk membuat seluruh tabel (urutan sudah disusun sesuai dependency foreign key).
3. Import data CSV ke masing-masing tabel (lewat DBeaver: klik kanan tabel → Import Data).
4. Jalankan query di `sql/02_sales_analysis.sql` dan `sql/03_financial_analysis.sql`.

## 👤 Tentang Project Ini

Dibuat sebagai bagian dari proses belajar SQL dari nol menuju Data Analyst, dengan latar belakang profesional di bidang Akuntansi — menunjukkan kombinasi pemahaman bisnis/finansial dengan kemampuan teknis SQL (JOIN, CTE, window functions, data aggregation).
