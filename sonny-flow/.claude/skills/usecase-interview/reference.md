# usecase-interview ─ thủ tục chi tiết

## Thủ tục
1. Hỏi người dùng về ngành nghề, loại hệ thống, chức năng mục tiêu
2. Hỏi các perspective sau **theo thứ tự, mỗi lần 1 câu**:
   1. Rule về tính toán số, độ chính xác, và cách làm tròn
   2. Cách xử lý nghiệp vụ khi có lỗi, có ngoại lệ (bù trừ, thông báo, log)
   3. Ràng buộc về việc phát sinh, cập nhật, xoá dữ liệu
   4. Xử lý đặc biệt kiểu "chỉ khách hàng này", "chỉ thời điểm này"
   5. Tiền đề "hiển nhiên tới mức không ai ghi vào spec"
   6. Quy định pháp lý, quy tắc hành chính, tiêu chuẩn ngành
   7. Phụ thuộc về thứ tự xử lý (phải chạy theo thứ tự A→B, v.v.)
3. Với mỗi câu trả lời, nếu còn mơ hồ thì đào sâu tiếp trong cùng perspective (không tự chốt rồi nhảy sang perspective sau)
4. Xong hết thì xuất kết quả đã sắp xếp ra Markdown

## Cấu trúc Markdown output
- Danh sách use case
- Danh sách user story (As a / I want / So that)
- Các business rule ngầm đã moi ra được (theo từng category)
- Các mục chưa xác nhận (những điểm không kịp xác nhận trong buổi phỏng vấn)

## Quy tắc chi tiết phải giữ
- Không hỏi nhiều câu cùng lúc (1 hỏi 1 đáp)
- Không tự ý diễn giải hay tự bù đắp câu trả lời của người dùng
- Không tự suy đoán câu trả lời rồi bỏ qua câu hỏi
- Câu trả lời còn mơ hồ thì ra câu hỏi đào sâu (không tự chốt rồi nhảy sang perspective sau)
- Nếu tới bước sắp xếp sau phỏng vấn mới có suy đoán chen vào thì bắt buộc gắn `(suy đoán)`
