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
--> Procurando respostas a algumas Perguntas de Negocio
------------------------------------------------------------------------------------------------------------
--> Autor: Bruno César Pasquini
--> Auxiliar: IAs
--> Revisor: Bruno César Pasquini
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------
--> 0. Verificando o atingimento de metas

--> Todo o Periodo
---------------------------------------------------------------------------

SELECT SUM(vendas)                                                       AS vendas
      , SUM(quantidade)                                                   AS qtde
      , SUM(meta_quantidade)                                              AS meta_qtde
      , ROUND(SUM(quantidade) - SUM(meta_quantidade), 2)                  AS dif_qtde
      , ROUND(100 * ((SUM(quantidade) / SUM(meta_quantidade)) - 1), 2)    AS perc_meta_qtde
      , SUM(receita_bruta)                                                AS receita_bruta
      , SUM(receita_liquida)                                              AS receita_liquida
      , SUM(meta_receita)                                                 AS meta_receita
      , ROUND(SUM(receita_bruta) - SUM(meta_receita), 2)                  AS dif_rec_bruta
      , ROUND(SUM(receita_liquida) - SUM(meta_receita), 2)                AS dif_rec_liq
      , ROUND(100 * ((SUM(receita_bruta)   / SUM(meta_receita)) - 1), 2) || '%' AS perc_meta_rec_bruta
      , ROUND(100 * ((SUM(receita_liquida) / SUM(meta_receita)) - 1), 2) || '%' AS perc_meta_rec_liq
FROM (
          SELECT 0                    AS vendas
         , 0.00                 AS receita_bruta
         , 0.00                 AS receita_liquida
         , 0.00                 AS quantidade
         , SUM(meta_receita)    AS meta_receita
         , SUM(meta_quantidade) AS meta_quantidade
      FROM d_meta_mensal
   UNION
      SELECT COUNT(*)             AS vendas
         , SUM(receita_bruta)   AS receita_bruta
         , SUM(receita_liquida) AS receita_liquida
         , SUM(quantidade)      AS quantidade
         , 0.00                 AS meta_receita
         , 0.00                 AS meta_quantidade
      FROM f_vendas);


---------------------------------------------------------------------------
--> 0. Verificando o atingimento de metas

--> Por Ano
---------------------------------------------------------------------------

SELECT COALESCE(metas.ano, vendas.ano)                                            AS ano
      , vendas.vendas
      , vendas.quantidade
      , metas.meta_quantidade
      , ROUND(vendas.quantidade - metas.meta_quantidade, 2)                        AS dif_qtde
      , ROUND(100 * ((vendas.quantidade / metas.meta_quantidade) - 1), 2) || '%'   AS perc_meta_qtde
      , vendas.receita_bruta
      , vendas.receita_liquida
      , metas.meta_receita
      , ROUND(SUM(vendas.receita_bruta) - SUM(metas.meta_receita), 2)              AS dif_rec_bruta
      , ROUND(SUM(vendas.receita_liquida) - SUM(metas.meta_receita), 2)            AS dif_rec_liq
      , ROUND(100 * ((vendas.receita_bruta   / metas.meta_receita) - 1), 2) || '%' AS perc_meta_rec_bruta
      , ROUND(100 * ((vendas.receita_liquida / metas.meta_receita) - 1), 2) || '%' AS perc_meta_rec_liq
FROM (
    SELECT ano
         , SUM(meta_receita)     AS meta_receita
         , SUM(meta_quantidade)  AS meta_quantidade
   FROM d_meta_mensal
   GROUP BY ano
   ORDER BY ano
         ) AS metas
   JOIN (
    SELECT CAST(strftime('%Y', "data") AS INTEGER) AS ano
         , COUNT(*)             AS vendas
         , SUM(receita_bruta)   AS receita_bruta
         , SUM(receita_liquida) AS receita_liquida
         , SUM(quantidade)      AS quantidade
   FROM f_vendas
   GROUP BY CAST(strftime('%Y', "data") AS INTEGER)
   ORDER BY CAST(strftime('%Y', "data") AS INTEGER)
     )  AS vendas
   ON metas.ano = vendas.ano
GROUP BY COALESCE(metas.ano, vendas.ano)
ORDER BY COALESCE(metas.ano, vendas.ano);


---------------------------------------------------------------------------
--> 0. Verificando o atingimento de metas

--> Por Mes
---------------------------------------------------------------------------

SELECT COALESCE(metas.anomes, vendas.anomes)                                      AS anomes
      , vendas.vendas
      , vendas.quantidade
      , metas.meta_quantidade
      , ROUND(vendas.quantidade - metas.meta_quantidade, 2)                        AS dif_qtde
      , ROUND(100 * ((vendas.quantidade / metas.meta_quantidade) - 1), 2) || '%'   AS perc_meta_qtde
      , vendas.receita_bruta
      , vendas.receita_liquida
      , metas.meta_receita
      , ROUND(SUM(vendas.receita_bruta) - SUM(metas.meta_receita), 2)              AS dif_rec_bruta
      , ROUND(SUM(vendas.receita_liquida) - SUM(metas.meta_receita), 2)            AS dif_rec_liq
      , ROUND(100 * ((vendas.receita_bruta   / metas.meta_receita) - 1), 2) || '%' AS perc_meta_rec_bruta
      , ROUND(100 * ((vendas.receita_liquida / metas.meta_receita) - 1), 2) || '%' AS perc_meta_rec_liq
FROM (
    SELECT 100 * ano + mes       AS anomes
         , SUM(meta_receita)     AS meta_receita
         , SUM(meta_quantidade)  AS meta_quantidade
   FROM d_meta_mensal
   GROUP BY 100 * ano + mes
   ORDER BY 100 * ano + mes
         ) AS metas
   JOIN (
    SELECT CAST(strftime('%Y%m', "data") AS INTEGER) AS anomes
         , COUNT(*)                                  AS vendas
         , SUM(receita_bruta)                        AS receita_bruta
         , SUM(receita_liquida)                      AS receita_liquida
         , SUM(quantidade)                           AS quantidade
   FROM f_vendas
   GROUP BY CAST(strftime('%Y%m', "data") AS INTEGER)
   ORDER BY CAST(strftime('%Y%m', "data") AS INTEGER)
     )  AS vendas
   ON metas.anomes = vendas.anomes
GROUP BY COALESCE(metas.anomes, vendas.anomes)
ORDER BY COALESCE(metas.anomes, vendas.anomes);


---------------------------------------------------------------------------
--> 1. Conferindo as Informações do Documento Fornecido
---------------------------------------------------------------------------

SELECT MIN("data")                      AS data_inicio
      , MAX("data")                      AS data_fim
      , COUNT(*)                         AS vendas
      , COUNT(DISTINCT produto_id)       AS produtos
      , COUNT(DISTINCT fornecedor_id)    AS fornecedores
      , ROUND(SUM(receita_bruta), 2)     AS receita_bruta
      , ROUND(SUM(desconto), 2)          AS desconto
      , ROUND(SUM(receita_liquida), 2)   AS receita_liquida
      , ROUND(SUM(custo_total), 2)       AS custo_total
      , ROUND(SUM(lucro), 2)             AS lucro
      , ROUND(SUM(receita_bruta)   / COUNT(*)         , 2) AS receita_bruta_por_transacao
      , ROUND(SUM(receita_liquida) / COUNT(*)         , 2) AS receita_liquida_por_transacao
      , ROUND(SUM(custo_total)     / COUNT(*)         , 2) AS custo_por_transacao
      , ROUND(SUM(lucro)           / COUNT(*)         , 2) AS lucro_por_transacao
      , ROUND(100 * SUM(lucro)  / SUM(receita_liquida), 2) || '%' AS margem
FROM f_vendas;


---------------------------------------------------------------------------
--> 2. Criando um intervalo de metas ("semaforo" da gestao)
---------------------------------------------------------------------------

