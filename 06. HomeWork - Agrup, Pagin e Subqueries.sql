sudo mysql -uroot -p

show databases;

USE db_softblue;

SHOW TABLES;

-- Selecione os nomes de todos os alunos que já fizeram alguma matrícula na Softblue, sem repetição;

SELECT DISTINCT(a.nome) FROM alunos a JOIN vendas v ON v.cliente = a.cod_alun;

-- Exiba o nome do aluno mais antigo da Softblue;

SELECT a.nome FROM alunos a JOIN vendas v1 ON v1.cliente = a.cod_alun WHERE v1.momento = (
  SELECT MAX(v2.momento) FROM vendas v2
);

-- Exiba o nome do aluno mais recente da Softblue;

SELECT a.nome FROM alunos a JOIN vendas v1 ON
  v1.cliente = a.cod_alun WHERE v1.momento = (
       SELECT MIN(v2.momento) FROM vendas v2
);

-- Exiba o nome do terceiro aluno mais antigo da Softblue;

SELECT DISTINCT(a.nome), v.momento FROM alunos a JOIN vendas v ON v.cliente = a.cod_alun ORDER BY v.momento LIMIT 1 OFFSET 2;

-- Exiba a quantidade de cursos que já foram vendidos pela Softblue;

SELECT COUNT(curso) FROM vendas;

-- Exiba o valor total já arrecadado pelos cursos vendidos pela Softblue;

SELECT SUM(montante) FROM detalhes_vendas;

-- Exiba o valor médio cobrado por curso para o pedido cujo CODIGO é 2;

SELECT detv.montante / COUNT(v.curso) FROM detalhes_vendas detv JOIN vendas v ON detv.cop_operação = v.cod_oper WHERE v.cod_oper=2;

-- Exiba o valor do curso mais caro da Softblue;

SELECT * FROM curso ORDER BY preço DESC;

SELECT c1.nome FROM curso c1 WHERE c1.preço = (SELECT MAX(c2.preço) FROM curso c2);

-- Exiba o valor do curso mais barato da Softblue;

SELECT * FROM curso ORDER BY preço ASC;

SELECT c1.nome FROM curso c1 WHERE c1.preço = (SELECT MIN(c2.preço) FROM curso c2);

-- Exiba o valor total de cada pedido realizado na Softblue;

SELECT cop_operação, montante FROM detalhes_vendas;

-- Exiba os nomes dos instrutores da Softblue e a quantidade de cursos que cada um tem sob sua responsabilidade;

SELECT inst.nome, COUNT(cur.cod_crs) FROM instrutor inst JOIN curso cur ON cur.instrutor = inst.cod_instr GROUP BY cur.instrutor;

-- Exiba o número do pedido, nome do aluno e valor para todos os pedidos realizados na Softblue cujo valor total sejam maiores que 500;

SELECT DISTINCT(v.cod_oper), v.cliente, a.nome, dv.montante FROM vendas v
   JOIN detalhes_vendas dv ON v.cod_oper = dv.cop_operação
   JOIN alunos a ON a.cod_alun = v.cliente
   WHERE dv.montante >= 500; -- ñ sei pq veio as info repitidas, coloq o distinct e deu certo, fica a dúvida...

-- Exiba o número do pedido, nome do aluno e quantos cursos foram comprados no pedido para todos os pedidos realizados na Softblue que compraram dois ou mais cursos;

DESCRIBE vendas;
DESCRIBE detalhes_vendas;
DESCRIBE alunos;

SELECT v.momento, a.nome, v.cod_oper, dv.montante FROM
 vendas v JOIN detalhes_vendas dv ON dv.cop_operação=v.cod_oper
          JOIN alunos a ON a.cod_alun = v.cliente;


SELECT a.nome, COUNT(v.cod_oper), dv.montante FROM
 vendas v JOIN detalhes_vendas dv ON dv.cop_operação=v.cod_oper
          JOIN alunos a ON a.cod_alun = v.cliente GROUP BY a.nome, dv.montante;

SELECT a.nome, COUNT(v.cod_oper), dv.montante FROM
 vendas v JOIN detalhes_vendas dv ON dv.cop_operação=v.cod_oper
          JOIN alunos a ON a.cod_alun = v.cliente GROUP BY a.nome, dv.montante HAVING dv.montante>=500;

-- Exiba o nome e endereço de todos os alunos que morem em Avenidas (Av.);

SELECT nome, endereço FROM alunos WHERE endereço LIKE '%Av%';

-- Exiba os nomes dos cursos de Java da Softblue;

DESCRIBE curso;
DESCRIBE tipo_crs;

SELECT nome FROM curso WHERE nome LIKE '%ava%';

-- Utilizando subquery, exiba uma lista com os nomes dos cursos disponibilizados pela Softblue informando para cada curso qual o seu menor valor de venda já praticado;

DESCRIBE vendas;
DESCRIBE detalhes_vendas;
-- !! Não dá pra fazer essa ips literis o que foi pedido: o valor é por pedido, não por curso.

-- Utilizando subquery e o parâmetro IN, exiba os nomes dos cursos disponibilizados pela Softblue cujo tipo de curso seja 'Programação';

DESCRIBE curso;
DESCRIBE tipo_crs;

SELECT c.nome, tc.tipo FROM curso c
   JOIN tipo_crs tc USING (cod_tip) WHERE tc.tipo LIKE '%rogram%';

-- Utilizando subquery e o parâmetro EXISTS, exiba novamente os nomes dos cursos disponibilizados pela Softblue cujo tipo de curso seja 'Programação';



-- Exiba uma lista com os nomes dos instrutores da Softblue e ao lado o total acumulado das vendas referente aos cursos pelo qual o instrutor é responsável;

DESCRIBE curso;
SELECT * from curso;
DESCRIBE vendas;
SELECT * from vendas;
DESCRIBE instrutor;

SELECT i.nome AS instrutor,
       c.nome AS curso,
       v.curso AS curso_vendido
FROM curso c JOIN instrutor i ON i.cod_instr=c.instrutor
             JOIN vendas v ON v.curso=c.cod_crs;

SELECT i.nome AS instrutor,
       COUNT(v.curso) AS núm_vendas,
       SUM(c.preço) AS total_faturado
FROM curso c JOIN instrutor i ON i.cod_instr=c.instrutor
             JOIN vendas v ON v.curso=c.cod_crs
GROUP BY i.nome;

-- Crie uma visão que exiba os nomes dos alunos e quanto cada um já comprou em cursos;

SELECT * from vendas;
SELECT * from detalhes_vendas;
SELECT * from alunos;

CREATE VIEW view_alun_montant AS
    SELECT a.nome, SUM(dv.montante) AS total_pago
       FROM alunos a JOIN vendas v ON v.cliente=a.cod_alun
                     JOIN detalhes_vendas dv ON dv.cop_operação = v.cod_oper
       GROUP BY a.nome;

SELECT * FROM view_alun_montant;
