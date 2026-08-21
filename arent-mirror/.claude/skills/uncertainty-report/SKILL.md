---
name: uncertainty-report
description: Classify the assumptions inside a spec, design doc or implementation into A/B/C/D, and inventory them with impact ratings and confirmation questions.
---

# uncertainty-report

## Khi nào dùng
- Khi muốn lọc ra "cần kiểm cái gì" ở human review gate, sau khi có spec, design doc, hoặc sau khi code
- Khi muốn nhìn thấy được mức độ tự tin của AI

## Input / output
- Input: deliverable cần xét (spec, design doc, code)
- Output: `deliverables/{phase}/{target}.uncertainty.json` (định dạng [`.claude/rules/output-formats.md`](../../rules/output-formats.md) §3)

## Quy tắc tối thiểu phải giữ
- Chỉ được trả về "không có suy đoán" khi thật sự làm hoàn toàn bằng thông tin đã nói rõ (cấm im lặng cho qua)
- Phân vân khi đánh giá mức ảnh hưởng thì chọn **cao hơn một bậc** (nghiêng về phía an toàn)
- Phân loại còn mập mờ thì để **D** (không giấu)

Định nghĩa phân loại ABCD và thủ tục kiểm kê chi tiết: xem [`reference.md`](reference.md).
