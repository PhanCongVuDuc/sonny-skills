# code-archeology ─ thủ tục chi tiết

## Thủ tục
1. Chỉ định code cần xét (theo file hoặc theo region)
2. Rút theo các perspective dưới đây (trọng tâm là "vì sao lại viết như thế", không phải "mô tả chức năng")
3. Phần suy đoán bắt buộc gắn `(suy đoán)`
4. Xuất kết quả có cấu trúc

## Các perspective cần rút

1. **Lý do nghiệp vụ** khiến đoạn code này tồn tại
2. Dấu vết của phán đoán và mẹo khi code (vì sao lại là cấu trúc này)
3. Chỗ có khả năng được thêm vào sau này (phong cách code không đồng nhất)
4. **Tiền đề ngầm, điều kiện tiên quyết** mà nó đang phụ thuộc vào
5. **Suy đoán về ý nghĩa nghiệp vụ** của magic number và các nhánh điều kiện đặc biệt
6. Chỗ sửa vào là rủi ro nhất, kèm lý do

## Cấu trúc output

```json
{
  "target": "src/domain/Pricing.ts",
  "items": [
    {
      "type": "business_rule_hint",
      "location": "Pricing.ts:42",
      "code_excerpt": "if (amount > 1000000) return amount * 0.95;",
      "interpretation": "Trên 1 triệu thì giảm 5% (lý do là suy đoán)",
      "confidence": "guess",
      "question_for_human": "Căn cứ nghiệp vụ của ngưỡng 1 triệu và mức giảm 5% là gì?"
    },
    {
      "type": "implicit_assumption",
      "location": "Order.ts:78",
      "interpretation": "Giả định ID khách hàng đã được kiểm tra trước khi gọi hàm",
      "confidence": "high",
      "question_for_human": null
    }
  ]
}
```

## Quy tắc chi tiết phải giữ
- Không "giải thích lại chức năng mà đọc code là biết" (tập trung vào **vì sao**)
- Bắt buộc phân biệt suy đoán với điều chắc chắn (`(suy đoán)` `(chắc chắn)` `(không rõ)`)
- Không sửa code (chỉ đọc)
- Phân biệt chỗ giải thích được bằng thông lệ ngành với chỗ là xử lý riêng của project này
- Luôn ý thức rằng kết quả rút ra **không được ghi đè thẳng vào `docs/domain/business_rules.md`** (bắt buộc đi qua human gate)
- Các mục `confidence: guess` chắc chắn sẽ bị kiểm ở human gate ⓪-3
