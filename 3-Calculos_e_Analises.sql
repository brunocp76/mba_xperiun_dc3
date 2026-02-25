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
--> Primeiras Analises
------------------------------------------------------------------------------------------------------------
--> Autor: Bruno César Pasquini
--> Auxiliar: ChatGPT 5
--> Revisor: Bruno César Pasquini
------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------
--> Tabela d_calendario
---------------------------------------------------------------------------

SELECT * FROM d_calendario;


---------------------------------------------------------------------------
--> Tabela d_fornecedor
---------------------------------------------------------------------------

SELECT * FROM d_fornecedor;

 SELECT MIN(prazo_entrega_dias)  AS Prazo_Min
      , AVG(prazo_entrega_dias)  AS Prazo_Med
      , MAX(prazo_entrega_dias)  AS Prazo_Max
   FROM d_fornecedor;

---------------------------------------------------------------------------
--> Tabela d_meta_mensal
---------------------------------------------------------------------------

SELECT * FROM d_meta_mensal;

 SELECT COUNT(*)                         AS Registros
      , ROUND(MIN(meta_receita), 2)      AS Meta_Receita_Min
      , ROUND(AVG(meta_receita), 2)      AS Meta_Receita_Med
      , ROUND(MAX(meta_receita), 2)      AS Meta_Receita_Max
      , ROUND(MIN(meta_quantidade), 2)   AS Meta_Quantidade_Min
      , ROUND(AVG(meta_quantidade), 2)   AS Meta_Quantidade_Med
      , ROUND(MAX(meta_quantidade), 2)   AS Meta_Quantidade_Max
   FROM d_meta_mensal
  WHERE ano * 100 + mes < 201910;

 SELECT ano
      , COUNT(*)                         AS Registros
      , ROUND(MIN(meta_receita), 2)      AS Meta_Receita_Min
      , ROUND(AVG(meta_receita), 2)      AS Meta_Receita_Med
      , ROUND(MAX(meta_receita), 2)      AS Meta_Receita_Max
      , ROUND(MIN(meta_quantidade), 2)   AS Meta_Quantidade_Min
      , ROUND(AVG(meta_quantidade), 2)   AS Meta_Quantidade_Med
      , ROUND(MAX(meta_quantidade), 2)   AS Meta_Quantidade_Max
   FROM d_meta_mensal
  WHERE ano * 100 + mes < 201910
  GROUP BY ano
  ORDER BY ano;

 SELECT mes
      , COUNT(*)                         AS Registros
      , ROUND(MIN(meta_receita), 2)      AS Meta_Receita_Min
      , ROUND(AVG(meta_receita), 2)      AS Meta_Receita_Med
      , ROUND(MAX(meta_receita), 2)      AS Meta_Receita_Max
      , ROUND(MIN(meta_quantidade), 2)   AS Meta_Quantidade_Min
      , ROUND(AVG(meta_quantidade), 2)   AS Meta_Quantidade_Med
      , ROUND(MAX(meta_quantidade), 2)   AS Meta_Quantidade_Max
   FROM d_meta_mensal
  WHERE ano * 100 + mes < 201910
  GROUP BY mes
  ORDER BY mes;