SELECT COALESCE(metas.anomes, vendas.anomes)                                      AS anomes
      , vendas.vendas
      , vendas.quantidade
      , metas.meta_quantidade
      , ROUND(vendas.quantidade - metas.meta_quantidade, 2)                        AS dif_qtde
      , ROUND(100 * ((vendas.quantidade / metas.meta_quantidade) - 1), 2) || '%'   AS perc_meta_qtde
      , CASE
         WHEN vendas.quantidade / metas.meta_quantidade < 0.9 THEN "Vermelho"
         WHEN vendas.quantidade / metas.meta_quantidade <   1 THEN "Amarelo"
         WHEN vendas.quantidade / metas.meta_quantidade >=  1 THEN "Verde"
         ELSE "Desligado"
      END  AS semaforo_qtde
      , vendas.receita_liquida
      , metas.meta_receita
      , ROUND(SUM(vendas.receita_liquida) - SUM(metas.meta_receita), 2)            AS dif_rec_liq
      , ROUND(100 * ((vendas.receita_liquida / metas.meta_receita) - 1), 2) || '%' AS perc_meta_rec_liq
      , CASE
         WHEN vendas.receita_liquida / metas.meta_receita < 0.9 THEN "Vermelho"
         WHEN vendas.receita_liquida / metas.meta_receita <   1 THEN "Amarelo"
         WHEN vendas.receita_liquida / metas.meta_receita >=  1 THEN "Verde"
         ELSE "Desligado"
      END  AS semaforo_rec_liq
FROM (
    SELECT 100 * ano + mes       AS anomes
         , SUM(meta_receita)     AS meta_receita
         , SUM(meta_quantidade)  AS meta_quantidade
   FROM d_meta_mensal
   GROUP BY 100 * ano + mes
   ORDER BY 100 * ano + mes
         ) AS metas
   JOIN (
    SELECT CAST(strftime('%Y%m', "data") AS INTEGER) AS anomes
         , COUNT(*)                                  AS vendas
         , SUM(receita_bruta)                        AS receita_bruta
         , SUM(receita_liquida)                      AS receita_liquida
         , SUM(quantidade)                           AS quantidade
   FROM f_vendas
   GROUP BY CAST(strftime('%Y%m', "data") AS INTEGER)
   ORDER BY CAST(strftime('%Y%m', "data") AS INTEGER)
     )  AS vendas
   ON metas.anomes = vendas.anomes
GROUP BY COALESCE(metas.anomes, vendas.anomes)
ORDER BY COALESCE(metas.anomes, vendas.anomes);


---------------------------------------------------------------------------
--> 3. Comparação de Receita e Lucro dos Produtos
-->    Agrupando pela Forma de Pagamento
---------------------------------------------------------------------------

SELECT forma_pagamento
      , COUNT(*)             AS vendas
      , SUM(receita_liquida) AS receita_liquida
      , SUM(lucro)           AS lucro
      , SUM(desconto)        AS desconto
      , ROUND(SUM(receita_liquida) / COUNT(*)            , 2)          AS ticket_medio
      , ROUND(100 * SUM(lucro)     / SUM(receita_liquida), 2) || '%'   AS margem
      , ROUND(100 * SUM(desconto)  / SUM(receita_liquida), 2) || '%'   AS desconto_receita
      , ROUND(100 * SUM(desconto)  / SUM(lucro)          , 2) || '%'   AS desconto_lucro
FROM f_vendas
GROUP BY forma_pagamento
ORDER BY SUM(f_vendas.lucro) / SUM(f_vendas.receita_liquida) DESC
      , forma_pagamento;

SELECT CAST(strftime('%Y', "data") AS INTEGER)   AS ano
      , forma_pagamento
      , COUNT(*)             AS vendas
      , SUM(receita_liquida) AS receita_liquida
      , SUM(lucro)           AS lucro
      , SUM(desconto)        AS desconto
      , ROUND(SUM(receita_liquida) / COUNT(*)            , 2)          AS ticket_medio
      , ROUND(100 * SUM(lucro)     / SUM(receita_liquida), 2) || '%'   AS margem
      , ROUND(100 * SUM(desconto)  / SUM(receita_liquida), 2) || '%'   AS desconto_receita
      , ROUND(100 * SUM(desconto)  / SUM(lucro)          , 2) || '%'   AS desconto_lucro
FROM f_vendas
GROUP BY CAST(strftime('%Y', "data") AS INTEGER)
      , forma_pagamento
ORDER BY CAST(strftime('%Y', "data") AS INTEGER)
      , forma_pagamento;

SELECT forma_pagamento
      , CASE
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  1 THEN 'Jan'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  2 THEN 'Fev'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  3 THEN 'Mar'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  4 THEN 'Abr'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  5 THEN 'Mai'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  6 THEN 'Jun'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  7 THEN 'Jul'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  8 THEN 'Ago'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  9 THEN 'Set'
            WHEN CAST(strftime('%m', "data") AS INTEGER) = 10 THEN 'Out'
            WHEN CAST(strftime('%m', "data") AS INTEGER) = 11 THEN 'Nov'
            WHEN CAST(strftime('%m', "data") AS INTEGER) = 12 THEN 'Dez'
            ELSE ''
         END  AS mes
      , COUNT(*)             AS vendas
      , SUM(receita_liquida) AS receita_liquida
      , SUM(lucro)           AS lucro
      , SUM(desconto)        AS desconto
      , ROUND(SUM(receita_liquida) / COUNT(*)            , 2)          AS ticket_medio
      , ROUND(100 * SUM(lucro)     / SUM(receita_liquida), 2) || '%'   AS margem
      , ROUND(100 * SUM(desconto)  / SUM(receita_liquida), 2) || '%'   AS desconto_receita
      , ROUND(100 * SUM(desconto)  / SUM(lucro)          , 2) || '%'   AS desconto_lucro
FROM f_vendas
GROUP BY forma_pagamento
      , CAST(strftime('%m', "data") AS INTEGER)
ORDER BY forma_pagamento
      , CAST(strftime('%m', "data") AS INTEGER);


---------------------------------------------------------------------------
--> 3. Comparação de Receita e Lucro dos Produtos
-->    Agrupando pela Exigencia de Receita
---------------------------------------------------------------------------

SELECT exige_receita
      , COUNT(*)             AS vendas
      , SUM(receita_liquida) AS receita_liquida
      , SUM(lucro)           AS lucro
      , SUM(desconto)        AS desconto
      , ROUND(SUM(receita_liquida) / COUNT(*)            , 2)          AS ticket_medio
      , ROUND(100 * SUM(lucro)     / SUM(receita_liquida), 2) || '%'   AS margem
      , ROUND(100 * SUM(desconto)  / SUM(receita_liquida), 2) || '%'   AS desconto_receita
      , ROUND(100 * SUM(desconto)  / SUM(lucro)          , 2) || '%'   AS desconto_lucro
FROM f_vendas
   LEFT JOIN d_produto
   ON f_vendas.produto_id = d_produto.produto_id
GROUP BY exige_receita
ORDER BY SUM(f_vendas.lucro) / SUM(f_vendas.receita_liquida) DESC
      , exige_receita;

SELECT CAST(strftime('%Y', "data") AS INTEGER)   AS ano
      , exige_receita
      , COUNT(*)             AS vendas
      , SUM(receita_liquida) AS receita_liquida
      , SUM(lucro)           AS lucro
      , SUM(desconto)        AS desconto
      , ROUND(SUM(receita_liquida) / COUNT(*)            , 2)          AS ticket_medio
      , ROUND(100 * SUM(lucro)     / SUM(receita_liquida), 2) || '%'   AS margem
      , ROUND(100 * SUM(desconto)  / SUM(receita_liquida), 2) || '%'   AS desconto_receita
      , ROUND(100 * SUM(desconto)  / SUM(lucro)          , 2) || '%'   AS desconto_lucro
FROM f_vendas
   LEFT JOIN d_produto
   ON f_vendas.produto_id = d_produto.produto_id
GROUP BY CAST(strftime('%Y', "data") AS INTEGER)
      , exige_receita
ORDER BY CAST(strftime('%Y', "data") AS INTEGER)
      , SUM(f_vendas.lucro) / SUM(f_vendas.receita_liquida) DESC
      , exige_receita;

