---
paths:
  - "Arent3d.Architecture.Routing*/**"
  - "Tests/**"
---

# Rule tham chiếu tri thức domain

Rule này tự động được áp dụng khi đọc/ghi các file thuộc project C# (`Arent3d.Architecture.Routing*` — Core / AppBase / Electrical.App / Presentation / Auth / RevitTest) và các file nằm dưới `Tests/`.

## Tài liệu bắt buộc tham chiếu trước khi code / thiết kế

Trước khi tạo mới hoặc sửa code, nếu các tài liệu sau tồn tại thì bắt buộc phải đọc:

1. **`docs/domain/business_rules.md`** — business rule, ràng buộc bất biến, công thức tính. Đây là căn cứ cho việc code.
2. **`docs/domain/glossary.md`** — định nghĩa thuật ngữ. Dùng để thống nhất từ ngữ trong tên biến, comment, tên API.
3. **`docs/domain/known_patterns.md`** — các pattern đã áp dụng. Code mới thì noi theo đây.
4. **`docs/domain/generated/code_map.md`** — bản đồ module. Dùng để nắm phạm vi ảnh hưởng.

Tài liệu không tồn tại thì bỏ qua cũng được, nhưng đã tồn tại thì không được bỏ qua.

## Tài liệu cần cân nhắc cập nhật sau khi code

- Phần nằm dưới `docs/domain/generated/` do agent `docs-keeper` tự động cập nhật (khi plugin `arent-workflow` đang bật).
- Nếu phát hiện business rule mới, sau khi code xong thì đề xuất bổ sung vào `docs/domain/business_rules.md`.
- Nếu áp dụng pattern thiết kế mới, thì đề xuất bổ sung vào `docs/domain/known_patterns.md`.

## Khi tài liệu và code mâu thuẫn nhau

1. Coi tài liệu (`business_rules.md`) là chuẩn, rồi cân nhắc hướng sửa code
2. Nếu không phán đoán được bên nào đúng, hỏi người dùng rồi mới đi tiếp
3. Nếu tài liệu rõ ràng đã cũ, thì đề xuất cập nhật (không tự động viết đè)
