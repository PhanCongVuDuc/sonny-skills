---
description: The behaviour-preserving variant of the feature flow. Use for moving logic between layers, splitting a class that mixes decision with mechanism, or renaming — anything where the requirement must not change. Records the decision as an ADR and sweeps every stale doc at the end.
argument-hint: <mô tả ngắn việc refactor>
---

Biến thể của flow cho thay đổi **không được đổi hành vi**. Dùng khi: chuyển logic giữa layer, tách class
đang trộn quyết định với cơ chế, rename, gộp abstraction trùng.

**Khác `/sonny-flow:feature` đúng hai bước.** Năm bước còn lại dùng lại y nguyên.

| Bước | Ở đây làm gì |
|---|---|
| 0 | [`orient`](orient.md) — **dùng lại** |
| 1 | [`grill`](grill.md) — **dùng lại**. Chốt: tách tới mức nào · cái nào **không** đáng tách · thứ tự move |
| 2 | [`baseline`](baseline.md) ← **khác**. Xem dưới |
| 3 | [`plan`](plan.md) — **dùng lại**. Chuỗi move nhỏ, mỗi bước tự đứng được |
| 4 | [`implement`](implement.md) — **dùng lại** + luật *hành vi không đổi* |
| 5 | [`verify`](verify.md) — **dùng lại y nguyên**. Gate là **test cũ vẫn xanh** |
| 6 | [`sync-docs`](sync-docs.md) ← **khác**. Xem dưới |

## Trạng thái sống ở đâu

Refactor trải qua nhiều feature, nên **không** có một feature doc nào chứa nó. Nhà của nó là **bản nháp
ADR**: `docs/adr/NNNN-<slug>.md`.

Tạo file đó ở bước 1 với **`## Flow-state`** (template ở [`rules/gates.md`](../rules/gates.md), dòng 2 là
`baseline`, dòng 6 là `sync-docs`) và `## Decisions`; thêm `## Plan` ở bước 3. Bước 6 xoá cả ba, để lại
đúng bản ghi quyết định. Trạng thái đọc từ `## Flow-state` — ô trống đầu tiên là bước phải chạy. Cùng khuôn với feature doc: section tạm nằm trong artifact vĩnh viễn, và **còn `- [ ]` là chưa
xong**.

Refactor này xứng đáng một ADR vì nó đủ ba điều kiện: khó đảo · người sau sẽ hỏi *"sao class này lại nằm
đây"* · có phương án khác thật (để nguyên) đã bị loại. Không đủ ba thì đây không phải refactor cần flow —
cứ sửa thẳng.

## Xác định đang ở bước nào

Lệnh này vừa để bắt đầu, vừa để **tiếp tục** sau khi ngắt giữa đường. Trạng thái nằm trong bản nháp ADR.

Tìm nó: file trong `docs/adr/` còn chứa `## Decisions` hoặc `## Plan` (bản nháp chưa xong). Có **nhiều
hơn một** thì hỏi người dùng cái nào — đừng đoán. Không có cái nào thì đây là refactor mới.

| Trạng thái bản nháp ADR | Chạy từ |
|---|---|
| Không tồn tại | bước 0 |
| `## Decisions` còn dòng **CHƯA CHỐT** | bước 1, vòng tiếp |
| `## Decisions` chốt hết, chưa liệt kê lưới an toàn | bước 2 |
| Đã có lưới an toàn, không có `## Plan` | bước 3 |
| `## Plan` còn `- [ ]` | bước 4 |
| `## Plan` toàn `- [x]` | bước 5 |
| Không khớp dòng nào | **hỏi người dùng** |

Nói ra mình xác định đang ở bước nào **trước khi** làm gì.

## Ba chỗ dừng

**Mỗi vòng grill** (bước 1) — hỏi rồi kết thúc lượt để chờ trả lời.

**Sau plan (bước 3).** Luật chính xác: **lượt này *tạo hoặc sửa* `## Plan` thì dừng ngay sau khi in plan
ra.** `## Plan` đã tồn tại nguyên vẹn từ trước lượt đó thì đi tiếp — người gõ lại lệnh là người duyệt. Nên
lần đầu bao giờ cũng dừng sau bước 3; gõ lại thì chạy 4 → 5 → 6.

**Gate không qua.** Đặc biệt: **G5 fail hoặc không kiểm chứng được thì KHÔNG chạy bước 6.** Sync-docs một
refactor chưa được kiểm là ghi vào tài liệu một hành vi có thể đã hỏng.

## Bước 2 — baseline, thay cho spec

**Refactor không có yêu cầu mới. Đó là định nghĩa của nó.** Nên không viết `## Contract` mới; `## Contract`
hiện có trong feature doc **chính là** spec, và yêu cầu là *"không đổi một chữ"*.

Việc thật của bước này là dựng **lưới an toàn**:

1. Liệt kê feature nào bị chạm, và với mỗi cái: **test nào hiện đang khoá hành vi của nó?**
2. Không có test nào → **viết characterization test trước khi động vào code.** Test khoá hành vi *hiện tại*,
   kể cả hành vi trông như sai. Chạy cho nó xanh. Giờ mới được move.
3. Ghi vào ADR: cái gì có lưới, cái gì không, và **cái nào cố tình đi mà không có lưới** — nếu có, phải là
   quyết định tường minh của người, không phải im lặng bỏ qua.

Không có baseline mà move là đánh cược, và cược đó **không lộ ra lúc build** — nó lộ ra ở người dùng.

Test thuần (không cần môi trường đặc biệt) đặt ở project unit test không phụ thuộc framework nặng. Chỗ nào
thì đọc `CLAUDE.md` của project, đừng đoán.

## Bước 4 — luật riêng khi implement

- **Một move một commit.** Move + rename + đổi signature cùng lúc là làm cho diff không đọc được và không
  bisect được.
- **Không sửa hành vi kèm theo**, kể cả khi thấy bug rõ ràng. Ghi lại, làm sau, bằng một `feature` run.
  Sửa bug trong lúc refactor là cách chắc nhất để không biết cái nào làm hỏng.
- Move rồi mà test cũ phải sửa để xanh → **dừng lại**. Hoặc hành vi đã đổi, hoặc test vốn dựa vào chi tiết
  implementation. Cả hai đều cần người quyết.

## Bước 6 — sync-docs, thay cho doc

Nội dung đầy đủ ở [`sync-docs`](sync-docs.md).

`/sonny-flow:doc` chỉ lo **một** feature doc. Refactor thì bán kính rộng hơn: doc của feature khác cũng
nhắc tên vừa đổi, `docs/architecture/*` không phải feature doc nên không lệnh nào phụ trách, và `CLAUDE.md`
hay khẳng định vị trí layer của class như một sự thật hiện tại — move class là câu đó thành **sai**.

Gate: không còn identifier nào **bị xoá trong diff** mà vẫn xuất hiện trong `docs/**`, `CLAUDE.md`,
`CONTEXT.md`; không còn link `[source](...)` gãy.

Rồi xoá `## Decisions` và `## Plan` khỏi ADR, để lại bản ghi quyết định.

## Kết thúc lượt

Báo: move nào đã xong · test cũ **pass / fail / không kiểm chứng được** · doc nào đã sửa · chỗ nào cố tình
đi mà không có lưới an toàn · move nào còn lại.
