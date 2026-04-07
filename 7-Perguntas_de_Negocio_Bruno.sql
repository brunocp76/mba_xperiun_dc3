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


---------------------------------------------------------------------------
--> 1. Tendência de crescimento Ano a Ano das metricas financeiras
-->    (Atraves da CAGR (Taxa de Crescimento Anual Composta))
-->    Começando pelo meses limítrofes...
---------------------------------------------------------------------------

-- ==========================================
-- A) Consolida VENDAS por ano e mes
-- ==========================================
WITH vendas_mensal AS (
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
, metas_mensal AS (
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
, mensal AS (
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
, limites AS (
 SELECT MIN(ano_mes) AS ano_mes_inicial
      , MAX(ano_mes) AS ano_mes_final
   FROM mensal
)

-- ==========================================
-- E) Calcula diferença total em meses
-- ==========================================
, periodo AS (
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
, mi AS (
 SELECT *
   FROM mensal
  WHERE ano_mes = (SELECT ano_mes_inicial FROM limites)
)

-- ==========================================
-- G) Captura mês final
-- ==========================================
, mf AS (
 SELECT *
   FROM mensal
  WHERE ano_mes = (SELECT ano_mes_final FROM limites)
)

-- ==========================================
-- H) Calcula todos os ratios como REAL
-- ==========================================
, ratios AS (
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
--> 2. Tendência de crescimento Ano a Ano das metricas financeiras por dimensoes
-->    (Atraves de um YoY Movel das metricas financeiras dadas e outras derivadas
-->    (Comparando as somas dos 12 últimos meses comparadas com os 12 meses anteriores)
-->    Deixando o Codigo Facilitado para Agrupamento
---------------------------------------------------------------------------

-- ==========================================
-- A) Base mensal (vendas)
-- ==========================================
WITH mensal_base AS (
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
, mensal_index AS (
 SELECT *
      , ((ano_mes / 100) * 12 + (ano_mes % 100)) AS mes_seq
   FROM mensal_base
)

-- ==========================================
-- C) Rolling 12M
-- ==========================================
, rolling_12m AS (
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
, metrics AS (
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
, comparison AS (
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
-- F) YoY Movel e Decomposicao do Mix
-- ==========================================
 SELECT -- <VARIAVEL DIMENSAO PELA QUAL SE PRETENDE AGRUPAR>,
        ano_mes
      , ROUND(100 * (1.0 * vendas_12m    / NULLIF(vendas_12m_prev, 0)    - 1),2) || '%'  AS YoY_vendas_12m
      , ROUND(100 * (1.0 * qtde_12m      / NULLIF(qtde_12m_prev, 0)      - 1),2) || '%'  AS YoY_qtde_12m
      , ROUND(100 * (1.0 * rec_bruta_12m / NULLIF(rec_bruta_12m_prev, 0) - 1),2) || '%'  AS YoY_rec_bruta_12m
      , ROUND(100 * (1.0 * desc_12m      / NULLIF(desc_12m_prev, 0)      - 1),2) || '%'  AS YoY_desc_12m
      , ROUND(100 * (1.0 * rec_liq_12m   / NULLIF(rec_liq_12m_prev, 0)   - 1),2) || '%'  AS YoY_rec_liq_12m
      , ROUND(100 * (1.0 * custo_12m     / NULLIF(custo_12m_prev, 0)     - 1),2) || '%'  AS YoY_custo_12m
      , ROUND(100 * (1.0 * lucro_12m     / NULLIF(lucro_12m_prev, 0)     - 1),2) || '%'  AS YoY_lucro_12m
   -- Margem
      , ROUND(100 * ((1.0 * lucro_12m / rec_liq_12m) /
              NULLIF((1.0 * lucro_12m_prev / rec_liq_12m_prev), 0) - 1), 2) || '%' AS YoY_margem_12m
   -- Ticket Medio
      , ROUND(100 * ((1.0 * rec_liq_12m / vendas_12m) /
              NULLIF((1.0 * rec_liq_12m_prev / vendas_12m_prev), 0) - 1), 2) || '%' AS YoY_ticket_medio_12m
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
