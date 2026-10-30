-- 1. Выбрать технические факультеты, на которых обучается более 200 студентов.
SELECT * FROM Faculties 
WHERE max_students > 200 AND activity_type IN ('IT', 'Строительство', 'Химия');

-- 2. Выбрать группы, обучающиеся на факультете теоретической физики, максимальное количество человек в которых больше 20. (В нашем случае взят ИТ-факультет)
SELECT Groups.* 
FROM Groups
JOIN Faculties ON Groups.faculty_code = Faculties.faculty_code
WHERE Faculties.faculty_name = 'Факультет информационных технологий' 
  AND Groups.max_people > 20;

-- 3. Создать таблицу, содержащую данные 1 запроса и номера групп, относящихся к этим факультетам.
CREATE TABLE Tech_Faculties_Groups (
    faculty_code INT,
    faculty_name VARCHAR(100),
    group_number VARCHAR(10),
    max_people INT
);

INSERT INTO Tech_Faculties_Groups (faculty_code, faculty_name, group_number, max_people)
SELECT F.faculty_code, F.faculty_name, G.group_number, G.max_people
FROM Faculties F
JOIN Groups G ON F.faculty_code = G.faculty_code
WHERE F.max_students > 200 AND F.activity_type IN ('IT', 'Строительство', 'Химия');

-- 4. В созданную таблицу добавить группы, в которых должно обучаться меньше 15 человек.
INSERT INTO Tech_Faculties_Groups (faculty_code, faculty_name, group_number, max_people)
SELECT G.faculty_code, F.faculty_name, G.group_number, G.max_people
FROM Groups G
JOIN Faculties F ON G.faculty_code = F.faculty_code
WHERE G.max_people < 15;

-- 5. В созданной таблице у всех групп, относящихся к техническим факультетам изменить первую букву на «Т».
UPDATE Tech_Faculties_Groups
SET group_number = 'Т' || SUBSTRING(group_number FROM 2)
WHERE faculty_code IN (SELECT faculty_code FROM Faculties WHERE activity_type IN ('IT', 'Строительство', 'Химия'));

-- 6. Удалить из созданной таблицы все записи для групп, у которых отсутствует куратор.
DELETE FROM Tech_Faculties_Groups
WHERE group_number IN (
    SELECT group_number FROM Groups WHERE curator IS NULL
);

-- 7. Посчитать количество групп и максимально возможное количество студентов на каждом факультете.
SELECT F.faculty_name, 
       COUNT(G.group_number) AS "Кол-во групп", 
       SUM(G.max_people) AS "Мест в группах", 
       MAX(F.max_students) AS "Максимум на фак-те"
FROM Faculties F
LEFT JOIN Groups G ON F.faculty_code = G.faculty_code
GROUP BY F.faculty_name;
