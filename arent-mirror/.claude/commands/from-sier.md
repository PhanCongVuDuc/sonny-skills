---
description: Read a design doc received from an external party (e.g. an SIer), produce a derived spec, and move on to the implementation phase. Use as the Phase 1 entry point when /setup Q3 answered "design doc available".
---

Dùng làm cửa vào Phase 1 khi bạn trả lời "có design doc nhận từ SIer" ở Q3 của `/setup`. Lấy design doc nhận được làm input, tạo ra **derived spec** đủ để giao cho implementer.

Cách tiến hành:

1. **Xác nhận input**: xem mục bố trí Input trong CLAUDE.md để biết chỗ đặt "design doc SIer". Nhờ người dùng xác nhận file đã đủ chưa
2. Khởi động agent [`sier-spec-reader`](../agents/sier-spec-reader.md) (dùng skill [`sier-spec-mapping`](../skills/sier-spec-mapping/SKILL.md))
   - Output:
     - `deliverables/01_requirements/{feature}.derived-spec.md` (derived spec)
     - `deliverables/01_requirements/{feature}.sier-readout.json` (danh sách mâu thuẫn / chưa định nghĩa)
3. Chạy tiếp [`uncertainty-auditor`](../agents/uncertainty-auditor.md)
   - Output: `deliverables/01_requirements/{feature}.uncertainty.json`
4. **Human gate ①'**: nhờ người dùng xác nhận các mục sau
   - Hướng xử lý cho `issues` trong `sier-readout.json` (mâu thuẫn / chưa định nghĩa)
   - Xác nhận các mục `impact: high` trong `uncertainty.json`
5. Xác nhận xong thì dùng `/implement` để sang Phase 3

**Quan trọng:** không đưa thẳng design doc nhận được cho implementation agent. Luôn đi qua `derived-spec.md`. (Nếu để mâu thuẫn và chỗ chưa định nghĩa giữa các design doc lọt tới implementer, phần code viết theo suy đoán sẽ tăng lên.)

Tham số (tuỳ chọn): truyền tên feature vào `$ARGUMENTS`.
