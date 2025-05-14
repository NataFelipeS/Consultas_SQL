-- Encontre os nomes e e-mails dos 50 primeiros clientes com base na data de criação da conta.


SELECT TOP 50 
    PP.FIRSTNAME, 
    PP.LASTNAME, 
    PE.EMAILADDRESS
FROM PERSON.PERSON PP
INNER JOIN PERSON.EMAILADDRESS PE ON PE.BUSINESSENTITYID = PP.BUSINESSENTITYID
ORDER BY PP.ModifiedDate DESC;
