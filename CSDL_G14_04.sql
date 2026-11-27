-- Chay toan bo file bang SQL Server (SSMS hoac VS Code MSSQL).
USE master;
GO
IF DB_ID(N'CSDL_G14_04') IS NULL
    EXEC(N'CREATE DATABASE [CSDL_G14_04]');
GO
USE [CSDL_G14_04];
GO

SET XACT_ABORT ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;

-- Bang NhanSu theo mo hinh 14 bang trong kehoach.md.
IF OBJECT_ID(N'dbo.NhanSu', N'U') IS NOT NULL
    THROW 50000, N'This database already contains dbo.NhanSu.', 1;

BEGIN TRANSACTION;

CREATE TABLE dbo.PhongThiNghiem (
    MaPhong INT IDENTITY PRIMARY KEY,
    TenPhong NVARCHAR(150) NOT NULL UNIQUE,
    ViTri NVARCHAR(200) NOT NULL,
    MoTa NVARCHAR(500) NULL
);

CREATE TABLE dbo.NhanSu (
    MaNhanSu INT IDENTITY PRIMARY KEY,
    MaDinhDanh VARCHAR(20) NOT NULL UNIQUE,
    HoTen NVARCHAR(100) NOT NULL,
    Email VARCHAR(254) NOT NULL UNIQUE,
    LoaiNhanSu VARCHAR(20) NOT NULL CHECK (LoaiNhanSu IN ('SinhVien', 'GiangVien', 'KyThuatVien')),
    DonVi NVARCHAR(150) NOT NULL,
    DangHoatDong BIT NOT NULL DEFAULT (1)
);

CREATE TABLE dbo.ChungChi (
    MaChungChi INT IDENTITY PRIMARY KEY,
    TenChungChi NVARCHAR(150) NOT NULL UNIQUE,
    MoTa NVARCHAR(500) NULL
);

CREATE TABLE dbo.NhanSu_ChungChi (
    MaNhanSu INT NOT NULL REFERENCES dbo.NhanSu(MaNhanSu),
    MaChungChi INT NOT NULL REFERENCES dbo.ChungChi(MaChungChi),
    NgayCap DATE NOT NULL,
    NgayHetHan DATE NOT NULL,
    BiThuHoi BIT NOT NULL DEFAULT (0),
    PRIMARY KEY (MaNhanSu, MaChungChi, NgayCap),
    CHECK (NgayHetHan >= NgayCap)
);

CREATE TABLE dbo.QuyenTruyCap (
    MaQuyen INT IDENTITY PRIMARY KEY,
    MaNhanSu INT NOT NULL REFERENCES dbo.NhanSu(MaNhanSu),
    MaPhong INT NOT NULL REFERENCES dbo.PhongThiNghiem(MaPhong),
    TuNgay DATETIME2 NOT NULL,
    DenNgay DATETIME2 NOT NULL,
    BiThuHoi BIT NOT NULL DEFAULT (0),
    CHECK (DenNgay > TuNgay)
);

CREATE TABLE dbo.NhatKyRaVao (
    MaNhatKy INT IDENTITY PRIMARY KEY,
    MaQuyen INT NOT NULL REFERENCES dbo.QuyenTruyCap(MaQuyen),
    ThoiGianVao DATETIME2 NOT NULL,
    ThoiGianRa DATETIME2 NULL,
    CHECK (ThoiGianRa >= ThoiGianVao)
);

CREATE TABLE dbo.KhoanTaiTro (
    MaTaiTro INT IDENTITY PRIMARY KEY,
    TenKhoanTaiTro NVARCHAR(200) NOT NULL,
    DonViTaiTro NVARCHAR(200) NOT NULL,
    TongKinhPhi DECIMAL(18,2) NOT NULL CHECK (TongKinhPhi > 0),
    NgayBatDau DATE NOT NULL,
    NgayKetThuc DATE NOT NULL,
    CHECK (NgayKetThuc >= NgayBatDau)
);

CREATE TABLE dbo.DuAnNghienCuu (
    MaDuAn INT IDENTITY PRIMARY KEY,
    TenDuAn NVARCHAR(200) NOT NULL,
    MaChuNhiem INT NOT NULL REFERENCES dbo.NhanSu(MaNhanSu),
    NgayBatDau DATE NOT NULL,
    NgayKetThuc DATE NULL,
    TrangThai VARCHAR(20) NOT NULL CHECK (TrangThai IN ('ChuaBatDau', 'DangThucHien', 'HoanThanh', 'TamDung')),
    CHECK (NgayKetThuc >= NgayBatDau)
);

