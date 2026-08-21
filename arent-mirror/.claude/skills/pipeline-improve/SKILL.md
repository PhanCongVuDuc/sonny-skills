---
name: pipeline-improve
description: Analyse the "what humans corrected and why" log from the recent AI-driven development cycles, and emit rule and pipeline improvements in Before/After form.
---

# pipeline-improve

## Khi nào dùng
- Review định kỳ 3 tháng một lần (chu kỳ trong [`docs/agent-rules.md`](../../../docs/agent-rules.md))
- Khi cảm thấy AI lặp đi lặp lại cùng một loại lỗi
- Khi file rule đã phình lên

## Input / output
- Input: các mục `verdict: có vấn đề` trong `deliverables/reviews/*.json`, các mục `assumptions(risk: high)` trong `deliverables/03_implementation/*.report.json`, và git diff do người sửa lại
- Output: `deliverables/reviews/pipeline-improve-{YYYY-MM}.md` (định dạng [`.claude/rules/output-formats.md`](../../rules/output-formats.md) §7)

## Quy tắc tối thiểu phải giữ
- Bắt buộc đi tìm cả "rule có thể bỏ đi" (chỉ toàn thêm mới thì rule sẽ phình lên)
- Phương án sửa rule phải ra bằng **câu chữ cụ thể** (cấm diễn đạt trừu tượng kiểu "cần chú ý")
- Đọc các báo cáo cũ để kiểm tra xem có đang lặp lại đúng phương án cải thiện đó không
- **Không ghi thẳng** kết quả của skill này vào `.claude/agents/*.md` (bắt buộc có người duyệt)

Cách tiến hành phân tích: xem [`reference.md`](reference.md).
