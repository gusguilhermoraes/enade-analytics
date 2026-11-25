DROP SCHEMA IF EXISTS dw_enade;
CREATE SCHEMA dw_enade;
USE dw_enade;

/* DIMENSAO ALUNO */
CREATE TABLE dim_aluno (
    aluno_id VARCHAR(50) PRIMARY KEY,
    turma VARCHAR(30),
    curso VARCHAR(100)
);

/* DIMENSAO QUESTAO */
CREATE TABLE dim_questao (
    questao_id INT PRIMARY KEY,
    enunciado TEXT,
    eixo_tematico VARCHAR(100),
    nivel_dificuldade VARCHAR(50),
    ordem_dificuldade INT,
    alternativas TEXT,
    resposta CHAR(1)
);

/* DIMENSAO SIMULADO */
CREATE TABLE dim_simulado (
    simulado_id INT PRIMARY KEY,
    ano_edicao INT
);

/* DIMENSAO DATA */
CREATE TABLE dim_data (
    data_id INT PRIMARY KEY AUTO_INCREMENT,
    data DATE UNIQUE
);

/* TABELA FATO RESPOSTA */
CREATE TABLE fato_resposta (
    aluno_id VARCHAR(50),
    questao_id INT,
    simulado_id INT,
    data_id INT,
    flag_certo_errado INT,
    nota DECIMAL(5,2),
    tempo_resposta INT,
    PRIMARY KEY (aluno_id, questao_id, simulado_id, data_id)
);

/* RELACIONAMENTOS (ESQUEMA ESTRELA) */
ALTER TABLE fato_resposta ADD CONSTRAINT fk_aluno FOREIGN KEY (aluno_id) REFERENCES dim_aluno(aluno_id);
ALTER TABLE fato_resposta ADD CONSTRAINT fk_questao FOREIGN KEY (questao_id) REFERENCES dim_questao(questao_id);
ALTER TABLE fato_resposta ADD CONSTRAINT fk_simulado FOREIGN KEY (simulado_id) REFERENCES dim_simulado(simulado_id);
ALTER TABLE fato_resposta ADD CONSTRAINT fk_data FOREIGN KEY (data_id) REFERENCES dim_data(data_id);