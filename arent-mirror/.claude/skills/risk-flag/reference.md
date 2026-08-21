# risk-flag ─ thủ tục chi tiết

## Thủ tục
1. Đọc code (diff cũng được)
2. Rút ra những chỗ rơi vào các risk category dưới đây
3. Gắn `risk_level: high/medium/low` cho từng chỗ
4. Xuất theo cấu trúc JSON (field `human_review_required`)

## Risk category (đối tượng cần rút ra)

- `numeric-precision`: làm tròn, ép kiểu, chia số nguyên
- `transaction-boundary`: nhiều thao tác DB, thất bại một phần
- `error-business-logic`: business logic nằm trong catch
- `business-rule`: phụ thuộc vào business rule ngầm
- `concurrency`: bất đồng bộ, an toàn luồng
- `security`: xác thực, phân quyền, kiểm tra input, rò rỉ thông tin

Perspective chi tiết: xem [`.claude/rules/risk-categories.md`](../../rules/risk-categories.md).

## Định dạng output

```json
{
  "human_review_required": [
    {
      "location": "src/foo.ts:42",
      "category": "numeric-precision",
      "description": "Dùng float khi tính tiền. Cần xác nhận có phải thay bằng decimal không",
      "risk_level": "high",
      "question_for_human": "Yêu cầu về độ chính xác khi tính tiền là gì? (đơn vị nhỏ nhất là bao nhiêu?)"
    }
  ]
}
```

## Quy tắc chi tiết phải giữ
- Tiêu chí cắm flag phải khớp với [`.claude/rules/risk-categories.md`](../../rules/risk-categories.md)
- Bắt buộc kèm `question_for_human` (nói rõ khi người xem thì cần xác nhận cái gì)
- Khi trả về "không có flag" thì phải nói rõ các category đã kiểm tra (`confirmed_categories: [...]`)
- Các pattern trùng lặp tần suất cao (ví dụ: cùng loại vấn đề trong cùng một file) thì có thể gộp lại làm một
- Tiêu chí phán định `risk_level: high`: rơi vào một trong ba mục ảnh hưởng nghiệp vụ, hỏng dữ liệu, bảo mật
