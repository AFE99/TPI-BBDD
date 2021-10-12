-- MySQL dump 10.13  Distrib 8.0.21, for Linux (x86_64)
--
-- Host: localhost    Database: BDA_TPI
-- ------------------------------------------------------
-- Server version	8.0.21

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Agencias`
--

DROP TABLE IF EXISTS `Agencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Agencias` (
  `nombre` varchar(45) COLLATE latin1_spanish_ci NOT NULL,
  `personal` int unsigned NOT NULL,
  `tipo` varchar(45) COLLATE latin1_spanish_ci NOT NULL,
  PRIMARY KEY (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Basuras`
--

DROP TABLE IF EXISTS `Basuras`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Basuras` (
  `id_basura` int NOT NULL AUTO_INCREMENT,
  `velocidad` decimal(11,2) NOT NULL,
  `tamaño` decimal(11,2) NOT NULL,
  `peso` decimal(11,2) NOT NULL,
  `matricula` varchar(10) COLLATE latin1_spanish_ci DEFAULT NULL,
  `excentricidad_orb` decimal(11,2) NOT NULL,
  `altura_orb` decimal(11,2) NOT NULL,
  `sentido_orb` enum('positivo','negativo') COLLATE latin1_spanish_ci NOT NULL,
  `id_padre` int DEFAULT NULL,
  PRIMARY KEY (`id_basura`),
  KEY `fk_basuras` (`matricula`),
  KEY `fk_posicion_orb` (`excentricidad_orb`,`altura_orb`,`sentido_orb`),
  KEY `fk_id_padre` (`id_padre`),
  KEY `basura_index` (`id_basura`),
  CONSTRAINT `fk_basuras` FOREIGN KEY (`matricula`) REFERENCES `Naves` (`matricula`),
  CONSTRAINT `fk_id_padre` FOREIGN KEY (`id_padre`) REFERENCES `Basuras` (`id_basura`),
  CONSTRAINT `fk_posicion_orb` FOREIGN KEY (`excentricidad_orb`, `altura_orb`, `sentido_orb`) REFERENCES `Orbitas` (`excentricidad`, `altura`, `sentido`)
) ENGINE=InnoDB AUTO_INCREMENT=100001 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Clase_nave`
--

DROP TABLE IF EXISTS `Clase_nave`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Clase_nave` (
  `prefijo` varchar(45) COLLATE latin1_spanish_ci NOT NULL,
  `nombre` varchar(45) COLLATE latin1_spanish_ci NOT NULL,
  PRIMARY KEY (`prefijo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Componentes`
--

DROP TABLE IF EXISTS `Componentes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Componentes` (
  `codigo` smallint NOT NULL AUTO_INCREMENT,
  `diametro` decimal(7,2) unsigned NOT NULL,
  `peso` decimal(7,2) unsigned NOT NULL,
  `prefijo` varchar(45) COLLATE latin1_spanish_ci NOT NULL,
  PRIMARY KEY (`codigo`),
  KEY `fk_componentes` (`prefijo`),
  CONSTRAINT `fk_componentes` FOREIGN KEY (`prefijo`) REFERENCES `Clase_nave` (`prefijo`)
) ENGINE=InnoDB AUTO_INCREMENT=2501 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Empresas`
--

