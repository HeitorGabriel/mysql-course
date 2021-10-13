CREATE DATABASE servblu2;

USE servblu2;

CREATE TABLE funcionarios();

CREATE TABLE funcionarios (
   id            int unsigned not null auto_increment,
   nome          varchar(45) not null,
   salario       double not null default '0',
   departamento  varchar(45) not null,
   PRIMARY KEY (id) 
 );

CREATE TABLE veiculos (
   id          int unsigned not null auto_increment,
   funcion_id  int unsigned default null,
   veiculo     varchar(45) not null default '',
   placa       varchar(10) not null default '',
   PRIMARY KEY (id),
   CONSTRAINT relac_func_veic FOREIGN KEY (funcion_id) REFERENCES funcionarios (id)
);

-- a linha CONSTRAINT cria uma relação, "relac_func_veic", aliando "funcion_id" com a chave externa "id", da tabela "funcionarios".

-- agora vamos alterar a variável "nome" da tabela funcionários: alterar o rótulo da variável e seu tamanho.

ALTER TABLE funcionarios CHANGE COLUMN nome nome_func varchar(50) not null;

CREATE INDEX ind_depart ON funcionarios (departamento);
CREATE INDEX ind_nome   ON funcionarios (nome_func(6));
