DROP DATABASE IF EXISTS BDA_TPI;
CREATE DATABASE BDA_TPI charset=latin1 collate=latin1_spanish_ci;
USE BDA_TPI;

CREATE TABLE IF NOT EXISTS Agencias(
nombre varchar(45),
personal int UNSIGNED NOT NULL,
tipo varchar(45) NOT NULL,
CONSTRAINT pk_agencias PRIMARY KEY(nombre));

CREATE TABLE IF NOT EXISTS Publicas(
nombre varchar(45),
nombre_e varchar(45) NOT NULL,
CONSTRAINT pk_publica PRIMARY KEY(nombre),
CONSTRAINT fk_publica FOREIGN KEY(nombre) REFERENCES Agencias(nombre));

CREATE INDEX idx_nombre_e ON Publicas(nombre_e) USING HASH;

CREATE TABLE IF NOT EXISTS Privadas(
nombre varchar(45),
nombre_publica varchar(45) NOT NULL,
CONSTRAINT pk_publica PRIMARY KEY(nombre),
CONSTRAINT fk_publica_agencia FOREIGN KEY(nombre) REFERENCES Agencias(nombre),
CONSTRAINT fk_publica_supervisa FOREIGN KEY(nombre_publica) REFERENCES Publicas(nombre_e)
);

CREATE TABLE IF NOT EXISTS Empresas(
CIF varchar(45),
nombre varchar(45) NOT NULL,
capital DECIMAL(11,2) UNSIGNED NOT NULL,
CONSTRAINT pk_empresas PRIMARY KEY(CIF)
);

CREATE TABLE IF NOT EXISTS Financia(
nombre varchar(45),
CIF varchar(45),
porcentaje smallint NOT NULL,
CONSTRAINT pk_financia PRIMARY KEY(nombre, CIF),
CONSTRAINT fk_financia_privada FOREIGN KEY(nombre) REFERENCES Privadas(nombre),
CONSTRAINT fk_financia_empresas FOREIGN KEY(CIF) REFERENCES Empresas(CIF)
);

CREATE TABLE IF NOT EXISTS Clase_nave(
prefijo varchar(45),
nombre varchar(45) NOT NULL,
CONSTRAINT pk_clase_nave PRIMARY KEY(prefijo)
);

CREATE TABLE IF NOT EXISTS Naves(
prefijo varchar(45),
matricula varchar(10),
mision varchar(45),
nombre varchar(45),
nombre_agencia_prop varchar(45),
CONSTRAINT pk_naves PRIMARY KEY(prefijo, matricula),
CONSTRAINT fk_clase_naves FOREIGN KEY(prefijo) REFERENCES Clase_nave(prefijo) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_naves_agencia_prop FOREIGN KEY(nombre_agencia_prop) REFERENCES Agencias(nombre)
);

CREATE INDEX idx_matricula ON Naves(matricula) USING HASH;

CREATE TABLE IF NOT EXISTS Componentes(
codigo smallint AUTO_INCREMENT,
diametro decimal(7,2) UNSIGNED NOT NULL,
peso decimal(7,2) UNSIGNED NOT NULL,
prefijo varchar(45) NOT NULL,
CONSTRAINT pk_componentes PRIMARY KEY(codigo),
CONSTRAINT fk_componentes FOREIGN KEY(prefijo) REFERENCES Clase_nave(prefijo)
);

CREATE TABLE IF NOT EXISTS Orbitas(
excentricidad decimal(11,2),
altura decimal(11,2),
sentido enum('positivo', 'negativo'),
geostacionario boolean,
circular boolean /*HACEMOS TRIGGER PARA CHEQUEAR QUE SI excentricidad=0 => circular = true*/,
CONSTRAINT pk_orbitas PRIMARY KEY(excentricidad, altura, sentido));

DELIMITER //
CREATE TRIGGER verificar_excent_orbita BEFORE INSERT on Orbitas for each row
begin
    IF (new.excentricidad = 0) then
        SET new.circular= true;
    ELSE
    	SET new.circular=false;
    end IF;
end
//

DELIMITER ;

CREATE INDEX idx_altura ON Orbitas(altura) USING BTREE;
CREATE INDEX idx_sentido ON Orbitas(sentido) USING BTREE;


