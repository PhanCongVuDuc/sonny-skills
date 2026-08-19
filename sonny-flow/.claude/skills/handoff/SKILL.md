---
name: handoff
description: At end of session, produce a handoff file that lets the next session resume from the same state. Always record the important misunderstandings that got corrected.
---

# handoff

## Khi nào dùng
- Khi cần ngắt session hiện tại trong một task dài hạn
- Khi context đã phình lên
- Khi AI hiểu sai lệch và muốn chuyển sang session mới

## Input / output
- Input: toàn bộ hội thoại, nội dung đã sửa, tình trạng công việc hiện tại
- Output: `deliverables/handoff/handoff-{YYYY-MM-DD}-{seq}.md` (định dạng [`.claude/rules/output-formats.md`](../../rules/output-formats.md) §6)

## Quy tắc tối thiểu phải giữ
- **Bắt buộc có đủ tất cả** 4 section (trạng thái hiện tại / sự kiện quan trọng / việc làm tiếp / lưu ý) — rỗng thì vẫn giữ tiêu đề
- Trong "sự kiện quan trọng" bắt buộc viết **những chỗ bị người dùng sửa lại**
- Không đưa thông tin nhạy cảm (mật khẩu, token) vào

Thủ tục nạp lại ở session mới: xem [`reference.md`](reference.md).
