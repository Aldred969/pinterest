-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 28, 2026 at 11:21 AM
-- Server version: 10.6.24-MariaDB-cll-lve
-- PHP Version: 8.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pencari2_wirabuana_pinterest`
--

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL,
  `post_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `comment` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`id`, `post_id`, `user_id`, `comment`, `created_at`) VALUES
(1, 5, 1, 'ini gambar yang bagus saya menyukai nya', '2026-01-16 07:09:34'),
(2, 5, 1, 'test', '2026-01-16 07:16:41'),
(4, 5, 3, 'test', '2026-01-16 08:33:34'),
(5, 6, 1, 'test comen', '2026-01-17 03:29:53'),
(6, 6, 1, 'a', '2026-01-21 13:26:01'),
(7, 8, 3, 'Test Komment Hari H', '2026-01-21 23:02:27');

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `caption` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`id`, `user_id`, `image`, `caption`, `created_at`) VALUES
(5, 3, 'uploads/images/post_1768545275.png', 'Akun1 KE 2 UPLOADS', '2026-01-16 06:34:35'),
(6, 3, 'uploads/images/post_1768619473.png', 'Wallpaper Honkai Starrail event versi 9.1 bertema summer , Ini merupakan Post pertama saya ', '2026-01-17 03:11:13'),
(8, 1, 'uploads/images/post_1769010608.png', 'test type', '2026-01-21 15:50:08'),
(9, 3, 'uploads/images/post_1769036414.jpg', 'Arlecchino 4K Wallpaper ', '2026-01-21 23:00:14'),
(10, 3, 'uploads/images/post_1769055309.png', 'hsjdsjhds', '2026-01-22 04:15:09');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `nama`, `bio`, `created_at`) VALUES
(1, 'aldred', '$2y$10$1DQjs.1E.YKYcOuRGJ9Hye0AW9mPW5HHaxLf5Biye/TkBOOe3PW56', 'Enzo kia', 'Saya melakukan perubahan pada bio supaya lebih menarik perubahan test perubahan', '2026-01-15 12:47:02'),
(3, 'akun1', '$2y$10$V1u0ju1xjaPXSheojw/V2utoHJNGjlMw1N11NIpIQVynAUnE8GPRi', 'alya', 'Halo saya alya dan disini sebagai pengguna kedua dari aplikasi beta saat inidfdfd', '2026-01-15 13:42:45'),
(4, 'aldy', '$2y$10$jY1mNgPG/q3BCeXcjQoYQO6N3eMjVYjTYuMTFH36tbJ4/YKWe/9De', 'sijago', NULL, '2026-01-21 23:23:18'),
(5, 'akun2', '$2y$10$RCLbzWg/v5nnPdOLdMPJi.EFa72nv5LTYncRsnZGyt9Ws33mtF8Jq', 'Nando', NULL, '2026-01-22 03:34:59');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `fk_comments_post` (`post_id`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  ADD CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_comments_post` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