DROP TABLE IF EXISTS `Empresas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Empresas` (
  `CIF` varchar(45) COLLATE latin1_spanish_ci NOT NULL,
  `nombre` varchar(45) COLLATE latin1_spanish_ci NOT NULL,
  `capital` decimal(11,2) unsigned NOT NULL,
  PRIMARY KEY (`CIF`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Financia`
--

DROP TABLE IF EXISTS `Financia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Financia` (
  `nombre` varchar(45) COLLATE latin1_spanish_ci NOT NULL,
  `CIF` varchar(45) COLLATE latin1_spanish_ci NOT NULL,
  `porcentaje` smallint NOT NULL,
  PRIMARY KEY (`nombre`,`CIF`),
  KEY `fk_financia_empresas` (`CIF`),
  CONSTRAINT `fk_financia_empresas` FOREIGN KEY (`CIF`) REFERENCES `Empresas` (`CIF`),
  CONSTRAINT `fk_financia_privada` FOREIGN KEY (`nombre`) REFERENCES `Privadas` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Lanza`
--

DROP TABLE IF EXISTS `Lanza`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Lanza` (
  `fecha_lanzamiento` datetime NOT NULL,
  `nombre_agencia` varchar(45) COLLATE latin1_spanish_ci NOT NULL,
  `excentricidad` decimal(11,2) NOT NULL,
  `altura` decimal(11,2) NOT NULL,
  `sentido` enum('positivo','negativo') COLLATE latin1_spanish_ci NOT NULL,
  `matricula` varchar(10) COLLATE latin1_spanish_ci NOT NULL,
  PRIMARY KEY (`nombre_agencia`,`excentricidad`,`altura`,`sentido`,`matricula`),
  KEY `fk_lanza_excentricidad` (`excentricidad`),
  KEY `fk_lanza_altura` (`altura`),
  KEY `fk_lanza_sentido` (`sentido`),
  KEY `fk_lanza_matricula` (`matricula`),
  CONSTRAINT `fk_lanza_altura` FOREIGN KEY (`altura`) REFERENCES `Orbitas` (`altura`),
  CONSTRAINT `fk_lanza_excentricidad` FOREIGN KEY (`excentricidad`) REFERENCES `Orbitas` (`excentricidad`),
  CONSTRAINT `fk_lanza_matricula` FOREIGN KEY (`matricula`) REFERENCES `Naves` (`matricula`),
  CONSTRAINT `fk_lanza_nombre` FOREIGN KEY (`nombre_agencia`) REFERENCES `Agencias` (`nombre`),
  CONSTRAINT `fk_lanza_sentido` FOREIGN KEY (`sentido`) REFERENCES `Orbitas` (`sentido`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Naves`
--

DROP TABLE IF EXISTS `Naves`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Naves` (
  `prefijo` varchar(45) COLLATE latin1_spanish_ci NOT NULL,
  `matricula` varchar(10) COLLATE latin1_spanish_ci NOT NULL,
  `mision` varchar(45) COLLATE latin1_spanish_ci DEFAULT NULL,
  `nombre` varchar(45) COLLATE latin1_spanish_ci DEFAULT NULL,
  `nombre_agencia_prop` varchar(45) COLLATE latin1_spanish_ci DEFAULT NULL,
  PRIMARY KEY (`prefijo`,`matricula`),
  KEY `fk_naves_agencia_prop` (`nombre_agencia_prop`),
  KEY `idx_matricula` (`matricula`),
  KEY `nave_index` (`matricula`),
  CONSTRAINT `fk_clase_naves` FOREIGN KEY (`prefijo`) REFERENCES `Clase_nave` (`prefijo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_naves_agencia_prop` FOREIGN KEY (`nombre_agencia_prop`) REFERENCES `Agencias` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Orbitas`
--

DROP TABLE IF EXISTS `Orbitas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Orbitas` (
  `excentricidad` decimal(11,2) NOT NULL,
  `altura` decimal(11,2) NOT NULL,
  `sentido` enum('positivo','negativo') COLLATE latin1_spanish_ci NOT NULL,
  `geostacionario` tinyint(1) DEFAULT NULL,
  `circular` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`excentricidad`,`altura`,`sentido`),
  KEY `idx_altura` (`altura`) USING BTREE,
  KEY `idx_sentido` (`sentido`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `verificar_excent_orbita` BEFORE INSERT ON `Orbitas` FOR EACH ROW begin
    IF (new.excentricidad = 0) then
        SET new.circular= true;
    ELSE
    	SET new.circular=false;
    end IF;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Posiciones`
--

DROP TABLE IF EXISTS `Posiciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Posiciones` (
  `id_basura` int NOT NULL,
  `altura` decimal(11,2) NOT NULL,
  `fecha_pos` datetime NOT NULL,
  `sentido` enum('positivo','negativo') COLLATE latin1_spanish_ci DEFAULT NULL,
  `excentricidad` decimal(11,2) NOT NULL,
  PRIMARY KEY (`id_basura`,`fecha_pos`),
  CONSTRAINT `fk_posiciones` FOREIGN KEY (`id_basura`) REFERENCES `Basuras` (`id_basura`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Privadas`
--

DROP TABLE IF EXISTS `Privadas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Privadas` (
  `nombre` varchar(45) COLLATE latin1_spanish_ci NOT NULL,
  `nombre_publica` varchar(45) COLLATE latin1_spanish_ci NOT NULL,
  PRIMARY KEY (`nombre`),
  KEY `fk_publica_supervisa` (`nombre_publica`),
  CONSTRAINT `fk_publica_agencia` FOREIGN KEY (`nombre`) REFERENCES `Agencias` (`nombre`),
  CONSTRAINT `fk_publica_supervisa` FOREIGN KEY (`nombre_publica`) REFERENCES `Publicas` (`nombre_e`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Publicas`
--

DROP TABLE IF EXISTS `Publicas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Publicas` (
  `nombre` varchar(45) COLLATE latin1_spanish_ci NOT NULL,
  `nombre_e` varchar(45) COLLATE latin1_spanish_ci NOT NULL,
  PRIMARY KEY (`nombre`),
  KEY `idx_nombre_e` (`nombre_e`),
  CONSTRAINT `fk_publica` FOREIGN KEY (`nombre`) REFERENCES `Agencias` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Tiene`
--

DROP TABLE IF EXISTS `Tiene`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tiene` (
  `matricula` varchar(10) COLLATE latin1_spanish_ci NOT NULL,
  `nombre_trip` varchar(40) COLLATE latin1_spanish_ci NOT NULL,
  PRIMARY KEY (`matricula`,`nombre_trip`),
  KEY `fk_tiene_nombre_trip` (`nombre_trip`),
  CONSTRAINT `fk_tiene_matricula` FOREIGN KEY (`matricula`) REFERENCES `Naves` (`matricula`),
  CONSTRAINT `fk_tiene_nombre_trip` FOREIGN KEY (`nombre_trip`) REFERENCES `Tripulantes` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Tripulantes`
--

DROP TABLE IF EXISTS `Tripulantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tripulantes` (
  `nombre` varchar(40) COLLATE latin1_spanish_ci NOT NULL,
  PRIMARY KEY (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `esta`
--

DROP TABLE IF EXISTS `esta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `esta` (
  `fecha_ini` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `excentricidad` decimal(11,2) NOT NULL,
  `altura` decimal(11,2) NOT NULL,
  `sentido` enum('positivo','negativo') COLLATE latin1_spanish_ci NOT NULL,
  `matricula` varchar(10) COLLATE latin1_spanish_ci NOT NULL,
  PRIMARY KEY (`matricula`,`excentricidad`,`altura`,`sentido`),
  KEY `fk_esta_excentricidad` (`excentricidad`),
  KEY `fk_esta_altura` (`altura`),
  KEY `fk_esta_sentido` (`sentido`),
  CONSTRAINT `fk_esta_altura` FOREIGN KEY (`altura`) REFERENCES `Orbitas` (`altura`),
  CONSTRAINT `fk_esta_excentricidad` FOREIGN KEY (`excentricidad`) REFERENCES `Orbitas` (`excentricidad`),
  CONSTRAINT `fk_esta_matricula` FOREIGN KEY (`matricula`) REFERENCES `Naves` (`matricula`),
  CONSTRAINT `fk_esta_sentido` FOREIGN KEY (`sentido`) REFERENCES `Orbitas` (`sentido`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-11-05  1:31:52
