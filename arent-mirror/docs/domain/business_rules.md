# Business rule

<!-- File này là bản chính thống do người (chuyên môn nghiệp vụ) quản lý. AI chỉ đọc. -->
<!-- AI bắt buộc tham chiếu file này làm căn cứ khi code và thiết kế (xem .claude/rules/domain-knowledge.md). -->
<!-- AI sẽ rút ứng viên ở phase code-archeology của /arent-workflow:onboarding và "đề xuất" phần bổ sung, nhưng việc phản ánh chỉ diễn ra sau khi người duyệt (cấm tự động ghi đè). -->
<!-- Hãy thay các section [REPLACE] bằng nội dung riêng của project. -->

## Tổng quan hệ thống

[REPLACE: mô tả trong 1–3 đoạn về mảng nghiệp vụ mà hệ thống này xử lý và các trách nhiệm chính.]

---

## Ràng buộc bất biến

Những rule về mặt nghiệp vụ tuyệt đối không được phá. Được ưu tiên hơn sự tiện lợi khi code.

### [REPLACE: tên rule 1]

- **Điều kiện**: [REPLACE: áp dụng trong tình huống nào]
- **Ràng buộc**: [REPLACE: cái gì bị cấm, cái gì bắt buộc]
- **Lý do**: [REPLACE: vì sao rule này tồn tại (quy định pháp lý, hợp đồng, thông lệ ngành, v.v.)]

### [REPLACE: tên rule 2]

- **Điều kiện**:
- **Ràng buộc**:
- **Lý do**:

---

## Công thức tính, logic tổng hợp

Ghi vào đây khi có công thức tính tường minh cho số tiền, số lượng, điểm số, v.v.

### [REPLACE: tên phép tính]

```
[REPLACE: viết công thức bằng mã giả hoặc công thức toán]
Ví dụ:
Tổng tiền = Σ(đơn giá × số lượng) × (1 - tỷ lệ giảm giá)
Thuế tiêu thụ = Tổng tiền × thuế suất (phần lẻ thì cắt xuống)
```

- **Điều kiện áp dụng**: [REPLACE]
- **Ngoại lệ**: [REPLACE: các case làm phép tính thay đổi]

---

## Chuyển trạng thái

Định nghĩa các trạng thái mà entity có thể có, và các chuyển đổi được phép.

### [REPLACE: tên entity]

```
[REPLACE: vẽ sơ đồ chuyển trạng thái bằng ASCII hoặc Mermaid]
Ví dụ:
draft → submitted → approved → closed
       ↓
     rejected → draft (sửa xong nộp lại)
```

| Chuyển đổi | Điều kiện | Role được phép |
|---|---|---|
| draft → submitted | [REPLACE] | [REPLACE] |
| submitted → approved | [REPLACE] | [REPLACE] |

---

## Xử lý ngoại lệ, edge case

Liệt kê các case nghiệp vụ đi chệch khỏi luồng thông thường.

| Case | Điều kiện phát sinh | Hành vi mong đợi |
|---|---|---|
| [REPLACE] | [REPLACE] | [REPLACE] |

---

## Phụ thuộc hệ thống ngoài, quy định pháp lý

Các business rule phụ thuộc vào API ngoài, quy định pháp lý, hoặc tiêu chuẩn. Quản lý tường minh vì ảnh hưởng khi thay đổi là lớn.

| Nơi phụ thuộc | Loại | Nội dung | Ngày xác nhận gần nhất |
|---|---|---|---|
| [REPLACE] | Quy định pháp lý/API ngoài/Tiêu chuẩn ngành | [REPLACE] | [REPLACE] |

---

## Bên liên quan, luồng duyệt

Nói rõ ai là người ra quyết định về mặt nghiệp vụ.

| Việc cần quyết | Người duyệt | Nơi escalate |
|---|---|---|
| [REPLACE] | [REPLACE] | [REPLACE] |