SELECT exige_receita
      , CASE
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  1 THEN 'Jan'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  2 THEN 'Fev'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  3 THEN 'Mar'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  4 THEN 'Abr'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  5 THEN 'Mai'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  6 THEN 'Jun'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  7 THEN 'Jul'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  8 THEN 'Ago'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  9 THEN 'Set'
            WHEN CAST(strftime('%m', "data") AS INTEGER) = 10 THEN 'Out'
            WHEN CAST(strftime('%m', "data") AS INTEGER) = 11 THEN 'Nov'
            WHEN CAST(strftime('%m', "data") AS INTEGER) = 12 THEN 'Dez'
            ELSE ''
         END  AS mes
      , COUNT(*)             AS vendas
      , SUM(receita_liquida) AS receita_liquida
      , SUM(lucro)           AS lucro
      , SUM(desconto)        AS desconto
      , ROUND(SUM(receita_liquida) / COUNT(*)            , 2)          AS ticket_medio
      , ROUND(100 * SUM(lucro)     / SUM(receita_liquida), 2) || '%'   AS margem
      , ROUND(100 * SUM(desconto)  / SUM(receita_liquida), 2) || '%'   AS desconto_receita
      , ROUND(100 * SUM(desconto)  / SUM(lucro)          , 2) || '%'   AS desconto_lucro
FROM f_vendas
   LEFT JOIN d_produto
   ON f_vendas.produto_id = d_produto.produto_id
GROUP BY exige_receita
      , CAST(strftime('%m', "data") AS INTEGER)
ORDER BY exige_receita
      , CAST(strftime('%m', "data") AS INTEGER);


---------------------------------------------------------------------------
--> 3. Comparação de Receita e Lucro dos Produtos
-->    Agrupando pelo Grupo Terapeutico
---------------------------------------------------------------------------

SELECT grupo_terapeutico
      , COUNT(*)             AS vendas
      , SUM(receita_liquida) AS receita_liquida
      , SUM(lucro)           AS lucro
      , SUM(desconto)        AS desconto
      , ROUND(SUM(receita_liquida) / COUNT(*)            , 2)          AS ticket_medio
      , ROUND(100 * SUM(lucro)     / SUM(receita_liquida), 2) || '%'   AS margem
      , ROUND(100 * SUM(desconto)  / SUM(receita_liquida), 2) || '%'   AS desconto_receita
      , ROUND(100 * SUM(desconto)  / SUM(lucro)          , 2) || '%'   AS desconto_lucro
FROM f_vendas
   LEFT JOIN d_produto
   ON f_vendas.produto_id = d_produto.produto_id
GROUP BY grupo_terapeutico
ORDER BY SUM(f_vendas.lucro) / SUM(f_vendas.receita_liquida) DESC
      , grupo_terapeutico;

SELECT CAST(strftime('%Y', "data") AS INTEGER)   AS ano
      , grupo_terapeutico
      , COUNT(*)             AS vendas
      , SUM(receita_liquida) AS receita_liquida
      , SUM(lucro)           AS lucro
      , SUM(desconto)        AS desconto
      , ROUND(SUM(receita_liquida) / COUNT(*)            , 2)          AS ticket_medio
      , ROUND(100 * SUM(lucro)     / SUM(receita_liquida), 2) || '%'   AS margem
      , ROUND(100 * SUM(desconto)  / SUM(receita_liquida), 2) || '%'   AS desconto_receita
      , ROUND(100 * SUM(desconto)  / SUM(lucro)          , 2) || '%'   AS desconto_lucro
FROM f_vendas
   LEFT JOIN d_produto
   ON f_vendas.produto_id = d_produto.produto_id
GROUP BY CAST(strftime('%Y', "data") AS INTEGER)
      , grupo_terapeutico
ORDER BY CAST(strftime('%Y', "data") AS INTEGER)
      , grupo_terapeutico;

SELECT grupo_terapeutico
      , CASE
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  1 THEN 'Jan'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  2 THEN 'Fev'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  3 THEN 'Mar'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  4 THEN 'Abr'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  5 THEN 'Mai'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  6 THEN 'Jun'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  7 THEN 'Jul'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  8 THEN 'Ago'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  9 THEN 'Set'
            WHEN CAST(strftime('%m', "data") AS INTEGER) = 10 THEN 'Out'
            WHEN CAST(strftime('%m', "data") AS INTEGER) = 11 THEN 'Nov'
            WHEN CAST(strftime('%m', "data") AS INTEGER) = 12 THEN 'Dez'
            ELSE ''
         END  AS mes
      , COUNT(*)             AS vendas
      , SUM(receita_liquida) AS receita_liquida
      , SUM(lucro)           AS lucro
      , SUM(desconto)        AS desconto
      , ROUND(SUM(receita_liquida) / COUNT(*)            , 2)          AS ticket_medio
      , ROUND(100 * SUM(lucro)     / SUM(receita_liquida), 2) || '%'   AS margem
      , ROUND(100 * SUM(desconto)  / SUM(receita_liquida), 2) || '%'   AS desconto_receita
      , ROUND(100 * SUM(desconto)  / SUM(lucro)          , 2) || '%'   AS desconto_lucro
FROM f_vendas
   LEFT JOIN d_produto
   ON f_vendas.produto_id = d_produto.produto_id
GROUP BY grupo_terapeutico
      , CAST(strftime('%m', "data") AS INTEGER)
ORDER BY grupo_terapeutico
      , CAST(strftime('%m', "data") AS INTEGER);


---------------------------------------------------------------------------
--> 3. Comparação de Receita e Lucro dos Produtos
-->    Agrupando pela Categoria
---------------------------------------------------------------------------

SELECT grupo_terapeutico
      , categoria
      , COUNT(*)             AS vendas
      , SUM(receita_liquida) AS receita_liquida
      , SUM(lucro)           AS lucro
      , SUM(desconto)        AS desconto
      , ROUND(SUM(receita_liquida) / COUNT(*)            , 2)          AS ticket_medio
      , ROUND(100 * SUM(lucro)     / SUM(receita_liquida), 2) || '%'   AS margem
      , ROUND(100 * SUM(desconto)  / SUM(receita_liquida), 2) || '%'   AS desconto_receita
      , ROUND(100 * SUM(desconto)  / SUM(lucro)          , 2) || '%'   AS desconto_lucro
FROM f_vendas
   LEFT JOIN d_produto
   ON f_vendas.produto_id = d_produto.produto_id
GROUP BY grupo_terapeutico
      , categoria
ORDER BY SUM(f_vendas.lucro) / SUM(f_vendas.receita_liquida) DESC
      , grupo_terapeutico
      , categoria;

SELECT CAST(strftime('%Y', "data") AS INTEGER)   AS ano
      , grupo_terapeutico
      , categoria
      , COUNT(*)             AS vendas
      , SUM(receita_liquida) AS receita_liquida
      , SUM(lucro)           AS lucro
      , SUM(desconto)        AS desconto
      , ROUND(SUM(receita_liquida) / COUNT(*)            , 2)          AS ticket_medio
      , ROUND(100 * SUM(lucro)     / SUM(receita_liquida), 2) || '%'   AS margem
      , ROUND(100 * SUM(desconto)  / SUM(receita_liquida), 2) || '%'   AS desconto_receita
      , ROUND(100 * SUM(desconto)  / SUM(lucro)          , 2) || '%'   AS desconto_lucro
FROM f_vendas
   LEFT JOIN d_produto
   ON f_vendas.produto_id = d_produto.produto_id
GROUP BY CAST(strftime('%Y', "data") AS INTEGER)
      , grupo_terapeutico
      , categoria
ORDER BY CAST(strftime('%Y', "data") AS INTEGER)
      , grupo_terapeutico
      , categoria;

