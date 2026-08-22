# E-Commerce Shipping Dashboard

Dashboard interaktif berbasis **R Shiny** yang digunakan untuk melakukan eksplorasi dan analisis data pengiriman e-commerce. Dashboard menyajikan statistik deskriptif, visualisasi data, analisis korelasi, serta beberapa insight terkait pengiriman, produk, pelanggan, dan ketepatan waktu pengiriman.

Dashboard ini dikembangkan untuk mempermudah proses eksplorasi data **E-Commerce Shipping** secara interaktif. Pengguna dapat memilih variabel, melihat statistik deskriptif, mengeksplorasi distribusi data melalui berbagai visualisasi, menganalisis hubungan antarvariabel numerik, serta melihat beberapa ringkasan insight berdasarkan pertanyaan analisis yang tersedia.

---

Dashboard ini menjawab beberapa pertanyaan meliputi:

* Mode pengiriman dengan total berat terbesar
* Pengaruh warehouse terhadap biaya produk
* Hubungan product importance dengan discount offered
* Kategori product importance dengan rata-rata diskon tertinggi
* Perbedaan ketepatan waktu pengiriman berdasarkan gender
* Warehouse dengan rata-rata biaya produk tertinggi
* Distribusi customer rating berdasarkan mode pengiriman
* Distribusi berat pada pengiriman yang terlambat
* Hubungan customer care calls dengan ketepatan waktu pengiriman
* Hubungan prior purchases dengan customer rating

---

## Dataset

Dataset yang digunakan adalah **E-Commerce Shipping Data** yang diperoleh dari Kaggle: https://www.kaggle.com/datasets/prachi13/customer-analytics/data

Dataset terdiri dari **10.999 observasi dan 12 variabel** yang berkaitan dengan pelanggan, produk, warehouse, metode pengiriman, dan ketepatan waktu pengiriman.

### Variabel

| Variabel              | Keterangan                                     |
| --------------------- | ---------------------------------------------- |
| `ID`                  | Identitas unik pelanggan                       |
| `Warehouse_block`     | Blok warehouse                                 |
| `Mode_of_Shipment`    | Mode pengiriman: Ship, Flight, atau Road       |
| `Customer_care_calls` | Jumlah panggilan customer care                 |
| `Customer_rating`     | Rating pelanggan dari 1–5                      |
| `Cost_of_the_Product` | Biaya produk dalam US Dollar                   |
| `Prior_purchases`     | Jumlah pembelian sebelumnya                    |
| `Product_importance`  | Tingkat kepentingan produk                     |
| `Gender`              | Jenis kelamin pelanggan                        |
| `Discount_offered`    | Besarnya diskon yang diberikan                 |
| `Weight_in_gms`       | Berat produk dalam gram                        |
| `Reached.on.Time_Y.N` | Indikator apakah pengiriman sampai tepat waktu |
