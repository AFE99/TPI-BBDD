


/*----------------------------Modificaciones del Esquema----------------------------*/

CREATE TABLE posee(
id_costo int,
fecha_lanzamiento DATETIME NOT NULL,
nombre_agencia varchar(45) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
excentricidad decimal(9,2),
altura decimal(9,2),
sentido enum('positivo', 'negativo'),
matricula varchar(10) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
CONSTRAINT pk_posee PRIMARY KEY (id_costo, nombre_agencia, excentricidad, altura, sentido, matricula),
CONSTRAINT fk_lanza_nombre_posee FOREIGN KEY(nombre_agencia) REFERENCES Agencias(nombre),
CONSTRAINT fk_lanza_excentricidad_posee FOREIGN KEY(excentricidad) REFERENCES Orbitas(excentricidad),
CONSTRAINT fk_lanza_altura_posee FOREIGN KEY(altura) REFERENCES Orbitas(altura),
CONSTRAINT fk_lanza_sentido_posee FOREIGN KEY(sentido) REFERENCES Orbitas(sentido),
CONSTRAINT fk_lanza_matricula_posee FOREIGN KEY(matricula) REFERENCES Naves(matricula),
CONSTRAINT fk_lanza_costo FOREIGN KEY(id_costo) REFERENCES Costo(id_costo));

CREATE TABLE costo(
id_costo int Auto_increment, 
costo_nave decimal(9,2) NOT NULL, 
costo_agencia decimal(9,2) NOT NULL,
costo_lanza decimal(9,2) NOT NULL,
costo_total decimal(12,2) DEFAULT NULL,
periodo DATE,
CONSTRAINT pk_costo PRIMARY KEY(id_costo)
);

DELIMITER //
CREATE TRIGGER total_costos BEFORE INSERT ON costo
FOR EACH ROW
	BEGIN 
SET new.costo_total = new.costo_nave + new.costo_lanza +  new.costo_agencia;
	END //
DELIMITER ;
