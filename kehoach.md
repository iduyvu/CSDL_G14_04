# Kế hoạch học tập và ôn luyện chi tiết
## Đề tài 4: Hệ thống theo dõi tài sản nghiên cứu & phòng thí nghiệm đại học

---

### 1. Yêu cầu chính của đề tài

*   **Bối cảnh:** Theo dõi các khoản tài trợ nghiên cứu, thiết bị phòng thí nghiệm, kho hóa chất và nhật ký ra vào của sinh viên/giảng viên.
*   **Thách thức CSDL:** Thiết lập các ràng buộc toàn vẹn nghiêm ngặt (ví dụ: chỉ nhân sự được cấp chứng chỉ mới được tiếp cận vật liệu nguy hiểm) thông qua SQL Trigger.
*   **Các mô hình áp dụng:** Sử dụng mô hình ER và EER (phân lớp *specialization* và tổng quát hóa *generalization*).

---

### 2. Lộ trình học tập & Thực hiện (4 Tuần)

#### Tuần 1: Khảo sát & Phân tích Yêu cầu (Database Requirement Specification)
*   **Mục tiêu:** Xác định đầy đủ các thực thể, thuộc tính và quy tắc nghiệp vụ trong phạm vi đề tài.
*   **Công việc:**
    *   **Xác định các thực thể chính:**
        *   *Con người:* Nhân sự (Giảng viên, Sinh viên, Kỹ thuật viên), Chứng chỉ/Cấp độ truy cập.
        *   *Tài sản & Tài nguyên:* Thiết bị phòng thí nghiệm, Hóa chất/Vật liệu nguy hiểm.
        *   *Nghiên cứu & Tài chính:* Khoản tài trợ (Grant), Dự án nghiên cứu.
        *   *Hoạt động:* Nhật ký ra/vào (Access Log), Lịch sử sử dụng/mượn thiết bị.
    *   **Viết tài liệu:** Xác lập yêu cầu chi tiết (Requirement Specification) theo mẫu báo cáo.

#### Tuần 2: Thiết kế Mô hình Conceptual (ER & EER Diagram)
*   **Mục tiêu:** Áp dụng mô hình ER/EER để thể hiện đầy đủ cấu trúc dữ liệu.
*   **Công việc:**
    *   **Áp dụng Phân lớp (Specialization) & Tổng quát hóa (Generalization):**
        *   Thực thể cha `NhanSu` ➔ Thực thể con: `GiangVien`, `SinhVien`, `KyThuatVien`.
        *   Thực thể cha `TaiSan` ➔ Thực thể con: `ThietBi`, `HoaChat` *(có thuộc tính riêng về độ nguy hiểm, điều kiện bảo quản)*.
    *   **Xác định Mối quan hệ:**
        *   `NhanSu` — Sở hữu/Được cấp — `ChungChi`.
        *   `NhanSu` — Truy cập — `PhongThiNghiem` (qua `NhatKyRaVao`).
        *   `KhoanTaiTro` — Tài trợ — `DuAnNghienCuu`.
    *   **Kiểm tra:** Các ràng buộc về tính toàn vẹn và bội số quan hệ (Cardinality Constraints).

#### Tuần 3: Chuyển đổi sang Mô hình Logical & Thiết kế Trigger
*   **Mục tiêu:** Chuyển đổi sơ đồ EER sang Quan hệ (Relational Schema), chuẩn hóa CSDL và viết SQL Trigger.
*   **Công việc:**
    *   **Chuyển đổi EER ➔ Bảng SQL:** Xác định Khóa chính (Primary Key), Khóa ngoại (Foreign Key).
    *   **Chuẩn hóa dữ liệu:** Đảm bảo các bảng đạt dạng chuẩn 3NF hoặc BCNF.
    *   **Xây dựng SQL Trigger (Yêu cầu cốt lõi):**
        *   *Trigger 1 (Kiểm tra quyền truy cập vật liệu nguy hiểm):* Trước khi thêm lượt cấp/mượn hóa chất nguy hiểm cho một nhân sự, kiểm tra nhân sự đó đã có chứng chỉ tương ứng chưa. Nếu chưa ➔ Báo lỗi và hủy giao dịch (ROLLBACK).
        *   *Trigger 2 (Cập nhật số lượng kho hóa chất):* Tự động giảm số lượng tồn kho khi hóa chất được xuất dùng và cảnh báo khi chạm ngưỡng tối thiểu.
        *   *Trigger 3 (Nhật ký ra vào):* Kiểm tra thời hạn hiệu lực của thẻ/quyền truy cập trước khi ghi nhật ký ra vào.

#### Tuần 4: Hoàn thiện Báo cáo & Chuẩn bị Bảo vệ
*   **Mục tiêu:** Hoàn thiện báo cáo kỹ thuật và kiểm thử CSDL.
*   **Công việc:**
    *   **Kiểm thử:** Áp dụng dữ liệu mẫu (Dummy Data) để test toàn bộ các kịch bản sử dụng và Trigger.
    *   **Tài liệu:** Tuân thủ cấu trúc và chuẩn mực tài liệu kỹ thuật theo mẫu được giao.
    *   **Thuyết trình:** Chuẩn bị slide trình chiếu và phân công phần trình bày cho 3 thành viên trong nhóm.

---

### 3. Các chủ đề lý thuyết cần tập trung ôn luyện

*   **Chương 4 (Mô hình ER/EER):** Kỹ năng vẽ sơ đồ ER, khái niệm Phân lớp (Specialization), Tổng quát hóa (Generalization), Disjoint/Overlap, Total/Partial Completeness.
*   **Lý thuyết Chuẩn hóa:** Các dạng chuẩn 1NF, 2NF, 3NF, BCNF.
*   **Ngôn ngữ SQL & Stored Procedures/Triggers:** Cú pháp viết Trigger trong hệ quản trị CSDL (PostgreSQL, MySQL, hoặc MS SQL Server), cách xử lý ngoại lệ (RAISE ERROR / SIGNAL SQLSTATE).
