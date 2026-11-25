USE dw_enade;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE dw_enade.fato_resposta;
TRUNCATE TABLE dw_enade.dim_aluno;
TRUNCATE TABLE dw_enade.dim_questao;
TRUNCATE TABLE dw_enade.dim_simulado;
TRUNCATE TABLE dw_enade.dim_data;
SET FOREIGN_KEY_CHECKS = 1;

/* CARGA DIM_ALUNO (Pseudonimizado conforme LGPD + padronizacao de turma) */
INSERT INTO dw_enade.dim_aluno (aluno_id, turma, curso)
SELECT 
    TRIM(e.codigo_anonimo) AS aluno_id,
    CASE
        WHEN UPPER(TRIM(e.turma)) IN ('GTI6', '6 SEMESTRE') OR UPPER(TRIM(e.turma)) LIKE '6%PERIODO' THEN 'GTI6'
        WHEN UPPER(TRIM(e.turma)) = 'GTI4' THEN 'GTI4'
        ELSE 'GTI'
    END AS turma,
    e.curso
FROM stg_enade.stg_estudante e;

/* CARGA DIM_QUESTAO (Agrupamento nos 6 macro-eixos + ordem da dificuldade + alternativas) */
INSERT INTO dw_enade.dim_questao (questao_id, enunciado, eixo_tematico, nivel_dificuldade, ordem_dificuldade, alternativas, resposta)
SELECT 
    q.id_questao AS questao_id,
    q.enunciado,
    CASE
        WHEN et.descricao_eixo LIKE '%COBIT%' OR et.descricao_eixo LIKE '%ITIL%' OR et.descricao_eixo LIKE '%SLA%' THEN 'Governança, Gestão e Serviços de TI'
        WHEN et.descricao_eixo LIKE '%Projetos%' THEN 'Gestão de Projetos'
        WHEN et.descricao_eixo LIKE '%Segurança%' OR et.descricao_eixo LIKE '%Continuidade%' THEN 'Segurança da Informação e Continuidade'
        WHEN et.descricao_eixo LIKE '%Engenharia%' OR et.descricao_eixo LIKE '%Arquitetura%' THEN 'Engenharia de Software e Arquitetura'
        WHEN et.descricao_eixo LIKE '%Nuvem%' OR et.descricao_eixo LIKE '%Tendências%' THEN 'Infraestrutura, Nuvem e Inovação'
        ELSE 'Sistemas Corporativos, Dados e Formação Geral'
    END AS eixo_tematico,
    nd.descricao_dificuldade AS nivel_dificuldade,
    CASE
        WHEN nd.descricao_dificuldade = 'Fácil' THEN 1
        WHEN nd.descricao_dificuldade = 'Médio' THEN 2
        WHEN nd.descricao_dificuldade = 'Difícil' THEN 3
        ELSE 4
    END AS ordem_dificuldade,
    GROUP_CONCAT(CONCAT(a.letra, ') ', a.texto_alternativa) ORDER BY a.letra SEPARATOR ' | ') AS alternativas,
    q.resposta_correta AS resposta
FROM stg_enade.stg_questao q
LEFT JOIN stg_enade.stg_eixo_tematico et ON q.idEixo = et.id_eixo
LEFT JOIN stg_enade.stg_nivel_dificuldade nd ON q.idDificuldade = nd.id_dificuldade
LEFT JOIN stg_enade.stg_alternativa a ON q.id_questao = a.idQuestao
GROUP BY q.id_questao, q.enunciado, et.descricao_eixo, nd.descricao_dificuldade, q.resposta_correta;

/* CARGA DIM_SIMULADO */
INSERT INTO dw_enade.dim_simulado (simulado_id, ano_edicao)
SELECT s.id_simulado AS simulado_id, s.ano_edicao
FROM stg_enade.stg_simulado s;

/* CARGA DIM_DATA */
INSERT INTO dw_enade.dim_data (data)
SELECT DISTINCT DATE(r.data_hora_submissao) AS data
FROM stg_enade.stg_resposta_submissao r
ORDER BY data;

/* CARGA FATO_RESPOSTA */
INSERT INTO dw_enade.fato_resposta 
    (aluno_id, questao_id, simulado_id, data_id, flag_certo_errado, nota, tempo_resposta)
SELECT
    TRIM(e.codigo_anonimo) AS aluno_id,
    r.idQuestao AS questao_id,
    r.idSimulado AS simulado_id,
    dd.data_id,
    CASE WHEN r.letra_marcada = dq.resposta THEN 1 ELSE 0 END AS flag_certo_errado,
    CASE WHEN r.letra_marcada = dq.resposta THEN 10.00 ELSE 0.00 END AS nota,
    NULL AS tempo_resposta
FROM stg_enade.stg_resposta_submissao r
JOIN stg_enade.stg_estudante e ON r.idEstudante = e.id_estudante
JOIN dw_enade.dim_questao dq ON dq.questao_id = r.idQuestao
JOIN dw_enade.dim_data dd ON dd.data = DATE(r.data_hora_submissao);

/* Conferencia final (128 registros na fato e ordenacao das dificuldades) */
SELECT COUNT(*) AS total_fato_resposta FROM dw_enade.fato_resposta;
SELECT DISTINCT nivel_dificuldade, ordem_dificuldade FROM dw_enade.dim_questao ORDER BY ordem_dificuldade;