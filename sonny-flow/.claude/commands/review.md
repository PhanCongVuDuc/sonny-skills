---
description: Review implementation code or design, one perspective at a time. Keep it to a single perspective per invocation (P1).
---

Khởi động [`implementation-reviewer`](../agents/implementation-reviewer.md) hoặc [`design-reviewer`](../agents/design-reviewer.md), **chỉ gói gọn trong 1 perspective**.
Dùng skill [`focused-review`](../skills/focused-review/SKILL.md), xuất kết quả có cấu trúc theo 3 giá trị `có vấn đề / không vấn đề / không kiểm chứng được`.

Cách tiến hành:
1. Chỉ định perspective (truyền qua `$ARGUMENTS`):
   - Review implementation: `transaction-boundary` / `error-business-logic` / `numeric-precision` / `performance` / `non-functional` / `security` / `spec-conformance` / `cross-file-flow` / `concurrency` / `config-branch`
   - Review design: `data-integrity` / `error-handling` / `transaction-boundary` / `security` / `non-functional`
2. Chỉ định đối tượng (diff / file / task ID)
3. Chạy review
   - Output: `deliverables/reviews/impl-{perspective}-{task_id}.json` hoặc `design-{perspective}-{feature}.json`
4. Thời điểm người xác nhận — chỉ với các mục `risk_level: high`:
   - **Review design**: xác nhận ngay tại chỗ với tư cách human gate ② → qua được thì sang `/implement`
   - **Review implementation**: trong Phase 3 chỉ lưu vào file kết quả. **Tới human gate ③ sau khi qua Phase 4 mới xác nhận, và phải xem kết quả review implementation do command này xuất ra (`deliverables/reviews/impl-{perspective}-{task_id}.json`) cùng lúc với kết quả chạy test** (định nghĩa giống trong `gates.md` / `test.md`)

Cần nhiều perspective thì gọi `/review` nhiều lần (**không xem nhiều perspective trong 1 lần gọi**).
