---
name: spec-draft
description: Generate a spec draft from requirements and user stories. Structure must always include happy path, error paths, transaction boundaries, and open questions.
---

# spec-draft

## Khi nào dùng
- Khi cần chuyển user story, ghi chú requirement, hoặc lời giải thích miệng thành spec
- Khi muốn thống nhất cấu trúc của spec

## Input / output
- Input: requirement, và các section liên quan trong [`docs/domain/business_rules.md`](../../../docs/domain/business_rules.md)
- Output: `deliverables/01_requirements/{feature}.spec.md`

## Quy tắc tối thiểu phải giữ
- Section "Các điểm chưa chốt" **bắt buộc phải tồn tại** (rỗng thì vẫn giữ tiêu đề)
- Luồng error path phải có dung lượng bằng hoặc hơn happy path
- Không lấp business rule bằng suy đoán. Không rõ thì đưa sang mục chưa chốt
- Không viết code

Cấu trúc spec và thủ tục soạn chi tiết: xem [`reference.md`](reference.md).
