-- Задание 1. Выбрать технические факультеты, на которых обучается более 200 студентов.
SELECT * 
FROM faculties 
WHERE max_students > 200 AND activity_type != 'Гуманитарные науки';


-- Задание 2. Выбрать группы, обучающиеся на факультете теоретической физики, максимальное количество человек в которых больше 20.
SELECT g.* 
FROM groups g
JOIN faculties f ON g.faculty_code = f.faculty_code
WHERE f.faculty_name = 'Факультет теоретической физики' 
  AND g.max_people > 20;


-- Задание 3. Создать таблицу, содержащую данные 1 запроса и номера групп, относящихся к этим факультетам.
DROP TABLE IF EXISTS tech_faculties_groups;

SELECT f.faculty_code, f.faculty_name, f.max_students, f.activity_type, g.group_number
INTO tech_faculties_groups
FROM faculties f
JOIN groups g ON f.faculty_code = g.faculty_code
WHERE f.max_students > 200 AND f.activity_type != 'Гуманитарные науки';


-- Задание 4. В созданную таблицу добавить группы, в которых должно обучаться меньше 15 человек.
INSERT INTO tech_faculties_groups (faculty_code, faculty_name, max_students, activity_type, group_number)
SELECT f.faculty_code, f.faculty_name, f.max_students, f.activity_type, g.group_number
FROM faculties f
JOIN groups g ON f.faculty_code = g.faculty_code
WHERE g.max_people < 15;


-- Задание 5. В созданной таблице у всех групп, относящихся к техническим факультетам изменить первую букву на «Т».
UPDATE tech_faculties_groups
SET group_number = 'Т' || SUBSTRING(group_number FROM 2)
WHERE activity_type != 'Гуманитарные науки';


-- Задание 6. Удалить из созданной таблицы все записи для групп, у которых отсутствует куратор.
DELETE FROM tech_faculties_groups
WHERE group_number IN (
    SELECT g.group_number 
    FROM groups g 
    WHERE g.curator IS NULL
) OR group_number IN (
    SELECT 'Т' || SUBSTRING(g.group_number FROM 2) 
    FROM groups g 
    WHERE g.curator IS NULL
);


-- Задание 7. Посчитать количество групп и максимально возможное количество студентов на каждом факультете.
SELECT f.faculty_name, 
       COUNT(g.group_number) AS total_groups, 
       SUM(g.max_people) AS total_max_students
FROM faculties f
LEFT JOIN groups g ON f.faculty_code = g.faculty_code
GROUP BY f.faculty_name
ORDER BY f.faculty_name;
