DROP TABLE alunos;
DROP TABLE usuarios;

create table alunos (
    codAluno number(8) not null,
    nomeAluno   varchar2(100) not null,
    notaAluno   number(4,2),
    finalizado  char(1) default 'N'
);
alter table alunos add constraint alunos_pk primary key(codAluno);

drop sequence seq_alunos;

create sequence seq_alunos
start with 20230001
maxvalue 20239999
minvalue 1
increment by 1;



INSERT INTO alunos(codAluno, nomeAluno, notaAluno) VALUES(seq_alunos.nextval, 'Daniel Valadares Marculano',10);
INSERT INTO alunos(codAluno, nomeAluno, notaAluno) VALUES(seq_alunos.nextval, 'Andre Prado Bonitao',9.9);

create table usuarios (
    nomeUsuario  varchar2(100) not null,
    permissao char(1) not null
); 

alter table usuarios add constraint usuarios_pk primary key(nomeUsuario);




select * from alunos;

