---
description: "Phase 1: organise requirements, use cases and user stories through an interview, and emit an assumptions report alongside"
---

Khởi động agent [`requirements-organizer`](../agents/requirements-organizer.md), dùng skill [`usecase-interview`](../skills/usecase-interview/SKILL.md) để sắp xếp lại, bao gồm cả những business rule ngầm hiểu.

Cách tiến hành:
1. Xác nhận feature mục tiêu, ngành nghề, loại hệ thống
2. Đặt câu hỏi **từng cái một** (tính toán số → xử lý ngoại lệ → ràng buộc dữ liệu → trường hợp đặc biệt → tiền đề ngầm → quy định pháp lý → thứ tự xử lý)
3. Ghi kết quả đã sắp xếp ra `deliverables/01_requirements/{feature}.requirements.md`
4. Chạy tiếp [`uncertainty-auditor`](../agents/uncertainty-auditor.md) để sinh `deliverables/01_requirements/{feature}.uncertainty.json` (báo cáo các chỗ suy đoán — định dạng ở [`output-formats.md`](../rules/output-formats.md) §3)
5. Hỏi xem có gọi tiếp [`spec-drafter`](../agents/spec-drafter.md) không

Tham số (tuỳ chọn): có thể truyền tên feature vào `$ARGUMENTS`.
