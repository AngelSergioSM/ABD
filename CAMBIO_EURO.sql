CREATE OR REPLACE PROCEDURE CAMBIO_EURO IS

ABREVIATURAV DIVISA.ABREVIATURA%TYPE;
CAMBIO DIVISA.CAMBIOEURO%TYPE;
BEGIN
    SELECT CAMBIOEURO INTO CAMBIO FROM V_COTIZACIONES;
    SELECT ABREVIATURA INTO ABREVIATURAV FROM V_COTIZACIONES;
    UPDATE DIVISA SET DIVISA.CAMBIOEURO = CAMBIO
        WHERE DIVISA.ABREVIATURA = ABREVIATURAV;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
            
END CAMBIO_EURO;

BEGIN
DBMS_SCHEDULER.CREATE_JOB(
    job_name            => 'J_CAMBIO_EURO',
    job_type            => 'PLSQL_BLOCK',
    job_action          => 'CAMBIO_EURO;',
    start_date          =>  SYSDATE,
    repeat_interval     =>  'FREQ=DAILY;BYHOUR=0;BYMINUTE=5' ,
    end_date            => null,
    enabled             => TRUE,
    comments            => 'Actualiza el atributo CambioEuro con el valor de V_COTIZACIONES a las 00:05 de cada día.'
);
END;