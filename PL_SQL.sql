
--CABEZERAS


create or replace PACKAGE PK_GESTION_CLIENTES AS 

    --RF2 FUNCIONAL
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

        --RF3 FUNCIONAL
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

        
        --RF6 FUNCIONAL
       PROCEDURE AGREGARAUTORIZADO(PA_ID PERSONA_AUTORIZADA.ID%TYPE,
                        PA_IDENT PERSONA_AUTORIZADA.IDENTIFICACION%TYPE,
                        PA_NOMBRE PERSONA_AUTORIZADA.NOMBRE%TYPE,
                        PA_APELLIDOS PERSONA_AUTORIZADA.APELLIDOS%TYPE,
                        PA_DIR PERSONA_AUTORIZADA.DIRECCION%TYPE,
                        PA_FN PERSONA_AUTORIZADA.FECHA_NACIMIENTO%TYPE,
                        PA_ESTADO PERSONA_AUTORIZADA.ESTADO%TYPE,
                        E_ID EMPRESA.ID%TYPE,
                        AUTORIZACION_TIPO Autorizacion.TIPO%TYPE);

TIPO_AUTORIZACION_NO_VALIDO_EXCEPTION EXCEPTION;

--RF7 FUNCIONAL
        PROCEDURE MODIFICARAUTORIZADO(PA_ID PERSONA_AUTORIZADA.ID%TYPE,
                                PA_IDENT PERSONA_AUTORIZADA.IDENTIFICACION%TYPE,
                                PA_NOMBRE PERSONA_AUTORIZADA.NOMBRE%TYPE,
                                PA_APELLIDOS PERSONA_AUTORIZADA.APELLIDOS%TYPE,
                                PA_DIR PERSONA_AUTORIZADA.DIRECCION%TYPE,
                                PA_FN PERSONA_AUTORIZADA.FECHA_NACIMIENTO%TYPE,
                                PA_ESTADO PERSONA_AUTORIZADA.ESTADO%TYPE,
                                E_ID EMPRESA.ID%TYPE,
                                AUTORIZACION_TIPO AUTORIZACION.TIPO%TYPE);
NO_AUTORIZADOS_EXCEPTION EXCEPTION;

      --RF8 FUNCIONAL
      PROCEDURE BORRARAUTORIZADO(PA_ID PERSONA_AUTORIZADA.ID%TYPE,
                            AUTORIZACION_TIPO AUTORIZACION.TIPO%TYPE);

END PK_GESTION_CLIENTES;