SELECT grupo_terapeutico
      , categoria
      , CASE
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  1 THEN 'Jan'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  2 THEN 'Fev'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  3 THEN 'Mar'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  4 THEN 'Abr'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  5 THEN 'Mai'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  6 THEN 'Jun'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  7 THEN 'Jul'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  8 THEN 'Ago'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  9 THEN 'Set'
            WHEN CAST(strftime('%m', "data") AS INTEGER) = 10 THEN 'Out'
            WHEN CAST(strftime('%m', "data") AS INTEGER) = 11 THEN 'Nov'
            WHEN CAST(strftime('%m', "data") AS INTEGER) = 12 THEN 'Dez'
            ELSE ''
         END  AS mes
      , COUNT(*)             AS vendas
      , SUM(receita_liquida) AS receita_liquida
      , SUM(lucro)           AS lucro
      , SUM(desconto)        AS desconto
      , ROUND(SUM(receita_liquida) / COUNT(*)            , 2)          AS ticket_medio
      , ROUND(100 * SUM(lucro)     / SUM(receita_liquida), 2) || '%'   AS margem
      , ROUND(100 * SUM(desconto)  / SUM(receita_liquida), 2) || '%'   AS desconto_receita
      , ROUND(100 * SUM(desconto)  / SUM(lucro)          , 2) || '%'   AS desconto_lucro
FROM f_vendas
   LEFT JOIN d_produto
   ON f_vendas.produto_id = d_produto.produto_id
GROUP BY grupo_terapeutico
      , categoria
      , CAST(strftime('%m', "data") AS INTEGER)
ORDER BY grupo_terapeutico
      , categoria
      , CAST(strftime('%m', "data") AS INTEGER);


---------------------------------------------------------------------------
--> 3. Comparação de Receita e Lucro dos Produtos
-->    Agrupando pelo Produto
---------------------------------------------------------------------------

SELECT grupo_terapeutico
      , categoria
      , nome_produto
      , COUNT(*)             AS vendas
      , SUM(receita_liquida) AS receita_liquida
      , SUM(lucro)           AS lucro
      , SUM(desconto)        AS desconto
      , ROUND(SUM(receita_liquida) / COUNT(*)            , 2)          AS ticket_medio
      , ROUND(100 * SUM(lucro)     / SUM(receita_liquida), 2) || '%'   AS margem
      , ROUND(100 * SUM(desconto)  / SUM(receita_liquida), 2) || '%'   AS desconto_receita
      , ROUND(100 * SUM(desconto)  / SUM(lucro)          , 2) || '%'   AS desconto_lucro
FROM f_vendas
   LEFT JOIN d_produto
   ON f_vendas.produto_id = d_produto.produto_id
GROUP BY grupo_terapeutico
      , categoria
      , nome_produto
ORDER BY SUM(f_vendas.lucro) / SUM(f_vendas.receita_liquida) DESC
      , grupo_terapeutico
      , categoria
      , nome_produto;

SELECT CAST(strftime('%Y', "data") AS INTEGER)   AS ano
      , grupo_terapeutico
      , categoria
      , nome_produto
      , COUNT(*)             AS vendas
      , SUM(receita_liquida) AS receita_liquida
      , SUM(lucro)           AS lucro
      , SUM(desconto)        AS desconto
      , ROUND(SUM(receita_liquida) / COUNT(*)            , 2)          AS ticket_medio
      , ROUND(100 * SUM(lucro)     / SUM(receita_liquida), 2) || '%'   AS margem
      , ROUND(100 * SUM(desconto)  / SUM(receita_liquida), 2) || '%'   AS desconto_receita
      , ROUND(100 * SUM(desconto)  / SUM(lucro)          , 2) || '%'   AS desconto_lucro
FROM f_vendas
   LEFT JOIN d_produto
   ON f_vendas.produto_id = d_produto.produto_id
GROUP BY CAST(strftime('%Y', "data") AS INTEGER)
      , grupo_terapeutico
      , categoria
      , nome_produto
ORDER BY CAST(strftime('%Y', "data") AS INTEGER)
      , grupo_terapeutico
      , categoria
      , nome_produto;

SELECT grupo_terapeutico
      , categoria
      , nome_produto
      , CASE
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  1 THEN 'Jan'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  2 THEN 'Fev'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  3 THEN 'Mar'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  4 THEN 'Abr'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  5 THEN 'Mai'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  6 THEN 'Jun'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  7 THEN 'Jul'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  8 THEN 'Ago'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  9 THEN 'Set'
            WHEN CAST(strftime('%m', "data") AS INTEGER) = 10 THEN 'Out'
            WHEN CAST(strftime('%m', "data") AS INTEGER) = 11 THEN 'Nov'
            WHEN CAST(strftime('%m', "data") AS INTEGER) = 12 THEN 'Dez'
            ELSE ''
         END  AS mes
      , COUNT(*)             AS vendas
      , SUM(receita_liquida) AS receita_liquida
      , SUM(lucro)           AS lucro
      , SUM(desconto)        AS desconto
      , ROUND(SUM(receita_liquida) / COUNT(*)            , 2)          AS ticket_medio
      , ROUND(100 * SUM(lucro)     / SUM(receita_liquida), 2) || '%'   AS margem
      , ROUND(100 * SUM(desconto)  / SUM(receita_liquida), 2) || '%'   AS desconto_receita
      , ROUND(100 * SUM(desconto)  / SUM(lucro)          , 2) || '%'   AS desconto_lucro
FROM f_vendas
   LEFT JOIN d_produto
   ON f_vendas.produto_id = d_produto.produto_id
GROUP BY grupo_terapeutico
      , categoria
      , nome_produto
      , CAST(strftime('%m', "data") AS INTEGER)
ORDER BY grupo_terapeutico
      , categoria
      , nome_produto
      , CAST(strftime('%m', "data") AS INTEGER);


---------------------------------------------------------------------------
--> 4. Comparação de Receita, Lucro e Ticket Medio de Periodos
-->    Agrupando pelo Turno
---------------------------------------------------------------------------

SELECT nome_turno
      , COUNT(*)             AS vendas
      , SUM(receita_liquida) AS receita_liquida
      , SUM(lucro)           AS lucro
      , SUM(desconto)        AS desconto
      , 'R$ ' || ROUND(SUM(receita_liquida) / COUNT(*)         , 2) AS ticket_medio
      , 'R$ ' || ROUND(SUM(receita_liquida) / SUM(horas_turno) , 2) AS receita_hora
      , ROUND(100 * SUM(lucro)    / SUM(receita_liquida), 2) || '%' AS margem
      , ROUND(100 * SUM(desconto) / SUM(receita_liquida), 2) || '%' AS desconto_receita
      , ROUND(100 * SUM(desconto) / SUM(lucro)          , 2) || '%' AS desconto_lucro
FROM f_vendas
   LEFT JOIN (
    SELECT *
         , (hora_fim - hora_inicio) AS horas_turno
   FROM d_turno) AS d_turno
   ON f_vendas.turno_id = d_turno.turno_id
GROUP BY nome_turno
ORDER BY f_vendas.turno_id;

SELECT CAST(strftime('%Y', "data") AS INTEGER)   AS ano
      , nome_turno
      , COUNT(*)             AS vendas
      , SUM(receita_liquida) AS receita_liquida
      , SUM(lucro)           AS lucro
      , SUM(desconto)        AS desconto
      , 'R$ ' || ROUND(SUM(receita_liquida) / COUNT(*)         , 2) AS ticket_medio
      , 'R$ ' || ROUND(SUM(receita_liquida) / SUM(horas_turno) , 2) AS receita_hora
      , ROUND(100 * SUM(lucro)    / SUM(receita_liquida), 2) || '%' AS margem
      , ROUND(100 * SUM(desconto) / SUM(receita_liquida), 2) || '%' AS desconto_receita
      , ROUND(100 * SUM(desconto) / SUM(lucro)          , 2) || '%' AS desconto_lucro
FROM f_vendas
   LEFT JOIN (
    SELECT *
         , (hora_fim - hora_inicio) AS horas_turno
   FROM d_turno) AS d_turno
   ON f_vendas.turno_id = d_turno.turno_id
GROUP BY CAST(strftime('%Y', "data") AS INTEGER)
      , nome_turno
ORDER BY CAST(strftime('%Y', "data") AS INTEGER)
      , f_vendas.turno_id;