CREATE TABLE dbo.TaiTro_DuAn (
    MaTaiTro INT NOT NULL REFERENCES dbo.KhoanTaiTro(MaTaiTro),
    MaDuAn INT NOT NULL REFERENCES dbo.DuAnNghienCuu(MaDuAn),
    SoTienPhanBo DECIMAL(18,2) NOT NULL CHECK (SoTienPhanBo > 0),
    PRIMARY KEY (MaTaiTro, MaDuAn)
);

CREATE TABLE dbo.ThanhVienDuAn (
    MaDuAn INT NOT NULL REFERENCES dbo.DuAnNghienCuu(MaDuAn),
    MaNhanSu INT NOT NULL REFERENCES dbo.NhanSu(MaNhanSu),
    NgayThamGia DATE NOT NULL,
    VaiTro VARCHAR(20) NOT NULL CHECK (VaiTro IN ('NghienCuuVien', 'TroLy', 'KyThuat')),
    PRIMARY KEY (MaDuAn, MaNhanSu)
);

CREATE TABLE dbo.ThietBi (
    MaThietBi INT IDENTITY PRIMARY KEY,
    TenThietBi NVARCHAR(150) NOT NULL,
    MaPhong INT NOT NULL REFERENCES dbo.PhongThiNghiem(MaPhong),
    NgayDuaVaoSuDung DATE NOT NULL,
    TinhTrang VARCHAR(20) NOT NULL CHECK (TinhTrang IN ('SuDungDuoc', 'BaoTri', 'NgungSuDung'))
);

CREATE TABLE dbo.MuonTraThietBi (
    MaLuotMuon INT IDENTITY PRIMARY KEY,
    MaThietBi INT NOT NULL REFERENCES dbo.ThietBi(MaThietBi),
    MaNhanSu INT NOT NULL REFERENCES dbo.NhanSu(MaNhanSu),
    ThoiGianMuon DATETIME2 NOT NULL,
    HanTra DATETIME2 NOT NULL,
    ThoiGianTra DATETIME2 NULL,
    CHECK (HanTra > ThoiGianMuon),
    CHECK (ThoiGianTra >= ThoiGianMuon)
);

CREATE UNIQUE INDEX UX_MuonTraThietBi_DangMuon
    ON dbo.MuonTraThietBi(MaThietBi) WHERE ThoiGianTra IS NULL;

CREATE TABLE dbo.HoaChat (
    MaHoaChat INT IDENTITY PRIMARY KEY,
    TenHoaChat NVARCHAR(150) NOT NULL,
    MaPhong INT NOT NULL REFERENCES dbo.PhongThiNghiem(MaPhong),
    DonViTinh VARCHAR(3) NOT NULL CHECK (DonViTinh IN ('g', 'ml', 'mol')),
    SoLuongTon DECIMAL(18,3) NOT NULL CHECK (SoLuongTon >= 0),
    NguongToiThieu DECIMAL(18,3) NOT NULL CHECK (NguongToiThieu >= 0),
    LaNguyHiem BIT NOT NULL,
    DieuKienBaoQuan NVARCHAR(300) NOT NULL,
    MaChungChiBatBuoc INT NULL REFERENCES dbo.ChungChi(MaChungChi),
    UNIQUE (MaPhong, TenHoaChat),
    CHECK (LaNguyHiem = 0 OR MaChungChiBatBuoc IS NOT NULL)
);

CREATE TABLE dbo.XuatHoaChat (
    MaLuotXuat INT IDENTITY PRIMARY KEY,
    MaHoaChat INT NOT NULL REFERENCES dbo.HoaChat(MaHoaChat),
    MaNhanSu INT NOT NULL REFERENCES dbo.NhanSu(MaNhanSu),
    ThoiGianXuat DATETIME2 NOT NULL,
    SoLuongXuat DECIMAL(18,3) NOT NULL CHECK (SoLuongXuat > 0),
    MucDich NVARCHAR(300) NOT NULL
);

COMMIT TRANSACTION;
