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

-- Exercícios 1 -------
-- o exercício pede a tab 'curso' diferente: o tipo de curso deve ser uma outra tabela específica com relacionamento para ela. Vamos fazer:

ALTER TABLE curso DROP COLUMN tipo;

CREATE TABLE tipo_crs (
  cod_tip     tinyint unsigned not null auto_increment,
  tipo        varchar(50) NOT NULL,
  PRIMARY KEY (cod_tip)
);

ALTER TABLE curso ADD COLUMN cod_tip tinyint unsigned not null;

ALTER TABLE curso ADD CONSTRAINT relac_tip_tip FOREIGN KEY (cod_tip) REFERENCES tipo_crs (cod_tip);

-- a minha tabla de alunos tbm está diferente da dele, vamos ajeitar, né:

ALTER TABLE alunos DROP COLUMN cep,
                   DROP COLUMN num_dom,
                   DROP COLUMN cidade,
                   DROP COLUMN estado,
                   DROP COLUMN nasc;

ALTER TABLE alunos ADD endereço VARCHAR(150) NOT NULL;

-- ERRO GRAVE : a tab 'detalhes_vendas' é que deveria gerar a operação para a tab 'vendas'. Na primeira tab é que 'operação' não se repete!

--ALTER TABLE detalhes_vendas CHANGE COLUMN operação cod_operação int unsigned not null auto_increment PRIMARY KEY;
-- ALTER TABLE detalhes_vendas
--    DROP CONSTRAINT relac_oper_oper,
--    CHANGE COLUMN operação int unsigned not null auto_increment,
--    ADD CONSTRAINT key_oper
--        PRIMARY KEY (operação);

-- com os códigos acima, tentei renomear e mudar propriedades da variável que é foreign key, parece q não pode. Apagua-las-ei e farei novas!

ALTER TABLE detalhes_vendas
    DROP CONSTRAINT relac_oper_oper,
    DROP operação,
    ADD COLUMN cop_operação int unsigned not null auto_increment PRIMARY KEY;

ALTER TABLE vendas
    DROP cod_operação,
    ADD COLUMN cod_oper int unsigned,
    ADD CONSTRAINT relac_oper_oper
        FOREIGN KEY (cod_oper) REFERENCES detalhes_vendas (cop_operação);

-- conferir se deu tudo certo:

DESCRIBE curso;
DESCRIBE alunos;
DESCRIBE tipo_crs;
DESCRIBE detalhes_vendas;
DESCRIBE vendas;

-- agora vamos popular as tabelas:

INSERT INTO tipo_crs (tipo) VALUES
    ('Banco de Dados'),
    ('Programação'),
    ('Modelagem de Dados');

INSERT INTO instrutor (nome, telefone) VALUES
    ('André Milani','11111111'),
    ('Carlos Tosin','12121212');

INSERT INTO curso (nome, cod_, instrutor, preço) VALUES
    ('Java Fundamentos','2', '2', '270'),
    ('Java Avançado',   '2', '2', '330'),
    ('SQL Completo',    '1', '1', '170'),
    ('Php Básico',      '2', '1', '270');

INSERT INTO alunos (nome, endereço, email) VALUES
    ('José',     'Rua XV de Novembro 72',  'jose@softblue.com.br'),
    ('Wagner',   'Av. Paulista',           'wagner@softblue.com.br'),
    ('Emílio',   'Rua Lajes 103, ap: 701', 'emilio@softblue.com.br'),
    ('Cris',     'Rua Tauney 22',          'cris@softblue.com.br'),
    ('Regina',   'Rua Salles 305',         'regina@softblue.com.br'),
    ('Fernando', 'Av. Central 30',         'fernando@softblue.com.br');

INSERT INTO formas_de_pagamento (forma) VALUES
    ('Débito'),
    ('Crédito'),
    ('Boleto'),
    ('Pix');

INSERT INTO detalhes_vendas (pagamento, montante) VALUES
    ('1','170'),
    ('3','440'),
    ('4','270'),
    ('2','600'),
    ('1','500');


INSERT INTO vendas (cod_oper, momento, cliente, curso) VALUES
    ('1', '2019-05-16 15:00:00', '1', '3'),
    ('2', '2020-01-01 14:01:00', '3', '3'),
    ('2', '2020-01-01 14:01:00', '3', '4'),
    ('3', '2021-11-01 20:30:55', '6', '1'),
    ('4', '2020-10-03 12:15:02', '5', '1'),
    ('4', '2020-10-03 12:15:02', '5', '2'),
    ('5', '2021-03-22 16:12:07', '4', '2'),
    ('5', '2021-03-22 16:12:07', '4', '3');

-- Exercícios 2 -------

SELECT * FROM alunos;
SELECT nome FROM curso;
SELECT nome, preço FROM curso WHERE preço > 200;
SELECT nome, preço FROM curso WHERE preço > 200 AND preço < 300;
-- or: SELECT nome, preço FROM curso WHERE preço BETWEEN 200 AND 300;
SELECT * FROM vendas WHERE momento BETWEEN '2020-01-01' AND '2020-12-31';
SELECT * FROM vendas WHERE DATE(momento) = '2020-01-01';

-- Exercícios 3 -------

UPDATE alunos SET endereço='Av. Brasil, 666' WHERE nome LIKE '%os%';

UPDATE alunos SET email='cristiana@softblue.com.br' WHERE nome='Cris';

UPDATE curso SET preço = ROUND(preço*1.1, 2) WHERE preço < 300;

SELECT cod_crs FROM curso WHERE nome LIKE '%php%';
UPDATE curso SET nome='Php Fundamentos' WHERE cod_crs= 4;

SELECT * FROM curso;
