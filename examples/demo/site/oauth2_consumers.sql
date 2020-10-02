-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: roc_mysql
-- Generation Time: Oct 19, 2018 at 06:41 AM
-- Server version: 5.7.23
-- PHP Version: 7.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rocdb_123`
--

-- --------------------------------------------------------

--
-- Table structure for table `oauth2_consumers`
--

CREATE TABLE `oauth2_consumers` (
  `cid` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `api_secret` text NOT NULL,
  `api_key` text NOT NULL,
  `scope` varchar(100) NOT NULL,
  `protected_resource_url` varchar(255) NOT NULL,
  `callback_name` varchar(255) NOT NULL,
  `extractor` varchar(50) NOT NULL,
  `authorize_url` varchar(255) NOT NULL,
  `endpoint` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `oauth2_consumers`
--

INSERT INTO `oauth2_consumers` (`cid`, `name`, `api_secret`, `api_key`, `scope`, `protected_resource_url`, `callback_name`, `extractor`, `authorize_url`, `endpoint`) VALUES
(1, 'google', 'i0vOUyZNbAsQcTlxDZEowHOy', '101932217297-ek3l17q7oes0kcsa6u2aggkk5o0v80ih.apps.googleusercontent.com', 'email', 'https://www.googleapis.com/plus/v1/people/me', 'callback_google', 'json', 'https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=$CLIENT_ID&redirect_uri=http://sandbox.eiffel.com:8080', 'https://accounts.google.com/o/oauth2/token'),
(2, 'facebook', 'EAAEFPwuPalEBAL9wA8fZBFUEj64ZCyHl9ufCjckzPkC8DEv8XZALlKz6pggUyzcG5ZBGO5Ng4ohmzbOV3I35bnLfJ66OWV4ZBEySGyGTQ2oL3kCI5H3S62L7ZCmH5odLGKZCsi5u4LGdhhxiXAT0lXidHBl3lAbLkfnfv3BvVXySdlZA7BnTpGuO9OYsHfgfXZA8ZD', '287243311737425|iVGeozVYBIz6p_07vb7Mdz-OEoA', 'email', 'https://graph.facebook.com/me', 'callback_facebook', 'text', 'https://www.facebook.com/dialog/oauth?response_type=code&client_id=$CLIENT_ID&redirect_uri=$REDIRECT_URI', 'https://graph.facebook.com/oauth/access_token'),
(4, 'github', '519a5a5e6518d0666cbe29c19b9d124817317994', '372e0e44220f995319d0', 'user', 'https://api.github.com/user', 'callback_github', 'text', 'https://github.com/login/oauth/authorize?client_id=$CLIENT_ID&redirect_uri=$REDIRECT_URI', 'https://github.com/login/oauth/access_token');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `oauth2_consumers`
--
ALTER TABLE `oauth2_consumers`
  ADD PRIMARY KEY (`cid`),
  ADD UNIQUE KEY `cid` (`cid`),
  ADD UNIQUE KEY `name` (`name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `oauth2_consumers`
--
ALTER TABLE `oauth2_consumers`
  MODIFY `cid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
