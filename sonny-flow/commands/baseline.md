---
description: Step 2 of the refactor flow. Build the safety net before any code moves — list every feature the refactor touches, find which tests already lock its behaviour, and write characterization tests for the ones that have none. Replaces the spec step, because a refactor has no new requirement.
argument-hint: <mô tả refactor, hoặc bỏ trống nếu chỉ có một bản nháp ADR>
model: opus
---

**Bước 2/6 của flow refactor — baseline.** Dựng lưới an toàn **trước khi** động vào code.

## Vào bước này cần gì

Bản nháp ADR trong `docs/adr/` có `## Decisions` không còn dòng **CHƯA CHỐT**. Chưa có thì dừng và bảo
người dùng chạy `/sonny-flow:grill` trước.

Nhiều bản nháp → **hỏi cái nào**, đừng đoán.

## Không viết `## Contract` mới

**Refactor không có yêu cầu mới — đó là định nghĩa của nó.** `## Contract` trong feature doc hiện có
**chính là** spec, và yêu cầu là *"không đổi một chữ"*. Viết Contract mới ở đây là đã đổi hành vi mà tự
cho phép mình.

## Ba việc

1. **Liệt kê feature bị chạm.** Mỗi cái: file nào sẽ move/tách, và `## Contract` của nó nằm ở doc nào.
2. **Với mỗi feature, tìm test đang khoá hành vi.** Tên file test, lệnh chạy, và nó khoá *cái gì* — con số
   cụ thể nếu có (ví dụ: assert đúng 80 dimension, đúng 45 cột). Đó là lưới an toàn thật.
   Kèm theo: **liệt kê chỗ test tham chiếu trực tiếp type sắp move** — construct bằng tay, gọi cặp method
   lẻ, resolve concrete type từ DI. Grep các project test theo tên type. Repo có file kiểm kê sẵn thì đọc
   và cập nhật nó (`CLAUDE.md` trỏ tới; với Sonny là `.sonnyflow/lessons/test-safety-net.md`). Ghi từng chỗ
   vào ADR như rủi ro biết trước, phân loại luôn: gãy *compile* ở đó là wiring — được retarget với
   assertion nguyên vẹn và phải khai trong ADR; phải đổi *assertion* mới là dừng hỏi người.
3. **Không có test nào → viết characterization test trước khi move.**
   - Test khoá hành vi **hiện tại**, kể cả hành vi trông như sai. Mục đích không phải chứng minh code đúng
     — mà là phát hiện code **đổi**.
   - Chạy cho nó **xanh** trên code chưa sửa. Test chưa từng xanh thì không phải lưới.
   - Chỗ đặt: đọc `CLAUDE.md` của project để biết project test nào không cần môi trường đặc biệt. Không tự
     đoán đường dẫn.

## Ghi vào ADR

Thêm vào bản nháp một mục nêu rõ ba thứ: feature nào **có** lưới · feature nào **vừa được** viết lưới ·
feature nào **cố tình đi mà không có lưới**.

Mục thứ ba phải là **quyết định tường minh của người**, không phải im lặng bỏ qua. Có thì nói rõ vì sao
chấp nhận rủi ro đó.

## Gate G2 (biến thể refactor)

Mỗi feature bị chạm đều có test khoá hành vi hiện tại và **đang xanh** — hoặc được người chấp nhận tường
minh là đi không lưới.

Không có baseline mà move là đánh cược, và cược đó **không lộ ra lúc build** — nó lộ ra ở người dùng.

## Tiếp theo

`/sonny-flow:plan <mô tả>` — hoặc `/sonny-flow:refactor <mô tả>` để chạy tiếp tới gate gần nhất.
