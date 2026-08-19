---
description: Update the AI-facing docs (code_map / dependencies / module_index) from the latest git diff. Callable manually or from CI/CD.
---

Khởi động agent [`docs-keeper`](../agents/docs-keeper.md) để cập nhật bộ docs dành cho AI. Chi tiết vận hành xem [`docs/ai-docs.md`](../../docs/ai-docs.md).

Cách tiến hành:

1. **Lấy diff**: lấy thay đổi gần nhất (`HEAD~1..HEAD` hoặc branch của PR) bằng git diff
2. **Xác định phạm vi ảnh hưởng**: xét xem diff có ảnh hưởng tới 3 file sau không:
   - `docs/domain/generated/code_map.md`
   - `docs/domain/generated/dependencies.md`
   - `docs/domain/generated/module_index.md`
3. **Cập nhật kiểu merge diff**:
   - Giữ lại file cũ, chỉ merge phần thay đổi
   - Không ghi đè toàn văn
4. **Phát hiện thay đổi quy mô lớn**: nếu thay đổi lớn (trên 50 file / trên 1000 dòng) thì **dừng** cập nhật tự động và xuất báo cáo khuyến nghị cập nhật tay
5. **Xuất bản tóm tắt diff cập nhật**: `deliverables/00_onboarding/docs-update-{YYYY-MM-DD}.json`

Khi gọi từ CI/CD: dùng [`scripts/update-ai-docs.sh`](../../scripts/update-ai-docs.sh) hoặc [`scripts/update-ai-docs.ps1`](../../scripts/update-ai-docs.ps1). Muốn tự động hoá bằng GitHub Actions thì tham khảo [`.github/workflows/ai-docs.yml.example`](../../.github/workflows/ai-docs.yml.example) để thêm vào (**việc thêm mới CI/CD phải có người xác nhận**).

Tham số (tuỳ chọn): `$ARGUMENTS` nhận `--dry-run` (chỉ hiện diff) hoặc `--force` (chạy cả khi thay đổi quy mô lớn).