SELECT nome_turno
      , CASE
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  1 THEN 'Jan'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  2 THEN 'Fev'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  3 THEN 'Mar'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  4 THEN 'Abr'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  5 THEN 'Mai'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  6 THEN 'Jun'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  7 THEN 'Jul'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  8 THEN 'Ago'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  9 THEN 'Set'
            WHEN CAST(strftime('%m', "data") AS INTEGER) = 10 THEN 'Out'
            WHEN CAST(strftime('%m', "data") AS INTEGER) = 11 THEN 'Nov'
            WHEN CAST(strftime('%m', "data") AS INTEGER) = 12 THEN 'Dez'
            ELSE ''
         END  AS mes
      , COUNT(*)             AS vendas
      , SUM(receita_liquida) AS receita_liquida
      , SUM(lucro)           AS lucro
      , SUM(desconto)        AS desconto
      , 'R$ ' || ROUND(SUM(receita_liquida) / COUNT(*)         , 2) AS ticket_medio
      , 'R$ ' || ROUND(SUM(receita_liquida) / SUM(horas_turno) , 2) AS receita_hora
      , ROUND(100 * SUM(lucro)    / SUM(receita_liquida), 2) || '%' AS margem
      , ROUND(100 * SUM(desconto) / SUM(receita_liquida), 2) || '%' AS desconto_receita
      , ROUND(100 * SUM(desconto) / SUM(lucro)          , 2) || '%' AS desconto_lucro
FROM f_vendas
   LEFT JOIN (
    SELECT *
         , (hora_fim - hora_inicio) AS horas_turno
   FROM d_turno) AS d_turno
   ON f_vendas.turno_id = d_turno.turno_id
GROUP BY nome_turno
      , CAST(strftime('%m', "data") AS INTEGER)
ORDER BY f_vendas.turno_id
      , CAST(strftime('%m', "data") AS INTEGER);


---------------------------------------------------------------------------
--> 5. Tentando avaliar opções de fornecedor
---------------------------------------------------------------------------

SELECT CAST(COUNT(*) AS REAL)        AS vendas
      , SUM(quantidade)               AS quantidade
      , SUM(f_vendas.preco_unitario)  AS preco_vendas
      , SUM(d_produto.preco_unitario) AS preco_produto
--       , ROUND(SUM(f_vendas.preco_unitario) - SUM(d_produto.preco_unitario), 2)  AS dif_precos
      , SUM(receita_bruta)            AS receita_bruta
      , SUM(desconto)                 AS desconto
      , SUM(receita_liquida)          AS receita_liquida
      , SUM(custo_total)              AS custo_total
      , ROUND(SUM(custo_total / quantidade), 2)                            AS custo_total_por_qtde
      , SUM(custo_unitario)           AS custo_unitario
--       , ROUND((SUM(custo_total / quantidade)) - SUM(custo_unitario), 2)    AS dif_custo
      , SUM(lucro)                    AS lucro
      , ROUND(100 * SUM(lucro)     / SUM(receita_liquida), 2) || '%'   AS margem
      , ROUND(SUM(receita_liquida) / COUNT(*)            , 2)          AS ticket_medio
      , ROUND(100 * SUM(desconto)  / SUM(receita_liquida), 2) || '%'   AS desconto_receita
      , ROUND(100 * SUM(desconto)  / SUM(lucro)          , 2) || '%'   AS desconto_lucro
FROM f_vendas
   LEFT JOIN d_produto
   ON f_vendas.produto_id = d_produto.produto_id

SELECT nome
      , CAST(COUNT(*) AS REAL)        AS vendas
--       , SUM(quantidade)               AS quantidade
--       , SUM(f_vendas.preco_unitario)  AS preco_vendas
--       , SUM(d_produto.preco_unitario) AS preco_produto
--       , ROUND(SUM(f_vendas.preco_unitario) - SUM(d_produto.preco_unitario), 2)  AS dif_precos
--       , SUM(receita_bruta)            AS receita_bruta
      , SUM(desconto)                 AS desconto
      , SUM(receita_liquida)          AS receita_liquida
--       , SUM(custo_total)              AS custo_total
--       , ROUND(SUM(custo_total / quantidade), 2)                            AS custo_total_por_qtde
--       , SUM(custo_unitario)           AS custo_unitario
--       , ROUND((SUM(custo_total / quantidade)) - SUM(custo_unitario), 2)    AS dif_custo
      , SUM(lucro)                    AS lucro
      , ROUND(100 * SUM(lucro)     / SUM(receita_liquida), 2) || '%'   AS margem
      , ROUND(SUM(receita_liquida) / COUNT(*)            , 2)          AS ticket_medio
--       , ROUND(100 * SUM(desconto)  / SUM(receita_liquida), 2) || '%'   AS desconto_receita
--       , ROUND(100 * SUM(desconto)  / SUM(lucro)          , 2) || '%'   AS desconto_lucro
FROM f_vendas
   LEFT JOIN d_produto
   ON f_vendas.produto_id = d_produto.produto_id
   LEFT JOIN d_fornecedor
   ON f_vendas.fornecedor_id = d_fornecedor.fornecedor_id
GROUP BY nome
ORDER BY ROUND(100 * SUM(lucro)     / SUM(receita_liquida), 2) DESC
      , nome;


SELECT CAST(strftime('%Y', "data") AS INTEGER)   AS ano
      , nome
      , CAST(COUNT(*) AS REAL)        AS vendas
--       , SUM(quantidade)               AS quantidade
--       , SUM(f_vendas.preco_unitario)  AS preco_vendas
--       , SUM(d_produto.preco_unitario) AS preco_produto
--       , ROUND(SUM(f_vendas.preco_unitario) - SUM(d_produto.preco_unitario), 2)  AS dif_precos
--       , SUM(receita_bruta)            AS receita_bruta
      , SUM(desconto)                 AS desconto
      , SUM(receita_liquida)          AS receita_liquida
--       , SUM(custo_total)              AS custo_total
--       , ROUND(SUM(custo_total / quantidade), 2)                            AS custo_total_por_qtde
--       , SUM(custo_unitario)           AS custo_unitario
--       , ROUND((SUM(custo_total / quantidade)) - SUM(custo_unitario), 2)    AS dif_custo
      , SUM(lucro)                    AS lucro
      , ROUND(100 * SUM(lucro)     / SUM(receita_liquida), 2) || '%'   AS margem
      , ROUND(SUM(receita_liquida) / COUNT(*)            , 2)          AS ticket_medio
--       , ROUND(100 * SUM(desconto)  / SUM(receita_liquida), 2) || '%'   AS desconto_receita
--       , ROUND(100 * SUM(desconto)  / SUM(lucro)          , 2) || '%'   AS desconto_lucro
FROM f_vendas
   LEFT JOIN d_produto
   ON f_vendas.produto_id = d_produto.produto_id
   LEFT JOIN d_fornecedor
   ON f_vendas.fornecedor_id = d_fornecedor.fornecedor_id
GROUP BY CAST(strftime('%Y', "data") AS INTEGER)
      , nome
ORDER BY CAST(strftime('%Y', "data") AS INTEGER)
      , nome;

SELECT nome
      , CASE
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  1 THEN 'Jan'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  2 THEN 'Fev'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  3 THEN 'Mar'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  4 THEN 'Abr'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  5 THEN 'Mai'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  6 THEN 'Jun'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  7 THEN 'Jul'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  8 THEN 'Ago'
            WHEN CAST(strftime('%m', "data") AS INTEGER) =  9 THEN 'Set'
            WHEN CAST(strftime('%m', "data") AS INTEGER) = 10 THEN 'Out'
            WHEN CAST(strftime('%m', "data") AS INTEGER) = 11 THEN 'Nov'
            WHEN CAST(strftime('%m', "data") AS INTEGER) = 12 THEN 'Dez'
            ELSE ''
         END  AS mes
      , CAST(COUNT(*) AS REAL)        AS vendas
--       , SUM(quantidade)               AS quantidade
--       , SUM(f_vendas.preco_unitario)  AS preco_vendas
--       , SUM(d_produto.preco_unitario) AS preco_produto
--       , ROUND(SUM(f_vendas.preco_unitario) - SUM(d_produto.preco_unitario), 2)  AS dif_precos
--       , SUM(receita_bruta)            AS receita_bruta
      , SUM(desconto)                 AS desconto
      , SUM(receita_liquida)          AS receita_liquida
