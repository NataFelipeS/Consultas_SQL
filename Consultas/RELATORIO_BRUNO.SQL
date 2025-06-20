WITH FATURAMENTO AS (
  SELECT
    DC.PESSOA_DOCCOM AS COD_SUPERVISOR,
    CASE 
      WHEN P.RAZAOSOCIAL_PESSOA = 'REGINALDO LEAL GOMES' THEN 'REGINALDO' 
      WHEN P.RAZAOSOCIAL_PESSOA = 'GEAN ORTIZ DE MORAIS' THEN 'GEAN'
      WHEN P.RAZAOSOCIAL_PESSOA = 'MARCO AURELIO SANTOS RIBEIRO' THEN 'MARCO'
      WHEN P.RAZAOSOCIAL_PESSOA = 'SUPERVISOR - EXPORTAÇÃO' THEN 'EXP.'
      WHEN P.RAZAOSOCIAL_PESSOA = 'SUPERVISOR - ECOMMERCE' THEN 'ECO.'
    END AS NOME_SUPERVISOR,
    SUM(SUM(NF.VALORMERCADORIA_NF) - SUM(NF.VALORDESCTOTAL_NF)) OVER(PARTITION BY DC.PESSOA_DOCCOM) AS VALOR_SUPERVISOR, 
    COUNT(DISTINCT NF.PESSOA_NF) OVER(PARTITION BY DC.PESSOA_DOCCOM) AS QTDE_CLIENTES,
    NF.PESSOA_NF AS CLIENTE,
    P_CLIENTE.RAZAOSOCIAL_PESSOA AS NOME_CLIENTE,
    (SUM(NF.VALORMERCADORIA_NF) - SUM(NF.VALORDESCTOTAL_NF)) AS VALOR_VENDIDO,
    ROW_NUMBER() OVER (
      PARTITION BY DC.PESSOA_DOCCOM
      ORDER BY SUM(NF.VALORMERCADORIA_NF) - SUM(NF.VALORDESCTOTAL_NF) DESC
    ) AS RN
FROM NOTA_FISCAL NF
    INNER JOIN DOCUMENTO_FATURA DF ON DF.CODIGO_DOCFAT = NF.LISTA_PEDIDOS_NF AND NF.LISTA_PEDIDOS_NF NOT LIKE '%/%'
    LEFT JOIN DOCUMENTO_COMISSAO DC ON DC.DOCUMENTO_DOCCOM = DF.CODIGO_DOCFAT AND DC.TIPOPESSOA_DOCCOM = 1 AND DC.PESSOA_DOCCOM IN (34994,35686,54773,52987,53019)
    LEFT JOIN PESSOA P ON P.CODIGO_PESSOA = DC.PESSOA_DOCCOM
    LEFT JOIN PESSOA P_CLIENTE ON P_CLIENTE.CODIGO_PESSOA = NF.PESSOA_NF
    LEFT JOIN DOCUMENTO_ITEM DI ON DI.DOCUMENTO_DOCITEM = DF.CODIGO_DOCFAT
    LEFT JOIN DOCUMENTO_ITEM_DETALHE DID ON DID.DOCUMENTO_DOCITEMDET = NF.LISTA_PEDIDOS_NF AND NF.LISTA_PEDIDOS_NF NOT LIKE '%/%'
WHERE                   
  EXTRACT(YEAR FROM NF.DATAEMISSAO_NF) = 2025 AND
  EXTRACT(MONTH FROM NF.DATAEMISSAO_NF) = 3 AND
  NF.TRANSACAO_NF IN (2,20,109,110,119,121,208,209,278,282,335,350,353) AND
  NF.TIPO_NF IN (2,3,5) AND
  NF.QUALIFICACAO_NF = 0 AND
  NF.ENTRADASAIDA_NF = 'S' AND
  NF.SITUACAO_NF NOT IN ('S', 'X', '2', '4') AND
  NF.EMPRESA_NF = 2
GROUP BY
  DC.PESSOA_DOCCOM,
  P.RAZAOSOCIAL_PESSOA,
  NF.PESSOA_NF,
  P_CLIENTE.RAZAOSOCIAL_PESSOA
)
SELECT
COD_SUPERVISOR,
NOME_SUPERVISOR,
VALOR_SUPERVISOR,
QTDE_CLIENTES,
CLIENTE,
NOME_CLIENTE,
VALOR_VENDIDO
FROM FATURAMENTO
WHERE RN <= 10
ORDER BY VALOR_SUPERVISOR, VALOR_VENDIDO DESC;


SELECT * FROM DOCUMENTO_ITEM_DETALHE DID;
SELECT * FROM LINHA;
SELECT * FROM DOCUMENTO_ITEM;

SELECT
  SUM(QTDEFATURADO_DOCITEMDET * VLRUNITARIOBRUTO_DOCITEMDET) AS TESTE,
  SUM(VLRTOTALLIQUIDO_DOCITEMDET) AS SOMA
FROM DOCUMENTO_FATURA DF
  --INNER JOIN DOCUMENTO_FATURA DF ON DF.CODIGO_DOCFAT = NF.LISTA_PEDIDOS_NF AND NF.LISTA_PEDIDOS_NF NOT LIKE ('%/%')
  INNER JOIN DOCUMENTO_ITEM DI ON DF.CODIGO_DOCFAT = DI.DOCUMENTO_DOCITEM
  INNER JOIN DOCUMENTO_ITEM_DETALHE DID ON DID.AUTOINCITEM_DOCITEMDET = DI.AUTOINC_DOCITEM 
WHERE
  EXTRACT(YEAR FROM DF.DTEMISSAO_DOCFAT) = 2025 AND
  EXTRACT(MONTH FROM DF.DTEMISSAO_DOCFAT) = 3 AND
  DF.CLASSIFICACAO_DOCFAT IN (1, 2, 5)
