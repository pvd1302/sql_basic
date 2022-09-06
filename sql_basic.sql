--A Basic query
-- 1. Li?t kê danh sách sinh viên s?p x?p theo th? t?:
--      a. id t?ng d?n

select *
from student
ORDER BY id ASC;

--      b. gi?i tính

select *
from student
ORDER BY gender;

--      c.ngày sinh T?NG D?N và h?c b?ng GI?M D?N
SELECT *
FROM student
ORDER BY birthday ASC,scholarship DESC;

-- 2. Môn h?c có tên b?t ??u b?ng ch? 'T'
SELECT *
FROM subject
WHERE name like'T%';

-- 3. Sinh viên có ch? cái cu?i cùng trong tên là 'i'
select *
from student
where name like'%i';

-- 4. Nh?ng khoa có ký t? th? hai c?a tên khoa có ch?a ch? 'n'
select *
from faculty
where name like'_n%';

-- 5. Sinh viên trong tên có t? 'Th?'
select *
from student
where name like'%Th?'
;
-- 6. Sinh viên có ký t? ??u tiên c?a tên n?m trong kho?ng t? 'a' ??n 'm', s?p x?p theo h? tên sinh viên
SELECT *
FROM student
WHERE name BETWEEN 'A' AND 'M'
ORDER BY name;
;
-- 7. Sinh viên có h?c b?ng l?n h?n 100000, s?p x?p theo mã khoa gi?m d?n
select *
from student
where scholarship>100000
ORDER BY faculty_id DESC;

-- 8. Sinh viên có h?c b?ng t? 150000 tr? lên và sinh ? Hà N?i
select *
from student
where scholarship>=150000 and hometown=N'Hà N?i';

-- 9. Nh?ng sinh viên có ngày sinh t? ngày 01/01/1991 ??n ngày 05/06/1992
select *
from student 
where birthday between '01-JAN-91' and '05-JUN-92';

-- 10. Nh?ng sinh viên có h?c b?ng t? 80000 ??n 150000
select *
from student
where scholarship between 80000 and 150000

-- 11. Nh?ng môn h?c có s? ti?t l?n h?n 30 và nh? h?n 45
select *
from subject
where lesson_quantity>30 and lesson_quantity<45

/********* B. CALCULATION QUERY *********/

-- 1. Cho bi?t thông tin v? m?c h?c b?ng c?a các sinh viên, g?m: Mã sinh viên, Gi?i tính, Mã 
		-- khoa, M?c h?c b?ng. Trong ?ó, m?c h?c b?ng s? hi?n th? là “H?c b?ng cao” n?u giá tr? 
		-- c?a h?c b?ng l?n h?n 500,000 và ng??c l?i hi?n th? là “M?c trung bình”.
SELECT id, name, gender, scholarship, CASE
WHEN scholarship > 500000 THEN'Học bổng cao'
ELSE'Mức trung bình'
END AS "Mức học bổng"
FROM student
where scholarship IS not  Null;

-- 2. Tính tổng số sinh viên của toàn trường
SELECT COUNT(*) "Tổng sinh viên"
FROM student;

-- 3. Tính tổng số sinh viên nam và tổng số sinh viên nữ.
SELECT gender, COUNT(*) "Tổng sinh viên"
FROM student
GROUP BY gender;

-- 4. Tính tổng số sinh viên từng khoa
SELECT faculty_id AS "Khoa", COUNT(*) "Tổng sinh viên"
FROM student
GROUP BY faculty_id;

-- 5. Tính tổng số sinh viên của từng môn học
SELECT su.name, COUNT(*)
FROM student s
LEFT JOIN exam_management ex ON s.id = ex.student_id
RIGHT JOIN subject        su ON su.id = ex.subject_id
GROUP BY su.name;

-- 6. Tính số lượng môn học mà sinh viên đã học
SELECT COUNT(*) "Tong mon"
FROM   (SELECT subject_id
       FROM exam_management
       GROUP BY subject_id);

-- 7. Tổng số học bổng của mỗi khoa
SELECT faculty_id AS "Khoa", COUNT(*) "Số học bổng"
FROM student
WHERE scholarship IS NOT NULL
GROUP BY faculty_id;

-- 8. Cho biết học bổng cao nhất của mỗi khoa
SELECT faculty_id "Khoa", MAX(scholarship) AS "Học bổng cao nhất"
FROM student
WHERE scholarship IS NOT NULL
GROUP BY faculty_id;

-- 9. Cho biết tổng số sinh viên nam và tổng số sinh viên nữ của mỗi khoa
SELECT faculty_id AS "Khoa", gender, COUNT(*)   AS "Học bổng cao nhất"
FROM student
GROUP BY faculty_id, gender;

-- 10. Cho biết số lượng sinh viên theo từng độ tuổi
--CURRENT_TIMESTAMP tra ve thoi gian hien tai
-- EXTRACT cat year
SELECT ( EXTRACT(YEAR FROM current_timestamp) - EXTRACT(YEAR FROM birthday) ) AS "Tuoi"
, COUNT(*) AS "So luong"
FROM student
GROUP BY ( EXTRACT(YEAR FROM current_timestamp) - EXTRACT(YEAR FROM birthday) );

-- 11. Cho biết những nơi nào có ít nhất 2 sinh viên đang theo học tại trường
SELECT hometown, COUNT(*) AS "Số lượng"
FROM student
GROUP BY hometown
HAVING COUNT(*) > 1;

