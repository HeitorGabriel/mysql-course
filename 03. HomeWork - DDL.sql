
CREATE DATABASE db_softblue;

USE db_softblue;

CREATE TABLE instrutor (
    cod_instr   tinyint unsigned not null auto_increment,
    nome        varchar(120) not null,
    telefone    bigint unsigned not null,
    PRIMARY KEY (cod_instr)
);

CREATE TABLE curso (
    cod_crs      tinyint unsigned not null auto_increment,
    nome         varchar(50) not null,
    tipo         varchar(50) not null,
    preço        smallint unsigned zerofill not null,
    instrutor    tinyint unsigned not null,
    PRIMARY KEY  (cod_crs),
    CONSTRAINT   relac_crs_instr
                 FOREIGN KEY (instrutor) REFERENCES instrutor (cod_instr)
);

CREATE TABLE alunos (
    cod_alun     int unsigned not null auto_increment,
    nome         varchar(120) not null,
    cep          int unsigned not null,
    num_dom      varchar(7) not null,
    cidade       varchar(50) not null default '',
    estado       varchar(2) not null default '',
    email        varchar(120) not null default '',
    PRIMARY KEY  (cod_alun)
);

CREATE TABLE vendas (
    cod_operação int unsigned not null auto_increment,
    momento      datetime not null auto_increment,
    cliente      int unsigned not null,
    curso        tinyint unsigned not null,
    PRIMARY KEY  (cod_operação),
    CONSTRAINT   relac_cli_alun
                 FOREIGN KEY (cliente) REFERENCES alunos (cod_alun),
    CONSTRAINT   relac_crs_crs
                 FOREIGN KEY (curso) REFERENCES curso (cod_crs)
);

CREATE TABLE formas_de_pagamento (
    forma       varchar(50) not null,
    cod_forma   tinyint unsigned not null auto_increment,
    PRIMARY KEY (cod_forma)
);

CREATE TABLE detalhes_vendas (
    operação    int unsigned not null,
    pagamento   tinyint unsigned not null,
    montante    int unsigned zerofill not null,
    CONSTRAINT  relac_oper_oper
                FOREIGN KEY (operação) REFERENCES vendas (cod_operação),
    CONSTRAINT  relac_pag_pag
                FOREIGN KEY (pagamento) REFERENCES formas_de_pagamento (cod_forma)
);

-- agora alteraremos as estruturas de acordo com a lista de exercícios propostos:
--    1) Inclua a coluna DATA_NASCIMENTO na tabela ALUNO do tipo string, de tamanho 10 caracteres;
--    2) Altere a coluna DATA_NASCIMENTO para NASCIMENTO e seu tipo de dado para DATE;
--    3) Crie um novo índice na tabela ALUNO, para o campo ALUNO;
--    4) Inclua o campo EMAIL na tabela INSTRUTOR, com tamanho de 100 caracteres;
--    5) Crie um novo índice na tabela CURSO, para o campo INSTRUTOR;
--    6) Remova o campo EMAIL da tabela INSTRUTOR;

ALTER TABLE alunos ADD data_nasc varchar(10) not null;

ALTER TABLE alunos CHANGE COLUMN data_nasc nasc date not null;

CREATE INDEX ind_alun_nome ON alunos (nome);

ALTER TABLE instrutor ADD email varchar(100) not null;

CREATE INDEX ind_instr_crs ON curso (instrutor);

ALTER TABLE instrutor DROP COLUMN email;
