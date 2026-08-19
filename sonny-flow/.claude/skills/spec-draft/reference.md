# spec-draft ─ thủ tục chi tiết

## Cấu trúc 10 section của bản nháp spec

```
1. Tổng quan chức năng (1–2 câu)
2. Điều kiện tiên quyết, trạng thái trước đó
3. Luồng happy path (có đánh số)
4. Luồng error path (các case lỗi và cách xử lý)
5. Định nghĩa input (tên mục, kiểu, bắt buộc/tuỳ chọn, validation)
6. Định nghĩa output (giá trị trả về, tác dụng phụ, dữ liệu bị cập nhật)
7. Business rule (công thức tính, điều kiện phán đoán, ràng buộc)
8. Transaction boundary (bắt buộc nếu đơn vị là API)
9. Tính idempotent (hành vi khi gửi cùng một request 2 lần)
10. Các điểm chưa chốt (những chỗ không quyết được vì thiếu thông tin, viết dưới dạng câu hỏi)
```

## Thủ tục
1. Input: requirement, các section liên quan trong `docs/domain/business_rules.md`
2. Sinh bản nháp theo 10 section ở trên
3. Xuất xong thì gọi [`uncertainty-auditor`](../../agents/uncertainty-auditor.md) để sinh `{feature}.uncertainty.json`

## Quy tắc chi tiết phải giữ
- Section "Các điểm chưa chốt" **bắt buộc phải tồn tại** (rỗng thì vẫn giữ tiêu đề)
- Luồng error path phải có dung lượng bằng hoặc hơn happy path
- Không lấp business rule bằng suy đoán. Không rõ thì đưa sang mục chưa chốt
- Không viết code
- Khuyến nghị mỗi section theo định dạng "mục → giải thích → ví dụ cụ thể"
- Định nghĩa input và định nghĩa output thì trình bày dạng bảng cho đều (để sau này dễ làm input cho `implementer`)
