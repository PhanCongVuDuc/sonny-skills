---
name: code-archeology
description: Extract the developer's intent, the business reason, and the implicit assumptions out of existing code. The workhorse skill for producing business-rule candidates in the /setup existing-analysis path.
---

# code-archeology

## Khi nào dùng
- Khi cần rút ra các business rule ứng viên trong existing-analysis path của /setup
- Khi muốn biết "vì sao lại viết như thế" đối với legacy code không có tài liệu
- Khi muốn hiểu "lý do nó đang chạy được" trước khi sửa

## Input / output
- Input: code cần xét (theo file hoặc theo region)
- Output:
  - Phase 0: `deliverables/00_onboarding/business-rules-candidates.json`
  - Khảo sát lẻ: `deliverables/00_onboarding/archeology-{target}.md`

## Quy tắc tối thiểu phải giữ
- Không "giải thích lại chức năng mà đọc code là biết" (tập trung vào **vì sao**)
- Bắt buộc phân biệt suy đoán với điều chắc chắn (`(suy đoán)` `(chắc chắn)` `(không rõ)`)
- Không sửa code (chỉ đọc)
- Kết quả rút ra **không được ghi đè thẳng vào `docs/domain/business_rules.md`** (bắt buộc đi qua human gate)

Perspective cần rút và cấu trúc output: xem [`reference.md`](reference.md).
