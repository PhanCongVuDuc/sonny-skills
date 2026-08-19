# handoff ─ thủ tục chi tiết

## Thủ tục
1. Phân loại công việc trong session hiện tại thành:
   - Xử lý đã hoàn thành
   - Xử lý chưa hoàn thành
   - Xử lý đang làm dở
2. Rút ra **các sự kiện quan trọng đã xác nhận trong session này**. Đặc biệt là:
   - Những chỗ AI hiểu sai lúc đầu rồi được sửa lại (chống tái phát ở session sau)
   - Kết quả xác nhận business rule
3. Viết cụ thể, đánh số, **những việc phải làm đầu tiên ở session sau**
4. Để lại ghi chép về các vấn đề phát sinh và về việc context bị nhiễu trong session này
5. Ghi ra file

## Định dạng output

```markdown
# File handoff ({ngày giờ})

## Trạng thái hiện tại
- Xử lý đã hoàn thành:
- Xử lý chưa hoàn thành:
- Xử lý đang làm dở:

## Sự kiện quan trọng đã xác nhận trong session này
- (Cách hiểu spec, các mục đã xác nhận về business rule, v.v.)
- (Ghi chép AI hiểu sai → được sửa lại)

## Việc phải làm đầu tiên ở session sau
1.
2.

## Lưu ý (vấn đề phát sinh trong session này và cách xử lý)
-
```

## Cách dùng khi bắt đầu session mới

Ở prompt đầu tiên của session mới, cho AI Read **file mới nhất** trong `deliverables/handoff/` để tái dựng nhận thức rồi mới bắt tay làm việc. Ví dụ cụ thể:

```
Tin nhắn đầu tiên của session mới:
"Đọc file mới nhất trong deliverables/handoff/ rồi tiếp tục công việc từ trạng thái đó."
```

## Quy tắc chi tiết phải giữ
- Bắt buộc có đủ tất cả 4 section (rỗng thì vẫn giữ tiêu đề)
- Trong "sự kiện quan trọng" bắt buộc viết những chỗ bị người dùng sửa lại
- Không đưa thông tin nhạy cảm (mật khẩu, token, v.v.) vào
- Suy đoán và tóm lược ở mức tối thiểu. Phủ đủ thông tin để session sau tái lập được
- Tên file đánh số thứ tự. Cùng ngày sinh nhiều lần thì `handoff-2026-05-19-1.md`, `handoff-2026-05-19-2.md`
