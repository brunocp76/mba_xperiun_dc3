--                                                                                                          
--   ######                                                  ######                                         
--   #     #   ##   #    #  ####   ####     #####  ######    #     #   ##   #####   ####   ####             
--   #     #  #  #  ##   # #    # #    #    #    # #         #     #  #  #  #    # #    # #                 
--   ######  #    # # #  # #      #    #    #    # #####     #     # #    # #    # #    #  ####             
--   #     # ###### #  # # #      #    #    #    # #         #     # ###### #    # #    #      #            
--   #     # #    # #   ## #    # #    #    #    # #         #     # #    # #    # #    # #    #            
--   ######  #    # #    #  ####   ####     #####  ######    ######  #    # #####   ####   ####             
--                                                                                                          
--                    #######                                #     #                                        
--   #####    ##      #         ##   #####  #    #   ##       #   #  #####  ###### #####  # #    # #    #   
--   #    #  #  #     #        #  #  #    # ##  ##  #  #       # #   #    # #      #    # # #    # ##   #   
--   #    # #    #    #####   #    # #    # # ## # #    #       #    #    # #####  #    # # #    # # #  #   
--   #    # ######    #       ###### #####  #    # ######      # #   #####  #      #####  # #    # #  # #   
--   #    # #    #    #       #    # #   #  #    # #    #     #   #  #      #      #   #  # #    # #   ##   
--   #####  #    #    #       #    # #    # #    # #    #    #     # #      ###### #    # #  ####  #    #   
--                                                                                                          
------------------------------------------------------------------------------------------------------------
--> Estrutura DDL do Banco de Dados SQL da Farma Xperiun
------------------------------------------------------------------------------------------------------------
--> Autor: Bruno César Pasquini
--> Auxiliar: ChatGPT 5
--> Revisor: Bruno César Pasquini
------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------
--> Obtido com o código:
-->
--> SELECT
-->    sql
--> FROM
-->    sqlite_master
--> WHERE
-->    type IN ('table', 'index', 'trigger')
-->    AND name NOT LIKE 'sqlite_%'
--> ORDER BY sql;
---------------------------------------------------------------------------


---------------------------------------------------------------------------
--> Tabela d_calendario
---------------------------------------------------------------------------

CREATE TABLE d_calendario (
    data DATE PRIMARY KEY,
    ano INTEGER,
    mes INTEGER,
    nome_mes TEXT,
    trimestre INTEGER,
    semestre INTEGER,
    dia_semana INTEGER,
    nome_dia_semana TEXT,
    is_fim_semana BOOLEAN,
    is_feriado BOOLEAN
)


---------------------------------------------------------------------------
--> Tabela d_fornecedor
---------------------------------------------------------------------------

CREATE TABLE d_fornecedor (
    fornecedor_id INTEGER PRIMARY KEY,
    nome TEXT,
    cidade TEXT,
    estado TEXT,
    regiao TEXT,
    prazo_entrega_dias INTEGER
)


---------------------------------------------------------------------------
--> Tabela d_meta_mensal
---------------------------------------------------------------------------

CREATE TABLE d_meta_mensal (
    meta_id INTEGER PRIMARY KEY,
    ano INTEGER,
    mes INTEGER,
    meta_receita NUMERIC(12, 2),
    meta_quantidade INTEGER
)


---------------------------------------------------------------------------
--> Tabela d_produto
---------------------------------------------------------------------------

CREATE TABLE d_produto (
    produto_id INTEGER PRIMARY KEY,
    nome_produto TEXT,
    codigo_atc TEXT,
    categoria TEXT,
    grupo_terapeutico TEXT,
    preco_unitario NUMERIC(12, 2),
    custo_unitario NUMERIC(12, 2),
    margem_percentual NUMERIC(12, 2),
    exige_receita BOOLEAN
)


---------------------------------------------------------------------------
--> Tabela d_turno
---------------------------------------------------------------------------

CREATE TABLE d_turno (
    turno_id INTEGER PRIMARY KEY,
    nome_turno TEXT,
    hora_inicio INTEGER,
    hora_fim INTEGER
)


---------------------------------------------------------------------------
--> Tabela f_vendas
---------------------------------------------------------------------------

CREATE TABLE f_vendas (
    venda_id INTEGER PRIMARY KEY,
    data DATE,
    hora INTEGER,
    turno_id INTEGER,
    produto_id INTEGER,
    fornecedor_id INTEGER,
    quantidade REAL,
    preco_unitario NUMERIC(12, 2),
    receita_bruta NUMERIC(12, 2),
    desconto NUMERIC(12, 2),
    receita_liquida NUMERIC(12, 2),
    custo_total NUMERIC(12, 2),
    lucro NUMERIC(12, 2),
    forma_pagamento TEXT,
    FOREIGN KEY (data) REFERENCES d_calendario(data),
    FOREIGN KEY (turno_id) REFERENCES d_turno(turno_id),
    FOREIGN KEY (produto_id) REFERENCES d_produto(produto_id),
    FOREIGN KEY (fornecedor_id) REFERENCES d_fornecedor(fornecedor_id)
)