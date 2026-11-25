DROP DATABASE IF EXISTS enade_oltp;
CREATE DATABASE enade_oltp;
USE enade_oltp;

CREATE TABLE Simulado (
    id_simulado INT PRIMARY KEY,
    titulo VARCHAR(100),
    ano_edicao INT
);

CREATE TABLE EixoTematico (
    id_eixo INT PRIMARY KEY,
    descricao_eixo VARCHAR(100)
);

CREATE TABLE NivelDificuldade (
    id_dificuldade INT PRIMARY KEY,
    descricao_dificuldade VARCHAR(50)
);

CREATE TABLE Questao (
    id_questao INT PRIMARY KEY,
    enunciado TEXT,
    resposta_correta CHAR(1),
    idEixo INT,
    idDificuldade INT
);

CREATE TABLE Alternativa (
    idQuestao INT,
    letra CHAR(1),
    texto_alternativa TEXT,
    PRIMARY KEY (idQuestao, letra)
);

CREATE TABLE Estudante (
    id_estudante INT PRIMARY KEY,
    codigo_anonimo VARCHAR(50),
    turma VARCHAR(50),
    curso VARCHAR(100),
    consentimento TEXT
);

CREATE TABLE Submissao (
    id_submissao INT PRIMARY KEY,
    idEstudante INT NOT NULL,
    idSimulado INT NOT NULL,
    data_hora_submissao DATETIME,
    pontuacao_total INT
);

CREATE TABLE RespostaSubmissao (
    idSubmissao INT,
    idQuestao INT,
    letra_marcada CHAR(1),
    texto_resposta TEXT,
    PRIMARY KEY (idSubmissao, idQuestao)
);

/* RELACIONAMENTOS OLTP */
ALTER TABLE Questao ADD FOREIGN KEY (idEixo) REFERENCES EixoTematico (id_eixo);
ALTER TABLE Questao ADD FOREIGN KEY (idDificuldade) REFERENCES NivelDificuldade (id_dificuldade);
ALTER TABLE Alternativa ADD FOREIGN KEY (idQuestao) REFERENCES Questao (id_questao);
ALTER TABLE Submissao ADD FOREIGN KEY (idEstudante) REFERENCES Estudante (id_estudante);
ALTER TABLE Submissao ADD FOREIGN KEY (idSimulado) REFERENCES Simulado (id_simulado);
ALTER TABLE RespostaSubmissao ADD FOREIGN KEY (idSubmissao) REFERENCES Submissao (id_submissao);
ALTER TABLE RespostaSubmissao ADD FOREIGN KEY (idQuestao) REFERENCES Questao (id_questao);
