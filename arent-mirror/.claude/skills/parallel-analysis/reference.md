# parallel-analysis ─ thủ tục chi tiết

## Thủ tục
1. **Thu đối tượng về đúng 1 region** (không đưa toàn bộ code một lần). Định nghĩa region nằm ở `deliverables/00_onboarding/regions.json`
2. Khởi động `legacy-analyzer` 2 lần trong **session độc lập** (run-1, run-2). Truyền cùng một prompt
   - Dùng chung session thì context bị nhiễu và kết quả sẽ giống nhau. **Bắt buộc khác session**
   - Nếu dư sức thì tăng lên tới run-3 (khớp 3-of-3 là mức bảo đảm mạnh nhất cho confirmed)
3. Lưu kết quả từng run thành `analysis-run1.json`, `analysis-run2.json`
4. Khởi động `analysis-aggregator` để đối chiếu:
   - `confirmed`: cả hai khớp → mức tin cậy = cao
   - `divergent`: hai bên kết luận khác nhau → bắt buộc người review
   - `partial`: chỉ một bên nhắc tới → bắt buộc người review
5. Ở human gate chỉ kiểm `divergent` và `partial` (`confirmed` thì về cơ bản cho qua)

## Quy tắc chi tiết phải giữ
- Mỗi run **bắt buộc chạy trong session khác nhau** (chống nhiễu context)
- **Không đổi prompt** giữa các run (đổi là mất tính so sánh trong cùng điều kiện)
- Xem kết quả run rồi nghĩ "run thứ 3 thêm chút gợi ý nữa" thì để cái đó lại như một task phân tích riêng (không trộn vào cùng một lần đối chiếu)
- `confidence_rate` dưới 70% thì có khả năng việc chia region đang quá thô. Chia lại region rồi chạy lại
- Có nhận ra vấn đề vắt qua nhiều region cũng không viết vào báo cáo của region đang xét (nằm ngoài trách nhiệm của `legacy-analyzer`)

## Cách dùng confidence_rate

`confidence_rate` trong `aggregation.json` được tính bằng **(số mục confirmed) / (tổng số mục)**.

| confidence_rate | Diễn giải | Cách xử lý |
|---|---|---|
| ≥ 0.90 | Độ tin cậy của phân tích rất cao | Đi tới human gate như bình thường |
| 0.70 – 0.90 | Có độ tin cậy nhất định. Người review phần divergent/partial | Vận hành bình thường |
| < 0.70 | Chia region quá thô, hoặc code quá phức tạp | Cân nhắc chia region nhỏ hơn rồi chạy lại |
