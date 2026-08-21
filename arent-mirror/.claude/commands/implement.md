---
description: "Phase 3: implement from the approved spec and design doc, and emit a self-check report in structured form"
---

Khởi động implementation phase.

Cách tiến hành:
1. **Kiểm tra tiền đề**: human gate ① và ② đã thông qua (nếu đi qua đường design doc nhận từ SIer thì chỉ cần ①')
2. Khởi động [`implementer`](../agents/implementer.md)
   - Input thông thường: `deliverables/01_requirements/{feature}.spec.md` + `deliverables/02_design/{feature}.design.md` + những gì nằm dưới [`docs/domain/`](../../docs/domain/)
   - Input khi đi qua design doc SIer: `deliverables/01_requirements/{feature}.derived-spec.md` + những gì nằm dưới [`docs/domain/`](../../docs/domain/)
   - Trước khi code, bắt buộc cho nó đọc các phần liên quan trong [`docs/domain/generated/code_map.md`](../../docs/domain/generated/code_map.md) và [`module_index.md`](../../docs/domain/generated/module_index.md)
   - Output: code + `deliverables/03_implementation/{task_id}.report.json` (định dạng theo [`.claude/rules/output-formats.md`](../rules/output-formats.md) §1)
   - Khi code, bắt buộc dùng skill [`risk-flag`](../skills/risk-flag/SKILL.md) để điền `human_review_required`
3. Kiểm tra **automated gate** của báo cáo ([`.claude/rules/gates.md`](../rules/gates.md), gate ③):
   - Có phải `status: completed` không
   - Có phải `todo_remaining: 0` không
   - `assumptions` có `risk: high` bằng 0, hoặc đã được duyệt, hay không
4. Chạy tiếp `/review` để sang bước review theo từng perspective

Tham số (tuỳ chọn): truyền task ID / tên feature vào `$ARGUMENTS`.
