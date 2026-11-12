-- Exercise 1: relational database (basic SQL)
-- Run with:
--   docker exec -i orion_postgres_db psql -U orion_user -d orion_db -v ON_ERROR_STOP=1 < exercise-1.sql

-- Drop the tables first so the script can be run again.
-- alunos goes together with cursos because it references it.
DROP TABLE IF EXISTS alunos, cursos;

-- Table cursos: primary key (numeric) and course name (text).
CREATE TABLE cursos (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome_curso TEXT
);

-- Table alunos: primary key, name, email and curso_id as a foreign key to cursos(id).
CREATE TABLE alunos (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome TEXT,
    email TEXT,
    curso_id INTEGER,
    FOREIGN KEY (curso_id) REFERENCES cursos (id)
);

-- Three courses. The last one has no students on purpose (used by the extra in exercise 2).
INSERT INTO cursos (nome_curso) VALUES
    ('Desenvolvimento Web'),
    ('Ciência de Dados'),
    ('Gestão de Projetos');

-- Four students. The course id is looked up by name instead of using fixed ids.
INSERT INTO alunos (nome, email, curso_id) VALUES
    ('João Silva', 'joao.silva@example.com',
        (SELECT id FROM cursos WHERE nome_curso = 'Desenvolvimento Web')),
    ('Maria', 'maria@example.com',
        (SELECT id FROM cursos WHERE nome_curso = 'Desenvolvimento Web')),
    ('Carlos Souza', 'carlos.souza@example.com',
        (SELECT id FROM cursos WHERE nome_curso = 'Ciência de Dados')),
    ('Ana Pereira', 'ana.pereira@example.com',
        (SELECT id FROM cursos WHERE nome_curso = 'Ciência de Dados'));

SELECT * FROM alunos;

-- Foreign key check (kept commented so the script keeps running without errors).
-- There is no course with id 999, so the foreign key must reject this insert:
--   INSERT INTO alunos (nome, email, curso_id)
--   VALUES ('Invalid Student', 'invalid@example.com', 999);
-- Expected result: ERROR: insert or update on table "alunos" violates foreign key constraint
