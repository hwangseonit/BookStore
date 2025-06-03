-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th5 07, 2023 lúc 10:57 PM
-- Phiên bản máy phục vụ: 10.4.28-MariaDB
-- Phiên bản PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `bookstore`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chitiethoadon`
--

CREATE TABLE `chitiethoadon` (
  `ma_hoa_don` int(11) NOT NULL,
  `ma_sach` char(10) NOT NULL,
  `so_luong_sp` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `chitiethoadon`
--

INSERT INTO `chitiethoadon` (`ma_hoa_don`, `ma_sach`, `so_luong_sp`) VALUES
(1, 'S04', 1),
(1, 'S06', 1),
(2, 'S03', 2),
(2, 'S07', 1),
(3, 'S01', 3),
(4, 'S08', 1),
(4, 'S10', 1),
(5, 'S01', 1),
(5, 'S03', 2),
(6, 'S06', 1),
(6, 'S10', 2),
(7, 'S04', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `giohang`
--

CREATE TABLE `giohang` (
  `id` int(10) NOT NULL,
  `ma_sach` char(10) NOT NULL,
  `so_luong_sach` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `giohang`
--

INSERT INTO `giohang` (`id`, `ma_sach`, `so_luong_sach`) VALUES
(3, 'S06', 1),
(3, 'S10', 1),
(3, 'S13', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `hoadon`
--

CREATE TABLE `hoadon` (
  `ma_hoa_don` int(11) NOT NULL,
  `id` int(10) NOT NULL,
  `ten_khach_hang` varchar(128) NOT NULL,
  `ngay_lap` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `trang_thai` varchar(128) NOT NULL,
  `trang_thai_thanh_toan` varchar(128) NOT NULL,
  `tong_tien` int(11) NOT NULL,
  `sdt` char(10) NOT NULL,
  `dia_chi` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `hoadon`
--

INSERT INTO `hoadon` (`ma_hoa_don`, `id`, `ten_khach_hang`, `ngay_lap`, `trang_thai`, `trang_thai_thanh_toan`, `tong_tien`, `sdt`, `dia_chi`) VALUES
(1, 3, 'Ngọc Trâm', '2023-05-06 16:18:06', 'Canceled', 'Chưa thanh toán', 138500, '0798067056', 'Phường Xuân Khánh, Ninh Kiều, Cần Thơ'),
(2, 3, 'Ngọc Trâm', '2023-05-06 16:31:35', 'Canceled', 'Chưa thanh toán', 120000, '0798067056', 'Phường Xuân Khánh, Ninh Kiều, Cần Thơ'),
(3, 3, 'Ngọc Trâm', '2023-05-06 17:12:53', 'recieved', 'Chưa thanh toán', 118800, '0798067056', 'Phường Xuân Khánh, Ninh Kiều, Cần Thơ'),
(4, 3, 'Ngọc Trâm', '2023-05-06 17:20:25', 'recieved', 'Đã thanh toán', 135000, '0798067056', 'Phường Xuân Khánh, Ninh Kiều, Cần Thơ'),
(5, 3, 'Ngọc Trâm', '2023-05-06 18:02:09', 'recieved', 'Đã thanh toán', 79600, '0798067056', 'Phường Xuân Khánh, Ninh Kiều, Cần Thơ'),
(6, 3, 'Ngọc Trâm', '2023-05-06 18:05:06', 'sending', 'Chưa thanh toán', 173500, '0902403754', 'Long Thạnh, Phụng Hiệp, Hậu Giang'),
(7, 3, 'Ngọc Trâm', '2023-05-06 18:04:01', 'processing', 'Chưa thanh toán', 45000, '0798067056', 'Phường Xuân Khánh, Ninh Kiều, Cần Thơ');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `loaisach`
--

CREATE TABLE `loaisach` (
  `ma_loai_sach` char(10) NOT NULL,
  `ten_loai_sach` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `loaisach`
--

INSERT INTO `loaisach` (`ma_loai_sach`, `ten_loai_sach`) VALUES
('B01', 'Sách Giáo Khoa'),
('B02', 'Tiểu Thuyết'),
('B03', 'Truyện Tranh'),
('B04', 'Kỹ năng sống'),
('B05', 'Sách Ngoại Ngữ');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `nhaxuatban`
--

CREATE TABLE `nhaxuatban` (
  `ma_nxb` int(10) NOT NULL,
  `ten_nxb` varchar(255) NOT NULL,
  `sdt_nxb` char(10) NOT NULL,
  `dia_chi_nxb` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `nhaxuatban`
--

INSERT INTO `nhaxuatban` (`ma_nxb`, `ten_nxb`, `sdt_nxb`, `dia_chi_nxb`) VALUES
(1, 'Giáo Dục Việt Nam', '0233456756', '81 Trần Hưng Đạo, Hoàn Kiếm, Hà Nội'),
(2, 'NXB Hồng Đức', '0123456789', 'Đống Đa, Hà Nội'),
(3, 'NXB Đại Học Quốc Gia Hà Nội', '0987654321', 'Quận 1, Thành Phố Hồ Chí Minh'),
(4, 'NXB Văn Học', '0123456788', '20 Đ. Nam Kỳ Khởi Nghĩa, Phường 8, Quận 3, Thành phố Hồ Chí Minh'),
(5, 'NXB Kim Đồng', '0987654322', '55 Quang Trung, Hai Bà Trưng');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sach`
--

