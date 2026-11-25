DROP DATABASE IF EXISTS stg_enade;
CREATE DATABASE stg_enade;
USE stg_enade;

CREATE TABLE stg_resposta_submissao (
    idSubmissao INT,
    idQuestao INT,
    idEstudante INT,
    idSimulado INT,
    data_hora_submissao DATETIME,
    letra_marcada CHAR(1),
    texto_resposta TEXT
);

CREATE TABLE stg_estudante (
    id_estudante INT,
    codigo_anonimo VARCHAR(50),
    turma VARCHAR(50),
    curso VARCHAR(100)
);

CREATE TABLE stg_questao (
    id_questao INT,
    enunciado TEXT,
    resposta_correta CHAR(1),
    idEixo INT,
    idDificuldade INT
);

CREATE TABLE stg_alternativa (
    idQuestao INT,
    letra CHAR(1),
    texto_alternativa TEXT
);

CREATE TABLE stg_eixo_tematico (
    id_eixo INT,
    descricao_eixo VARCHAR(100)
);

CREATE TABLE stg_nivel_dificuldade (
    id_dificuldade INT,
    descricao_dificuldade VARCHAR(50)
);

CREATE TABLE stg_simulado (
    id_simulado INT,
    titulo VARCHAR(100),
    ano_edicao INT
);
