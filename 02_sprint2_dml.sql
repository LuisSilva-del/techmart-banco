/* =================================================================
   HOMOLOGAÇÃO TÉCNICA: TECHMART CORPORATE SYSTEMS (db_techmart)
   CANDIDATO(A): [Luis Miguel Pereira da Silva]
   TURMA: [2º EM] | DATA: [09/12/2026]
   ARQUIVO: [02_sprint2_dml.sql]
   ===================================================================== */

USE db_techmart;

-- 1. Regiões de atuação
INSERT INTO regioes (id_regiao, nome_regiao) VALUES
(1, 'Sudeste'),
(2, 'Sul'),
(3, 'Nordeste');

-- 2. Unidades filiais
INSERT INTO filiais (id_filial, nome, cidade, id_regiao) VALUES
(10, 'TechMart SP Paulista', 'São Paulo', 1),
(20, 'TechMart RJ Copacabana', 'Rio de Janeiro', 1),
(30, 'TechMart PR Curitiba', 'Curitiba', 2),
(40, 'TechMart PE Recife', 'Recife', 3);

-- 3. Departamentos internos
INSERT INTO departamentos (id_departamento, nome_departamento) VALUES
(1, 'TI & Inovação'),
(2, 'Comercial & Vendas'),
(3, 'Recursos Humanos'),
(4, 'Logística & Suprimentos');

-- 4. Colaboradores
-- Fernando e o Diretor Geral e, por isso, não possui supervisor.
INSERT INTO colaboradores
(id_colaborador, nome, email, cargo, salario, id_filial, id_departamento, id_supervisor)
VALUES
(1, 'Fernando Silva', 'fernando@techmart.com', 'Diretor Geral', 12000.00, 10, 2, NULL),
(2, 'Roberto Costa', 'roberto@techmart.com', 'Líder de TI', 8500.00, 10, 1, 1),
(3, 'Mariana Souza', 'mariana@techmart.com', 'Analista de Sistemas', 5800.00, 10, 1, 2),
(4, 'Lucas Oliveira', 'lucas@techmart.com', 'Executivo de Vendas', 4200.00, 10, 2, 1),
(5, 'Camilla Rocha', 'camilla@techmart.com', 'Gerente Regional', 9000.00, 20, 2, 1),
(6, 'Gabriel Santos', 'gabriel@techmart.com', 'Vendedor Pleno', 3400.00, 20, 2, 5),
(7, 'Patricia Melo', 'patricia@techmart.com', 'Analista de RH', 4600.00, 30, 3, 5),
(8, 'Diego Ferreira', 'diego@techmart.com', 'Trainee Corporativo', 2100.00, 40, NULL, 3);

-- 5. Carteira de clientes
INSERT INTO clientes (id_cliente, nome, documento, tipo, cidade) VALUES
(101, 'Alpha Tech Solutions SA', '11.222.333/0001-01', 'PJ', 'São Paulo'),
(102, 'Ana Beatriz Nogueira', '123.456.789-00', 'PF', 'São Paulo'),
(103, 'Carlos Eduardo Lopes', '234.567.890-11', 'PF', 'Rio de Janeiro'),
(104, 'SulVarejo Comércio LTDA', '44.555.666/0001-99', 'PJ', 'Curitiba'),
(105, 'Fernanda Vasconcelos', '345.678.901-22', 'PF', 'Belo Horizonte'),
(106, 'Nordeste Digital ME', '77.888.999/0001-55', 'PJ', 'Recife');

-- 6. Categorias
INSERT INTO categorias (id_categoria, nome_categoria) VALUES
(1, 'Hardware & Notebooks'),
(2, 'Periféricos & Acessórios'),
(3, 'Redes & Servidores'),
(4, 'Mobiliário Corporativo');

-- 7. Produtos
INSERT INTO produtos
(id_produto, nome, preco_unitario, quantidade_estoque, id_categoria)
VALUES
(1001, 'Notebook Pro Workstation', 6000.00, 20, 1),
(1002, 'SSD NVMe 1TB Ultra', 500.00, 40, 1),
(1003, 'Mouse Vertical Ergonômico', 200.00, 60, 2),
(1004, 'Teclado Mecânico RGB', 400.00, 35, 2),
(1005, 'Switch Gigabit 24 Portas', 1500.00, 12, 3),
(1006, 'Roteador Wi-Fi 6 Mesh', 800.00, 25, 3);

-- 8. Pedidos
INSERT INTO pedidos
(id_pedido, data_pedido, valor_total, id_filial, id_colaborador, id_cliente)
VALUES
(5001, '2026-10-01 00:00:00', 13000.00, 10, 4, 101),
(5002, '2026-10-03 00:00:00', 600.00, 10, 4, 102),
(5003, '2026-10-05 00:00:00', 3000.00, 20, 6, 103),
(5004, '2026-10-10 00:00:00', 1600.00, 30, 7, 104),
(5005, '2026-10-12 00:00:00', 1500.00, 10, 4, 101),
(5006, '2026-10-15 00:00:00', 400.00, 20, 6, NULL);

-- 9. Itens dos pedidos
INSERT INTO itens_pedido
(id_pedido, id_produto, quantidade, preco_unitario)
VALUES
(5001, 1001, 2, 6000.00),
(5001, 1002, 2, 500.00),
(5002, 1003, 1, 200.00),
(5002, 1004, 1, 400.00),
(5003, 1005, 2, 1500.00),
(5004, 1006, 2, 800.00),
(5005, 1002, 3, 500.00),
(5006, 1003, 2, 200.00);

-- 1. Desempenho das lojas
SELECT
    f.nome AS filial,
    COUNT(p.id_pedido) AS quantidade_pedidos,
    COALESCE(SUM(p.valor_total), 0.00) AS total_faturado,
    COALESCE(ROUND(AVG(p.valor_total), 2), 0.00) AS valor_medio_por_pedido
FROM filiais f
LEFT JOIN pedidos p ON f.id_filial = p.id_filial
GROUP BY f.id_filial, f.nome
ORDER BY total_faturado DESC;

-- 2. Capital parado em estoque
SELECT
    c.nome_categoria,
    COUNT(DISTINCT p.id_produto) AS quantidade_produtos,
    SUM(p.preco_unitario * p.quantidade_estoque) AS valor_total_estoque
FROM categorias c
INNER JOIN produtos p ON c.id_categoria = p.id_categoria
GROUP BY c.id_categoria, c.nome_categoria
HAVING SUM(p.preco_unitario * p.quantidade_estoque) > 25000.00
ORDER BY valor_total_estoque DESC;

-- 3. Auditoria de vendas identificadas
SELECT
    p.id_pedido AS numero_pedido,
    p.data_pedido,
    cl.nome AS cliente,
    cl.tipo AS tipo_cliente,
    f.nome AS filial,
    co.nome AS vendedor,
    p.valor_total
FROM pedidos p
INNER JOIN clientes cl ON p.id_cliente = cl.id_cliente
INNER JOIN filiais f ON p.id_filial = f.id_filial
INNER JOIN colaboradores co ON p.id_colaborador = co.id_colaborador
ORDER BY p.id_pedido;

-- 4. Custo de pessoal por departamento
SELECT
    d.nome_departamento,
    COUNT(c.id_colaborador) AS quantidade_funcionarios,
    COALESCE(SUM(c.salario), 0.00) AS custo_total_folha
FROM departamentos d
LEFT JOIN colaboradores c ON d.id_departamento = c.id_departamento
GROUP BY d.id_departamento, d.nome_departamento
ORDER BY d.id_departamento;