--/****************************************************************************************************************************************************\

--CUERPOS

create or replace PACKAGE BODY PK_GESTION_CLIENTES AS

        --RF2 FUNCIONAL
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
  ID_CLIENTE CLIENTE.ID%TYPE;

  BEGIN
      
      SELECT COUNT(ID) INTO X FROM CLIENTE WHERE C_ID=ID;
      IF(X>0) THEN
        RAISE CLIENTE_EXISTENTE_EXCEPTION;
      END IF;
      
        ID_CLIENTE:=SQ_CLIENTE.NEXTVAL;
    
      INSERT INTO CLIENTE(ID, IDENTIFICACION, TIPO_CLIENTE, ESTADO, FECHA_ALTA, DIRECCION, CIUDAD, CODIGOPOSTAL, PAIS) VALUES(
                        ID_CLIENTE,C_IDENT,C_TIPO,C_ESTADO,C_FA, C_DIR, C_CIUDAD, C_POSTAL, C_PAIS);
      IF(C_TIPO='INDIVIDUAL') THEN
        INSERT INTO INDIVIDUAL(ID, NOMBRE, APELLIDO, FECHA_NACIMIENTO) VALUES(
                              ID_CLIENTE, I_NOMBRE, I_APELLIDO, I_FN);
      ELSIF(C_TIPO='EMPRESA') THEN
        INSERT INTO EMPRESA (ID, RAZON_SOCIAL) VALUES(
                             ID_CLIENTE, E_RAZON);
      ELSE
        RAISE CLIENTE_NO_VALIDO_EXCEPTION;
      END IF;
      
      COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
        --ROLLBACK;
        RAISE;

  END ALTACLIENTE;

        --RF3 FUNCIONAL
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
        --ROLLBACK;
        RAISE;

  END MODIFICACLIENTE;


--RF4
        PROCEDURE BAJACLIENTE(C_IDENT  CLIENTE.IDENTIFICACION%TYPE)AS
        
        N_CUENTAS INT;
        X INT;
        BEGIN
	    
            SELECT COUNT(IDENTIFICACION) INTO X FROM CLIENTE WHERE C_IDENT=IDENTIFICACION;
            IF(X=0) THEN
                RAISE CLIENTE_NO_EXISTENTE_EXCEPTION;
            END IF;
            
            SELECT COUNT(*) INTO N_CUENTAS 
             FROM CUENTA_FINTECH INNER JOIN CLIENTE
                ON (CUENTA_FINTECH.CLIENTE_ID = CLIENTE.ID)
                 WHERE CLIENTE.IDENTIFICACION = C_IDENT AND UPPER(CUENTA_FINTECH.ESTADO) != 'BAJA';
        
            IF (n_cuentas <= 0) THEN
                UPDATE cliente
                SET estado = 'BAJA',
                    fecha_baja = CURRENT_DATE
                WHERE CLIENTE.IDENTIFICACION = C_IDENT;
                
            END IF;
	    
	    COMMIT;
            
       EXCEPTION
    WHEN OTHERS THEN
        --ROLLBACK;
        RAISE;
        
      END BAJACLIENTE;

COMMIT;

  --RF6 FUNCIONAL
  PROCEDURE AGREGARAUTORIZADO(PA_ID PERSONA_AUTORIZADA.ID%TYPE,
                        PA_IDENT PERSONA_AUTORIZADA.IDENTIFICACION%TYPE,
                        PA_NOMBRE PERSONA_AUTORIZADA.NOMBRE%TYPE,
                        PA_APELLIDOS PERSONA_AUTORIZADA.APELLIDOS%TYPE,
                        PA_DIR PERSONA_AUTORIZADA.DIRECCION%TYPE,
                        PA_FN PERSONA_AUTORIZADA.FECHA_NACIMIENTO%TYPE,
                        PA_ESTADO PERSONA_AUTORIZADA.ESTADO%TYPE,
                        E_ID EMPRESA.ID%TYPE,
                        AUTORIZACION_TIPO Autorizacion.TIPO%TYPE)AS
    X_PA INT;
    X_AUT INT;
    ID_PA PERSONA_AUTORIZADA.ID%TYPE;
	BEGIN
		
		IF (AUTORIZACION_TIPO != 'CONSULTA' AND
            AUTORIZACION_TIPO != 'OPERACION') THEN
			RAISE TIPO_AUTORIZACION_NO_VALIDO_EXCEPTION;
		END IF;
        
		SELECT COUNT(*) INTO X_PA FROM PERSONA_AUTORIZADA
		 WHERE PERSONA_AUTORIZADA.IDENTIFICACION = PA_IDENT;

		IF (X_PA = 0) THEN
        
      ID_PA:= SQ_PERSONA.NEXTVAL;
            
			INSERT INTO PERSONA_AUTORIZADA(ID, IDENTIFICACION, NOMBRE, APELLIDOS, DIRECCION, FECHA_NACIMIENTO, FECHA_INICIO, ESTADO)
			VALUES ( ID_PA, PA_IDENT, PA_NOMBRE, PA_APELLIDOS, PA_DIR, PA_FN, CURRENT_DATE, PA_ESTADO);

			INSERT INTO AUTORIZACION(TIPO, PERSONA_ID, EMPRESA_ID) 
			VALUES (AUTORIZACION_TIPO, ID_PA, E_ID);
		ELSE
			SELECT COUNT(*) INTO X_AUT
			FROM AUTORIZACION
			WHERE PERSONA_ID = PA_ID 
                    AND EMPRESA_ID = E_ID;

			IF X_AUT != 0 THEN
				UPDATE AUTORIZACION
				SET TIPO = AUTORIZACION_TIPO;
			ELSE
				INSERT INTO AUTORIZACION(TIPO, PERSONA_ID, EMPRESA_ID)
				VALUES (AUTORIZACION_TIPO, PA_ID, E_ID);
			END IF;
		END IF;	
        COMMIT;
        
     EXCEPTION
    WHEN OTHERS THEN
        --ROLLBACK;
        RAISE;
    END AGREGARAUTORIZADO;

--RF7 FUNCIONAL
    PROCEDURE MODIFICARAUTORIZADO(PA_ID PERSONA_AUTORIZADA.ID%TYPE,
                                PA_IDENT PERSONA_AUTORIZADA.IDENTIFICACION%TYPE,
                                PA_NOMBRE PERSONA_AUTORIZADA.NOMBRE%TYPE,
                                PA_APELLIDOS PERSONA_AUTORIZADA.APELLIDOS%TYPE,
                                PA_DIR PERSONA_AUTORIZADA.DIRECCION%TYPE,
                                PA_FN PERSONA_AUTORIZADA.FECHA_NACIMIENTO%TYPE,
                                PA_ESTADO PERSONA_AUTORIZADA.ESTADO%TYPE,
                                E_ID EMPRESA.ID%TYPE,
                                AUTORIZACION_TIPO AUTORIZACION.TIPO%TYPE)AS
    
    X_PA NUMBER(3,0);
    X_AUT NUMBER(3,0);
    BEGIN
                                
      SELECT COUNT(*) INTO X_PA FROM PERSONA_AUTORIZADA
      WHERE PERSONA_AUTORIZADA.ID = PA_ID;
      IF(X_PA=0) THEN
          RAISE NO_AUTORIZADOS_EXCEPTION;
      END IF;
      SELECT COUNT(*) INTO X_AUT FROM AUTORIZACION
      WHERE AUTORIZACION.PERSONA_ID = PA_ID;
      IF(X_AUT=0) THEN
          RAISE NO_AUTORIZADOS_EXCEPTION;
      END IF;

      IF (AUTORIZACION_TIPO != 'CONSULTA' AND
            AUTORIZACION_TIPO != 'OPERACION') THEN
			  RAISE TIPO_AUTORIZACION_NO_VALIDO_EXCEPTION;
		  END IF;

      UPDATE PERSONA_AUTORIZADA SET NOMBRE=PA_NOMBRE,
          APELLIDOS=PA_APELLIDOS,
          DIRECCION=PA_DIR,
          FECHA_NACIMIENTO=PA_FN,
          ESTADO=PA_ESTADO
        WHERE PERSONA_AUTORIZADA.IDENTIFICACION = PA_IDENT;
      
      UPDATE AUTORIZACION SET TIPO = AUTORIZACION_TIPO
        WHERE AUTORIZACION.PERSONA_ID = PA_ID
          AND AUTORIZACION.EMPRESA_ID=E_ID;
      
    COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
        --ROLLBACK;
        RAISE;

    END MODIFICARAUTORIZADO;

      --RF8 FUNCIONAL
      PROCEDURE BORRARAUTORIZADO(PA_ID PERSONA_AUTORIZADA.ID%TYPE,
                            AUTORIZACION_TIPO AUTORIZACION.TIPO%TYPE)AS
      
      X NUMBER(3,0);             
      BEGIN
        

        IF (AUTORIZACION_TIPO != 'CONSULTA' AND
            AUTORIZACION_TIPO != 'OPERACION') THEN
			    RAISE TIPO_AUTORIZACION_NO_VALIDO_EXCEPTION;
		    END IF;

        SELECT COUNT(*) INTO X FROM AUTORIZACION WHERE AUTORIZACION.PERSONA_ID=PA_ID;
      
        IF (X=0) THEN
      
          INSERT INTO PERSONA_AUTORIZADA(ESTADO) VALUES ('BORRADO');
          INSERT INTO PERSONA_AUTORIZADA(FECHA_FIN) VALUES (CURRENT_DATE);
      
        ELSE
          DELETE FROM AUTORIZACION WHERE AUTORIZACION.PERSONA_ID=PA_ID
                                    AND AUTORIZACION.TIPO=AUTORIZACION_TIPO;

        END IF;
        
	COMMIT;
      
      END BORRARAUTORIZADO;    

END PK_GESTION_CLIENTES;












-- =========================OPCIONAL===================
-- 4. AUDITORÍAS
AUDIT ALL ON FINTECH.TRANSACCION;
AUDIT ALL ON FINTECH.MOVIMIENTO;

AUDIT UPDATE, INSERT, DELETE ON FINTECH.DEPOSITADA_EN;
AUDIT UPDATE, INSERT, DELETE ON FINTECH.CUENTA_REFERENCIA;

---- DESDE SYSTEM --
--Muestra la auditoría estándar:
SELECT * FROM SYS.DBA_AUDIT_TRAIL;

--Información relativa a la auditoría de los inicios de sesión de los usuarios
SELECT * FROM SYS.DBA_AUDIT_SESSION;

-- Ver que la auditoría AUDIT_TRAIL está activa:
SELECT name, value
FROM v$parameter
WHERE NAME LIKE 'audit_trail';
-- ====FIN AUDITORÍAS====