--       , SUM(custo_total)              AS custo_total
--       , ROUND(SUM(custo_total / quantidade), 2)                            AS custo_total_por_qtde
--       , SUM(custo_unitario)           AS custo_unitario
--       , ROUND((SUM(custo_total / quantidade)) - SUM(custo_unitario), 2)    AS dif_custo
      , SUM(lucro)                    AS lucro
      , ROUND(100 * SUM(lucro)     / SUM(receita_liquida), 2) || '%'   AS margem
      , ROUND(SUM(receita_liquida) / COUNT(*)            , 2)          AS ticket_medio
--       , ROUND(100 * SUM(desconto)  / SUM(receita_liquida), 2) || '%'   AS desconto_receita
--       , ROUND(100 * SUM(desconto)  / SUM(lucro)          , 2) || '%'   AS desconto_lucro
FROM f_vendas
   LEFT JOIN d_produto
   ON f_vendas.produto_id = d_produto.produto_id
   LEFT JOIN d_fornecedor
   ON f_vendas.fornecedor_id = d_fornecedor.fornecedor_id
GROUP BY CAST(strftime('%m', "data") AS INTEGER)
      , nome
ORDER BY CAST(strftime('%m', "data") AS INTEGER)
      , nome;


---------------------------------------------------------------------------
--> 6. Tendência de crescimento Ano a Ano das metricas financeiras
-->    (Atraves da CAGR (Taxa de Crescimento Anual Composta))
-->    Começando pelo meses limítrofes...
---------------------------------------------------------------------------

-- ==========================================
-- A) Consolida VENDAS por ano e mes
-- ==========================================
WITH
   vendas_mensal
   AS
   (
      SELECT (CAST(strftime('%Y', "data") AS INTEGER) * 100 +
         CAST(strftime('%m', "data") AS INTEGER)) AS ano_mes
      , CAST(COUNT(*) AS REAL)  AS vendas
      , SUM(quantidade)         AS quantidade
      , SUM(receita_bruta)      AS receita_bruta
      , SUM(desconto)           AS desconto
      , SUM(receita_liquida)    AS receita_liquida
      , SUM(custo_total)        AS custo
      , SUM(lucro)              AS lucro
      FROM f_vendas
      WHERE (CAST(strftime('%Y', "data") AS INTEGER) * 100 +
         CAST(strftime('%m', "data") AS INTEGER)) <= 201909
      GROUP BY ano_mes
      ORDER BY ano_mes
   )

-- ==========================================
-- B) Consolida METAS por ano e mes
-- ==========================================
,
   metas_mensal
   AS
   (
      SELECT (ano * 100 + mes)    AS ano_mes
      , SUM(meta_quantidade) AS meta_quantidade
      , SUM(meta_receita)    AS meta_receita
      FROM d_meta_mensal
      WHERE (ano * 100 + mes) <= 201909
      GROUP BY ano_mes
      ORDER BY ano_mes
   )

-- ==========================================
-- C) Junta vendas e metas
-- ==========================================
,
   mensal
   AS
   (
      SELECT v.ano_mes
      , v.vendas
      , v.quantidade
      , m.meta_quantidade
      , v.receita_bruta
      , v.desconto
      , v.receita_liquida
      , v.custo
      , v.lucro
      , m.meta_receita
      FROM vendas_mensal v
         LEFT JOIN metas_mensal m
         ON v.ano_mes = m.ano_mes
      ORDER BY v.ano_mes
   )

-- ==========================================
-- D) Descobre primeiro e último mês válidos
-- ==========================================
,
   limites
   AS
   (
      SELECT MIN(ano_mes) AS ano_mes_inicial
      , MAX(ano_mes) AS ano_mes_final
      FROM mensal
   )

-- ==========================================
-- E) Calcula diferença total em meses
-- ==========================================
,
   periodo
   AS
   (
      SELECT
         (
        ((ano_mes_final / 100) - (ano_mes_inicial / 100)) * 12
      +
        ((ano_mes_final % 100) - (ano_mes_inicial % 100))
      ) AS meses_totais
      FROM limites
   )

-- ==========================================
-- F) Captura mês inicial
-- ==========================================
,
   mi
   AS
   (
      SELECT *
      FROM mensal
      WHERE ano_mes = (SELECT ano_mes_inicial
      FROM limites)
   )

-- ==========================================
-- G) Captura mês final
-- ==========================================
,
   mf
   AS
   (
      SELECT *
      FROM mensal
      WHERE ano_mes = (SELECT ano_mes_final
      FROM limites)
   )

-- ==========================================
-- H) Calcula todos os ratios como REAL
-- ==========================================
,
   ratios
   AS
   (
      SELECT 1.0 * mf.vendas          / NULLIF(mi.vendas, 0)           AS r_vendas
      , 1.0 * mf.quantidade      / NULLIF(mi.quantidade, 0)       AS r_quantidade
      , 1.0 * mf.meta_quantidade / NULLIF(mi.meta_quantidade, 0)  AS r_meta_qtde
      , 1.0 * mf.receita_bruta   / NULLIF(mi.receita_bruta, 0)    AS r_rec_bruta
      , 1.0 * mf.desconto        / NULLIF(mi.desconto, 0)         AS r_desc
      , 1.0 * mf.receita_liquida / NULLIF(mi.receita_liquida, 0)  AS r_rec_liq
      , 1.0 * mf.custo           / NULLIF(mi.custo, 0)            AS r_custo
      , 1.0 * mf.lucro           / NULLIF(mi.lucro, 0)            AS r_lucro
      , 1.0 * mf.meta_receita    / NULLIF(mi.meta_receita, 0)     AS r_meta_rec
   -- Ticket médio
    , ((1.0 * mf.receita_liquida / mf.vendas) / NULLIF((1.0 * mi.receita_liquida / mi.vendas), 0))   AS r_ticket_medio
   -- Margem
    , ((1.0 * mf.lucro / mf.receita_liquida) / NULLIF((1.0 * mi.lucro / mi.receita_liquida), 0))     AS r_margem
      FROM mi
         JOIN mf 
   )

-- ==========================================
-- I) Calcula o CAGR anualizado
-- ==========================================
SELECT ROUND(100 * (POWER(r.r_vendas,       12.0 / p.meses_totais) - 1), 2) || '%' AS CAGR_vendas
      , ROUND(100 * (POWER(r.r_quantidade,   12.0 / p.meses_totais) - 1), 2) || '%' AS CAGR_qtde
      , ROUND(100 * (POWER(r.r_meta_qtde,    12.0 / p.meses_totais) - 1), 2) || '%' AS CAGR_meta_qtde
      , ROUND(100 * (POWER(r.r_rec_bruta,    12.0 / p.meses_totais) - 1), 2) || '%' AS CAGR_rec_bruta
      , ROUND(100 * (POWER(r.r_desc,         12.0 / p.meses_totais) - 1), 2) || '%' AS CAGR_desc
      , ROUND(100 * (POWER(r.r_rec_liq,      12.0 / p.meses_totais) - 1), 2) || '%' AS CAGR_rec_liq
      , ROUND(100 * (POWER(r.r_custo,        12.0 / p.meses_totais) - 1), 2) || '%' AS CAGR_custo
      , ROUND(100 * (POWER(r.r_lucro,        12.0 / p.meses_totais) - 1), 2) || '%' AS CAGR_lucro
      , ROUND(100 * (POWER(r.r_meta_rec,     12.0 / p.meses_totais) - 1), 2) || '%' AS CAGR_meta_rec
      , ROUND(100 * (POWER(r.r_margem,       12.0 / p.meses_totais) - 1), 2) || '%' AS CAGR_margem
      , ROUND(100 * (POWER(r.r_ticket_medio, 12.0 / p.meses_totais) - 1), 2) || '%' AS CAGR_ticket_medio
FROM ratios r
   CROSS JOIN periodo p