CREATE TABLE `sach` (
  `ma_sach` char(10) NOT NULL,
  `ten_sach` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `gia_sach` int(12) NOT NULL,
  `khuyen_mai` int(12) NOT NULL,
  `gia_khuyen_mai` int(12) NOT NULL,
  `mo_ta` text NOT NULL,
  `so_luong` int(12) NOT NULL,
  `sold` int(11) NOT NULL,
  `hinh_anh` varchar(128) NOT NULL,
  `anh_1` varchar(255) DEFAULT NULL,
  `anh_2` varchar(255) DEFAULT NULL,
  `ma_loai_sach` char(10) NOT NULL,
  `ma_tac_gia` int(10) NOT NULL,
  `ma_nxb` int(10) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `sach`
--

INSERT INTO `sach` (`ma_sach`, `ten_sach`, `gia_sach`, `khuyen_mai`, `gia_khuyen_mai`, `mo_ta`, `so_luong`, `sold`, `hinh_anh`, `anh_1`, `anh_2`, `ma_loai_sach`, `ma_tac_gia`, `ma_nxb`, `created_at`, `updated_at`) VALUES
('S01', 'Đắc Nhân Tâm (Tái bản lần thứ 10 năm 2022)', 70000, 10, 63000, '“Rất ít cuốn sách thật sự khiến bạn trở thành một con người tốt hơn. Cuốn sách này là một trong số đó.” - Chelsea Can\r\n\r\n', 74, 6, 'img-12.jpg', 'sgk12_1.jpg', 'sgk12_2.jpg', 'B04', 7, 4, '2023-05-07 06:23:23', '2023-05-07 06:23:23'),
('S02', 'Bài tập nâng cao Luyện thi đại học môn Toán', 56000, 0, 56000, 'Nhà sách Bookworm có hàng ngàn tựa sách, cam kết hoàn tiền nếu sách giả, nhiều mã giảm giá hôm nay. Mua ngay!', 186, 14, 'img-07.jpg', 'detail1.png', 'detail2.png', 'B01', 1, 1, '2023-05-07 06:25:07', '2023-05-07 06:25:07'),
('S03', 'Bên nhau trọn đời - Cuộc gặp gỡ định mệnh', 65000, 20, 52000, 'Sinh nhật lần thứ 14, Quan Tiểu Úc gặp tình yêu sét đánh tại Bule Pub. Anh chàng lạ mắt trông cao quý và hấp dẫn đã thu hút ánh nhìn và trái tim cô bé mới lớn. Rồi khi nhìn chàng trai xa lạ kia khoác vai người đẹp rời đi, “mối tình đầu thơ ngây” của cô bỗng tan thành mây khói.', 195, 5, 'img-01.jpg', 'detail4.jpg', 'sgk12_2.jpg', 'B02', 4, 4, '2023-05-07 06:29:22', '2023-05-07 06:29:22'),
('S04', 'Chuột Chinpui và những người bạn - Tập 1', 25000, 0, 25000, '“Chuột Chinpui” là truyện dài kì gần đây nhất của tôi. Sau Doraemon thì trong số những truyện tranh hài hước về cuộc sống hàng ngày, tôi muốn có một tác phẩm mang màu sắc dị thường một chút nên đã dồn rất nhiều tâm huyết để sáng tác “Chuột Chinpui”.', 16, 4, 'img-02.jpg', 'detail5.jpg', 'detail6.jpg', 'B03', 3, 5, '2023-05-07 06:31:49', '2023-05-07 06:31:49'),
('S05', 'Thỏ Bảy Màu Và Những Người Nghĩ Nó Là Bạn', 85000, 10, 76500, 'Thỏ Bảy Màu là một nhân vật hư cấu chẳng còn xa lạ gì với anh em dùng mạng xã hội với slogan “Nghe lời Thỏ, kiếp này coi như bỏ!”. Thỏ Bảy Màu đơn giản chỉ là một con thỏ trắng với sự dở hơi, ngang ngược nhưng đáng yêu vô cùng tận. Nó luôn nghĩ rằng mình không có cuộc sống và không có bạn bè. ', 48, 2, 'img-13.jpg', 'detail5.jpg', 'detail5.jpg', 'B03', 2, 1, '2023-05-03 16:18:22', '2023-05-03 16:18:22'),
('S06', 'Hôm Nay Cậu Ấy Cũng Thật Dễ Thương - Tập 1', 110000, 15, 93500, 'Câu chuyện xoay quanh mối nhân duyên bất ngờ giữa Thương Thư và Tề Lân. Thương Thư - một học bá lạnh lùng, có niềm đam mê với học hành. Hay nói cách khác, cô bị ám ảnh bởi việc học. Trái ngược hoàn toàn, Tề Lân là một nữ sinh có học lực kém, đôi khi ngốc nghếch đáng yêu nhưng lại là đàn chị có tiếng trong trường.', 197, 3, 'img-14.jpg', 'detail4.jpg', 'detail4.jpg', 'B03', 1, 1, '2023-05-06 18:03:02', '2023-05-06 18:03:02'),
('S07', 'Doraemon - Cuộc phiêu lưu đến vùng đất bí ẩn', 25000, 10, 22500, 'Chúng ta của hiện tại, đều chưa kịp lớn đã phải trưởng thành. Lúc còn nhỏ có thể khóc cười tuỳ ý. Trưởng thành rồi mới biết hành động cũng cần nhìn sắc mặt người khác. Lúc còn nhỏ có thể sống vô tư, vô lo. Trưởng thành rồi mới biết nếu chậm chân hơn người khác, chắc chắn sẽ bị đào thải bất cứ lúc nào.', 148, 2, 'img-04.jpg', 'detail1.png', 'detail2.png', 'B03', 3, 5, '2023-05-07 06:33:46', '2023-05-07 06:33:46'),
('S08', 'Kỹ năng phòng chống bạo lực học đường', 100000, 5, 95000, 'Những câu chuyện nhỏ xảy ra ở một ngôi làng nhỏ: chuyện người, chuyện cóc, chuyện ma, chuyện công chúa và hoàng tử , rồi chuyện đói ăn, cháy nhà, lụt lội,... ', 298, 2, 'img-10.jpg', 'detail1.png', 'thien_1.jpg', 'B04', 5, 2, '2023-05-07 06:35:22', '2023-05-07 06:35:22'),
('S10', 'Dưới cánh cửa thầm thì (Tái bản 2023)', 50000, 20, 40000, '“Tác phẩm mới nhất của Klune, người chiến thắng Giải thưởng Văn học Lambda, là một câu chuyện chiến thắng về nỗi đau, mất mát và bước tiếp. Độc giả sẽ khóc và bị mê hoặc bởi những nhân vật tuyệt vời của anh ấy.\"', 117, 3, 'img-18.jpg', 'detail5.jpg', 'detail6.jpg', 'B02', 2, 4, '2023-05-07 06:37:25', '2023-05-07 06:37:25'),
('S11', '50 đề minh họa môn Toán học 2023 (Tái bản)', 150000, 10, 135000, 'Gồm 45 đề thi minh hoạ do thầy Lê Văn Tuấn và thầy Nguyễn Thế Duy (tác giả của rất nhiều bộ sách ôn thi thpt môn Toán) biên soạn và 5 đề thi chính thức của bộ GDĐT các năm trước đây.', 100, 0, 'img-06.jpg', 'sgk12_1.jpg', 'sgk12_2.jpg', 'B01', 1, 1, '2023-05-07 06:39:24', '2023-05-07 06:39:24'),
('S12', 'Giới Hạn Của Bạn Chỉ Là Xuất Phát Điểm Của Tôi', 75000, 20, 60000, 'Giới hạn là gì? Giới hạn liệu có phải ranh giới an toàn của mỗi người?', 200, 0, 'img-11.jpg', 'sgk12_1.jpg', 'sgk12_2.jpg', 'B02', 6, 3, '2023-05-07 06:44:02', '2023-05-07 06:44:02'),
('S13', 'Sơn trà nở muộn (Tái bản lần thứ 5)', 40000, 10, 36000, 'Nếu mỗi cuốn tiểu thuyết được ví như thời gian trong một ngày, thì “Sơn Trà Nở Muộn” có lẽ đã được bắt đầu vào thời điểm tăm tối nhất, đó chính là nửa đêm.', 150, 0, 'img-19.jpg', 'detail1.png', 'detail2.png', 'B02', 2, 2, '2023-05-07 06:46:56', '2023-05-07 06:46:56');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tacgia`
--

CREATE TABLE `tacgia` (
  `ma_tac_gia` int(10) NOT NULL,
  `ten_tac_gia` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tacgia`
--

INSERT INTO `tacgia` (`ma_tac_gia`, `ten_tac_gia`) VALUES
(1, 'Bộ Giáo Dục Và Đào Tạo'),
(2, 'José Mauro de Vasconcelos'),
(3, 'Fujiko F Fujio'),
(4, 'Okura'),
(5, 'Huỳnh Thái Ngọc'),
(6, 'Lê Đỗ Quỳnh Hương'),
(7, 'Dale Carnegie');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` int(10) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` char(10) NOT NULL,
  `address` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `phone`, `address`, `created_at`, `updated_at`) VALUES
