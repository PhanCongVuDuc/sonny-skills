---
description: At end of session, produce a handoff file that lets the next session resume from the same state
---

<!--
Command này là custom slash command riêng của template này, không phải command built-in
chính thức của Claude Code.
Các cơ chế nối tiếp session mà bản chính thức cung cấp là:
  - `/compact` … nén lịch sử hội thoại trong cùng một session
  - `/recap`   … tóm tắt mà vẫn giữ cache
  - `--continue` / Resume … mở lại session trước
  - `CLAUDE.md` / auto memory … tài liệu chỉ dẫn thường trú của project và bộ nhớ vĩnh viễn
Command này khác mục đích với những cái trên: nó để lại phần handoff dưới dạng **file vĩnh viễn
có cấu trúc** trong `deliverables/handoff/`. Dùng khi bàn giao sang một session hoàn toàn khác:
khác ngày, khác máy, v.v.
Có thể dùng kèm `/compact` `/recap` chính thức nếu cần.
-->

Khởi động [`handoff-writer`](../agents/handoff-writer.md), dùng skill [`handoff`](../skills/handoff/SKILL.md) để sinh file handoff.

Cách tiến hành:
1. Phân loại công việc đã làm trong session này: xong / chưa xong / đang làm dở
2. Rút ra các sự kiện quan trọng: **chỗ đã bị người dùng sửa lại**, kết quả xác nhận business rule, các quyết định thiết kế đã chốt
3. Viết cụ thể, đánh số, những việc phải làm đầu tiên ở session sau
4. Ghi lại các lưu ý (chỗ nào bị nhiễu context, xử lý nào đã phải retry)
5. Ghi ra `deliverables/handoff/handoff-{YYYY-MM-DD}-{seq}.md`

Ở prompt đầu tiên của session mới, Read file này rồi mới làm tiếp.