---------------------------------------------------------------------------
--> 7. Tendência de crescimento Ano a Ano das metricas financeiras por dimensoes
-->    (Atraves de um YoY Movel das metricas financeiras dadas e outras derivadas
-->    (Comparando as somas dos 12 últimos meses comparadas com os 12 meses anteriores)
-->    Deixando o Codigo Facilitado para Agrupamento
---------------------------------------------------------------------------

-- ==========================================
-- A) Base mensal (vendas)
-- ==========================================
WITH mensal_base
AS
(
 SELECT -- <VARIAVEL DIMENSAO PELA QUAL SE PRETENDE AGRUPAR>,
   (CAST(strftime('%Y',"data") AS INTEGER) * 100 +
         CAST(strftime('%m',"data") AS INTEGER)) AS ano_mes
      , CAST(COUNT(*) AS REAL) AS vendas
      , SUM(quantidade)        AS quantidade
      , SUM(receita_bruta)     AS receita_bruta
      , SUM(desconto)          AS desconto
      , SUM(receita_liquida)   AS receita_liquida
      , SUM(custo_total)       AS custo
      , SUM(lucro)             AS lucro
FROM f_vendas
--    LEFT JOIN <TABELA DA VARIAVEL DIMENSAO PELA QUAL SE PRETENDE AGRUPAR>
--      ON <CHAVES CORRESPONDENTES>
WHERE (CAST(strftime('%Y',"data") AS INTEGER) * 100 +
         CAST(strftime('%m',"data") AS INTEGER)) <= 201909
GROUP BY -- <VARIAVEL DIMENSAO PELA QUAL SE PRETENDE AGRUPAR>,
        ano_mes
)

-- ==========================================
-- B) Sequencia continua de meses
-- ==========================================
, mensal_index AS
(
 SELECT *
      , ((ano_mes / 100) * 12 + (ano_mes % 100)) AS mes_seq
FROM mensal_base
)

-- ==========================================
-- C) Rolling 12M
-- ==========================================
, rolling_12m AS
(
 SELECT -- <VARIAVEL DIMENSAO PELA QUAL SE PRETENDE AGRUPAR>,
   ano_mes
      , mes_seq
      , SUM(vendas)          OVER (-- PARTITION BY <VARIAVEL DIMENSAO PELA QUAL SE PRETENDE AGRUPAR>
                                    ORDER BY mes_seq ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) AS vendas_12m
      , SUM(quantidade)      OVER (-- PARTITION BY <VARIAVEL DIMENSAO PELA QUAL SE PRETENDE AGRUPAR>
                                    ORDER BY mes_seq ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) AS qtde_12m
      , SUM(receita_bruta)   OVER (-- PARTITION BY <VARIAVEL DIMENSAO PELA QUAL SE PRETENDE AGRUPAR>
                                    ORDER BY mes_seq ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) AS rec_bruta_12m
      , SUM(desconto)        OVER (-- PARTITION BY <VARIAVEL DIMENSAO PELA QUAL SE PRETENDE AGRUPAR>
                                    ORDER BY mes_seq ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) AS desc_12m
      , SUM(receita_liquida) OVER (-- PARTITION BY <VARIAVEL DIMENSAO PELA QUAL SE PRETENDE AGRUPAR>
                                    ORDER BY mes_seq ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) AS rec_liq_12m
      , SUM(custo)           OVER (-- PARTITION BY <VARIAVEL DIMENSAO PELA QUAL SE PRETENDE AGRUPAR>
                                    ORDER BY mes_seq ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) AS custo_12m
      , SUM(lucro)           OVER (-- PARTITION BY <VARIAVEL DIMENSAO PELA QUAL SE PRETENDE AGRUPAR>
                                    ORDER BY mes_seq ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) AS lucro_12m
FROM mensal_index
)

-- ==========================================
-- D) Metrica do Preco Medio
-- ==========================================
, metrics AS
(
 SELECT -- <VARIAVEL DIMENSAO PELA QUAL SE PRETENDE AGRUPAR>,
   ano_mes
      , mes_seq
      , vendas_12m
      , qtde_12m
      , rec_bruta_12m
      , desc_12m
      , rec_liq_12m
      , custo_12m
      , lucro_12m
      , 1.0 * rec_liq_12m / NULLIF(qtde_12m,0) AS preco_medio
FROM rolling_12m
)

-- ==========================================
-- E) Comparacao com 12M anteriores
-- ==========================================
, comparison AS
(
 SELECT -- m1.<VARIAVEL DIMENSAO PELA QUAL SE PRETENDE AGRUPAR>,
   m1.ano_mes
      , m1.mes_seq
   -- atual
      , m1.vendas_12m
      , m1.qtde_12m
      , m1.rec_bruta_12m
      , m1.desc_12m
      , m1.rec_liq_12m
      , m1.custo_12m
      , m1.lucro_12m
      , m1.preco_medio
   -- passado
      , m2.vendas_12m     AS vendas_12m_prev
      , m2.qtde_12m       AS qtde_12m_prev
      , m2.rec_bruta_12m  AS rec_bruta_12m_prev
      , m2.desc_12m       AS desc_12m_prev
      , m2.rec_liq_12m    AS rec_liq_12m_prev
      , m2.custo_12m      AS custo_12m_prev
      , m2.lucro_12m      AS lucro_12m_prev
      , m2.preco_medio    AS preco_medio_prev
FROM metrics m1
   LEFT JOIN metrics m2
   ON m2.mes_seq = m1.mes_seq - 12
--     AND m2.<VARIAVEL DIMENSAO PELA QUAL SE PRETENDE AGRUPAR> = m1.<VARIAVEL DIMENSAO PELA QUAL SE PRETENDE AGRUPAR>
WHERE m2.mes_seq IS NOT NULL
)

-- ==========================================
-- F) CAGR Rolling 12M e Decomposicao do Mix
-- ==========================================
SELECT -- <VARIAVEL DIMENSAO PELA QUAL SE PRETENDE AGRUPAR>,
   ano_mes
      , ROUND(100 * (1.0 * vendas_12m    / NULLIF(vendas_12m_prev, 0)    - 1),2) || '%'  AS cagr_vendas_12m
      , ROUND(100 * (1.0 * qtde_12m      / NULLIF(qtde_12m_prev, 0)      - 1),2) || '%'  AS cagr_qtde_12m
      , ROUND(100 * (1.0 * rec_bruta_12m / NULLIF(rec_bruta_12m_prev, 0) - 1),2) || '%'  AS cagr_rec_bruta_12m
      , ROUND(100 * (1.0 * desc_12m      / NULLIF(desc_12m_prev, 0)      - 1),2) || '%'  AS cagr_desc_12m
      , ROUND(100 * (1.0 * rec_liq_12m   / NULLIF(rec_liq_12m_prev, 0)   - 1),2) || '%'  AS cagr_rec_liq_12m
      , ROUND(100 * (1.0 * custo_12m     / NULLIF(custo_12m_prev, 0)     - 1),2) || '%'  AS cagr_custo_12m
      , ROUND(100 * (1.0 * lucro_12m     / NULLIF(lucro_12m_prev, 0)     - 1),2) || '%'  AS cagr_lucro_12m
   -- Margem
      , ROUND(100 * ((1.0 * lucro_12m / rec_liq_12m) /
              NULLIF((1.0 * lucro_12m_prev / rec_liq_12m_prev), 0) - 1), 2) || '%' AS cagr_margem_12m
   -- Ticket Medio
      , ROUND(100 * ((1.0 * rec_liq_12m / vendas_12m) /
              NULLIF((1.0 * rec_liq_12m_prev / vendas_12m_prev), 0) - 1), 2) || '%' AS cagr_ticket_medio_12m
   -- Delta Receita
      , ROUND(rec_liq_12m - rec_liq_12m_prev, 2) AS delta_receita
   -- Efeito Volume
      , ROUND((qtde_12m - qtde_12m_prev) * preco_medio_prev, 2) AS efeito_volume
   -- Efeito Preço
      , ROUND((preco_medio - preco_medio_prev) * qtde_12m_prev, 2) AS efeito_preco
   -- Efeito Mix
      , ROUND((qtde_12m - qtde_12m_prev) *
              (preco_medio - preco_medio_prev), 2) AS efeito_mix
      , ROUND((rec_liq_12m - rec_liq_12m_prev) -
         ((qtde_12m - qtde_12m_prev) * preco_medio_prev +
          (preco_medio - preco_medio_prev) * qtde_12m_prev +
          (qtde_12m - qtde_12m_prev) * (preco_medio - preco_medio_prev)), 6) AS check_decomposicao