(2, 'Admin', 'admin@gmail.com', '$2y$10$WyMtvmxxvhAu8.XoXYEOAeMMqMYGOxiAWkrkjQyC2Rz/5dbeQcwJG', '0939819802', 'Trường Khánh, Long Thạnh, Phụng Hiệp, Hậu Giang', '2023-04-28 09:09:21', '2023-04-28 09:09:21'),
(3, 'Ngọc Trâm', 'ngoctram@gmail.com', '$2y$10$fIhKuqTdBLhHVvPsTeaDPudnh6FnpLEegy1jekWxgsrCmdYrH0tLO', '0902403754', 'Phường Xuân Khánh, Ninh Kiều, Cần Thơ', '2023-05-07 04:46:56', '2023-05-06 23:46:56');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `chitiethoadon`
--
ALTER TABLE `chitiethoadon`
  ADD PRIMARY KEY (`ma_hoa_don`,`ma_sach`);

--
-- Chỉ mục cho bảng `giohang`
--
ALTER TABLE `giohang`
  ADD PRIMARY KEY (`ma_sach`,`id`);

--
-- Chỉ mục cho bảng `hoadon`
--
ALTER TABLE `hoadon`
  ADD PRIMARY KEY (`ma_hoa_don`),
  ADD KEY `hoadon_ibfk_1` (`id`);

