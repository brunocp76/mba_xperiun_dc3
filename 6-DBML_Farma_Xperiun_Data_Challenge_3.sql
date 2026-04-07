CREATE TABLE "d_calendario" (
  "data" date PRIMARY KEY,
  "ano" integer,
  "mes" integer,
  "nome_mes" text,
  "trimestre" integer,
  "semestre" integer,
  "dia_semana" integer,
  "nome_dia_semana" text,
  "is_fim_semana" boolean,
  "is_feriado" boolean
);

CREATE TABLE "d_fornecedor" (
  "fornecedor_id" integer PRIMARY KEY,
  "nome" text,
  "cidade" text,
  "estado" text,
  "regiao" text,
  "prazo_entrega_dias" integer
);

CREATE TABLE "d_meta_mensal" (
  "meta_id" integer PRIMARY KEY,
  "ano" integer,
  "mes" integer,
  "meta_receita" numeric,
  "meta_quantidade" integer
);

CREATE TABLE "d_produto" (
  "produto_id" integer PRIMARY KEY,
  "nome_produto" text,
  "codigo_atc" text,
  "categoria" text,
  "grupo_terapeutico" text,
  "preco_unitario" numeric,
  "custo_unitario" numeric,
  "margem_percentual" numeric,
  "exige_receita" boolean
);

CREATE TABLE "d_turno" (
  "turno_id" integer PRIMARY KEY,
  "nome_turno" text,
  "hora_inicio" integer,
  "hora_fim" integer
);

CREATE TABLE "f_vendas" (
  "venda_id" integer PRIMARY KEY,
  "data" date,
  "hora" integer,
  "turno_id" integer,
  "produto_id" integer,
  "fornecedor_id" integer,
  "quantidade" numeric,
  "preco_unitario" numeric,
  "receita_bruta" numeric,
  "desconto" numeric,
  "receita_liquida" numeric,
  "custo_total" numeric,
  "lucro" numeric,
  "forma_pagamento" text
);
