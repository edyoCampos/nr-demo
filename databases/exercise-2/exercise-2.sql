-- Exercise 2: relational database (JOINs and filters)
-- Uses the schema and data from exercise 1, so run exercise-1.sql first:
--   docker exec -i orion_postgres_db psql -U orion_user -d orion_db -v ON_ERROR_STOP=1 < ../exercise-1/exercise-1.sql
--   docker exec -i orion_postgres_db psql -U orion_user -d orion_db -v ON_ERROR_STOP=1 < exercise-2.sql
-- Running exercise-1.sql again restores the original data (Maria back in Desenvolvimento Web).

\echo '--- 1. INNER JOIN: student name and course name'
SELECT a.nome, c.nome_curso
FROM alunos a
INNER JOIN cursos c ON c.id = a.curso_id
ORDER BY a.id;

\echo '--- 2. JOIN + WHERE: only the students in Desenvolvimento Web'
SELECT a.nome, c.nome_curso
FROM alunos a
INNER JOIN cursos c ON c.id = a.curso_id
WHERE c.nome_curso = 'Desenvolvimento Web'
ORDER BY a.id;

\echo '--- 3. UPDATE: move Maria to Ciência de Dados'
UPDATE alunos
SET curso_id = (SELECT id FROM cursos WHERE nome_curso = 'Ciência de Dados')
WHERE nome = 'Maria';

\echo '--- 3. Same JOIN as item 1: the change is visible'
SELECT a.nome, c.nome_curso
FROM alunos a
INNER JOIN cursos c ON c.id = a.curso_id
ORDER BY a.id;

\echo '--- Extra: LEFT JOIN + WHERE: courses without any student'
SELECT c.nome_curso
FROM cursos c
LEFT JOIN alunos a ON a.curso_id = c.id
WHERE a.id IS NULL;
