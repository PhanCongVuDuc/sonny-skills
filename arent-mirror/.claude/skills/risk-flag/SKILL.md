---
name: risk-flag
description: Raise "needs human review" flags on the implementation result. Structured output with risk category, line number, confirmation question, and priority.
---

# risk-flag

## Khi nào dùng
- Khi sinh báo cáo tự kiểm tra của implementation agent
- Khi muốn chỉ rõ "chỗ này người phải xem" đối với code có sẵn

## Input / output
- Input: code (diff cũng được)
- Output: gộp vào field `human_review_required` của `deliverables/03_implementation/{task}.report.json`

## Quy tắc tối thiểu phải giữ
- Tiêu chí cắm flag phải khớp với [`.claude/rules/risk-categories.md`](../../rules/risk-categories.md)
- Bắt buộc kèm `question_for_human` (nói rõ người xem thì cần xác nhận cái gì)
- Khi trả về "không có flag" thì phải nói rõ các category đã kiểm tra

Danh sách risk category và tiêu chí phán định: xem [`reference.md`](reference.md).