---------------------------------------------------------------------------
--> Tabela d_produto
---------------------------------------------------------------------------

 SELECT *
      , ROUND(100 * ((preco_unitario / custo_unitario) - 1), 1)     AS margem_percentual_calc
      , ROUND(custo_unitario * (1 + (margem_percentual / 100)), 2)  AS preco_unitario_calc
   FROM d_produto;

 SELECT COUNT(*)                         AS Registros
      , ROUND(MIN(preco_unitario), 2)    AS Preco_Unit_Min
      , ROUND(AVG(preco_unitario), 2)    AS Preco_Unit_Med
      , ROUND(MAX(preco_unitario), 2)    AS Preco_Unit_Max
      , ROUND(MIN(custo_unitario), 2)    AS Custo_Unit_Min
      , ROUND(AVG(custo_unitario), 2)    AS Custo_Unit_Med
      , ROUND(MAX(custo_unitario), 2)    AS Custo_Unit_Max
      , ROUND(MIN(margem_percentual), 2) AS Margem_Perc_Min
      , ROUND(AVG(margem_percentual), 2) AS Margem_Perc_Med
      , ROUND(MAX(margem_percentual), 2) AS Margem_Perc_Max
      , ROUND(MIN(100 * ((preco_unitario / custo_unitario) - 1)), 1)   AS Margem_Calc_Min
      , ROUND(AVG(100 * ((preco_unitario / custo_unitario) - 1)), 1)   AS Margem_Calc_Med
      , ROUND(MAX(100 * ((preco_unitario / custo_unitario) - 1)), 1)   AS Margem_Calc_Max
      , ROUND(MIN(custo_unitario * (1 + (margem_percentual / 100))), 2)   AS  Preco_Calc_Min
      , ROUND(AVG(custo_unitario * (1 + (margem_percentual / 100))), 2)   AS  Preco_Calc_Med
      , ROUND(MAX(custo_unitario * (1 + (margem_percentual / 100))), 2)   AS  Preco_Calc_Max
   FROM d_produto;

 SELECT exige_receita
      , COUNT(*)                         AS Registros
      , ROUND(MIN(preco_unitario), 2)    AS Preco_Unit_Min
      , ROUND(AVG(preco_unitario), 2)    AS Preco_Unit_Med
      , ROUND(MAX(preco_unitario), 2)    AS Preco_Unit_Max
      , ROUND(MIN(custo_unitario), 2)    AS Custo_Unit_Min
      , ROUND(AVG(custo_unitario), 2)    AS Custo_Unit_Med
      , ROUND(MAX(custo_unitario), 2)    AS Custo_Unit_Max
      , ROUND(MIN(margem_percentual), 2) AS Margem_Perc_Min
      , ROUND(AVG(margem_percentual), 2) AS Margem_Perc_Med
      , ROUND(MAX(margem_percentual), 2) AS Margem_Perc_Max
      , ROUND(MIN(100 * ((preco_unitario / custo_unitario) - 1)), 1)   AS Margem_Calc_Min
      , ROUND(AVG(100 * ((preco_unitario / custo_unitario) - 1)), 1)   AS Margem_Calc_Med
      , ROUND(MAX(100 * ((preco_unitario / custo_unitario) - 1)), 1)   AS Margem_Calc_Max
      , ROUND(MIN(custo_unitario * (1 + (margem_percentual / 100))), 2)   AS  Preco_Calc_Min
      , ROUND(AVG(custo_unitario * (1 + (margem_percentual / 100))), 2)   AS  Preco_Calc_Med
      , ROUND(MAX(custo_unitario * (1 + (margem_percentual / 100))), 2)   AS  Preco_Calc_Max
   FROM d_produto
  GROUP BY exige_receita
  ORDER BY exige_receita;

 SELECT grupo_terapeutico
      , COUNT(*)                         AS Registros
      , ROUND(MIN(preco_unitario), 2)    AS Preco_Unit_Min
      , ROUND(AVG(preco_unitario), 2)    AS Preco_Unit_Med
      , ROUND(MAX(preco_unitario), 2)    AS Preco_Unit_Max
      , ROUND(MIN(custo_unitario), 2)    AS Custo_Unit_Min
      , ROUND(AVG(custo_unitario), 2)    AS Custo_Unit_Med
      , ROUND(MAX(custo_unitario), 2)    AS Custo_Unit_Max
      , ROUND(MIN(margem_percentual), 2) AS Margem_Perc_Min
      , ROUND(AVG(margem_percentual), 2) AS Margem_Perc_Med
      , ROUND(MAX(margem_percentual), 2) AS Margem_Perc_Max
      , ROUND(MIN(100 * ((preco_unitario / custo_unitario) - 1)), 1)   AS Margem_Calc_Min
      , ROUND(AVG(100 * ((preco_unitario / custo_unitario) - 1)), 1)   AS Margem_Calc_Med
      , ROUND(MAX(100 * ((preco_unitario / custo_unitario) - 1)), 1)   AS Margem_Calc_Max
      , ROUND(MIN(custo_unitario * (1 + (margem_percentual / 100))), 2)   AS  Preco_Calc_Min
      , ROUND(AVG(custo_unitario * (1 + (margem_percentual / 100))), 2)   AS  Preco_Calc_Med
      , ROUND(MAX(custo_unitario * (1 + (margem_percentual / 100))), 2)   AS  Preco_Calc_Max
   FROM d_produto
  GROUP BY grupo_terapeutico
  ORDER BY grupo_terapeutico;

 SELECT categoria
      , COUNT(*)                         AS Registros
      , ROUND(MIN(preco_unitario), 2)    AS Preco_Unit_Min
      , ROUND(AVG(preco_unitario), 2)    AS Preco_Unit_Med
      , ROUND(MAX(preco_unitario), 2)    AS Preco_Unit_Max
      , ROUND(MIN(custo_unitario), 2)    AS Custo_Unit_Min
      , ROUND(AVG(custo_unitario), 2)    AS Custo_Unit_Med
      , ROUND(MAX(custo_unitario), 2)    AS Custo_Unit_Max
      , ROUND(MIN(margem_percentual), 2) AS Margem_Perc_Min
      , ROUND(AVG(margem_percentual), 2) AS Margem_Perc_Med
      , ROUND(MAX(margem_percentual), 2) AS Margem_Perc_Max
      , ROUND(MIN(100 * ((preco_unitario / custo_unitario) - 1)), 1)   AS Margem_Calc_Min
      , ROUND(AVG(100 * ((preco_unitario / custo_unitario) - 1)), 1)   AS Margem_Calc_Med
      , ROUND(MAX(100 * ((preco_unitario / custo_unitario) - 1)), 1)   AS Margem_Calc_Max
      , ROUND(MIN(custo_unitario * (1 + (margem_percentual / 100))), 2)   AS  Preco_Calc_Min
      , ROUND(AVG(custo_unitario * (1 + (margem_percentual / 100))), 2)   AS  Preco_Calc_Med
      , ROUND(MAX(custo_unitario * (1 + (margem_percentual / 100))), 2)   AS  Preco_Calc_Max
   FROM d_produto
  GROUP BY categoria
  ORDER BY categoria;


