CREATE TABLE aplazado (
    id_unico     VARCHAR2(30) NOT NULL,
    mensualidad  DATE
); -- AQUI HAY CAMBIOS RESPECTO EL DRIVE

ALTER TABLE aplazado ADD CONSTRAINT aplazado_pk PRIMARY KEY ( id_unico ) USING INDEX TABLESPACE TS_INDICES;


CREATE TABLE persona_autorizada (
    id               VARCHAR2(20) NOT NULL,
    identificacion   VARCHAR2(20) NOT NULL,
    nombre           VARCHAR2(20) NOT NULL,
    apellidos        VARCHAR2(20) NOT NULL,
    direccion        VARCHAR2(30) NOT NULL,
    fecha_nacimiento DATE,
    fecha_inicio     DATE,
    estado           VARCHAR2(20),
    fecha_fin        DATE
);


CREATE TABLE cliente (
    id              VARCHAR2(30) NOT NULL,
    identificacion  VARCHAR2(40) NOT NULL,
    tipo_cliente    VARCHAR2(10) NOT NULL,
    estado          VARCHAR2(10) NOT NULL,
    fecha_alta      DATE NOT NULL,
    fecha_baja      DATE,
    direccion      VARCHAR2(20) NOT NULL,
    ciudad          VARCHAR2(20) NOT NULL,
    codigopostal    INTEGER NOT NULL,
    pais            VARCHAR2(20) NOT NULL
); -- AQUI HAY CAMBIOS RESPECTO EL DRIVE

ALTER TABLE cliente ADD CONSTRAINT cliente_pk PRIMARY KEY ( id ) USING INDEX TABLESPACE TS_INDICES;

ALTER TABLE cliente ADD CONSTRAINT cliente_identificacion_un UNIQUE ( identificacion ) USING INDEX TABLESPACE TS_INDICES;


CREATE TABLE cuenta (
    iban   VARCHAR2(25) NOT NULL, -- AQUI HAY CAMBIOS. LE HE SUBIDO LONGITUD IBAN
    swift  VARCHAR2(20)
);

ALTER TABLE cuenta ADD CONSTRAINT cuenta_pk PRIMARY KEY ( iban ) USING INDEX TABLESPACE TS_INDICES;

CREATE TABLE cuenta_fintech (
    iban            VARCHAR2(25) NOT NULL, -- CAMBIOS
    estado          VARCHAR2(20) NOT NULL,
    fecha_apertura  DATE NOT NULL,
    fecha_cierre    DATE,
    clasificacion   VARCHAR2(10),
    cliente_id      VARCHAR2(30) NOT NULL -- Para la relacion Many2One
);

ALTER TABLE cuenta_fintech ADD CONSTRAINT cuenta_fintech_pk PRIMARY KEY ( iban ) USING INDEX TABLESPACE TS_INDICES;

-- ESTA TABLA???
CREATE TABLE cuenta_referencia (
    iban                VARCHAR2(25) NOT NULL, -- CAMBIOS
    nombrebanco         VARCHAR2(10) NOT NULL,
    sucursal            VARCHAR2(15),
    pais                VARCHAR2(20),
    saldo               NUMBER(20, 6) NOT NULL, -- CAMBIADO. NO TENIA SENTIDO
    fecha_apertura      DATE,
    estado              VARCHAR2(20),
    divisa_abreviatura  VARCHAR2(10) NOT NULL -- Para la relación Many2One
);

ALTER TABLE cuenta_referencia ADD CONSTRAINT cuenta_referencia_pk PRIMARY KEY ( iban ) USING INDEX TABLESPACE TS_INDICES;

CREATE TABLE depositada_en (
    saldo                   NUMBER(20, 6) NOT NULL, -- CAMBIADO. MAS PRECISION
    cuenta_referencia_iban  VARCHAR2(25) NOT NULL, -- CAMBIADO
    pooled_account_iban      VARCHAR2(25) NOT NULL -- CAMBIADO
);

CREATE TABLE divisa (
    abreviatura  VARCHAR2(10) NOT NULL,
    nombre       VARCHAR2(30) NOT NULL, -- CAMBIADO
    simbolo      VARCHAR2(5 CHAR), -- CAMBIADO
    cambioeuro   NUMBER(30, 25) NOT NULL
);                                                                    


ALTER TABLE divisa ADD CONSTRAINT divisa_pk PRIMARY KEY ( abreviatura ) USING INDEX TABLESPACE TS_INDICES;

CREATE TABLE empresa (
    id            VARCHAR2(30) NOT NULL,
    razon_social  VARCHAR2(50) NOT NULL
);

ALTER TABLE empresa ADD CONSTRAINT empresa_pk PRIMARY KEY ( id ) USING INDEX TABLESPACE TS_INDICES;

CREATE TABLE individual (
    id                VARCHAR2(30) NOT NULL,
    nombre            VARCHAR2(20) NOT NULL,
    apellido          VARCHAR2(30) NOT NULL,
    fecha_nacimiento  DATE
);

ALTER TABLE individual ADD CONSTRAINT individual_pk PRIMARY KEY ( id ) USING INDEX TABLESPACE TS_INDICES;

