/* =================================================================
   HOMOLOGAÇÃO TÉCNICA: TECHMART CORPORATE SYSTEMS (db_techmart)
   CANDIDATO(A): [Luis Miguel Pereira da Silva]
   TURMA: [2º EM] | DATA: [09/12/2026]
   ARQUIVO: [01_sprint1_ddl.sql]
   ===================================================================== */

CREATE DATABASE db_techmart;
USE db_techmart;

-- ---------------------------------------------------------------------
-- 2. TABELAS DE DOMÍNIO E CADASTROS BÁSICOS
-- ---------------------------------------------------------------------

-- Regiões geográficas de atuação
CREATE TABLE regioes (
    id_regiao INT PRIMARY KEY AUTO_INCREMENT,
    nome_regiao VARCHAR(50) NOT NULL UNIQUE
);

-- Setores internos da empresa
CREATE TABLE departamentos (
    id_departamento INT PRIMARY KEY AUTO_INCREMENT,
    nome_departamento VARCHAR(50) NOT NULL UNIQUE
);

-- Categorias de classificação dos produtos
CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nome_categoria VARCHAR(50) NOT NULL UNIQUE
);

-- Cadastro de clientes (Pessoa Física e Jurídica)
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    documento VARCHAR(20) NOT NULL UNIQUE,
    tipo ENUM('PF', 'PJ') NOT NULL,
    cidade VARCHAR(100) NOT NULL
);

-- ---------------------------------------------------------------------
-- 3. TABELAS ESTRUTURAIS E DE CATÁLOGO
-- ---------------------------------------------------------------------

-- Unidades e lojas físicas vinculadas às regiões
CREATE TABLE filiais (
    id_filial INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL UNIQUE,
    cidade VARCHAR(100) NOT NULL,
    id_regiao INT NOT NULL,
    CONSTRAINT fk_filiais_regioes FOREIGN KEY (id_regiao) REFERENCES regioes(id_regiao)
);

-- Funcionários, seus vínculos e hierarquia de supervisão
CREATE TABLE colaboradores (
    id_colaborador INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    cargo VARCHAR(100) NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    id_filial INT NOT NULL,
    id_departamento INT NULL,
    id_supervisor INT NULL,
    CONSTRAINT fk_colaboradores_filiais FOREIGN KEY (id_filial) REFERENCES filiais(id_filial),
    CONSTRAINT fk_colaboradores_departamentos FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento),
    CONSTRAINT fk_colaboradores_supervisor FOREIGN KEY (id_supervisor) REFERENCES colaboradores(id_colaborador)
);

-- Catálogo de produtos e controle de estoque
CREATE TABLE produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL UNIQUE,
    preco_unitario DECIMAL(10,2) NOT NULL,
    quantidade_estoque INT NOT NULL DEFAULT 0,
    id_categoria INT NOT NULL,
    CONSTRAINT fk_produtos_categorias FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

-- ---------------------------------------------------------------------
-- 4. TABELAS TRANSACIONAIS (VENDAS)
-- ---------------------------------------------------------------------

-- Cabeçalho e resumo de cada pedido realizado
CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    data_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    id_filial INT NOT NULL,
    id_colaborador INT NOT NULL,
    id_cliente INT NULL,
    CONSTRAINT fk_pedidos_filiais FOREIGN KEY (id_filial) REFERENCES filiais(id_filial),
    CONSTRAINT fk_pedidos_colaboradores FOREIGN KEY (id_colaborador) REFERENCES colaboradores(id_colaborador),
    CONSTRAINT fk_pedidos_clientes FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Detalhamento dos produtos vendidos em cada pedido
CREATE TABLE itens_pedido (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_itens_pedidos FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
    CONSTRAINT fk_itens_produtos FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

-- ---------------------------------------------------------------------
-- 5. AUDITORIA E CONTROLE
-- ---------------------------------------------------------------------

-- Registro histórico de operações realizadas no banco
CREATE TABLE log_auditoria_operacoes (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo_operacao VARCHAR(50) NOT NULL,
    descricao TEXT NOT NULL,
    usuario_banco VARCHAR(100) NOT NULL
);