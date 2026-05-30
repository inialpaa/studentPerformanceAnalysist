-- Cek overview setelah cleaning
SELECT
	*
FROM student_analysist sa 
LIMIT 10;

-- Nilai Akhir Siswa Berdasarkan Gender
-- Apakah terdapat kesenjangan performa akademik yang signifikan antara siswa laki-laki dan perempuan?

SELECT 
    Gender,
    COUNT(*) AS total_siswa,
    ROUND(AVG(FinalGrade), 2) AS rata_rata_nilai_akhir,
    ROUND(MIN(FinalGrade), 2) AS nilai_terendah,
    ROUND(MAX(FinalGrade), 2) AS nilai_tertinggi
FROM student_analysist sa
GROUP BY Gender;

-- Pengharuh Waktu Belajar Terhadap Nilai Akhir Siswa
-- Bagaimana dampak durasi belajar mandiri mingguan terhadap hasil akhir siswa?

SELECT 
    CASE 
        WHEN StudyHoursPerWeek < 10 THEN '1. Rendah (<10 jam/minggu)'
        WHEN StudyHoursPerWeek BETWEEN 10 AND 20 THEN '2. Sedang (10-20 jam/minggu)'
        ELSE '3. Tinggi (>20 jam/minggu)'
    END AS Kategori_Jam_Belajar,
    COUNT(*) AS Total_Siswa,
    ROUND(AVG(FinalGrade), 2) AS Rata_Rata_Nilai
FROM student_analysist sa
GROUP BY 1
ORDER BY Kategori_Jam_Belajar;

-- Pengaruh Tingkat Kehadiran Terhadap Nilai Akhir Siswa
-- Bagaimana dampak tingkat kehadiran di kelas terhadap hasil akhir siswa?

SELECT 
    CASE 
        WHEN AttendanceRate < 75 THEN '1. Kurang (<75%)'
        WHEN AttendanceRate BETWEEN 75 AND 89 THEN '2. Cukup (75-89%)'
        ELSE '3. Baik (>=90%)'
    END AS Kategori_Kehadiran,
    COUNT(*) AS Total_Siswa,
    ROUND(AVG(FinalGrade), 2) AS Rata_Rata_Nilai
FROM student_analysist sa 
WHERE AttendanceRate IS NOT NULL
GROUP BY 1
ORDER BY Kategori_Kehadiran;

-- Segmentasi Siswa Di Luar Jam Sekolah
-- "Apakah siswa yang terlalu banyak mengambil kegiatan (Ekskul + Kelas Online) justru kelelahan (burnout) sehingga nilainya turun? Atau justru mereka yang paling berprestasi karena pandai mengatur waktu?"

SELECT 
    CASE 
        WHEN `Online Classes Taken` = 'True' AND ExtracurricularActivities > 0 THEN '1. Well-Rounded (Ekskul & Kelas Online)'
        WHEN `Online Classes Taken` = 'True' AND ExtracurricularActivities = 0 THEN '2. Digital Learner (Hanya Kelas Online)'
        WHEN `Online Classes Taken` = 'False' AND ExtracurricularActivities > 0 THEN '3. Traditional Active (Hanya Ekskul)'
        ELSE '4. Minimalist (Tidak Keduanya)'
    END AS Profil_Keterlibatan_Siswa,
    COUNT(*) AS Total_Siswa,
    ROUND(AVG(FinalGrade), 2) AS Rata_Rata_Nilai_Akhir,
    ROUND(AVG(StudyHoursPerWeek), 2) AS Rata_Rata_Jam_Belajar_Per_Minggu,
    ROUND(AVG(AttendanceRate), 2) AS Rata_Rata_Kehadiran_Sekolah
FROM student_analysist sa 
WHERE `Online Classes Taken` IS NOT NULL 
  AND `Online Classes Taken` != ''
GROUP BY 1
ORDER BY Rata_Rata_Nilai_Akhir DESC;

-- Pengaruh Dukungan Orang Tua Terhadap Nilai Akhir Siswa
-- Seberapa besar peran dukungan orang tua dalam mendongkrak pencapaian akademik anak?

SELECT 
    ParentalSupport,
    COUNT(*) AS Total_Siswa,
    ROUND(AVG(FinalGrade), 2) AS Rata_Rata_Nilai
FROM student_analysist sa 
WHERE ParentalSupport IS NOT NULL AND ParentalSupport != 'Unknown'
GROUP BY ParentalSupport
ORDER BY Rata_Rata_Nilai DESC;
