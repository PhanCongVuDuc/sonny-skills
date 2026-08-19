# uncertainty-report ─ thủ tục chi tiết

## Định nghĩa phân loại ABCD

- **A**: suy đoán vì thiếu thông tin
- **B**: có nhiều cách diễn giải, đã chọn một trong số đó
- **C**: không rõ business rule nên làm theo hành vi thông thường
- **D**: hoàn toàn chưa hiểu

## Thủ tục
1. Đọc deliverable cần xét
2. Rà ra toàn bộ "những chỗ đã lấp bằng suy đoán vì thông tin không được nói rõ"
3. Phân loại vào một trong ABCD
4. Gắn `impact: high/medium/low` cho từng mục
5. Gắn "một câu hỏi nên hỏi người" cho từng mục
6. Xếp các mục có mức ảnh hưởng = high lên trên rồi xuất ra

## Ví dụ định dạng output

```json
{
  "agent": "uncertainty-auditor",
  "target": "deliverables/01_requirements/feature-X.spec.md",
  "items": [
    {
      "id": "A1",
      "class": "A",
      "content": "Định dạng của ID khách hàng (số hay chuỗi)",
      "guess": "Đã xử lý như kiểu số",
      "basis": "Suy đoán từ kiểu dữ liệu của bảng có sẵn",
      "question_for_human": "ID khách hàng xử lý đúng là kiểu số hay kiểu chuỗi?",
      "impact": "high"
    }
  ]
}
```

## Quy tắc chi tiết phải giữ
- Chỉ được trả về "không có suy đoán" khi thật sự làm hoàn toàn bằng thông tin đã nói rõ (cấm im lặng cho qua)
- Phân vân khi đánh giá mức ảnh hưởng thì chọn **cao hơn một bậc** (nghiêng về phía an toàn)
- Phân loại ABCD còn mập mờ thì để **D** (không giấu)
- "Câu hỏi nên hỏi người" phải là câu hỏi đóng (trả lời được bằng Yes/No hoặc bằng cách chọn phương án)
- Các mục có mức ảnh hưởng = high thì xếp lên trên, và sẽ là đối tượng human review của gate ①
