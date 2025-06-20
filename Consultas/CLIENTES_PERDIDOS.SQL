WITH ULTIMA_COMPRA (COD_SUP, NOME_SUP, COD_CONS, NOME_CONS, CLIENTE, TIPO, NOME, TEL, REGIAO, ULTIMA, DIAS, VALOR, MEDIA, VENDAS) AS (
SELECT
    DC_SUP.PESSOA_DOCCOM AS COD_SUP,
    P_SUP.RAZAOSOCIAL_PESSOA AS NOME_SUP,
    DC_CONS.PESSOA_DOCCOM AS COD_CONS,
    P_CONS.RAZAOSOCIAL_PESSOA AS NOME_CONS,
    DF.CLIENTE_DOCFAT AS CLIENTE,
    P.TIPO_PESSOA AS TIPO,
    P.RAZAOSOCIAL_PESSOA AS NOME,
    MAX(PT.TELEFONE_PESSOA_TEL) AS TEL,
    R.DESCRICAO_REGIAO AS REGIAO,
    MAX(NF.DATAEMISSAO_NF) AS ULTIMA,
    CURRENT_DATE - CAST(MAX(NF.DATAEMISSAO_NF) AS DATE) AS DIAS,
    SUM(NF.VALORTOTAL_NF) AS VALOR,
    AVG(NF.VALORTOTAL_NF) AS MEDIA,
    COUNT(NF.AUTOINC_NF) AS VENDAS
FROM NOTA_FISCAL NF
    INNER JOIN DOCUMENTO_FATURA DF ON DF.CODIGO_DOCFAT = NF.LISTA_PEDIDOS_NF AND NF.LISTA_PEDIDOS_NF NOT LIKE '%/%'
    INNER JOIN PESSOA P ON P.CODIGO_PESSOA = DF.CLIENTE_DOCFAT
    INNER JOIN PESSOA_ENDERECO PE ON PE.AUTOINC_PESSOA_END = NF.ENDERECO_NF
    INNER JOIN REGIAO R ON R.CODIGO_REGIAO = PE.REGIAO_PESSOA_END
    LEFT JOIN (
        SELECT T1.PESSOA_PESSOA_TEL, T1.TELEFONE_PESSOA_TEL
        FROM PESSOA_TELEFONE T1
        WHERE T1.DATAHORAINCLUSAO_PESSOA_TEL = (
            SELECT MAX(T2.DATAHORAINCLUSAO_PESSOA_TEL)
            FROM PESSOA_TELEFONE T2
            WHERE T2.PESSOA_PESSOA_TEL = T1.PESSOA_PESSOA_TEL
        )
    ) PT ON PT.PESSOA_PESSOA_TEL = P.CODIGO_PESSOA
    LEFT JOIN DOCUMENTO_COMISSAO DC_SUP ON (DC_SUP.DOCUMENTO_DOCCOM = DF.CODIGO_DOCFAT) AND DC_SUP.TIPOPESSOA_DOCCOM = 1 AND DC_SUP.PRINCIPAL_DOCCOM = 'S' AND DC_SUP.PESSOA_DOCCOM NOT IN (53019)
    LEFT JOIN PESSOA P_SUP ON P_SUP.CODIGO_PESSOA = DC_SUP.PESSOA_DOCCOM
    LEFT JOIN DOCUMENTO_COMISSAO DC_CONS ON (DC_CONS.DOCUMENTO_DOCCOM = DF.CODIGO_DOCFAT) AND DC_CONS.TIPOPESSOA_DOCCOM = 0 AND DC_CONS.PRINCIPAL_DOCCOM = 'S' AND DC_CONS.PESSOA_DOCCOM NOT IN (40670)
    LEFT JOIN PESSOA P_CONS ON P_CONS.CODIGO_PESSOA = DC_CONS.PESSOA_DOCCOM
WHERE 
    NF.TRANSACAO_NF IN (2,20,110,119,121,350) AND
    DF.CLASSIFICACAO_DOCFAT = 1 AND
    P.TIPO_PESSOA = 'J' AND
    NF.DATAEMISSAO_NF BETWEEN Filtro(2, 0) AND CURRENT_DATE AND
    Filtro(5,'DC_SUP.PESSOA_DOCCOM') AND
    Filtro(6,'DC_CONS.PESSOA_DOCCOM')
GROUP BY
    DC_SUP.PESSOA_DOCCOM,
    P_SUP.RAZAOSOCIAL_PESSOA,
    DC_CONS.PESSOA_DOCCOM,
    P_CONS.RAZAOSOCIAL_PESSOA,
    DF.CLIENTE_DOCFAT,
    R.DESCRICAO_REGIAO,
    P.TIPO_PESSOA,
    P.RAZAOSOCIAL_PESSOA
   -- PT.TELEFONE_PESSOA_TEL
)
SELECT
    COD_SUP,
    NOME_SUP,
    COD_CONS,
    NOME_CONS, 
    CLIENTE,
    NOME,
    REGIAO,
    TEL,
    ULTIMA, 
    DIAS,
    VALOR,
    MEDIA,
    VENDAS,
    SUM(CASE WHEN DIAS >= Filtro(4) THEN 1 ELSE 0 END) OVER() AS CONTA
FROM ULTIMA_COMPRA
WHERE DIAS >= Filtro(4)
