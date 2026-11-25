/* =================================================================
   HOMOLOGAÇÃO TÉCNICA: TECHMART CORPORATE SYSTEMS (db_techmart)
   CANDIDATO(A): [Luis Miguel Pereira da Silva]
   TURMA: [2º EM] | DATA: [09/12/2026]
   ARQUIVO: [01_sprint1_ddl.sql]
   ===================================================================== */
   
   DROP DATABASE IF EXISTS db_techmart;

CREATE DATABASE db_techmart;
USE db_techmart;

-- Tabela regiões
CREATE TABLE regioes (
	id_regioes INT PRIMARY KEY AUTO_INCREMENT,
    nome_regioes VARCHAR(50) NOT NULL UNIQUE
    );

-- Tabela departamentos
CREATE TABLE departamentos (
    id_departamento INT PRIMARY KEY AUTO_INCREMENT,
    nome_departamento VARCHAR(50) NOT NULL UNIQUE
);

-- Tabela categorias
CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nome_categoria VARCHAR(50) NOT NULL UNIQUE
);

