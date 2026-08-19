# focused-review ─ thủ tục chi tiết

## Thủ tục chuẩn
1. Chốt đối tượng review (design doc hoặc code) và **đúng 1 perspective**
2. Khoá perspective thì chọn từ [`.claude/rules/risk-categories.md`](../../rules/risk-categories.md)
3. Khai triển perspective đó ra 3–5 điểm kiểm tra cụ thể rồi truyền vào
4. Nói rõ phần nằm ngoài phạm vi (quy ước đặt tên, happy path, hiệu năng, v.v.)
5. Xuất kết quả review theo 3 giá trị:

```json
{
  "items": [
    {"verdict": "có vấn đề", "location": "...", "issue": "...", "risk_level": "high"},
    {"verdict": "không vấn đề", "scope": "perspective đã kiểm tra"},
    {"verdict": "không kiểm chứng được", "reason": "chưa xác nhận business rule", "needed_info": "..."}
  ]
}
```

## Mẫu điểm kiểm tra theo từng perspective

### transaction-boundary
- Những chỗ lẽ ra nhiều thao tác DB phải nằm trong 1 transaction có bị tách ra không
- Đã định nghĩa xử lý khôi phục khi thất bại một phần chưa
- Có cần nested transaction không

### numeric-precision
- Trộn lẫn int/float với decimal
- Bị cắt cụt ngoài ý muốn do chia số nguyên
- Cách làm tròn có khớp business rule không

### error-business-logic
- Trong khối catch có gì ngoài "log đơn giản, re-throw exception" không
- Nhánh xử lý nghiệp vụ theo loại lỗi
- Việc ghi bảng khác, gửi thông báo, bù trừ khi có lỗi

### performance
- Query DB trong vòng lặp (N+1)
- Lấy toàn bộ rồi lọc ở phía app
- Nạp lượng lớn dữ liệu vào memory một lần

Các perspective khác thì tham chiếu thẳng [`.claude/rules/risk-categories.md`](../../rules/risk-categories.md).

## Quy tắc chi tiết phải giữ
- Nghiêm ngặt **1 lần gọi 1 perspective**
- Không xuất "điểm tốt" (chỉ nêu vấn đề)
- "Không vấn đề" cũng phải xuất kèm perspective đã xét
- Nhận ra vấn đề không thuộc perspective đang xét thì bỏ qua, xử lý ở lần gọi khác
- Bắt buộc gắn `risk_level: high/medium/low`
- Khi "không kiểm chứng được" thì phải nói rõ cần thông tin gì