-- 12. Cho biết những sinh viên thi lại ít nhất 2 lần
SELECT s.name, ex.number_of_exam_taking
FROM student s
JOIN exam_management ex ON s.id = ex.student_id
WHERE ex.number_of_exam_taking > 1
GROUP BY s.name, ex.number_of_exam_taking;

-- 13. Cho biết những sinh viên nam có điểm trung bình lần 1 trên 7.0
SELECT s.name, ROUND(Avg(ex.mark),2)
FROM student s
JOIN exam_management ex ON s.id = ex.student_id
WHERE ex.number_of_exam_taking = 1
GROUP BY s.name
HAVING   Avg(ex.mark) > 7.0 ;

-- 14. Cho biết danh sách các sinh viên rớt ít nhất 2 môn ở lần thi 1 (rớt môn là điểm thi của môn không quá 4 điểm)
SELECT s.name, COUNT(*) AS "SỐ MÔN RỚT"
FROM student s
JOIN exam_management ex ON s.id = ex.student_id
WHERE ex.number_of_exam_taking = 1
      AND ex.mark < 4
GROUP BY s.name
HAVING COUNT(*) > 1;

-- 15. Cho biết danh sách những khoa có nhiều hơn 2 sinh viên nam
SELECT f.name,count(*)
FROM student s
JOIN faculty f ON s.faculty_id = f.id
WHERE s.gender = 'Nam'
GROUP BY f.name
HAVING count(*) >1 ;

-- 16. Cho biết những khoa có 2 sinh viên đạt học bổng từ 200000 đến 300000
SELECT f.name
FROM student s
JOIN faculty f ON s.faculty_id = f.id
WHERE scholarship BETWEEN 200000 AND 300000
GROUP BY f.name
HAVING COUNT(*) > 1;

-- 17. Cho biết sinh viên nào có học bổng cao nhất
SELECT *
FROM student
WHERE scholarship = (
    SELECT MAX(scholarship)
    FROM student
);

/********* C. DATE/TIME QUERY *********/
-- 1. Sinh viên có n?i sinh ? Hà N?i và sinh vào tháng 02
select *
from student
where hometown=N'Hà N?i' and EXTRACT(MONTH FROM birthday)=2;

-- 2. Sinh viên có tu?i l?n h?n 20
select *
from student
where EXTRACT(YEAR FROM CURRENT_TIMESTAMP)-EXTRACT(YEAR FROM birthday)>30;

-- 3. Sinh viên sinh vào mùa xuân n?m 1990
select *
from student
where EXTRACT(MONTH FROM birthday) in (1,2,3) and EXTRACT(YEAR FROM birthday)=1990;

/********* D. JOIN QUERY *********/

-- 1. Danh sách các sinh viên c?a khoa ANH V?N và khoa V?T LÝ
SELECT * 
FROM faculty inner join student on faculty.id = student.faculty_id
where faculty.name like N'Anh - V?n' or faculty.name like N'V?t lý';


-- 2. Nh?ng sinh viên nam c?a khoa ANH V?N và khoa TIN H?C
SELECT * 
FROM faculty inner join student on faculty.id = student.faculty_id
where faculty.name like N'Anh - V?n' or faculty.name like N'Tin h?c'
group by student.gender like N'Nam';

-- 3. Cho bi?t sinh viên nào có ?i?m thi l?n 1 môn c? s? d? li?u cao nh?t
select st.name"H? tên  sinh viên", sb.name"tên môn h?c", number_of_exam_taking, mark
from exam_management ex, subject sb, student st
where st.id = ex.student_id and  ex.subject_id=sb.id and number_of_exam_taking=1 and sb.name=N'C? s? d? li?u'
and mark=
(
SELECT MAX(mark)
FROM exam_management ex, subject sb
where ex.subject_id  = sb.id and sb.name=N'C? s? d? li?u' and number_of_exam_taking=1
);

--4. Cho bi?t sinh viên khoa anh v?n có tu?i l?n nh?t.
select *
FROM student
where birthday=(
SELECT min(birthday)
FROM student 
where faculty_id='1');

-- 5. Cho bi?t khoa nào có ?ông sinh viên nh?t
select fa.name
from faculty fa,student sv
where sv.faculty_id=fa.id
group by fa.name
having count(fa.name)>=all(select count(sv.id)
from student
group by faculty_id);

-- 6. Cho bi?t khoa nào có ?ông n? nh?t
select fa.name
from faculty fa,student sv
where sv.faculty_id=fa.id and gender=N'N?'
group by fa.name
having count(fa.name)>=all(select count(sv.id)
from student
group by faculty_id);

-- 7. Cho bi?t nh?ng sinh viên ??t ?i?m cao nh?t trong t?ng môn
select exam_management.student_id,exam_management.subject_id,mark
from exam_management, (select exam_management.subject_id, max(mark) as maxdiem
from exam_management
group by exam_management.subject_id) a
where exam_management.subject_id=a.subject_id and mark=a.maxdiem;

-- 8. Cho bi?t nh?ng khoa không có sinh viên h?c
select *
from faculty
where not exists (select distinct faculty_id
from exam_management ex join student sv on ex.student_id=sv.id where  sv.faculty_id=faculty.id)

 9. Cho bi?t sinh viên ch?a thi môn c? s? d? li?u
select *
FROM student
where not exists
(select distinct*
from exam_management
where subject_id = '1' and student_id = student.id);

-- 10. Cho bi?t sinh viên nào không thi l?n 1 mà có d? thi l?n 2
select student_id
from exam_management ex
where number_of_exam_taking=2 and not exists
(select*
from exam_management
where number_of_exam_taking=1 and student_id=ex.student_id);