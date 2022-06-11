# ABD
Trabajo ABD 

Integrantes Grupo JARD:  
Angel Sergio Sánchez Marín, Claudia Paola García Nocetti, Diego Cuesta García, Javier Márquez Ruiz, Rubén Cazorla Rodríguez


# Explicación del modelo (vídeo)

## Sobre los **clientes** y las **personas autorizadas**
Los **clientes** pueden ser **empresas** (personas jurídicas) o **individuales** (personas físicas).
Si es una empresa podrá autorizar a **personas autorizadas** para que hagan operaciones con las cuentas.
Las personas autorizadas no son clientes, sino empleados de la empresa.

Razón social: nombre empresa.


## Sobre las **cuentas**
Las **cuentas de referencia** son cuentas de otros bancos.
Las **cuentas fintech** es el producto que eBury ofrece. Estas cuentas no guardan dinero. Ese dinero
se pone en una cuenta de verdad, las **cuentas de referencia**.

En las **cuentas pooled** hay "una cuenta de verdad" (bancaria) para almacenar el dinero de varios clientes.
Virtualmente (_da la sensación de que_) sus cuentas están separadas, pero físicamente están en el mismo sitio.

En una **cuenta segregada** solo se almacena el dinero de una persona por cuenta bancaria (**cuenta referencia**).

- Una **cuenta fintech** puede tener el saldo en varias divisas
- Pero... las **cuentas referencia** ("de verdad") están en UNA SOLA divisa
- Solución: **DEPOSITADA_EN**


## Sobre las transacciones
Transacciones entre 2 cuentas. Una cuenta siempre tendrá que ser fintech.(ORIGEN O DESTINO TIENE QUE SER FINTECH).
Si son 2 cuentas fintech habrá que hacer 2 operaciones. 
Pueden ser CARGO o INGRESO, dependiendo de la perspectiva. 
