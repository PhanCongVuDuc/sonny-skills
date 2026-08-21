# design-decision ─ thủ tục chi tiết

## Tiến hành 3 bước

```
Step 1: đóng vai "người ủng hộ phương án A", đưa 3 lý do nên chọn A
Step 2: đóng vai "người ủng hộ phương án B", đưa 3 lý do nên chọn B
Step 3: đóng vai "trọng tài trung lập", sắp xếp 2 perspective mang tính quyết định nhất cho lựa chọn này
```

**Ở Step 3 không đưa ra kết luận**. Chỉ sắp xếp các perspective mang tính quyết định. Phán đoán cuối cùng do người làm.

## Ví dụ định dạng output

```markdown
# Quyết định thiết kế: chọn DB engine

## Các phương án
- A: PostgreSQL
- B: MySQL

## Điều kiện tiền đề
- Quy mô: 1 triệu bản ghi/năm
- Ràng buộc: bắt buộc vận hành on-premise
- Kỹ năng team: nhiều người có kinh nghiệm MySQL, ít người có kinh nghiệm PG

## Lập luận của người ủng hộ A
1. Hỗ trợ JSONB gốc nên dễ xử lý dữ liệu bán cấu trúc
2. Kết hợp ràng buộc khoá ngoại và trigger rất chắc chắn
3. CTE, hàm window có sẵn theo chuẩn

## Lập luận của người ủng hộ B
1. Team đã sẵn có kỹ năng và kinh nghiệm vận hành
2. Tài liệu về cấu hình replication rất phong phú
3. Có nhiều thực tế vận hành trên cả cloud lẫn on-premise

## Trọng tài trung lập: các perspective mang tính quyết định
1. Perspective: chi phí học của team (B có lợi)
2. Perspective: dư địa mở rộng data model về sau (A có lợi)
(Không đưa ra kết luận. Người sẽ quyết)
```

## Quy tắc chi tiết phải giữ
- Cấm AI phát biểu kết luận "bên nào tốt hơn"
- Lập luận của mỗi người ủng hộ phải ra đều tay, mỗi bên 3 điểm (để không bên nào bị mỏng)
- Với "perspective mang tính quyết định" thì gắn nhãn A có lợi / B có lợi / hoà
- Nếu điều kiện tiền đề còn thiếu thì báo lại bằng "(cần xác nhận)", không lấp bằng suy đoán
- Nếu có từ 3 phương án trở lên thì trước hết thu về 2 lựa chọn rồi áp dụng lặp lại
