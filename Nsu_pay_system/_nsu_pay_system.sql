-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 26, 2026 at 07:04 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: ` nsu_pay_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `log_id` bigint(20) NOT NULL,
  `tx_id` bigint(20) DEFAULT NULL,
  `device_id` varchar(50) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `action_performed` enum('Insert','Update','Delete','TapIn','PaymentAttempt') NOT NULL,
  `log_timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bus_operations`
--

CREATE TABLE `bus_operations` (
  `operation_id` int(11) NOT NULL,
  `card_serial` varchar(50) NOT NULL,
  `route_id` int(11) NOT NULL,
  `board_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `bus_no` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bus_routes`
--

CREATE TABLE `bus_routes` (
  `route_id` int(11) NOT NULL,
  `route_name` varchar(100) NOT NULL,
  `start_location` varchar(100) NOT NULL,
  `end_location` varchar(100) NOT NULL,
  `fare` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `loans`
--

CREATE TABLE `loans` (
  `loan_id` int(11) NOT NULL,
  `card_serial` varchar(50) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `issued_date` date NOT NULL,
  `due_date` date NOT NULL,
  `status` enum('Active','Paid','Overdue','Defaulted') DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nsu_pay_cards`
--

CREATE TABLE `nsu_pay_cards` (
  `card_serial` varchar(50) NOT NULL,
  `student_id` int(11) NOT NULL,
  `issue_date` date NOT NULL,
  `valid_until` date NOT NULL,
  `card_status` enum('Active','Blocked','Expired','Lost') DEFAULT 'Active',
  `card_type` enum('Regular','Premium','Temporary') DEFAULT 'Regular'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `Student_ID` int(11) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `RFID_Tag` varchar(50) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Department` varchar(50) DEFAULT NULL,
  `Credit_Completed` int(11) DEFAULT 0,
  `Status` enum('Active','Inactive','Graduated','Suspended') DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transaction_ledger`
--

CREATE TABLE `transaction_ledger` (
  `tx_id` bigint(20) NOT NULL,
  `card_serial` varchar(50) NOT NULL,
  `vendor_id` int(11) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `tx_type` enum('Purchase','TopUp','BusFare','LoanRepayment','Refund') NOT NULL,
  `tx_timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('Pending','Completed','Failed','Reversed') DEFAULT 'Completed'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vendor_items`
--

CREATE TABLE `vendor_items` (
  `item_id` int(11) NOT NULL,
  `vendor_id` int(11) NOT NULL,
  `item_name` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `availability` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vendor_registry`
--

CREATE TABLE `vendor_registry` (
  `vendor_id` int(11) NOT NULL,
  `vendor_name` varchar(100) NOT NULL,
  `location` varchar(100) DEFAULT NULL,
  `contact_no` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wallets`
--

CREATE TABLE `wallets` (
  `wallet_id` int(11) NOT NULL,
  `card_serial` varchar(50) NOT NULL,
  `balance` decimal(10,2) DEFAULT 0.00,
  `loyalty_points` int(11) DEFAULT 0,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `fk_audit_tx` (`tx_id`);

--
-- Indexes for table `bus_operations`
--
ALTER TABLE `bus_operations`
  ADD PRIMARY KEY (`operation_id`),
  ADD KEY `fk_bus_card` (`card_serial`),
  ADD KEY `fk_bus_route` (`route_id`);

--
-- Indexes for table `bus_routes`
--
ALTER TABLE `bus_routes`
  ADD PRIMARY KEY (`route_id`);

--
-- Indexes for table `loans`
--
ALTER TABLE `loans`
  ADD PRIMARY KEY (`loan_id`),
  ADD KEY `fk_loans_card` (`card_serial`);

--
-- Indexes for table `nsu_pay_cards`
--
ALTER TABLE `nsu_pay_cards`
  ADD PRIMARY KEY (`card_serial`),
  ADD KEY `fk_cards_student` (`student_id`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`Student_ID`),
  ADD UNIQUE KEY `RFID_Tag` (`RFID_Tag`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- Indexes for table `transaction_ledger`
--
ALTER TABLE `transaction_ledger`
  ADD PRIMARY KEY (`tx_id`),
  ADD KEY `fk_tx_card` (`card_serial`),
  ADD KEY `fk_tx_vendor` (`vendor_id`);

--
-- Indexes for table `vendor_items`
--
ALTER TABLE `vendor_items`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `fk_items_vendor` (`vendor_id`);

--
-- Indexes for table `vendor_registry`
--
ALTER TABLE `vendor_registry`
  ADD PRIMARY KEY (`vendor_id`);

--
-- Indexes for table `wallets`
--
ALTER TABLE `wallets`
  ADD PRIMARY KEY (`wallet_id`),
  ADD UNIQUE KEY `card_serial` (`card_serial`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `log_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bus_operations`
--
ALTER TABLE `bus_operations`
  MODIFY `operation_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bus_routes`
--
ALTER TABLE `bus_routes`
  MODIFY `route_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `loans`
--
ALTER TABLE `loans`
  MODIFY `loan_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `Student_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transaction_ledger`
--
ALTER TABLE `transaction_ledger`
  MODIFY `tx_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `vendor_items`
--
ALTER TABLE `vendor_items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `vendor_registry`
--
ALTER TABLE `vendor_registry`
  MODIFY `vendor_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wallets`
--
ALTER TABLE `wallets`
  MODIFY `wallet_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `fk_audit_tx` FOREIGN KEY (`tx_id`) REFERENCES `transaction_ledger` (`tx_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `bus_operations`
--
ALTER TABLE `bus_operations`
  ADD CONSTRAINT `fk_bus_card` FOREIGN KEY (`card_serial`) REFERENCES `nsu_pay_cards` (`card_serial`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_bus_route` FOREIGN KEY (`route_id`) REFERENCES `bus_routes` (`route_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `loans`
--
ALTER TABLE `loans`
  ADD CONSTRAINT `fk_loans_card` FOREIGN KEY (`card_serial`) REFERENCES `nsu_pay_cards` (`card_serial`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `nsu_pay_cards`
--
ALTER TABLE `nsu_pay_cards`
  ADD CONSTRAINT `fk_cards_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`Student_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `transaction_ledger`
--
ALTER TABLE `transaction_ledger`
  ADD CONSTRAINT `fk_tx_card` FOREIGN KEY (`card_serial`) REFERENCES `nsu_pay_cards` (`card_serial`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tx_vendor` FOREIGN KEY (`vendor_id`) REFERENCES `vendor_registry` (`vendor_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `vendor_items`
--
ALTER TABLE `vendor_items`
  ADD CONSTRAINT `fk_items_vendor` FOREIGN KEY (`vendor_id`) REFERENCES `vendor_registry` (`vendor_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `wallets`
--
ALTER TABLE `wallets`
  ADD CONSTRAINT `fk_wallets_card` FOREIGN KEY (`card_serial`) REFERENCES `nsu_pay_cards` (`card_serial`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
