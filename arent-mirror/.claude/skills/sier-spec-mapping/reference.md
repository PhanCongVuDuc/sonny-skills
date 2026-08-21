# sier-spec-mapping ─ thủ tục chi tiết

## Thủ tục
1. Xem mục bố trí Input trong CLAUDE.md để biết chỗ đặt design doc nhận được
2. Khởi động agent `sier-spec-reader` để đọc hiểu bộ design doc
3. Rút các perspective dưới đây theo **thứ tự cố định**
4. Chia output làm 2 phần:
   - **Derived spec** (chỉ dẫn code đã khai triển tới mức giao được cho implementer)
   - **issues** (mâu thuẫn, chỗ chưa định nghĩa, câu hỏi xác nhận)
5. Bắt buộc chạy song song skill `uncertainty-report` để xuất các chỗ suy đoán ra JSON riêng
6. Trong derived spec **bắt buộc gắn tham chiếu về design doc nhận được** (`source: inputs/sier-design/v1.2_basic-design.docx#3.2.1`)

## Các perspective cần rút (thứ tự cố định)

1. Input/output của chức năng (request, response, các mục trên màn hình)
2. Business rule (công thức tính, điều kiện phán đoán, ngưỡng)
3. Error handling (nêu rõ cả những cái không được viết trong doc)
4. Transaction boundary và tính idempotent
5. Các điểm mâu thuẫn giữa những design doc khác nhau
6. Tiền đề ngầm (những cái bị lược đi vì là thông lệ ngành)
7. Chỗ chưa định nghĩa (chỗ buộc phải chọn khi code nhưng doc không chỉ dẫn)

## Định dạng phần đầu của derived spec (derived-spec.md)

```markdown
# Derived spec của {feature}

## Nguồn
- inputs/sier-design/v1.2_basic-design.docx (chương 3.2.1–3.2.5)
- inputs/sier-design/v1.0_screen-definition.xlsx (sheet "Màn hình đơn hàng")

## Phiên bản của design doc nhận được
- Thiết kế cơ bản v1.2 (nhận ngày 2026-04-01)
- Định nghĩa màn hình v1.0 (nhận ngày 2026-04-01)

## Lưu ý
File này là bản khai triển design doc nhận được tới độ mịn có thể code được. Bản gốc xem ở inputs/sier-design/.
Mâu thuẫn và chỗ chưa định nghĩa thì xem file riêng {feature}.sier-readout.json.

---

(Từ đây trở xuống là 10 section giống cấu trúc spec thông thường)
```

## Quy tắc chi tiết phải giữ
- **Không tóm tắt, không diễn đạt lại** design doc nhận được. Chỉ rút thông tin cần cho việc code
- Không "tự giác" thêm những xử lý không có trong design doc
- Mâu thuẫn và chỗ chưa định nghĩa thì không đưa vào derived spec (dồn vào `issues`)
- Bắt buộc đi qua **human gate ①'**. Giải quyết xong `issues` rồi mới sang implementer
- Bắt buộc ghi rõ phiên bản của design doc nhận được ở đầu `derived-spec.md`
- Khi có nhiều phiên bản design doc thì ưu tiên bản mới nhất, nhưng vẫn ghi phần khác biệt so với bản cũ vào `version_diff`
