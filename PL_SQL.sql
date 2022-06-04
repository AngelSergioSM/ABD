
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

  
  
  
  
  
  END ALTACLIENTE;

END PK_GESTION_CLIENTES;