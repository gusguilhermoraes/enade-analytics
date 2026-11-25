USE stg_enade;

TRUNCATE TABLE stg_enade.stg_resposta_submissao;
TRUNCATE TABLE stg_enade.stg_estudante;
TRUNCATE TABLE stg_enade.stg_questao;
TRUNCATE TABLE stg_enade.stg_alternativa;
TRUNCATE TABLE stg_enade.stg_eixo_tematico;
TRUNCATE TABLE stg_enade.stg_nivel_dificuldade;
TRUNCATE TABLE stg_enade.stg_simulado;

/* Extrair Respostas */
INSERT INTO stg_enade.stg_resposta_submissao (idSubmissao, idQuestao, idEstudante, idSimulado, data_hora_submissao, letra_marcada, texto_resposta)
SELECT
    r.idSubmissao,
    r.idQuestao,
    s.idEstudante,
    s.idSimulado,
    s.data_hora_submissao,
    r.letra_marcada,
    r.texto_resposta
FROM enade_oltp.RespostaSubmissao r
JOIN enade_oltp.Submissao s ON r.idSubmissao = s.id_submissao;

/* Extrair Estudante */
INSERT INTO stg_enade.stg_estudante (id_estudante, codigo_anonimo, turma, curso)
SELECT e.id_estudante, e.codigo_anonimo, e.turma, e.curso
FROM enade_oltp.Estudante e;

/* Extrair Questao */
INSERT INTO stg_enade.stg_questao (id_questao, enunciado, resposta_correta, idEixo, idDificuldade)
SELECT q.id_questao, q.enunciado, q.resposta_correta, q.idEixo, q.idDificuldade
FROM enade_oltp.Questao q;

/* Extrair Alternativa */
INSERT INTO stg_enade.stg_alternativa (idQuestao, letra, texto_alternativa)
SELECT a.idQuestao, a.letra, a.texto_alternativa
FROM enade_oltp.Alternativa a;

/* Extrair Eixo Tematico */
INSERT INTO stg_enade.stg_eixo_tematico (id_eixo, descricao_eixo)
SELECT et.id_eixo, et.descricao_eixo
FROM enade_oltp.EixoTematico et;

/* Extrair Nivel de Dificuldade */
INSERT INTO stg_enade.stg_nivel_dificuldade (id_dificuldade, descricao_dificuldade)
SELECT nd.id_dificuldade, nd.descricao_dificuldade
FROM enade_oltp.NivelDificuldade nd;

/* Extrair Simulado */
INSERT INTO stg_enade.stg_simulado (id_simulado, titulo, ano_edicao)
SELECT sim.id_simulado, sim.titulo, sim.ano_edicao
FROM enade_oltp.Simulado sim;

/* Validacao COUNT(*) */
SELECT 'RespostaSubmissao' AS tabela, COUNT(*) AS total_oltp, (SELECT COUNT(*) FROM stg_enade.stg_resposta_submissao) AS total_stage FROM enade_oltp.RespostaSubmissao
UNION ALL
SELECT 'Estudante', COUNT(*), (SELECT COUNT(*) FROM stg_enade.stg_estudante) FROM enade_oltp.Estudante
UNION ALL
SELECT 'Questao', COUNT(*), (SELECT COUNT(*) FROM stg_enade.stg_questao) FROM enade_oltp.Questao
UNION ALL
SELECT 'Simulado', COUNT(*), (SELECT COUNT(*) FROM stg_enade.stg_simulado) FROM enade_oltp.Simulado;
