-- Indices de claves primarias hechos en NivelFisico

-- Indices en TS_INDICES

--CREATE INDEX <nombre indice> ON <TABLA>(<ATRIBUTO>)

-- Si la cardinalidad de la columna es baja:
--CREATE BITMAP INDEX <nombre indice> ON <TABLA>(<ATRIBUTO>)

-- Indice sobre valores unicos:
--CREATE UNIQUE INDEX <nombre indice> ON <TABLA>(<ATRIBUTO>)

--Pocos valores y de lectura recurrente
CREATE BITMAP INDEX estado_cuenta_idx 
    ON CUENTA_FINTECH(ESTADO) TABLESPACE TS_INDICES;

-- Indice sobre las identificaciones de personas autorizadas
-- Uso frecuente, cambiara poco y son unicos.
CREATE UNIQUE INDEX pa_identificacion_idx 
    ON PERSONA_AUTORIZADA(IDENTIFICACION) TABLESPACE TS_INDICES;

-- CLIENTE.IDENTIFICACION ya esta indexado en nivel fisico

-- SWIFT tendra pocos valores y sera accedido frecuentemente
CREATE BITMAP INDEX swift_idx
    ON CUENTA(SWIFT) TABLESPACE TS_INDICES;