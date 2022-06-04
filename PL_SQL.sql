
--CABEZERAS


create or replace PACKAGE PK_GESTION_CLIENTES AS 

    --RF2
    PROCEDURE ALTACLIENTE(C_ID  CLIENTE.ID%TYPE,
                        C_IDENT CLIENTE.IDENTIFICACION%TYPE,
                        C_TIPO CLIENTE.TIPO_CLIENTE%TYPE,
                        C_ESTADO CLIENTE.ESTADO%TYPE,
                        C_FA CLIENTE.FECHA_ALTA%TYPE,
                        C_DIR CLIENTE.DIRECCION%TYPE,
                        C_CIUDAD CLIENTE.CIUDAD%TYPE,
                        C_POSTAL CLIENTE.CODIGOPOSTAL%TYPE,
                        C_PAIS CLIENTE.PAIS%TYPE,
                        E_RAZON EMPRESA.RAZON_SOCIAL%TYPE,
                        I_NOMBRE INDIVIDUAL.NOMBRE%TYPE,
                        I_APELLIDO INDIVIDUAL.APELLIDO%TYPE,
                        I_FN INDIVIDUAL.FECHA_NACIMIENTO%TYPE);

CLIENTE_EXISTENTE_EXCEPTION EXCEPTION;
CLIENTE_NO_VALIDO_EXCEPTION EXCEPTION;

        --RF3
        PROCEDURE MODIFICACLIENTE(C_ID  CLIENTE.ID%TYPE,
                        C_IDENT CLIENTE.IDENTIFICACION%TYPE,
                        C_TIPO CLIENTE.TIPO_CLIENTE%TYPE,
                        C_ESTADO CLIENTE.ESTADO%TYPE,
                        C_FA CLIENTE.FECHA_ALTA%TYPE,
                        C_DIR CLIENTE.DIRECCION%TYPE,
                        C_CIUDAD CLIENTE.CIUDAD%TYPE,
                        C_POSTAL CLIENTE.CODIGOPOSTAL%TYPE,
                        C_PAIS CLIENTE.PAIS%TYPE,
                        E_RAZON EMPRESA.RAZON_SOCIAL%TYPE,
                        I_NOMBRE INDIVIDUAL.NOMBRE%TYPE,
                        I_APELLIDO INDIVIDUAL.APELLIDO%TYPE,
                        I_FN INDIVIDUAL.FECHA_NACIMIENTO%TYPE);

CLIENTE_NO_EXISTENTE_EXCEPTION EXCEPTION;


        --RF4
        PROCEDURE BAJACLIENTE(C_IDENT  CLIENTE.IDENTIFICACION%TYPE);






END PK_GESTION_CLIENTES;



