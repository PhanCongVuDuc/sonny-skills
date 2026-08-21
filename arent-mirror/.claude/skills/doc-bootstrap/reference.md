# doc-bootstrap ─ thủ tục chi tiết

## Thủ tục
1. Kiểm tra input:
   - `aggregation.json` của toàn bộ region đã đủ và có kèm `human_verdict` chưa
   - Chưa đủ thì dừng, và báo lại những region còn thiếu
2. Khởi động agent `docs-keeper` để **sinh lần đầu** 3 file sau:
   - `docs/domain/generated/code_map.md`
   - `docs/domain/generated/dependencies.md`
   - `docs/domain/generated/module_index.md`
3. Phương châm sinh:
   - **Chỉ phản ánh những mục `human_verdict: confirmed`**
   - Không phản ánh phần suy đoán (không trộn thông tin chưa chắc chắn vào tài liệu ban đầu)
   - Mỗi module 1–3 dòng (ưu tiên ngắn gọn)
   - Bắt buộc gắn **link qua lại** tới các module liên quan
   - Module rủi ro cao thì gắn **marker ⚠️** (chỉ riêng marker này được phép dùng emoji, như một ngoại lệ)
4. Xong thì xuất bản tóm tắt số lượng:
   - Số module đã phản ánh
   - Số mục không phản ánh (suy đoán, cần xác nhận, không rõ) kèm lý do

## Hướng dẫn cấu trúc của 3 file

### code_map.md
- Chia section theo region
- Mỗi module: path + trách nhiệm (1 dòng) + link liên quan

### dependencies.md
- Các điều cấm về vi phạm layer
- Nơi mà các module chính phụ thuộc vào (theo chiều xuôi)
- Phụ thuộc vòng và các chỗ cần chú ý (marker ⚠️)

### module_index.md
- Dạng bảng: tên chức năng / file chính / scenario liên quan / tham chiếu business rule

## Quy tắc chi tiết phải giữ
- **Chỉ dành cho lần sinh đầu tiên**. Không dùng cập nhật theo diff, mà sinh mới toàn văn (khi cập nhật thì dùng chế độ merge diff của `docs-keeper`)
- Không đưa thông tin suy đoán vào tài liệu ban đầu (chỉ những gì đã thành `confirmed` ở human gate ⓪-1)
- Nếu file đã tồn tại thì phải hỏi xác nhận ghi đè (cấm tự động ghi đè)
- Sinh xong bắt buộc đi tới human gate ⓪-2 (không tự động sang phase kế tiếp)
- Các mục không phản ánh (divergent / partial mà human_verdict chưa chốt, v.v.) thì ghi số lượng và lý do vào summary