--
-- Chỉ mục cho bảng `loaisach`
--
ALTER TABLE `loaisach`
  ADD PRIMARY KEY (`ma_loai_sach`);

--
-- Chỉ mục cho bảng `nhaxuatban`
--
ALTER TABLE `nhaxuatban`
  ADD PRIMARY KEY (`ma_nxb`);

--
-- Chỉ mục cho bảng `sach`
--
ALTER TABLE `sach`
  ADD PRIMARY KEY (`ma_sach`),
  ADD KEY `sach_ibfk_1` (`ma_loai_sach`),
  ADD KEY `sanpham_ibfk_2` (`ma_tac_gia`),
  ADD KEY `sanpham_ibfk_3` (`ma_nxb`);

--
-- Chỉ mục cho bảng `tacgia`
--
ALTER TABLE `tacgia`
  ADD PRIMARY KEY (`ma_tac_gia`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `hoadon`
--
ALTER TABLE `hoadon`
  MODIFY `ma_hoa_don` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `giohang`
--
ALTER TABLE `giohang`
  ADD CONSTRAINT `giohang_ibfk_1` FOREIGN KEY (`id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `giohang_ibfk_2` FOREIGN KEY (`ma_sach`) REFERENCES `sach` (`ma_sach`);

--
-- Các ràng buộc cho bảng `hoadon`
--
ALTER TABLE `hoadon`
  ADD CONSTRAINT `hoadon_ibfk_1` FOREIGN KEY (`id`) REFERENCES `users` (`id`);

--
-- Các ràng buộc cho bảng `sach`
--
ALTER TABLE `sach`
  ADD CONSTRAINT `sach_ibfk_1` FOREIGN KEY (`ma_loai_sach`) REFERENCES `loaisach` (`ma_loai_sach`),
  ADD CONSTRAINT `sach_ibfk_2` FOREIGN KEY (`ma_tac_gia`) REFERENCES `tacgia` (`ma_tac_gia`),
  ADD CONSTRAINT `sach_ibfk_3` FOREIGN KEY (`ma_nxb`) REFERENCES `nhaxuatban` (`ma_nxb`),
  ADD CONSTRAINT `sanpham_ibfk_2` FOREIGN KEY (`ma_tac_gia`) REFERENCES `tacgia` (`ma_tac_gia`),
  ADD CONSTRAINT `sanpham_ibfk_3` FOREIGN KEY (`ma_nxb`) REFERENCES `nhaxuatban` (`ma_nxb`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
