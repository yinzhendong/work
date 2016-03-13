-- MySQL dump 10.13  Distrib 5.1.73, for redhat-linux-gnu (x86_64)
--
-- Host: localhost    Database: trent
-- ------------------------------------------------------
-- Server version	5.1.73

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `boful_file`
--

DROP TABLE IF EXISTS `boful_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boful_file` (
  `file_path` varchar(100) DEFAULT NULL,
  `file_hash` varchar(100) DEFAULT NULL,
  `file_length` varchar(100) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `boful_file`
--

LOCK TABLES `boful_file` WRITE;
/*!40000 ALTER TABLE `boful_file` DISABLE KEYS */;
INSERT INTO `boful_file` VALUES ('/home/pdf/155cb9d35bd744cf65424acba39c71ae.pdf','155cb9d35bd744cf65424acba39c71ae','3'),('/home/pdf/77b3a76840160b33ed9b3a589c1a5589.pdf','77b3a76840160b33ed9b3a589c1a5589','4098'),('/home/pdf/a54b8b2e2cd56a51a11acd54ced375bf.pdf','a54b8b2e2cd56a51a11acd54ced375bf','3554'),('/home/pdf/ad1aadb45c48899cbc21985a8c418f20.pdf','ad1aadb45c48899cbc21985a8c418f20','4202'),('/home/pdf/b7c718541a266d3138f125643da76f54.pdf','b7c718541a266d3138f125643da76f54','340'),('/home/pdf/efaa27a42c362916e7732e35c327cce8.pdf','efaa27a42c362916e7732e35c327cce8','3210'),('/home/moosefs-labels-manual.pdf','14b59c4c0487c2dbdab11464d3a18b81','19');
/*!40000 ALTER TABLE `boful_file` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-01-07 17:39:36
