
-- Cria a tabela alunos com as restrições
DROP TABLE alunos CASCADE CONSTRAINTS;
CREATE TABLE alunos 
   ( codAluno    NUMBER(8) NOT NULL
   , nome        VARCHAR2(100) NOT NULL
   , nota        NUMBER(4,2)
   , finalizado  CHAR(1) DEFAULT 'N' CONSTRAINT alunos_finalizado NOT NULL
  );

ALTER TABLE alunos  
ADD CONSTRAINT pk_alunos PRIMARY KEY(codAluno);

ALTER TABLE alunos
ADD CONSTRAINT alunos_finalizado_ck
CHECK (finalizado IN ('S', 'N'));


--Criação da sequencia Alunos
DROP SEQUENCE seq_alunos;
CREATE SEQUENCE seq_alunos
    START WITH 20230001
    INCREMENT BY 1
    MAXVALUE 20239999
    MINVALUE 1
;

--Criação do Trigger para inserir código autimaticamente
CREATE OR REPLACE TRIGGER trg_alunos
BEFORE INSERT ON alunos
FOR EACH ROW
BEGIN
    :new.codAluno := seq_alunos.nextval;
END;
/

INSERT INTO alunos(nome, nota) VALUES('Daniel Valadares Marculano',10);
INSERT INTO alunos(nome, nota) VALUES('Andre Prado Bonitao',9.9);
INSERT INTO alunos(nome, nota) VALUES('Joao Vitor Tarzan',8.5);
INSERT INTO alunos(nome, nota) VALUES('Pedro Lima Corno',5);
INSERT INTO alunos(nome, nota) VALUES('Yuri Alberto Lider',10);

UPDATE alunos
SET finalizado = 'S'
WHERE codAluno = 20230001
;
/*
UPDATE alunos
SET nome = 'CABRITO'
WHERE codAluno = 20230001
;*/

DROP TABLE usuarios CASCADE CONSTRAINTS;
CREATE TABLE usuarios
    (username   VARCHAR2(50) CONSTRAINT usuario_cargo_nn      NOT NULL
    ,permissao  VARCHAR2(1)  CONSTRAINT usuarios_permissao_nn NOT NULL
    );
    
ALTER TABLE usuarios
ADD CONSTRAINT usuarios_pk PRIMARY KEy (username);

ALTER TABLE usuarios
ADD CONSTRAINT usuarios_permissao_ck
CHECK(permissao IN('C', 'A'));

ALTER TABLE usuarios
ADD CONSTRAINT usuario_cargo_ck
CHECK (username in('HR', 'ADMIN'));

INSERT INTO usuarios(username, permissao) VALUES('ADMIN','A');
INSERT INTO usuarios(username, permissao) VALUES('HR','C');

CREATE OR REPLACE TRIGGER trg_usuarios_permissao
BEFORE UPDATE OR DELETE ON alunos
FOR EACH ROW
DECLARE
    permissao_sessao VARCHAR2(1);
BEGIN
SELECT 
    permissao
INTO
    permissao_sessao
FROM 
    usuarios
WHERE
    upper(username) = upper(user);
    
    IF permissao_sessao = 'C' and :old.finalizado = 'S'  THEN
    raise_application_error(-20000, 'Você não tem permissao para alterar ou atualizar a tabela alunos.');
    
    ELSIF permissao_sessao = 'A' and :old.finalizado = 'S' AND DELETING THEN
    raise_application_error(-20002, 'Você não pode deletar esse estudante.');
    END IF;
END;
/

-- CRIANDO USUARIOS
DROP USER  "ADMIN" CASCADE;
CREATE USER "ADMIN" IDENTIFIED BY "1234"  ;

-- ROLES
GRANT "DBA" TO "ADMIN" ;
GRANT "CONNECT" TO "ADMIN" ;
GRANT "RESOURCE" TO "ADMIN" ;

-- SYSTEM PRIVILEGES
GRANT CREATE ROLE TO "ADMIN" ;
GRANT CREATE TRIGGER TO "ADMIN" ;
GRANT ALTER SESSION TO "ADMIN" ;
GRANT CREATE VIEW TO "ADMIN" ;
GRANT CREATE SESSION TO "ADMIN" ;
GRANT CREATE TABLE TO "ADMIN" ;
GRANT ALTER USER TO "ADMIN" ;
GRANT CREATE SEQUENCE TO "ADMIN" ;
GRANT CREATE USER TO "ADMIN" ;
GRANT DROP USER TO "ADMIN" ;
GRANT ALTER SYSTEM TO "ADMIN" ;
GRANT DROP TABLESPACE TO "ADMIN" ;

CONNECT ADMIN/1234@localhost:1521/xepdb1

DELETE alunos 
WHERE codAluno = 20230001 ;


