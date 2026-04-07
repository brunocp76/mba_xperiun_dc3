------------------------------------------------------------------------------------------------------------
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
--> Analise de Chaves Primarias e Estrangeiras
------------------------------------------------------------------------------------------------------------
--> Autor: Bruno César Pasquini
--> Auxiliar: ChatGPT 5
--> Revisor: Bruno César Pasquini
------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------
--> Tabela d_calendario
---------------------------------------------------------------------------

--> Candidatas a chaves primárias

SELECT COUNT(*)                                         AS linhas
      , COUNT(DISTINCT "data")                           AS distintos
      , SUM(CASE WHEN "data" IS NULL THEN 1 ELSE 0 END)  AS nulos
FROM d_calendario;

--> Chave Primária: data


---------------------------------------------------------------------------
--> Tabela d_fornecedor
---------------------------------------------------------------------------

--> Candidatas a chaves primárias

SELECT COUNT(*)                                               AS linhas
      , COUNT(DISTINCT fornecedor_id)                          AS distintos
      , SUM(CASE WHEN fornecedor_id IS NULL THEN 1 ELSE 0 END) AS nulos
FROM d_fornecedor;

--> Chave Primária: fornecedor_id


---------------------------------------------------------------------------
--> Tabela d_meta_mensal
---------------------------------------------------------------------------

--> Candidatas a chaves primárias

SELECT COUNT(*)                                         AS linhas
      , COUNT(DISTINCT meta_id)                          AS distintos
      , SUM(CASE WHEN meta_id IS NULL THEN 1 ELSE 0 END) AS nulos
FROM d_meta_mensal;

--> Chave Primária: meta_id


---------------------------------------------------------------------------
--> Tabela d_produto
---------------------------------------------------------------------------

--> Candidatas a chaves primárias

SELECT COUNT(*)                                            AS linhas
      , COUNT(DISTINCT produto_id)                          AS distintos
      , SUM(CASE WHEN produto_id IS NULL THEN 1 ELSE 0 END) AS nulos
FROM d_produto;

--> Chave Primária: produto_id


---------------------------------------------------------------------------
--> Tabela d_turno
---------------------------------------------------------------------------

--> Candidatas a chaves primárias

SELECT COUNT(*)                                            AS linhas
      , COUNT(DISTINCT turno_id)                            AS distintos
      , SUM(CASE WHEN turno_id IS NULL THEN 1 ELSE 0 END)   AS nulos
FROM d_turno;

--> Chave Primária: turno_id


---------------------------------------------------------------------------
--> Tabela f_vendas
---------------------------------------------------------------------------

--> Candidatas a chaves primárias

SELECT COUNT(*)                                            AS linhas
      , COUNT(DISTINCT venda_id)                            AS distintos
      , SUM(CASE WHEN venda_id IS NULL THEN 1 ELSE 0 END)   AS nulos
FROM f_vendas;

--> Candidatas a chaves estrangeiras

SELECT COUNT(*)                                         AS linhas
      , COUNT(DISTINCT "data")                           AS distintos
      , SUM(CASE WHEN "data" IS NULL THEN 1 ELSE 0 END)  AS nulos
FROM f_vendas;

SELECT COUNT(*)                                            AS linhas
      , COUNT(DISTINCT turno_id)                            AS distintos
      , SUM(CASE WHEN turno_id IS NULL THEN 1 ELSE 0 END)   AS nulos
FROM f_vendas;

SELECT COUNT(*)                                            AS linhas
      , COUNT(DISTINCT produto_id)                          AS distintos
      , SUM(CASE WHEN produto_id IS NULL THEN 1 ELSE 0 END) AS nulos
FROM f_vendas;

SELECT COUNT(*)                                               AS linhas
      , COUNT(DISTINCT fornecedor_id)                          AS distintos
      , SUM(CASE WHEN fornecedor_id IS NULL THEN 1 ELSE 0 END) AS nulos
FROM f_vendas;

--> Chave Primária: venda_id
--> Chaves Estrangeiras: data, turno_id, produto_id e fornecedor_id
