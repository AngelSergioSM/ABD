--RF5
-- Abrir cuenta POOLED o SEGREGADA
-- Si un cliente esta de baja: falla

-- PROCEDURE ABRIRCUENTA(
--            CU_IBAN             CUENTA.IBAN%TYPE,                     --OBLIGATORIO
--            CU_SWIFT            CUENTA.SWIFT%TYPE,                    --OPCIONAL
--            CU_TIPO             CUENTA_FINTECH.CLASIFICACION%TYPE,    --OBLIGATORIO
--            CU_CLAS             CUENTA_FINTECH.CLASIFICACION%TYPE,    --OPCIONAL. ?
--            CU_COMISION         SEGREGADA.COMISION%TYPE,              --OPCIONAL 
--            ID_CLIENTE          CLIENTE.ID%TYPE,                      --OBLIGATORIO
--            CREF_IBAN           CUENTA.IBAN%TYPE                      --OBLIGATORIO SI ES SEGREGADA
--    );

-- TIENEN QUE FUNCIONAR:
EXECUTE PK_GESTION_CUENTAS.ABRIRCUENTA('IBANDUMMY1','SWIFT1', 'SEGREGADA', 'CLASIF', '1', '1', 'ES32 1226 347 77987');
select * from SEGREGADA inner join cuenta_fintech on (segregada.iban = cuenta_fintech.iban)
    where segregada.iban = 'IBANDUMMY1';

EXECUTE PK_GESTION_CUENTAS.ABRIRCUENTA('IBANDUMMY2','SWIFT1', 'SEGREGADA', 'CLASIF', NULL, '1', 'ES32 1226 347 77987');
select * from SEGREGADA inner join cuenta_fintech on (segregada.iban = cuenta_fintech.iban)
    where segregada.iban = 'IBANDUMMY2';

EXECUTE PK_GESTION_CUENTAS.ABRIRCUENTA('IBANDUMMY3','SWIFT1', 'POOLED', 'CLASIF', '2', '1', NULL);
select * from pooled_account inner join cuenta_fintech on (pooled_account.iban = cuenta_fintech.iban)
    where pooled_account.iban = 'IBANDUMMY3';


-- TIENEN QUE FALLAR:
-- Cliente ID 2 esta de BAJA:
EXECUTE PK_GESTION_CUENTAS.ABRIRCUENTA('IBANDUMMY','SWIFT1', 'SEGREGADA', 'CLASIF', NULL, '2', 'ES32 1226 347 77987');

-- CREF_IBAN obligatorio si es SEGREGADA:
EXECUTE PK_GESTION_CUENTAS.ABRIRCUENTA('IBANDUMMY','SWIFT1', 'SEGREGADA', 'CLASIF', NULL, '2', NULL);

-- Tipo SEGREG incorrecto:
EXECUTE PK_GESTION_CUENTAS.ABRIRCUENTA('IBANDUMMY','SWIFT1', 'SEGREG', 'CLASIF', NULL, '2', NULL);