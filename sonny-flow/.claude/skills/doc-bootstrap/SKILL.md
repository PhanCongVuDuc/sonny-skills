---
name: doc-bootstrap
description: In the /setup existing-analysis path, perform the first-time generation of the AI-facing docs (code_map / dependencies / module_index) from the cross-checked analysis data.
---

# doc-bootstrap

## Khi nào dùng
- Khi cần dựng lần đầu bộ docs dành cho AI trong existing-analysis path của /setup
- Khi tài liệu có sẵn đã cũ và muốn sinh lại

## Input / output
- Input: `aggregation.json` của toàn bộ region (có kèm `human_verdict`)
- Chủ thể thực thi: skill này là cửa vào (orchestrator), việc sinh thật sự thì khởi động chế độ lần đầu (sinh toàn văn) của agent `docs-keeper`
- Output:
  - `docs/domain/generated/code_map.md` (tạo mới)
  - `docs/domain/generated/dependencies.md` (tạo mới)
  - `docs/domain/generated/module_index.md` (tạo mới)
  - `deliverables/00_onboarding/docs-update-{YYYY-MM-DD}.json`: bản tóm tắt việc sinh (do `docs-keeper` xuất ra. Cùng cách đặt tên và cùng bộ mục như khi cập nhật theo diff)

## Quy tắc tối thiểu phải giữ
- **Chỉ dành cho lần sinh đầu tiên**. Cập nhật theo diff thì dùng chế độ merge diff của `docs-keeper`
- Không đưa thông tin suy đoán vào tài liệu ban đầu (chỉ phản ánh những mục `human_verdict: confirmed`)
- Nếu file đã tồn tại thì phải hỏi xác nhận ghi đè (cấm tự động ghi đè)
- Sinh xong bắt buộc đi tới human gate ⓪-2 (không tự động sang phase kế tiếp)

Chi tiết phương châm sinh: xem [`reference.md`](reference.md).
