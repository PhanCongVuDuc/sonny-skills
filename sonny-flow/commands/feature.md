---
description: Start or resume the whole feature flow. Reads the feature doc's Flow-state checklist to work out which step the feature is on, then runs forward from there — stopping at every grilling round, at the human gate after the plan, or at the first gate that does not pass.
argument-hint: <Feature> [mô tả ngắn, chỉ cần cho lần đầu]
model: opus
---

Chạy cả flow. Dùng khi **không** muốn gõ từng bước.

Không giữ trạng thái ở đâu khác: **`docs/features/{Feature}.md` chính là trạng thái.** Đọc nó rồi chạy
tiếp từ đúng chỗ đang dở — nên lệnh này vừa để bắt đầu, vừa để tiếp tục sau khi ngắt giữa đường.

## Xác định đang ở bước nào

Mở `docs/features/{Feature}.md` và đọc **`## Flow-state`** — ô `- [ ]` đầu tiên còn trống chính là bước
phải chạy (dòng 6 nhìn vào ô con 6a–6g). Đó là nguồn trạng thái chính; bảng dưới chỉ dùng khi file
**chưa có `## Flow-state`** (doc cũ — khi đó chép template từ [`rules/gates.md`](../rules/gates.md) vào
đầu file, tick sẵn theo bằng chứng của bảng):

| Trạng thái file | Đang ở | Chạy từ |
|---|---|---|
| Không tồn tại | chưa bắt đầu | bước 0 |
| Có `## Behaviour`, không có `## Decisions` lẫn `## Spec` | feature đã xong, đây là việc mới trên nó | bước 0 |
| `## Decisions` còn dòng **CHƯA CHỐT** | đang giữa grill | bước 1, vòng tiếp |
| `## Decisions` chốt hết, không có `## Spec` | grill xong | bước 2 |
| Có `## Spec`, `## Contract` thiếu phần | bước 2 dở | bước 2 |
| Có `## Contract` đủ, không có `## Plan` | bước 2 xong | bước 3 |
| `## Plan` còn `- [ ]` | bước 4 dở | bước 4 |
| `## Plan` toàn `- [x]` | bước 4 xong | bước 5 |
| Không khớp dòng nào ở trên | file dở dang bất thường | **hỏi người dùng**, đừng đoán |

Nói ra mình xác định đang ở bước nào **trước khi** làm gì, để người dùng chặn được nếu sai.

## Chạy forward

Lần lượt các bước còn lại. Mỗi bước **gọi bằng Skill tool** — không đọc file markdown của bước rồi tự
làm theo, và càng không làm từ trí nhớ:

`Skill(sonny-flow:orient)` → `Skill(sonny-flow:grill)` → `Skill(sonny-flow:spec)` →
`Skill(sonny-flow:plan)` → `Skill(sonny-flow:implement)` → `Skill(sonny-flow:verify)` →
`Skill(sonny-flow:doc)`

Truyền `args` đúng như khi người dùng gõ tay lệnh đó — `args: "<Feature>"`, riêng `implement` thêm số task
nếu lượt này chỉ làm một task. **Đọc file thay vì gọi thì mất bốn thứ:** `$ARGUMENTS` trong bước đó không
được thay, và `model` / `effort` / `allowed-tools` khai trong frontmatter của bước đó không có hiệu lực.

Điều kiện gate: [`rules/gates.md`](../rules/gates.md). Xong bước nào tick ô đó trong `## Flow-state`.

## Ba chỗ dừng

**Mỗi vòng grill.** Bước 1 vốn là hỏi–chờ–hỏi tiếp, nên lệnh này dừng ở cuối **mỗi** vòng để chờ trả lời.
Frontier rỗng ngay vòng 1 thì không dừng — đi tiếp luôn.

**Human gate sau plan.** Luật chính xác: **nếu lượt này *tạo hoặc sửa* `## Plan` thì dừng ngay sau khi in
plan ra.** `## Plan` đã tồn tại nguyên vẹn từ trước khi lượt này bắt đầu thì đi tiếp — việc người dùng gõ
lại lệnh này *chính là* sự duyệt.

**Gate không qua.** Dừng tại chỗ, báo gate nào và vì sao. Không đi tiếp bước sau:

- **G0** — chưa trả lời được 6 câu → nói câu nào chưa biết, đừng viết bù vào
- **G1** — `## Decisions` còn CHƯA CHỐT → đó là còn vòng grill, không phải lỗi
- **G2** — `## Contract` thiếu phần → nói thiếu phần nào
- **G4** — còn `- [ ]` không làm được → nói task nào, vì sao
- **G5** — test **fail** hoặc **không kiểm chứng được** → **không** chạy bước 6. Doc hoá một hành vi chưa
  được kiểm là biến một bug thành đặc tả
- **G6** — `## Contract` lệch code → báo cả hai khả năng, đừng viết đè bên nào

## Kết thúc lượt

Báo bốn thứ: đã chạy tới bước nào (theo `## Flow-state`) · kết quả test (**pass** / **fail** / **không
kiểm chứng được**) · chỗ lệch giữa doc và code kèm câu hỏi · lệnh tiếp theo nên gõ.
