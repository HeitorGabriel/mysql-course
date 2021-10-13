sudo mysql -uroot -p

show databases;

USE db_softblue;

SHOW TABLES;

DESCRIBE alunos;
DESCRIBE instrutor;
DESCRIBE curso;
DESCRIBE formas_de_pagamento;
DESCRIBE detalhes_vendas;
DESCRIBE vendas;

-- Exiba uma lista com os títulos dos cursos da Softblue e o tipo de curso ao lado;

SELECT * FROM tipo_crs;
SELECT * FROM curso;

SELECT * FROM curso INNER JOIN tipo_crs USING (cod_tip);
SELECT nome, tipo FROM curso   JOIN tipo_crs USING (cod_tip);
SELECT tipo, nome FROM curso c JOIN tipo_crs tc ON c.cod_tip=tc.cod_tip;

--Exiba uma lista com os títulos dos cursos da Softblue, tipo do curso, nome do instrutor responsável pelo mesmo e telefone;

SELECT c.nome, tc.tipo, i.nome, i.telefone FROM
instrutor i INNER JOIN curso c     ON c.instrutor = i.cod_instr
            INNER JOIN tipo_crs tc USING (cod_tip);

--Exiba uma lista com o código e data e hora dos pedidos e os títulos dos cursos de cada pedido;

SELECT v.momento, c.nome FROM
vendas v JOIN curso c ON v.curso = c.cod_crs;

--Exiba uma lista com o código e data e hora dos pedidos, nome do aluno e os títulos dos cursos de cada pedido;

SELECT v.momento, c.nome AS curso_comprado, a.nome AS nome_aluno FROM
curso c JOIN vendas v ON v.curso = c.cod_crs
        JOIN alunos a ON a.cod_alun = v.cliente;

--Crie uma visão que traga o título e preço somente dos cursos de programação da Softblue;

SELECT * FROM curso;
SELECT * FROM tipo_crs;
CREATE VIEW view_prog_curs AS SELECT nome, preço FROM curso WHERE cod_tip=2;

SELECT * FROM view_prog_curs;

--Crie uma visão que traga os títulos dos cursos, tipo do curso e nome do instrutor;

CREATE VIEW view_2 AS SELECT c.nome AS curso, tc.tipo, i.nome AS instrutor FROM
curso c JOIN tipo_crs tc USING (cod_tip)
        JOIN instrutor i  ON c.instrutor = i.cod_instr;

SELECT * FROM view_2;

--Crie uma visão que exiba os pedidos realizados, informando o nome do aluno, data e código do pedido;

CREATE VIEW view_3 AS SELECT v.cod_oper, v.momento, a.nome AS Aluno, c.nome AS Curso FROM
curso c JOIN vendas v ON v.curso = c.cod_crs
        JOIN alunos a ON a.cod_alun = v.cliente;

SELECT * FROM view_3;