--/****************************************************************************************************************************************************\

--CUERPOS

create or replace PACKAGE BODY PK_GESTION_CLIENTES AS

        --RF2
        PROCEDURE ALTACLIENTE(C_ID  CLIENTE.ID%TYPE,
                              C_IDENT CLIENTE.IDENTIFICACION%TYPE,
                              C_TIPO CLIENTE.TIPO_CLIENTE%TYPE,
                              C_ESTADO CLIENTE.ESTADO%TYPE,
                              C_FA CLIENTE.FECHA_ALTA%TYPE,
                              C_DIR CLIENTE.DIRECCION%TYPE,
                              C_CIUDAD CLIENTE.CIUDAD%TYPE,
                              C_POSTAL CLIENTE.CODIGOPOSTAL%TYPE,
                              C_PAIS CLIENTE.PAIS%TYPE,
                              E_RAZON EMPRESA.RAZON_SOCIAL%TYPE,
                              I_NOMBRE INDIVIDUAL.NOMBRE%TYPE,
                              I_APELLIDO INDIVIDUAL.APELLIDO%TYPE,
                              I_FN INDIVIDUAL.FECHA_NACIMIENTO%TYPE) AS
    X NUMBER(3,0);

  BEGIN
      SELECT COUNT(ID) INTO X FROM CLIENTE WHERE C_ID=ID;
      IF(X>0) THEN
        RAISE CLIENTE_EXISTENTE_EXCEPTION;
      END IF;
      

      
      INSERT INTO CLIENTE(ID, IDENTIFICACION, TIPO_CLIENTE, ESTADO, FECHA_ALTA, DIRECCION, CIUDAD, CODIGOPOSTAL, PAIS) VALUES(
                        C_ID,C_IDENT,C_TIPO,C_ESTADO,C_FA, C_DIR, C_CIUDAD, C_POSTAL, C_PAIS);
      IF(C_TIPO='INDIVIDUAL') THEN
        INSERT INTO INDIVIDUAL(ID, NOMBRE, APELLIDO, FECHA_NACIMIENTO) VALUES(
                               C_ID, I_NOMBRE, I_APELLIDO, I_FN);
      ELSIF(C_TIPO='EMPRESA') THEN
        INSERT INTO EMPRESA (ID, RAZON_SOCIAL) VALUES(
                             C_ID, E_RAZON);
      ELSE
        RAISE CLIENTE_NO_VALIDO_EXCEPTION;
      END IF;
      
      COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        --RAISE;

  END ALTACLIENTE;

        --RF3
        PROCEDURE MODIFICACLIENTE(C_ID  CLIENTE.ID%TYPE,
                        C_IDENT CLIENTE.IDENTIFICACION%TYPE,
                        C_TIPO CLIENTE.TIPO_CLIENTE%TYPE,
                        C_ESTADO CLIENTE.ESTADO%TYPE,
                        C_FA CLIENTE.FECHA_ALTA%TYPE,
                        C_DIR CLIENTE.DIRECCION%TYPE,
                        C_CIUDAD CLIENTE.CIUDAD%TYPE,
                        C_POSTAL CLIENTE.CODIGOPOSTAL%TYPE,
                        C_PAIS CLIENTE.PAIS%TYPE,
                        E_RAZON EMPRESA.RAZON_SOCIAL%TYPE,
                        I_NOMBRE INDIVIDUAL.NOMBRE%TYPE,
                        I_APELLIDO INDIVIDUAL.APELLIDO%TYPE,
                        I_FN INDIVIDUAL.FECHA_NACIMIENTO%TYPE)AS
    X INT;

  BEGIN
       SELECT COUNT(ID) INTO X FROM CLIENTE WHERE C_ID=ID;
      IF(X<=0) THEN
        RAISE CLIENTE_NO_EXISTENTE_EXCEPTION;
      END IF;
    	UPDATE CLIENTE SET ID = C_ID,
                IDENTIFICACION=C_IDENT,
            	TIPO_CLIENTE = C_TIPO,
            	ESTADO = C_ESTADO,
            	FECHA_ALTA = C_FA,
            	DIRECCION = C_DIR,
            	CIUDAD = C_CIUDAD,
            	CODIGOPOSTAL = C_POSTAL,
            	PAIS = C_PAIS
    	WHERE CLIENTE.ID = C_ID;
   	 
     
        IF(C_TIPO='INDIVIDUAL') THEN
            UPDATE INDIVIDUAL
        	SET ID = C_ID,
                	NOMBRE = I_NOMBRE,
                	APELLIDO = I_APELLIDO,
                	FECHA_NACIMIENTO = I_FN
        	WHERE INDIVIDUAL.ID = C_ID;
            
        ELSIF(C_TIPO='EMPRESA') THEN
        	UPDATE EMPRESA
        	SET ID = C_ID,
                	RAZON_SOCIAL = E_RAZON
        	WHERE EMPRESA.ID = C_ID;
            
    	ELSE
        	RAISE TIPO_NO_VALIDO_EXCEPTION;
            
        END IF;
        
        COMMIT; 
    
   EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;

  END MODIFICACLIENTE;

END PK_GESTION_CLIENTES;

--RF4
        PROCEDURE BAJACLIENTE(C_IDENT  CLIENTE.IDENTIFICACION%TYPE)AS
        
        n_cuentas INT;
        X INT;
        BEGIN
            SELECT COUNT(IDENTIFICACION) INTO X FROM CLIENTE WHERE C_IDENT=IDENTIFICACION;
            IF(X<=0) THEN
                RAISE CLIENTE_NO_EXISTENTE_EXCEPTION;
            END IF;
            
            SELECT COUNT(*) INTO n_cuentas 
             FROM cuenta_fintech INNER JOIN cliente 
                ON (cuenta_fintech.cliente_id = CLIENTE.id)
                 WHERE cliente.identificacion = C_IDENT AND UPPER(cuenta_fintech.estado) != 'BAJA';
        
            IF (n_cuentas >= 0) THEN
                UPDATE cliente
                SET estado = 'BAJA',
                    fecha_baja = CURRENT_DATE
                WHERE CLIENTE.IDENTIFICACION = C_IDENT;
                
            END IF;
            
       EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
        
      END BAJACLIENTE;


































END PK_GESTION_CLIENTES;