---------------------------------------------------------------------------
--> Tabela d_turno
---------------------------------------------------------------------------

SELECT * FROM d_turno;


---------------------------------------------------------------------------
--> Tabela f_vendas
---------------------------------------------------------------------------

 SELECT *
      , ROUND(receita_bruta - receita_bruta_calc, 2)       AS receita_bruta_dif
      , ROUND(receita_liquida - receita_liquida_calc, 2)   AS receita_liquida_dif
      , ROUND(lucro - lucro_calc, 2)                       AS lucro_dif
   FROM (
    SELECT *
         , ROUND(quantidade * preco_unitario, 2)                          AS receita_bruta_calc
         , ROUND(quantidade * preco_unitario - desconto, 2)               AS receita_liquida_calc
         , ROUND(quantidade * preco_unitario - desconto - custo_total, 2) AS lucro_calc
      FROM f_vendas
   ) AS Aux
  WHERE ABS(ROUND(receita_bruta - receita_bruta_calc, 2)) > 0.001
     OR ABS(ROUND(receita_liquida - receita_liquida_calc, 2)) > 0.001
     OR ABS(ROUND(lucro - lucro_calc, 2)) > 0.001
  ORDER BY ABS(receita_bruta_dif) DESC
      , ABS(receita_liquida_dif) DESC
      , ABS(lucro_dif) DESC;

 SELECT COUNT(*)                         AS Registros
      , ROUND(MIN(quantidade), 2)        AS Qtde_Min
      , ROUND(AVG(quantidade), 2)        AS Qtde_Med
      , ROUND(MAX(quantidade), 2)        AS Qtde_Max
      , ROUND(MIN(preco_unitario), 2)    AS Preco_Unit_Min
      , ROUND(AVG(preco_unitario), 2)    AS Preco_Unit_Med
      , ROUND(MAX(preco_unitario), 2)    AS Preco_Unit_Max
      , ROUND(MIN(receita_bruta), 2)     AS Receita_Bruta_Min
      , ROUND(AVG(receita_bruta), 2)     AS Receita_Bruta_Med
      , ROUND(MAX(receita_bruta), 2)     AS Receita_Bruta_Max
      , ROUND(MIN(desconto), 2)          AS Desconto_Min
      , ROUND(AVG(desconto), 2)          AS Desconto_Med
      , ROUND(MAX(desconto), 2)          AS Desconto_Max
      , ROUND(MIN(receita_liquida), 2)   AS Receita_Bruta_Min
      , ROUND(AVG(receita_liquida), 2)   AS Receita_Bruta_Med
      , ROUND(MAX(receita_liquida), 2)   AS Receita_Bruta_Max
      , ROUND(MIN(custo_total), 2)       AS Custo_Total_Min
      , ROUND(AVG(custo_total), 2)       AS Custo_Total_Med
      , ROUND(MAX(custo_total), 2)       AS Custo_Total_Max
      , ROUND(MIN(lucro), 2)             AS Lucro_Min
      , ROUND(AVG(lucro), 2)             AS Lucro_Med
      , ROUND(MAX(lucro), 2)             AS Lucro_Max
   FROM f_vendas;

 SELECT forma_pagamento
      , COUNT(*)                         AS Registros
      , ROUND(MIN(quantidade), 2)        AS Qtde_Min
      , ROUND(AVG(quantidade), 2)        AS Qtde_Med
      , ROUND(MAX(quantidade), 2)        AS Qtde_Max
      , ROUND(MIN(preco_unitario), 2)    AS Preco_Unit_Min
      , ROUND(AVG(preco_unitario), 2)    AS Preco_Unit_Med
      , ROUND(MAX(preco_unitario), 2)    AS Preco_Unit_Max
      , ROUND(MIN(receita_bruta), 2)     AS Receita_Bruta_Min
      , ROUND(AVG(receita_bruta), 2)     AS Receita_Bruta_Med
      , ROUND(MAX(receita_bruta), 2)     AS Receita_Bruta_Max
      , ROUND(MIN(desconto), 2)          AS Desconto_Min
      , ROUND(AVG(desconto), 2)          AS Desconto_Med
      , ROUND(MAX(desconto), 2)          AS Desconto_Max
      , ROUND(MIN(receita_liquida), 2)   AS Receita_Bruta_Min
      , ROUND(AVG(receita_liquida), 2)   AS Receita_Bruta_Med
      , ROUND(MAX(receita_liquida), 2)   AS Receita_Bruta_Max
      , ROUND(MIN(custo_total), 2)       AS Custo_Total_Min
      , ROUND(AVG(custo_total), 2)       AS Custo_Total_Med
      , ROUND(MAX(custo_total), 2)       AS Custo_Total_Max
      , ROUND(MIN(lucro), 2)             AS Lucro_Min
      , ROUND(AVG(lucro), 2)             AS Lucro_Med
      , ROUND(MAX(lucro), 2)             AS Lucro_Max
   FROM f_vendas
  GROUP BY forma_pagamento
  ORDER BY forma_pagamento;

 SELECT nome
      , COUNT(*)                         AS Registros
      , ROUND(MIN(quantidade), 2)        AS Qtde_Min
      , ROUND(AVG(quantidade), 2)        AS Qtde_Med
      , ROUND(MAX(quantidade), 2)        AS Qtde_Max
      , ROUND(MIN(preco_unitario), 2)    AS Preco_Unit_Min
      , ROUND(AVG(preco_unitario), 2)    AS Preco_Unit_Med
      , ROUND(MAX(preco_unitario), 2)    AS Preco_Unit_Max
      , ROUND(MIN(receita_bruta), 2)     AS Receita_Bruta_Min
      , ROUND(AVG(receita_bruta), 2)     AS Receita_Bruta_Med
      , ROUND(MAX(receita_bruta), 2)     AS Receita_Bruta_Max
      , ROUND(MIN(desconto), 2)          AS Desconto_Min
      , ROUND(AVG(desconto), 2)          AS Desconto_Med
      , ROUND(MAX(desconto), 2)          AS Desconto_Max
      , ROUND(MIN(receita_liquida), 2)   AS Receita_Bruta_Min
      , ROUND(AVG(receita_liquida), 2)   AS Receita_Bruta_Med
      , ROUND(MAX(receita_liquida), 2)   AS Receita_Bruta_Max
      , ROUND(MIN(custo_total), 2)       AS Custo_Total_Min
      , ROUND(AVG(custo_total), 2)       AS Custo_Total_Med
      , ROUND(MAX(custo_total), 2)       AS Custo_Total_Max
      , ROUND(MIN(lucro), 2)             AS Lucro_Min
      , ROUND(AVG(lucro), 2)             AS Lucro_Med
      , ROUND(MAX(lucro), 2)             AS Lucro_Max
   FROM f_vendas
   JOIN d_fornecedor
     ON f_vendas.fornecedor_id = d_fornecedor.fornecedor_id
  GROUP BY nome
  ORDER BY nome;
 
 SELECT nome_produto
      , COUNT(*)                         AS Registros
      , ROUND(MIN(quantidade), 2)        AS Qtde_Min
      , ROUND(AVG(quantidade), 2)        AS Qtde_Med
      , ROUND(MAX(quantidade), 2)        AS Qtde_Max
      , ROUND(MIN(f_vendas.preco_unitario), 2)    AS Preco_Unit_Vendas_Min
      , ROUND(AVG(f_vendas.preco_unitario), 2)    AS Preco_Unit_Vendas_Med
      , ROUND(MAX(f_vendas.preco_unitario), 2)    AS Preco_Unit_Vendas_Max
      , ROUND(MIN(d_produto.preco_unitario), 2)   AS Preco_Unit_Prod_Min
      , ROUND(AVG(d_produto.preco_unitario), 2)   AS Preco_Unit_Prod_Med
      , ROUND(MAX(d_produto.preco_unitario), 2)   AS Preco_Unit_Prod_Max
      , ROUND(MIN(receita_bruta), 2)     AS Receita_Bruta_Min
      , ROUND(AVG(receita_bruta), 2)     AS Receita_Bruta_Med
      , ROUND(MAX(receita_bruta), 2)     AS Receita_Bruta_Max
      , ROUND(MIN(desconto), 2)          AS Desconto_Min
      , ROUND(AVG(desconto), 2)          AS Desconto_Med
      , ROUND(MAX(desconto), 2)          AS Desconto_Max
      , ROUND(MIN(receita_liquida), 2)   AS Receita_Bruta_Min
      , ROUND(AVG(receita_liquida), 2)   AS Receita_Bruta_Med
      , ROUND(MAX(receita_liquida), 2)   AS Receita_Bruta_Max
      , ROUND(MIN(custo_total), 2)       AS Custo_Total_Min
      , ROUND(AVG(custo_total), 2)       AS Custo_Total_Med
      , ROUND(MAX(custo_total), 2)       AS Custo_Total_Max
      , ROUND(MIN(lucro), 2)             AS Lucro_Min
      , ROUND(AVG(lucro), 2)             AS Lucro_Med
      , ROUND(MAX(lucro), 2)             AS Lucro_Max
   FROM f_vendas
   JOIN d_produto
     ON f_vendas.produto_id = d_produto.produto_id
  GROUP BY nome_produto
  ORDER BY nome_produto;

 SELECT categoria
      , COUNT(*)                         AS Registros
      , ROUND(MIN(quantidade), 2)        AS Qtde_Min
      , ROUND(AVG(quantidade), 2)        AS Qtde_Med
      , ROUND(MAX(quantidade), 2)        AS Qtde_Max
      , ROUND(MIN(f_vendas.preco_unitario), 2)    AS Preco_Unit_Vendas_Min
      , ROUND(AVG(f_vendas.preco_unitario), 2)    AS Preco_Unit_Vendas_Med
      , ROUND(MAX(f_vendas.preco_unitario), 2)    AS Preco_Unit_Vendas_Max
      , ROUND(MIN(d_produto.preco_unitario), 2)   AS Preco_Unit_Prod_Min
      , ROUND(AVG(d_produto.preco_unitario), 2)   AS Preco_Unit_Prod_Med
      , ROUND(MAX(d_produto.preco_unitario), 2)   AS Preco_Unit_Prod_Max
      , ROUND(MIN(receita_bruta), 2)     AS Receita_Bruta_Min
      , ROUND(AVG(receita_bruta), 2)     AS Receita_Bruta_Med
      , ROUND(MAX(receita_bruta), 2)     AS Receita_Bruta_Max
      , ROUND(MIN(desconto), 2)          AS Desconto_Min
      , ROUND(AVG(desconto), 2)          AS Desconto_Med
      , ROUND(MAX(desconto), 2)          AS Desconto_Max
      , ROUND(MIN(receita_liquida), 2)   AS Receita_Bruta_Min
      , ROUND(AVG(receita_liquida), 2)   AS Receita_Bruta_Med
      , ROUND(MAX(receita_liquida), 2)   AS Receita_Bruta_Max
      , ROUND(MIN(custo_total), 2)       AS Custo_Total_Min
      , ROUND(AVG(custo_total), 2)       AS Custo_Total_Med
      , ROUND(MAX(custo_total), 2)       AS Custo_Total_Max
      , ROUND(MIN(lucro), 2)             AS Lucro_Min
      , ROUND(AVG(lucro), 2)             AS Lucro_Med
      , ROUND(MAX(lucro), 2)             AS Lucro_Max
   FROM f_vendas
   JOIN d_produto
     ON f_vendas.produto_id = d_produto.produto_id
  GROUP BY categoria
  ORDER BY categoria;

 SELECT grupo_terapeutico
      , COUNT(*)                         AS Registros
      , ROUND(MIN(quantidade), 2)        AS Qtde_Min
      , ROUND(AVG(quantidade), 2)        AS Qtde_Med
      , ROUND(MAX(quantidade), 2)        AS Qtde_Max
      , ROUND(MIN(f_vendas.preco_unitario), 2)    AS Preco_Unit_Vendas_Min
      , ROUND(AVG(f_vendas.preco_unitario), 2)    AS Preco_Unit_Vendas_Med
      , ROUND(MAX(f_vendas.preco_unitario), 2)    AS Preco_Unit_Vendas_Max
      , ROUND(MIN(d_produto.preco_unitario), 2)   AS Preco_Unit_Prod_Min
      , ROUND(AVG(d_produto.preco_unitario), 2)   AS Preco_Unit_Prod_Med
      , ROUND(MAX(d_produto.preco_unitario), 2)   AS Preco_Unit_Prod_Max
      , ROUND(MIN(receita_bruta), 2)     AS Receita_Bruta_Min
      , ROUND(AVG(receita_bruta), 2)     AS Receita_Bruta_Med
      , ROUND(MAX(receita_bruta), 2)     AS Receita_Bruta_Max
      , ROUND(MIN(desconto), 2)          AS Desconto_Min
      , ROUND(AVG(desconto), 2)          AS Desconto_Med
      , ROUND(MAX(desconto), 2)          AS Desconto_Max
      , ROUND(MIN(receita_liquida), 2)   AS Receita_Bruta_Min
      , ROUND(AVG(receita_liquida), 2)   AS Receita_Bruta_Med
      , ROUND(MAX(receita_liquida), 2)   AS Receita_Bruta_Max
      , ROUND(MIN(custo_total), 2)       AS Custo_Total_Min
      , ROUND(AVG(custo_total), 2)       AS Custo_Total_Med
      , ROUND(MAX(custo_total), 2)       AS Custo_Total_Max
      , ROUND(MIN(lucro), 2)             AS Lucro_Min
      , ROUND(AVG(lucro), 2)             AS Lucro_Med
      , ROUND(MAX(lucro), 2)             AS Lucro_Max
   FROM f_vendas
   JOIN d_produto
     ON f_vendas.produto_id = d_produto.produto_id
  GROUP BY grupo_terapeutico
  ORDER BY grupo_terapeutico;

 SELECT turno_id
      , COUNT(*)                         AS Registros
      , ROUND(MIN(quantidade), 2)        AS Qtde_Min
      , ROUND(AVG(quantidade), 2)        AS Qtde_Med
      , ROUND(MAX(quantidade), 2)        AS Qtde_Max
      , ROUND(MIN(preco_unitario), 2)    AS Preco_Unit_Min
      , ROUND(AVG(preco_unitario), 2)    AS Preco_Unit_Med
      , ROUND(MAX(preco_unitario), 2)    AS Preco_Unit_Max
      , ROUND(MIN(receita_bruta), 2)     AS Receita_Bruta_Min
      , ROUND(AVG(receita_bruta), 2)     AS Receita_Bruta_Med
      , ROUND(MAX(receita_bruta), 2)     AS Receita_Bruta_Max
      , ROUND(MIN(desconto), 2)          AS Desconto_Min
      , ROUND(AVG(desconto), 2)          AS Desconto_Med
      , ROUND(MAX(desconto), 2)          AS Desconto_Max
      , ROUND(MIN(receita_liquida), 2)   AS Receita_Bruta_Min
      , ROUND(AVG(receita_liquida), 2)   AS Receita_Bruta_Med
      , ROUND(MAX(receita_liquida), 2)   AS Receita_Bruta_Max
      , ROUND(MIN(custo_total), 2)       AS Custo_Total_Min
      , ROUND(AVG(custo_total), 2)       AS Custo_Total_Med
      , ROUND(MAX(custo_total), 2)       AS Custo_Total_Max
      , ROUND(MIN(lucro), 2)             AS Lucro_Min
      , ROUND(AVG(lucro), 2)             AS Lucro_Med
      , ROUND(MAX(lucro), 2)             AS Lucro_Max
   FROM f_vendas
  GROUP BY turno_id
  ORDER BY turno_id;

 SELECT hora
      , COUNT(*)                         AS Registros
      , ROUND(MIN(quantidade), 2)        AS Qtde_Min
      , ROUND(AVG(quantidade), 2)        AS Qtde_Med
      , ROUND(MAX(quantidade), 2)        AS Qtde_Max
      , ROUND(MIN(preco_unitario), 2)    AS Preco_Unit_Min
      , ROUND(AVG(preco_unitario), 2)    AS Preco_Unit_Med
      , ROUND(MAX(preco_unitario), 2)    AS Preco_Unit_Max
      , ROUND(MIN(receita_bruta), 2)     AS Receita_Bruta_Min
      , ROUND(AVG(receita_bruta), 2)     AS Receita_Bruta_Med
      , ROUND(MAX(receita_bruta), 2)     AS Receita_Bruta_Max
      , ROUND(MIN(desconto), 2)          AS Desconto_Min
      , ROUND(AVG(desconto), 2)          AS Desconto_Med
      , ROUND(MAX(desconto), 2)          AS Desconto_Max
      , ROUND(MIN(receita_liquida), 2)   AS Receita_Bruta_Min
      , ROUND(AVG(receita_liquida), 2)   AS Receita_Bruta_Med
      , ROUND(MAX(receita_liquida), 2)   AS Receita_Bruta_Max
      , ROUND(MIN(custo_total), 2)       AS Custo_Total_Min
      , ROUND(AVG(custo_total), 2)       AS Custo_Total_Med
      , ROUND(MAX(custo_total), 2)       AS Custo_Total_Max
      , ROUND(MIN(lucro), 2)             AS Lucro_Min
      , ROUND(AVG(lucro), 2)             AS Lucro_Med
      , ROUND(MAX(lucro), 2)             AS Lucro_Max
   FROM f_vendas
  GROUP BY hora
  ORDER BY hora;
