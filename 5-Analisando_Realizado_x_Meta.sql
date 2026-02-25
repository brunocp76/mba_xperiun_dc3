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

 SELECT COALESCE(metas.anomes, vendas.anomes)  AS anomes
      , meta_receita
      , meta_quantidade
      , receita_bruta
      , receita_liquida
      , quantidade
   FROM (
    SELECT 100 * ano + mes   AS anomes
         , meta_receita
         , meta_quantidade
      FROM d_meta_mensal
     ORDER BY ano
         , mes
         ) AS metas
   JOIN (
    SELECT CAST(strftime('%Y%m', "data") AS INTEGER) AS anomes
         , SUM(receita_bruta)                        AS receita_bruta
         , SUM(receita_liquida)                      AS receita_liquida
         , SUM(quantidade)                           AS quantidade
      FROM f_vendas
     GROUP BY CAST(strftime('%Y%m', "data") AS INTEGER)
     ORDER BY CAST(strftime('%Y%m', "data") AS INTEGER)
     )  AS vendas
     ON metas.anomes = vendas.anomes
  ORDER BY COALESCE(metas.anomes, vendas.anomes);