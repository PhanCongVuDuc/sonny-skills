---
description: "Phase 1: generate a spec draft from the requirements, and emit an assumptions report alongside"
---

Khởi động agent [`spec-drafter`](../agents/spec-drafter.md), sinh bản nháp spec theo cấu trúc của skill [`spec-draft`](../skills/spec-draft/SKILL.md).

Cách tiến hành:
1. Đọc file requirement mục tiêu `deliverables/01_requirements/{feature}.requirements.md`
2. Đọc các section liên quan trong [`docs/domain/business_rules.md`](../../docs/domain/business_rules.md)
3. Ghi bản nháp spec ra `{feature}.spec.md` (cố định 10 section, bắt buộc phải có mục "Các điểm chưa chốt")
4. Chạy tiếp [`uncertainty-auditor`](../agents/uncertainty-auditor.md) để sinh `{feature}.uncertainty.json`
5. **Human gate ①**: nhờ người dùng xác nhận các chỗ suy đoán có `impact: high` và mục "Các điểm chưa chốt"

Tham số (tuỳ chọn): truyền tên feature vào `$ARGUMENTS`.
