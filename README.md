# 📊 Student Performance Analysis (SQL Case Study)

## 📌 Project Overview
Proyek ini berfokus pada **Exploratory Data Analysis (EDA)** untuk mengidentifikasi faktor-faktor yang memengaruhi performa akademik siswa. Analisis dilakukan menggunakan dataset performa siswa dengan membedah aspek demografi (gender), manajemen waktu luar sekolah, tingkat kehadiran, serta faktor eksternal seperti dukungan orang tua.

## 🛠️ Tech Stack & Tools
- **Database:** MySQL (Data Cleaning & Exploratory Data Analysis)
- **Visualization:** PowerBI *(Work in Progress)*
- **Documentation:** Markdown

---

## 💾 Dataset Used
Dataset yang digunakan dalam proyek ini diambil dari Kaggle.

🔗 **[Dataset From Kaggle](https://www.kaggle.com/datasets/haseebindata/student-performance-predictions)**

---

## 🧹 Data Cleaning Phase
Sebelum masuk ke tahap analisis, data mentah dibersihkan terlebih dahulu menggunakan MySQL untuk memastikan hasil analisis terbebas dari bias (*noise*). Langkah pembersihan meliputi:
1. **Standardisasi Missing Value:** Mengubah string kosong atau teks `'NaN'` menjadi `NULL`.
2. **Penghapusan Baris Tanpa Target Variable:** Menghapus baris yang memiliki nilai `FinalGrade` kosong (`NULL`), karena baris tanpa nilai akhir tidak dapat digunakan untuk analisis pengaruh/kausalitas.
3. **Pembersihan Data Anomali:** Menetralkan data tidak logis seperti jam belajar bernilai negatif (`< 0`) dan tingkat kehadiran di atas 100% agar tidak merusak metrik statistik.
4. **Filter Demografi:** Mengabaikan data dengan gender `Unknown` untuk menjaga fokus pada esensi pertanyaan bisnis.

*Skrip pembersihan lengkap dapat dilihat pada file `sql/1_data_cleaning.sql`.*

---

## 🔍 Business Questions & Data Insights

### 1. Apakah terdapat kesenjangan performa akademik yang signifikan antara siswa laki-laki dan perempuan?
Analisis pada bagian ini mengeksplorasi apakah faktor demografi gender memiliki pengaruh atau pola tertentu terhadap performa akademik siswa di kelas.

**Output Data:**
| Gender | Total Siswa | Rata-Rata Nilai Akhir | Nilai Terendah | Nilai Tertinggi |
| :--- | :---: | :---: | :---: | :---: |
| **Female** | 607 | **80.65** | 62.0 | 92.0 |
| **Male** | 680 | 79.67 | 62.0 | 92.0 |

**Insight:**
Rata-rata nilai akhir siswa perempuan unggul **0.98 poin** dibandingkan siswa laki-laki. Uniknya, nilai tertinggi (`MAX`) dan terendah (`MIN`) pada kedua gender bernilai sama persis (62.0 dan 92.0). Hal ini mengindikasikan bahwa kapasitas individu terbaik antar gender adalah setara, namun siswa perempuan secara populasi memiliki konsistensi belajar yang lebih merata di kelompok nilai atas.

---

### 2. Dampak Durasi Belajar Mandiri Mingguan dan Tingkat Kehadiran Terhadap Nilai Akhir
Analisis pada bagian ini bertujuan untuk mengukur sejauh mana komitmen waktu belajar mandiri di luar jam sekolah serta kedisiplinan kehadiran siswa di kelas memengaruhi hasil akademik mereka.

#### A. Distribusi Berdasarkan Kategori Jam Belajar per Minggu (`StudyHoursPerWeek`)
**Output Data:**
| Kategori Jam Belajar | Total Siswa | Rata-Rata Nilai Akhir |
| :--- | :---: | :---: |
| 1. Rendah (<10 jam/minggu) | 126 | 79.10 |
| 2. Sedang (10-20 jam/minggu) | 779 | 79.88 |
| 3. Tinggi (>20 jam/minggu) | 382 | **80.99** |

#### B. Distribusi Berdasarkan Kategori Kehadiran Sekolah (`AttendanceRate`)
**Output Data:**
| Kategori Kehadiran | Total Siswa | Rata-Rata Nilai Akhir |
| :--- | :---: | :---: |
| 1. Kurang (<75%) | 132 | 79.52 |
| 2. Cukup (75-89%) | 603 | **80.14** |
| 3. Baik (>=90%) | 503 | 80.02 |

**Insight:**
- **Jam Belajar:** Menunjukkan korelasi linear positif yang jelas. Semakin tinggi durasi belajar mandiri siswa per minggu, semakin meningkat pula nilai akhir mereka, di mana kelompok jam belajar tinggi memuncaki nilai rata-rata (**80.99**).
- **Kehadiran:** Menunjukkan efek *plateau* yang menarik. Siswa dengan kehadiran **Cukup (75-89%)** meraih rata-rata nilai tertinggi (**80.14**), sedikit mengungguli kelompok kehadiran **Baik (80.02)**. Hal ini menandakan bahwa setelah melewati ambang batas kehadiran minimum (75%), faktor kehadiran fisik di kelas tidak lagi mendominasi peningkatan nilai secara signifikan jika tidak diimbangi oleh efektivitas belajar mandiri.

---

### 3. Bagaimana produktivitas siswa di luar jam sekolah memengaruhi nilai akhir mereka? (Counter-Intuitive Finding #1)
Siswa dikelompokkan ke dalam 4 segmen berdasarkan kombinasi aktivitas ekstra dan kelas online:
- **Minimalist:** Tidak ikut ekskul & tidak mengambil kelas online.
- **Digital Learner:** Hanya mengambil kelas online.
- **Traditional Active:** Hanya mengikuti kegiatan ekskul.
- **Well-Rounded:** Mengikuti ekskul sekaligus mengambil kelas online.

**Output Data:**
| Profil Siswa | Total Siswa | Rata-Rata Nilai Akhir | Jam Belajar / Minggu | Kehadiran Sekolah (%) |
| :--- | :---: | :---: | :---: | :---: |
| **1. Minimalist** | 358 | **80.62** | 17.20 jam | 85.84% |
| **2. Digital Learner** | 320 | 80.29 | 16.88 jam | 86.36% |
| **3. Traditional Active** | 315 | 80.06 | 17.85 jam | 85.39% |
| **4. Well-Rounded** | 361 | 79.68 | 17.43 jam | 85.51% |

**Insight:**
Ditemukan temuan yang tidak biasa (*counter-intuitive*). Siswa kelompok **Minimalist** justru meraih rata-rata nilai tertinggi (**80.62**), sedangkan kelompok **Well-Rounded** berada di posisi terendah (**79.68**). Meskipun kelompok *Well-Rounded* memiliki durasi belajar mandiri yang tinggi (17.43 jam/minggu), keterlibatan yang berlebihan di banyak aktivitas luar sekolah disinyalir memecah fokus mereka dan memicu kelelahan mental (*burnout*). Di sisi lain, kelompok *Minimalist* diuntungkan oleh otonomi waktu dan fokus kognitif yang sepenuhnya tercurah pada kurikulum utama sekolah.

---

### 4. Apakah tingkat dukungan orang tua yang semakin tinggi selalu menjamin nilai akademik yang lebih baik? (Counter-Intuitive Finding #2)
Analisis dilakukan untuk melihat korelasi tingkat dukungan orang tua (*Parental Support*) terhadap capaian nilai siswa.

**Output Data:**
| Parental Support | Total Siswa | Rata-Rata Nilai Akhir |
| :--- | :---: | :---: |
| **Medium** | 402 | **80.91** |
| **Low** | 405 | 80.29 |
| **High** | 448 | 79.45 |

**Insight:**
Data mematahkan asumsi umum bahwa dukungan tinggi otomatis menghasilkan nilai terbaik. Kelompok **Medium Support** menjadi *sweet spot* yang menghasilkan nilai tertinggi (**80.91**). Dukungan tingkat *High* justru menduduki peringkat terbawah (**79.45**). 

Kondisi ini mengindikasikan dua kemungkinan realita:
1. **Academic Stress:** Pengawasan orang tua yang terlalu ketat (*helicopter parenting*) menimbulkan tekanan psikologis yang kontraproduktif bagi anak.
2. **Reverse Causality (Sebab-Akibat Terbalik):** Orang tua cenderung baru mengintervensi dan memberikan dukungan tingkat tinggi (*High*) secara intensif ketika mendapati anak mereka sedang berjuang atau mengalami penurunan nilai di sekolah.

---

## 📊 PowerBI Dashboard
*(Work in Progress)*
Dashboard interaktif sedang dikembangkan di PowerBI Desktop untuk memvisualisasikan matriks segmentasi siswa dan mempermudah pemangku kebijakan sekolah melakukan filter data secara *real-time*.

---
*Proyek ini dikembangkan secara mandiri untuk kebutuhan portofolio data analytics.*
