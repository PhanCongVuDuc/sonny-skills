---
name: focused-review
description: Review a design or code narrowed to exactly one perspective. State what is out of scope, and emit structured output in three values: issue found / no issue / cannot verify.
---

# focused-review

## Khi nào dùng
- Khi bạn định nói "review toàn bộ giúp tôi" (→ hãy thu hẹp lại perspective)
- Khi muốn kiểm tra tập trung vào một perspective cụ thể (transaction boundary, độ chính xác số, v.v.)
- Khi gọi `design-reviewer` hoặc `implementation-reviewer`

## Input / output
- Input: đối tượng review + **đúng 1 perspective** (chọn từ [`.claude/rules/risk-categories.md`](../../rules/risk-categories.md))
- Output:
  - Design: `deliverables/reviews/design-{perspective}-{feature}.json`
  - Implementation: `deliverables/reviews/impl-{perspective}-{task_id}.json`
- Định dạng: [`.claude/rules/output-formats.md`](../../rules/output-formats.md) §2 (3 giá trị `verdict: có vấn đề / không vấn đề / không kiểm chứng được`)

## Quy tắc tối thiểu phải giữ
- Nghiêm ngặt **1 lần gọi 1 perspective**
- Không xuất "điểm tốt" (chỉ nêu vấn đề)
- "Không vấn đề" cũng phải xuất kèm perspective đã xét (không im lặng cho qua)
- Nhận ra vấn đề không thuộc perspective đang xét thì bỏ qua, xử lý ở lần gọi khác

Điểm kiểm tra chi tiết theo từng perspective: xem [`reference.md`](reference.md).
