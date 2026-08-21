---
description: "Phase 2: generate a design-doc draft from the approved spec, then run per-perspective review and the devil's advocate pass"
---

Khởi động design phase.

Cách tiến hành:
1. **Kiểm tra tiền đề**: human gate ① (tính hợp lệ của spec) đã thông qua
2. Khởi động [`design-architect`](../agents/design-architect.md)
   - Input: `deliverables/01_requirements/{feature}.spec.md`, và những gì nằm dưới [`docs/domain/`](../../docs/domain/)
   - Output: `deliverables/02_design/{feature}.design.md`
   - Chỗ nào có nhiều phương án thì dùng skill [`design-decision`](../skills/design-decision/SKILL.md) để bày ra dưới dạng tranh luận
3. Gọi [`design-reviewer`](../agents/design-reviewer.md) **theo từng perspective**:
   - Chọn những cái cần trong `data-integrity` / `error-handling` / `transaction-boundary` / `security` / `non-functional`
   - Output: `deliverables/reviews/design-{perspective}-{feature}.json`
4. Gọi [`devils-advocate`](../agents/devils-advocate.md) để liệt kê các kịch bản thất bại
5. **Human gate ②**: xác nhận hướng xử lý cho các điểm `risk_level: high` và cho các kịch bản thất bại

Tham số (tuỳ chọn): truyền tên feature vào `$ARGUMENTS`.
