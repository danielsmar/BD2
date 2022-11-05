
-- Cria a tabela alunos com as restrições
DROP TABLE alunos;
CREATE TABLE alunos 
   ( codAluno    NUMBER(8) NOT NULL
   , nome        VARCHAR2(100) NOT NULL
   , nota        NUMBER(4,2)
   , finalizado  CHAR(1) DEFAULT 'N'
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


--Criação do Trigger para  impedir a alteração/remoção de dados da tabela alunos caso finalizado seja 'S'
CREATE OR REPLACE TRIGGER trg_alunos_finalizado
BEFORE UPDATE OR DELETE ON ALUNOS
FOR EACH ROW
BEGIN
    if :old.finalizado = 'S' THEN
    raise_application_error(-20002, 'Impossível Alterar, o Aluno Está Finalizado');
    end if;
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

/*UPDATE alunos
SET nome = 'Claudio da Silva'
WHERE codAluno = 20230001
;*/

CREATE TABLE usuarios
    (username   VARCHAR2(50) NOT NULL
    ,permissao  VARCHAR2(1)  NOT NULL
    );
    
ALTER TABLE usuarios
ADD CONSTRAINT usuarios_pk PRIMARY KEy (username);

ALTER TABLE usuarios
ADD CONSTRAINT usuarios_permissao_ck
CHECK(permissao IN('C', 'A'));


CREATE OR REPLACE TRIGGER trg_usuarios_permissao
BEFORE UPDATE OR DELETE ON alunos
FOR EACH ROW
DECLARE
    trg_permissao VARCHAR2(1);
BEGIN
    SELECT permissao
    INTO trg_permissao
    FROM usuarios
    WHERE username = user
    ;
    
    IF trg_permissao = 'A' AND :old.finalizado = 'N'
    
    ELSIF trg_permissao = 'C' AND :old.finalizado = 'N'
    
    IF :old.finalizado = 'S' THEN
    raise_application_error(-20002, 'Impossível Alterar, o Aluno Está Finalizado');
    END IF;
END ;

SELECT * FROM alunos;

