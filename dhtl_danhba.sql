-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 08, 2021 at 03:30 AM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 8.0.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dhtl_danhba`
--

-- --------------------------------------------------------

--
-- Table structure for table `db_donvi`
--

CREATE TABLE `db_donvi` (
  `ma_donvi` int(10) UNSIGNED NOT NULL,
  `ten_donvi` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `somayban` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `diachi` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `website` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ma_donvicha` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `db_donvi`
--

INSERT INTO `db_donvi` (`ma_donvi`, `ten_donvi`, `somayban`, `diachi`, `email`, `website`, `ma_donvicha`) VALUES
(1, 'Trường Đại học Thủy lợi', '(024) 38522201', '175 Tây Sơn, Đống Đa, Hà Nội', 'phonghcth@tlu.edu.vn', 'http://tlu.edu.vn', NULL),
(2, 'Khoa Công nghệ thông tin', '024333335555', 'Nhà C1, 175 Tây Sơn, Đống Đa, Hà Nội', 'cntt@tlu.edu.vn', 'http://cse.tlu.edu.vn', 1),
(3, 'Brainverse', '454-100-7211', '4230 Trailsway Hill', 'ccourcey2@indiatimes.com', 'purevolume.com', 2),
(4, 'Avamba', '509-536-0759', '58 Starling Lane', 'dbudge3@cyberchimps.com', 'blog.com', 2),
(5, 'Tekfly', '436-315-3942', '2 Hollow Ridge Plaza', 'rwoodman4@cbsnews.com', 'unicef.org', 2),
(6, 'Avavee', '626-398-9064', '3 Iowa Court', 'psutcliffe5@ycombinator.com', 'washington.edu', 2),
(7, 'Quatz', '804-609-0923', '09 Orin Drive', 'dbebis6@etsy.com', 'guardian.co.uk', 2),
(8, 'Linkbridge', '571-800-5701', '4627 Beilfuss Street', 'mmugglestone7@dyndns.org', 'paypal.com', 2),
(9, 'Dynabox', '534-710-9659', '7984 Paget Terrace', 'bfreed8@mapquest.com', 'sciencedaily.com', 2),
(10, 'Blognation', '754-825-8385', '777 Monument Avenue', 'cdeveral9@deviantart.com', 'census.gov', 2),
(11, 'Edgeify', '512-814-8262', '727 Old Gate Center', 'dmerritt0@google.cn', 'phpbb.com', 1),
(12, 'Omba', '960-102-7236', '617 Old Shore Avenue', 'mcaulket1@dailymail.co.uk', 'quantcast.com', 2);

-- --------------------------------------------------------

--
-- Table structure for table `db_nguoidung`
--

CREATE TABLE `db_nguoidung` (
  `ma_nguoidung` int(10) UNSIGNED NOT NULL,
  `tendangnhap` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `matkhau` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `db_nhanvien`
--

CREATE TABLE `db_nhanvien` (
  `ma_nhanvien` int(10) UNSIGNED NOT NULL,
  `hovaten` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `chucvu` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sodt_coquan` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sodt_didong` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ma_donvi` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `db_nhanvien`
--

INSERT INTO `db_nhanvien` (`ma_nhanvien`, `hovaten`, `chucvu`, `sodt_coquan`, `sodt_didong`, `email`, `ma_donvi`) VALUES
(2, 'Shaylynn Jacobbe', 'Construction Manager', '595-221-1272', '174-485-62', 'sjacobbe1@rambler.ru', 2),
(3, 'Berni Caudle', 'Architect', '549-977-1921', '785-135-41', 'bcaudle2@wiley.com', 2),
(4, 'Jenn Ife', 'Construction Expeditor', '120-254-8397', '311-961-45', 'jife3@de.vu', 2),
(5, 'Johannes Pengilly', 'Architect', '266-734-3367', '141-305-52', 'jpengilly4@vinaora.com', 2),
(6, 'Percy Enbury', 'Engineer', '158-865-3175', '547-389-66', 'penbury5@msu.edu', 2),
(7, 'Miguela Hukins', 'Engineer', '954-351-1084', '322-486-12', 'mhukins6@cnbc.com', 2),
(8, 'Flint Labroue', 'Architect', '167-204-9787', '206-695-28', 'flabroue7@java.com', 2),
(9, 'Mickie Sparks', 'Engineer', '622-101-9527', '219-561-37', 'msparks8@istockphoto.com', 2),
(10, 'Sydney Tiron', 'Electrician', '750-563-4467', '602-123-26', 'stiron9@google.ca', 2),
(11, 'Celinda Shrigley', 'Construction Expeditor', '582-121-6798', '377-939-73', 'cshrigley0@cam.ac.uk', 2);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `db_donvi`
--
ALTER TABLE `db_donvi`
  ADD PRIMARY KEY (`ma_donvi`),
  ADD KEY `ma_donvicha` (`ma_donvicha`);

--
-- Indexes for table `db_nguoidung`
--
ALTER TABLE `db_nguoidung`
  ADD PRIMARY KEY (`ma_nguoidung`),
  ADD UNIQUE KEY `tendangnhap` (`tendangnhap`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `db_nhanvien`
--
ALTER TABLE `db_nhanvien`
  ADD PRIMARY KEY (`ma_nhanvien`),
  ADD KEY `ma_donvi` (`ma_donvi`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `db_donvi`
--
ALTER TABLE `db_donvi`
  MODIFY `ma_donvi` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `db_nguoidung`
--
ALTER TABLE `db_nguoidung`
  MODIFY `ma_nguoidung` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `db_nhanvien`
--
ALTER TABLE `db_nhanvien`
  MODIFY `ma_nhanvien` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `db_donvi`
--
ALTER TABLE `db_donvi`
  ADD CONSTRAINT `db_donvi_ibfk_1` FOREIGN KEY (`ma_donvicha`) REFERENCES `db_donvi` (`ma_donvi`);

--
-- Constraints for table `db_nhanvien`
--
ALTER TABLE `db_nhanvien`
  ADD CONSTRAINT `db_nhanvien_ibfk_1` FOREIGN KEY (`ma_donvi`) REFERENCES `db_donvi` (`ma_donvi`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