-- Aqui estamos jugando con fuego
CREATE TABLE pago_credito_debito (
    id_unico             VARCHAR2(30) NOT NULL,
    periodo_liquidacion  DATE,
    "dia_cobro/abono"    DATE,
    interes              NUMBER(3),
    modo_operacion       VARCHAR2(20) NOT NULL,
    emisor_fisico        BLOB NOT NULL,
    emisor_online        BLOB NOT NULL
);

ALTER TABLE pago_credito_debito ADD CONSTRAINT pago_credito_debito_pk PRIMARY KEY ( id_unico ) USING INDEX TABLESPACE TS_INDICES;

CREATE TABLE pooled_account (
    iban VARCHAR2(25) NOT NULL -- CAMBIADO
);

ALTER TABLE pooled_account ADD CONSTRAINT pooled_account_pk PRIMARY KEY ( iban ) USING INDEX TABLESPACE TS_INDICES;

CREATE TABLE segregada (
    iban                    VARCHAR2(25) NOT NULL, -- CAMBIADO
    comision                NUMBER(9, 3),
    cuenta_referencia_iban  VARCHAR2(25) NOT NULL -- CAMBIADO
);

-- ?
-- CREATE UNIQUE INDEX segregada__idx ON segregada ( ASC(cuenta_referencia_iban)  ) USING INDEX TABLESPACE TS_INDICES;

-- NOMBRE CAMBIADO A SINGULAR
CREATE TABLE tarjeta_credito (
    num_tarjeta       NUMBER(16) NOT NULL, -- CAMBIADO
    cvc               NUMBER(3) NOT NULL,
    fecha_caducidad   DATE NOT NULL,
    nom_propietario   VARCHAR2(20) NOT NULL,
    fecha_activacion  DATE NOT NULL,
    cuenta_iban       VARCHAR2(25) NOT NULL, -- CAMBIADO
    modo_default      VARCHAR2(15) NOT NULL,
    limite_fisico     NUMBER(5) NOT NULL, -- CAMBIADO DE 4 A 5
    limite_online     NUMBER(5) NOT NULL, -- CAMBIADO DE 4 A 5
    limite_cajero     NUMBER(5) NOT NULL, -- CAMBIADO DE 4 A 5
    cliente_id        VARCHAR2(30) NOT NULL,
    cuenta_id         VARCHAR2(25) NOT NULL
);

ALTER TABLE tarjeta_credito ADD CONSTRAINT tarjeta_credito_pk PRIMARY KEY (num_tarjeta) USING INDEX TABLESPACE TS_INDICES;

CREATE TABLE transaccion (
    id_unico                      VARCHAR2(30) NOT NULL,
    fechainstruccion              DATE NOT NULL,
    cantidad                      INTEGER NOT NULL,
    fechaejecucion                DATE,
    tipo                          VARCHAR2(15) NOT NULL, -- REDUCIDO DE 50 A 15 (CARGO O INGRESO)
    comision                      NUMBER(6, 3), -- CAMBIADO
    internacional                 BLOB,
    cuenta_iban1                  VARCHAR2(25) NOT NULL, -- CAMBIADO.( SERIA MEJOR iban_destino y iban_origen)
    cuenta_iban                   VARCHAR2(25) NOT NULL, -- CAMBIADO
    divisa_abreviatura            VARCHAR2(10) NOT NULL,
    divisa_abreviatura1           VARCHAR2(10) NOT NULL,
    tarjeta_credito_num_tarjeta  NUMBER(16) NOT NULL, -- CAMBIADO
    tarjeta_credito_cuenta_iban  VARCHAR2(25) NOT NULL -- CAMBIADO
);

ALTER TABLE transaccion ADD CONSTRAINT transaccion_pk PRIMARY KEY ( id_unico ) USING INDEX TABLESPACE TS_INDICES;

CREATE TABLE autorizacion (
    tipo        INTEGER NOT NULL,
    id          INTEGER NOT NULL,
    empresa_id  VARCHAR2(30) NOT NULL
);

ALTER TABLE autorizacion ADD CONSTRAINT autorización_pk PRIMARY KEY ( id);


CREATE TABLE movimientos (
    id                  VARCHAR2(20) NOT NULL,
    num_tarjeta         NUMBER(16,0) NOT NULL,
    divisa              VARCHAR2(20) NOT NULL,   
    fecha               DATE NOT NULL,
    cantidad            NUMBER(9,0),
    estado              VARCHAR2(20) NOT NULL,
    metodo                VARCHAR2(20),
    patron                VARCHAR2(20)
)

ALTER TABLE movimiento ADD CONSTRAINT movimientos_pk PRIMARY KEY ( id );

-----------------------------------------------------------------------------------------------------------



ALTER TABLE movimiento
    ADD CONSTRAINT tarjeta_fk FOREIGN KEY ( num_tarjeta )
        REFERENCES tarjeta ( num_tarjeta )
    NOT DEFERRABLE;


ALTER TABLE movimiento
    ADD CONSTRAINT divisa_fk FOREIGN KEY ( divisa )
        REFERENCES divisa ( abreviatura )
    NOT DEFERRABLE;

