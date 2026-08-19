# rules/

Các file rule trong thư mục này được inject vào `.claude/rules/` của project.

Subagent② của `/arent-workflow:setup` sẽ phân tích các file ở đây và phát hiện xung đột với những rule đã có sẵn trong project.

## Danh sách file

### Rule path-scoped (frontmatter `paths:` — tự động load khi sửa file thuộc phạm vi)

- `database.md` — rule về thao tác DB và migration
- `api-design.md` — rule về thiết kế API endpoint
- `testing.md` — phương châm test và chiến lược mock
- `domain-knowledge.md` — rule về việc tham chiếu tri thức domain
- `lsp-navigation.md` — rule về việc điều hướng code bằng LSP

### Rule áp dụng toàn cục (không có `paths:` — luôn áp dụng)

- `security.md` — bảo mật (áp dụng cho mọi file)

### Rule dạng hợp đồng - contract (không có `paths:` — được từng agent / skill / command tham chiếu tường minh)

- `output-formats.md` — hợp đồng về định dạng có cấu trúc của deliverable (§1–§9)
- `gates.md` — tiêu chí phán định gate chuyển phase (gate tự động / human gate)
- `risk-categories.md` — định nghĩa chính thống của khoá perspective review, risk category, và mức nghiêm trọng

## Cách quản lý

Những rule này do plugin `arent-workflow` inject vào (nguồn chuẩn nằm ở `templates/inject/claude/rules/`). Việc lấy về phần plugin cập nhật thì làm bằng `/arent-workflow:re-setup` (phần sửa tay được bảo vệ bằng so sánh 3 chiều).
Rule bổ sung riêng của project thì cứ thêm thẳng vào `.claude/rules/` (chúng sẽ được giữ lại như phần nằm ngoài quản lý của plugin).
