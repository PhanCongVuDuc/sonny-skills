# Pattern thiết kế, quy ước code

<!-- Tầng bán cố định: AI đề xuất ứng viên, và ghi lại những ví dụ thực tế mà tech lead đã duyệt. AI không được tự động sửa. -->
<!-- AI noi theo các pattern trong file này khi code mới (xem .claude/rules/domain-knowledge.md). -->
<!-- Khi áp dụng pattern mới thì "đề xuất" bổ sung vào đây sau khi đã review thiết kế. -->
<!-- Hãy giữ nguyên cấu trúc [REPLACE] và thay nội dung bằng ví dụ thực tế của project. -->

## Pattern kiến trúc

### [REPLACE: tên pattern (ví dụ: Repository Pattern)]

- **Lý do áp dụng**: [REPLACE: vì sao lại dùng pattern này]
- **Phạm vi áp dụng**: [REPLACE: áp dụng cho layer/module nào]
- **Ví dụ code**:

```[REPLACE: ngôn ngữ]
// [REPLACE: ví dụ code ngắn gọn]
```

- **Những điều không được làm**: [REPLACE: anti-pattern, những biến thể không được phép]

---

## Quy ước đặt tên

| Đối tượng | Quy ước | Ví dụ |
|---|---|---|
| [REPLACE: tên file] | [REPLACE: kebab-case / PascalCase / etc.] | [REPLACE: ví dụ] |
| [REPLACE: tên hàm] | [REPLACE] | [REPLACE] |
| [REPLACE: hằng số] | [REPLACE] | [REPLACE] |

---

## Pattern error handling

[REPLACE: phương châm error handling đã thống nhất trong project này, kèm ví dụ thực tế]

```[REPLACE: ngôn ngữ]
// [REPLACE: ví dụ error handling chuẩn]
```

---

## Pattern test

### [REPLACE: loại test (ví dụ: integration test)]

- **Công cụ**: [REPLACE]
- **Chỗ đặt file**: [REPLACE: ví dụ `tests/integration/**/*.test.ts`]
- **Phương châm fixture**: [REPLACE: cách tạo dữ liệu test]
- **Ví dụ thực tế**:

```[REPLACE: ngôn ngữ]
// [REPLACE: ví dụ code test]
```

---

## Pattern không còn khuyến nghị, đã bỏ

Những pattern từng dùng nhưng hiện không dùng nữa. Ghi rõ hướng xử lý khi bắt gặp trong code có sẵn.

| Pattern | Lý do bỏ | Thay thế bằng |
|---|---|---|
| [REPLACE] | [REPLACE] | [REPLACE] |
