# Vận hành tài liệu dành cho AI (ai-docs)

Định nghĩa rule vận hành cho **tầng sinh tự động** (tài liệu dành cho AI) trong `docs/domain/generated/`.
Command `docs-update`, agent `docs-keeper`, và `scripts/update-ai-docs.*` đều tuân theo rule này.

---

## File thuộc phạm vi (tầng sinh tự động)

Chỉ mỗi agent `docs-keeper` được sửa. **Con người không sửa tay** (sẽ bị ghi đè ở lần cập nhật sau).

| File | Nội dung |
|---|---|
| `docs/domain/generated/code_map.md` | Bản đồ module, class, hàm (1 module = vài dòng + link liên quan) |
| `docs/domain/generated/dependencies.md` | Đồ thị phụ thuộc |
| `docs/domain/generated/module_index.md` | Danh sách entry point và API công khai |

> Business rule (`business_rules.md`), lựa chọn công nghệ (`tech_stack.md`), thuật ngữ (`glossary.md`) là
> **bản chính thống do con người quản lý**, không thuộc phạm vi sinh tự động. Phân chia vai trò: xem [`docs/domain/README.md`](domain/README.md).

---

## Luồng cập nhật

1. **Khởi động**: thủ công (`/arent-workflow:docs-update`) / hook (dry-run sau `Edit`, `Write`) / CI (nói ở dưới).
2. **Lấy diff**: lấy thay đổi gần nhất (`HEAD~1..HEAD` hoặc branch của PR) bằng `git diff`.
3. **Xác định ảnh hưởng**: xét xem diff có ảnh hưởng tới 3 file trên không.
4. **Cập nhật kiểu merge diff**: giữ lại phần đã có, chỉ merge phần thay đổi (**không ghi đè toàn văn**).
5. **Phát hiện thay đổi quy mô lớn**: trên 50 file / trên 1000 dòng thì **dừng cập nhật tự động** và xuất báo cáo khuyến nghị cập nhật tay.
6. **Xuất bản tóm tắt**: `deliverables/00_onboarding/docs-update-{YYYY-MM-DD}.json`.

Tham số: `--dry-run` (chỉ hiện diff) / `--force` (chạy cả khi thay đổi quy mô lớn).

---

## Các đường khởi động

| Đường | Command |
|---|---|
| Thủ công (trong Claude Code) | `/arent-workflow:docs-update` (khởi động `docs-keeper`) |
| Hook (tự động dry-run) | `scripts/update-ai-docs.sh dry-run` sau `Edit`/`Write` (hook PostToolUse của plugin) |
| Chạy gộp ở máy local | `scripts/update-ai-docs.sh force` (macOS/Linux) / `scripts/update-ai-docs.ps1 force` (Windows) |
| CI/CD (tuỳ chọn) | Tham khảo `.github/workflows/ai-docs.yml.example` để thêm vào (**việc thêm mới CI/CD phải có người xác nhận**) |

---

## Rule mà docs-keeper phải giữ

- Không phản ánh những mục người chưa duyệt (`human_verdict` trong `aggregation.json` còn trống).
- File đã có thì merge diff. Khi mâu thuẫn thì không ghi đè, giữ cả hai và gắn `// TODO: docs-keeper review`.
- Giữ cấu trúc dễ cho AI tra cứu (1 module vài dòng, bắt buộc có link liên quan, module rủi ro cao thì làm nổi bật).
- Vượt 500 dòng thì tách theo chủ đề và biến `code_map.md` thành mục lục.
- Không đụng tới business rule (phần đó do người quản lý trong `business_rules.md`).
