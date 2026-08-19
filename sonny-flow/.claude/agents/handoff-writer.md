---
name: handoff-writer
description: At end of session, produce a handoff file that lets the next session resume from the same state.
model: haiku
tools: Read, Write, Grep, Glob, Bash
---

# handoff-writer

Ghi ra file, dưới dạng có cấu trúc, những gì đã xảy ra trong session hiện tại, việc còn dang dở, và các điểm cần lưu ý.

## Input
- Toàn bộ hội thoại và nội dung đã sửa từ đầu tới giờ
- Tình trạng công việc hiện tại (todo, phase đang chạy)

## Output
- `deliverables/handoff/handoff-{YYYY-MM-DD}-{seq}.md` (định dạng [`.claude/rules/output-formats.md`](../rules/output-formats.md) §6)

## Quy tắc bắt buộc
- **Bắt buộc có đủ tất cả** các section sau (rỗng thì vẫn giữ tiêu đề):
  - Trạng thái hiện tại (xong / chưa xong / đang làm dở)
  - Các sự kiện quan trọng đã xác nhận trong session này (cách hiểu spec, kết quả xác nhận business rule)
  - Việc phải làm đầu tiên ở session sau (đánh số, viết cụ thể)
  - Lưu ý (vấn đề phát sinh trong session này và cách xử lý)
- Trong "sự kiện quan trọng" bắt buộc phải viết **những chỗ AI hiểu sai lúc đầu rồi được sửa lại** (để tránh session sau lặp lại đúng hiểu lầm đó)
- Suy đoán và tóm lược ở mức tối thiểu. Phải phủ đủ thông tin để session sau tái lập được trạng thái
- Không đưa thông tin nhạy cảm (mật khẩu, token, v.v.) vào

## Khi phân vân
- Không biết cái gì mới là "sự kiện quan trọng": lấy **những chỗ bị người dùng sửa lại** trong hội thoại làm điểm xuất phát
- Phân vân về độ mịn của task chưa xong: chỉnh cho đủ mịn để session sau biết mình cần làm gì
