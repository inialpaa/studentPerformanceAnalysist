-- Cek Overview Awal
SELECT
	*
FROM student_analysist sa
LIMIT 10;

-- Cleaning Data
UPDATE student_analysist sa
SET 
    AttendanceRate = IF(AttendanceRate = '', NULL, AttendanceRate),
    ParentalSupport = IF(ParentalSupport = '', NULL, ParentalSupport),
    FinalGrade = IF(FinalGrade = '', NULL, FinalGrade),
    `Online Classes Taken` = IF(`Online Classes Taken` = '', NULL, `Online Classes Taken`);

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN StudentID IS NULL THEN 1 ELSE 0 END) AS missing_id,
    SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS missing_name,
    SUM(CASE WHEN AttendanceRate IS NULL THEN 1 ELSE 0 END) AS missing_attendance_rate,
    SUM(CASE WHEN ParentalSupport IS NULL THEN 1 ELSE 0 END) AS missing_parental,
    SUM(CASE WHEN FinalGrade IS NULL THEN 1 ELSE 0 END) AS missing_final_grade,
FROM student_analysist sa;

DELETE FROM student_analysist
WHERE StudentID IS NULL OR StudentID = '';

UPDATE student_analysist sa 
SET 
    `Study Hours` = IF(`Study Hours` < 0, NULL, `Study Hours`),
    `Attendance (%)` = IF(`Attendance (%)` > 100, NULL, `Attendance (%)`);

UPDATE student_analysist sa 
SET 
    ParentalSupport = COALESCE(NULLIF(ParentalSupport, ''), 'Unknown'),
    Gender = COALESCE(NULLIF(Gender, ''), 'Unknown');

DELETE FROM student_analysist  
WHERE FinalGrade IS NULL OR FinalGrade = '';

DELETE FROM student_analysist 
WHERE Gender = 'Unknown';

SELECT
	*
FROM student_analysist sa;