FROM comparison
ORDER BY -- <VARIAVEL DIMENSAO PELA QUAL SE PRETENDE AGRUPAR>,
        ano_mes;


---------------------------------------------------------------------------
--> 8. Estudando a questao dos preços
-->    Primeiro os deficitarios
---------------------------------------------------------------------------

SELECT f_vendas.*
      , ROUND(d_produto.preco_unitario, 2)                       AS preco_unitario_sugerido
      , ROUND(d_produto.custo_unitario, 2)                       AS custo_unitario_sugerido
      , ROUND(d_produto.custo_unitario * f_vendas.quantidade, 2) AS custo_total_sugerido
      , ROUND(100 * f_vendas.lucro / f_vendas.receita_liquida, 2) || '%'  AS margem_financeira
FROM f_vendas
   JOIN d_produto
   ON f_vendas.produto_id = d_produto.produto_id
WHERE f_vendas.quantidade = 1
   AND (f_vendas.preco_unitario <= d_produto.preco_unitario
   OR f_vendas.custo_total <= d_produto.custo_unitario * f_vendas.quantidade)
ORDER BY ROUND(100 * f_vendas.lucro / f_vendas.receita_liquida, 2) DESC
      , f_vendas.desconto DESC
      , f_vendas.preco_unitario DESC
      , f_vendas.custo_total DESC;


---------------------------------------------------------------------------
--> 8. Estudando a questao dos preços
-->    Segundo os superavitarios
---------------------------------------------------------------------------

SELECT f_vendas.*
      , ROUND(d_produto.preco_unitario, 2)                       AS preco_unitario_sugerido
      , ROUND(d_produto.custo_unitario, 2)                       AS custo_unitario_sugerido
      , ROUND(d_produto.custo_unitario * f_vendas.quantidade, 2) AS custo_total_sugerido
      , ROUND(100 * f_vendas.lucro / f_vendas.receita_liquida, 2) || '%'  AS margem_financeira
FROM f_vendas
   JOIN d_produto
   ON f_vendas.produto_id = d_produto.produto_id
WHERE f_vendas.quantidade = 1
   AND f_vendas.preco_unitario > d_produto.preco_unitario
   AND f_vendas.custo_total > d_produto.custo_unitario * f_vendas.quantidade
ORDER BY ROUND(100 * f_vendas.lucro / f_vendas.receita_liquida, 2) DESC
      , f_vendas.desconto DESC
      , f_vendas.preco_unitario DESC
      , f_vendas.custo_total DESC;


---------------------------------------------------------------------------
--> 8. Estudando a questao dos preços
-->    Terceiro os resumos
---------------------------------------------------------------------------

   SELECT 'Todos'                             AS tipo
      , COUNT(*)                            AS transacoes
      , ROUND(SUM(quantidade), 2)           AS quantidade
      , ROUND(SUM(receita_bruta), 2)        AS receita_bruta
      , ROUND(SUM(desconto), 2)             AS desconto
      , ROUND(SUM(receita_liquida), 2)      AS receita_liquida
      , ROUND(SUM(custo_total), 2)          AS custo_total
      , ROUND(SUM(lucro), 2)                AS lucro
      , ROUND(SUM(custo_total_sugerido), 2) AS custo_total_sugerido
      , ROUND(100 * SUM(lucro)     / SUM(receita_liquida), 3) || '%'   AS margem_financeira
      , ROUND(SUM(receita_liquida) / COUNT(*), 2) AS receita_media
      , ROUND(SUM(desconto)        / COUNT(*), 2) AS desconto_medio
      , ROUND(SUM(lucro)           / COUNT(*), 2) AS lucro_medio
   FROM (
    SELECT f_vendas.*
         , ROUND(d_produto.preco_unitario, 2)                       AS preco_unitario_sugerido
         , ROUND(d_produto.custo_unitario, 2)                       AS custo_unitario_sugerido
         , ROUND(d_produto.custo_unitario * f_vendas.quantidade, 2) AS custo_total_sugerido
      FROM f_vendas
         JOIN d_produto
         ON f_vendas.produto_id = d_produto.produto_id
      ORDER BY f_vendas.desconto DESC
         , f_vendas.preco_unitario DESC
         , f_vendas.custo_total DESC
   ) AS AUX_All

UNION ALL

   SELECT 'Deficitarios'                      AS tipo
      , COUNT(*)                            AS transacoes
      , ROUND(SUM(quantidade), 2)           AS quantidade
      , ROUND(SUM(receita_bruta), 2)        AS receita_bruta
      , ROUND(SUM(desconto), 2)             AS desconto
      , ROUND(SUM(receita_liquida), 2)      AS receita_liquida
      , ROUND(SUM(custo_total), 2)          AS custo_total
      , ROUND(SUM(lucro), 2)                AS lucro
      , ROUND(SUM(custo_total_sugerido), 2) AS custo_total_sugerido
      , ROUND(100 * SUM(lucro)     / SUM(receita_liquida), 3) || '%'   AS margem_financeira
      , ROUND(SUM(receita_liquida) / COUNT(*), 2) AS receita_media
      , ROUND(SUM(desconto)        / COUNT(*), 2) AS desconto_medio
      , ROUND(SUM(lucro)           / COUNT(*), 2) AS lucro_medio
   FROM (
    SELECT f_vendas.*
         , ROUND(d_produto.preco_unitario, 2)                       AS preco_unitario_sugerido
         , ROUND(d_produto.custo_unitario, 2)                       AS custo_unitario_sugerido
         , ROUND(d_produto.custo_unitario * f_vendas.quantidade, 2) AS custo_total_sugerido
      FROM f_vendas
         JOIN d_produto
         ON f_vendas.produto_id = d_produto.produto_id
      WHERE f_vendas.preco_unitario <= d_produto.preco_unitario
         OR f_vendas.custo_total <= d_produto.custo_unitario * f_vendas.quantidade
      ORDER BY f_vendas.desconto DESC
         , f_vendas.preco_unitario DESC
         , f_vendas.custo_total DESC
   ) AS AUX_Def

UNION ALL

   SELECT 'Superavitarios'                    AS tipo
      , COUNT(*)                            AS transacoes
      , ROUND(SUM(quantidade), 2)           AS quantidade
      , ROUND(SUM(receita_bruta), 2)        AS receita_bruta
      , ROUND(SUM(desconto), 2)             AS desconto
      , ROUND(SUM(receita_liquida), 2)      AS receita_liquida
      , ROUND(SUM(custo_total), 2)          AS custo_total
      , ROUND(SUM(lucro), 2)                AS lucro
      , ROUND(SUM(custo_total_sugerido), 2) AS custo_total_sugerido
      , ROUND(100 * SUM(lucro)     / SUM(receita_liquida), 3) || '%'   AS margem_financeira
      , ROUND(SUM(receita_liquida) / COUNT(*), 2) AS receita_media
      , ROUND(SUM(desconto)        / COUNT(*), 2) AS desconto_medio
      , ROUND(SUM(lucro)           / COUNT(*), 2) AS lucro_medio
   FROM (
    SELECT f_vendas.*
         , ROUND(d_produto.preco_unitario, 2)                       AS preco_unitario_sugerido
         , ROUND(d_produto.custo_unitario, 2)                       AS custo_unitario_sugerido
         , ROUND(d_produto.custo_unitario * f_vendas.quantidade, 2) AS custo_total_sugerido
      FROM f_vendas
         JOIN d_produto
         ON f_vendas.produto_id = d_produto.produto_id
      WHERE f_vendas.preco_unitario > d_produto.preco_unitario
         AND f_vendas.custo_total > d_produto.custo_unitario * f_vendas.quantidade
      ORDER BY f_vendas.desconto DESC
         , f_vendas.preco_unitario DESC
         , f_vendas.custo_total DESC
   ) AS AUX_Sup;
