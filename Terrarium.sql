-- phpMyAdmin SQL Dump
-- version 4.2.12deb2+deb8u2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Erstellungszeit: 04. Apr 2017 um 19:06
-- Server Version: 5.5.54-0+deb8u1
-- PHP-Version: 5.6.29-0+deb8u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Datenbank: `Terrarium`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `clients`
--

CREATE TABLE IF NOT EXISTS `clients` (
`id` int(11) NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `humidity_log`
--

CREATE TABLE IF NOT EXISTS `humidity_log` (
`id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `value_1` float NOT NULL,
  `value_2` float NOT NULL,
  `timestamp` datetime NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=256 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `temperature_log`
--

CREATE TABLE IF NOT EXISTS `temperature_log` (
`id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `value_1` float NOT NULL,
  `value_2` float NOT NULL,
  `timestamp` datetime NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=258 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Terrarium_1`
--

CREATE TABLE IF NOT EXISTS `Terrarium_1` (
`ID` int(11) NOT NULL,
  `timestamp` datetime NOT NULL,
  `Temp_1` float NOT NULL,
  `Humidity_1` float NOT NULL,
  `Temp_2` float NOT NULL,
  `Humidity_2` float NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=777 DEFAULT CHARSET=utf8;

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `clients`
--
ALTER TABLE `clients`
 ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `humidity_log`
--
ALTER TABLE `humidity_log`
 ADD PRIMARY KEY (`id`), ADD KEY `client_id` (`client_id`);

--
-- Indizes für die Tabelle `temperature_log`
--
ALTER TABLE `temperature_log`
 ADD PRIMARY KEY (`id`), ADD KEY `client_id` (`client_id`);

--
-- Indizes für die Tabelle `Terrarium_1`
--
ALTER TABLE `Terrarium_1`
 ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `clients`
--
ALTER TABLE `clients`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT für Tabelle `humidity_log`
--
ALTER TABLE `humidity_log`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=256;
--
-- AUTO_INCREMENT für Tabelle `temperature_log`
--
ALTER TABLE `temperature_log`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=258;
--
-- AUTO_INCREMENT für Tabelle `Terrarium_1`
--
ALTER TABLE `Terrarium_1`
MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=777;
--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `humidity_log`
--
ALTER TABLE `humidity_log`
ADD CONSTRAINT `humidity_log_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`);

--
-- Constraints der Tabelle `temperature_log`
--
ALTER TABLE `temperature_log`
ADD CONSTRAINT `temperature_log_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
