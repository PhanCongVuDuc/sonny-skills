# test-scenario ─ thủ tục chi tiết

## Thủ tục
1. **Chốt level**: `unit` hay `e2e` (end-to-end). Cần cả hai thì chạy skill 2 lần
2. Đọc spec của chức năng mục tiêu (`{feature}.spec.md` hoặc `.derived-spec.md`)
3. Đọc `docs/domain/business_rules.md` để nắm các ranh giới của business rule
4. Sinh scenario theo category của từng level
5. Gắn các field bắt buộc cho từng scenario (xem dưới)
6. Ghi ra file JSON output

## Category theo từng level

### unit (unit test)
- `boundary-value` (0 bản ghi, số bản ghi tối đa, NULL, rỗng, số chữ số tối đa, số âm)
- `business-rule-boundary` (phần lẻ, đúng ngay ngưỡng, cuối kỳ, cuối tháng)
- `processing-order` (bỏ qua xử lý tiền đề)
- `partial-failure` (lỗi giữa chừng trong chuỗi nhiều bước)
- `concurrency` (chạy đồng thời, tranh chấp)

### e2e (end-to-end test)
- `user-flow-error` (bất thường trên luồng thao tác: quay lại giữa chừng, đóng, timeout)
- `cross-module-state` (nhất quán trạng thái xuyên module: chuỗi đơn hàng → tồn kho → hoá đơn)
- `integration-failure` (tích hợp ngoài thất bại: thanh toán, thông báo, xác thực)
- `auth-boundary` (ranh giới phân quyền: không nhìn thấy dữ liệu của người dùng khác)
- `data-leak` (có hiển thị dữ liệu ngoài quyền hay không)

## Field bắt buộc của từng scenario

- Chung: `id`, `category`, `name`, `preconditions`, `steps`, `expected`, **`miss_impact`**
- e2e thêm: `entry_point` (màn hình/URL/API), `actors` (ai là người thao tác)

## Quy tắc chi tiết phải giữ
- **Không xuất scenario happy path** (đó là phần AI giỏi nhất, nên để người tự thêm)
- Bắt buộc kèm 1 dòng `miss_impact` (ảnh hưởng nếu bỏ sót)
- Scenario nào không rõ business rule thì gắn `(cần xác nhận)`
- Sinh dựa trên spec (không nhìn code rồi suy ngược ra "hành vi lẽ ra phải thế")
- **Không trộn unit và e2e trong cùng 1 file** (sẽ làm rối phần viết test)