CREATE TABLE IF NOT EXISTS Basuras(
id_basura int AUTO_INCREMENT,
velocidad DECIMAL(11,2) NOT NULL,
tamaño DECIMAL(11,2) NOT NULL,
peso DECIMAL(11,2) NOT NULL,
matricula varchar(10),
excentricidad_orb DECIMAL(11,2) NOT NULL,
altura_orb DECIMAL(11,2) NOT NULL,
sentido_orb enum('positivo', 'negativo') NOT NULL,
basura_padre int DEFAULT NULL,
CONSTRAINT pk_basuras PRIMARY KEY(id_basura),
CONSTRAINT fk_basuras FOREIGN KEY(matricula) REFERENCES Naves(matricula),
CONSTRAINT fk_posicion_orb FOREIGN KEY(excentricidad_orb,altura_orb,sentido_orb) REFERENCES Orbitas(excentricidad,altura,sentido),
CONSTRAINT fk_basuras FOREIGN KEY(basura_padre) REFERENCES Basuras(id_basura)
);

CREATE TABLE IF NOT EXISTS Posiciones(
id_basura  int,
altura  DECIMAL(11,2) NOT NULL,
fecha_pos datetime NOT NULL,
sentido enum('positivo', 'negativo'),
excentricidad DECIMAL(11,2) NOT NULL,
CONSTRAINT pk_posiciones PRIMARY KEY(id_basura, fecha_pos),
CONSTRAINT fk_posiciones FOREIGN KEY(id_basura) REFERENCES Basuras(id_basura) ON DELETE CASCADE ON UPDATE CASCADE);

CREATE TABLE IF NOT EXISTS Lanza(
fecha_lanzamiento DATETIME NOT NULL,
nombre_agencia varchar(45),
excentricidad DECIMAL(11,2),
altura DECIMAL(11,2),
sentido  enum('positivo', 'negativo'),
matricula varchar(10),
CONSTRAINT pk_lanza PRIMARY KEY(nombre_agencia, excentricidad, altura, sentido, matricula),
CONSTRAINT fk_lanza_nombre FOREIGN KEY(nombre_agencia) REFERENCES Agencias(nombre),
CONSTRAINT fk_lanza_excentricidad FOREIGN KEY(excentricidad) REFERENCES Orbitas(excentricidad),
CONSTRAINT fk_lanza_altura FOREIGN KEY(altura) REFERENCES Orbitas(altura),
CONSTRAINT fk_lanza_sentido FOREIGN KEY(sentido) REFERENCES Orbitas(sentido),
CONSTRAINT fk_lanza_matricula FOREIGN KEY(id_basura) REFERENCES Basuras(id_basura));

CREATE TABLE IF NOT EXISTS esta(
fecha_ini DATE,
fecha_fin DATE,
excentricidad DECIMAL(11,2),
altura DECIMAL(11,2),
sentido  enum('positivo', 'negativo'),
matricula varchar(10) NOT NULL,
CONSTRAINT pk_esta PRIMARY KEY(matricula, excentricidad, altura, sentido),
CONSTRAINT fk_esta_excentricidad FOREIGN KEY(excentricidad) REFERENCES Orbitas(excentricidad),
CONSTRAINT fk_esta_altura FOREIGN KEY(altura) REFERENCES Orbitas(altura),
CONSTRAINT fk_esta_sentido FOREIGN KEY(sentido) REFERENCES Orbitas(sentido),
CONSTRAINT fk_esta_matricula FOREIGN KEY(matricula) REFERENCES Naves(matricula));

CREATE TABLE IF NOT EXISTS Tripulantes(
nombre varchar(40) NOT NULL,
CONSTRAINT pk_nom_tripulantes PRIMARY KEY (nombre)
);


CREATE TABLE IF NOT EXISTS Tiene(
matricula varchar(10),
nombre_trip varchar(40),
CONSTRAINT pk_nave_tiene_trip PRIMARY KEY (matricula,nombre_trip),
CONSTRAINT fk_tiene_matricula FOREIGN KEY(matricula) REFERENCES Naves(matricula),
CONSTRAINT fk_tiene_nombre_trip FOREIGN KEY(nombre_trip) REFERENCES Tripulantes(nombre)
);