ALTER TABLE aplazado
    ADD CONSTRAINT aplazado_pago_credito_debito_fk FOREIGN KEY ( id_unico )
        REFERENCES pago_credito_debito ( id_unico );

ALTER TABLE autorizacion
    ADD CONSTRAINT autorización_empresa_fk FOREIGN KEY ( empresa_id )
        REFERENCES empresa ( id )
    NOT DEFERRABLE;

ALTER TABLE autorizacion
    ADD CONSTRAINT autorizacion_persona_fk FOREIGN KEY ( persona_id )
        REFERENCES persona_autorizada ( id )
    NOT DEFERRABLE;


ALTER TABLE cuenta_fintech
    ADD CONSTRAINT cuenta_fintech_cliente_fk FOREIGN KEY ( cliente_id )
        REFERENCES cliente ( id )
    NOT DEFERRABLE;

ALTER TABLE cuenta_fintech
    ADD CONSTRAINT cuenta_fintech_cuenta_fk FOREIGN KEY ( iban )
        REFERENCES cuenta ( iban )
    NOT DEFERRABLE;

ALTER TABLE cuenta_referencia
    ADD CONSTRAINT cuenta_referencia_cuenta_fk FOREIGN KEY ( iban )
        REFERENCES cuenta ( iban )
    NOT DEFERRABLE;

ALTER TABLE cuenta_referencia
    ADD CONSTRAINT cuenta_referencia_divisa_fk FOREIGN KEY ( divisa_abreviatura )
        REFERENCES divisa ( abreviatura )
    NOT DEFERRABLE;

 
ALTER TABLE depositada_en
    ADD CONSTRAINT depositada_en_cuenta_referencia_fk FOREIGN KEY ( cuenta_referencia_iban )
        REFERENCES cuenta_referencia ( iban )
    NOT DEFERRABLE;


ALTER TABLE depositada_en
    ADD CONSTRAINT depositada_en_pooled_account_fk FOREIGN KEY ( pooled_account_iban )
        REFERENCES pooled_account ( iban )
    NOT DEFERRABLE;

ALTER TABLE empresa
    ADD CONSTRAINT empresa_cliente_fk FOREIGN KEY ( id )
        REFERENCES cliente ( id )
    NOT DEFERRABLE;

ALTER TABLE individual
    ADD CONSTRAINT individual_cliente_fk FOREIGN KEY ( id )
        REFERENCES cliente ( id )
    NOT DEFERRABLE;
 
ALTER TABLE pago_credito_debito
    ADD CONSTRAINT pago_credito_debito_transaccion_fk FOREIGN KEY ( id_unico )
        REFERENCES transaccion ( id_unico );

 
ALTER TABLE pooled_account
    ADD CONSTRAINT pooled_account_cuenta_fintech_fk FOREIGN KEY ( iban )
        REFERENCES cuenta_fintech ( iban )
    NOT DEFERRABLE;

ALTER TABLE segregada
    ADD CONSTRAINT segregada_cuenta_fintech_fk FOREIGN KEY ( iban )
        REFERENCES cuenta_fintech ( iban )
    NOT DEFERRABLE;

ALTER TABLE segregada
    ADD CONSTRAINT segregada_cuenta_referencia_fk FOREIGN KEY ( cuenta_referencia_iban )
        REFERENCES cuenta_referencia ( iban )
    NOT DEFERRABLE;

ALTER TABLE tarjeta_credito
    ADD CONSTRAINT tarjeta_credito_cuenta_fk FOREIGN KEY ( cuenta_iban )
        REFERENCES cuenta ( iban )
    NOT DEFERRABLE;

ALTER TABLE tarjeta_credito
    ADD CONSTRAINT tarjetas_cuenta_fk FOREIGN KEY ( cuenta_id )
        REFERENCES cuenta ( iban )
    NOT DEFERRABLE;

ALTER TABLE transaccion
    ADD CONSTRAINT transaccion_cuenta_fk1 FOREIGN KEY ( cuenta_iban )
        REFERENCES cuenta ( iban )
    NOT DEFERRABLE;

ALTER TABLE transaccion
    ADD CONSTRAINT transaccion_cuenta_fk2 FOREIGN KEY ( cuenta_iban1 )
        REFERENCES cuenta ( iban )
    NOT DEFERRABLE;

ALTER TABLE transaccion
    ADD CONSTRAINT transaccion_divisa_fk1 FOREIGN KEY ( divisa_abreviatura )
        REFERENCES divisa ( abreviatura )
    NOT DEFERRABLE;

ALTER TABLE transaccion
    ADD CONSTRAINT transaccion_divisa_fk2 FOREIGN KEY ( divisa_abreviatura1 )
        REFERENCES divisa ( abreviatura )
    NOT DEFERRABLE;

ALTER TABLE transaccion
    ADD CONSTRAINT transaccion_tarjeta_credito_fk FOREIGN KEY ( tarjeta_credito_num_tarjeta)
        REFERENCES tarjeta_credito ( num_tarjeta);