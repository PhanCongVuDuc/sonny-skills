---
description: Step 1 of the feature flow. Interview the user in rounds until every open decision about the feature is settled, recording answers into the feature doc, the glossary and ADRs so the spec never has to guess.
argument-hint: <Feature> [mô tả ngắn việc cần làm]
---

**Bước 1/6 — grill.** Hỏi cho hết chỗ chưa rõ **trước khi** có chữ nào của spec. Thứ đã ghi vào file là
mặc định, và mặc định do AI đoán thì không ai đọc lại.

## Vào bước này cần gì

Đã orient. Chưa thì chạy [`orient`](orient.md) tại đây trước — vòng hỏi đầu chỉ sắc khi đã biết code có
những abstraction nào, và hỏi người thứ mình tra được là sai nguyên tắc.

## Tạo feature doc + Flow-state

Chưa có `docs/features/{Feature}.md` thì tạo, gồm: đoạn mở đầu · **`## Flow-state`** (chép template từ
[`rules/gates.md`](../rules/gates.md), tick dòng 0 vì orient đã chạy) · `## Decisions`. Feature đang sửa
thì thêm hai section đó sau đoạn mở đầu, **không xoá `## Behaviour`**.

## Cơ chế: dùng lại `/grilling`

Chạy skill **`mattpocock-skills:grilling`** — đừng viết lại cơ chế. Nó lo: cây quyết định · **frontier**
(chỉ hỏi câu mà tiền đề đã chốt; câu phụ thuộc câu còn mở để vòng sau) · hỏi cả frontier một vòng, đánh
số `❓ **Qn**` kèm `➡️` đề xuất · **tìm dữ kiện là việc của agent, quyết định là việc của người**.

Chạy kèm **`mattpocock-skills:domain-modeling`** để thuật ngữ và ADR tự vào đúng chỗ. Cả hai thuộc plugin
`mattpocock-skills` — không có thì bước này không chạy được (xem [`README.md`](../README.md)).

## Seed cây từ hình dạng `## Contract` — nhóm ★ hỏi trước

| Nhóm | Hỏi gì |
|---|---|
| ★ **Named failure modes** | Từng nhánh lỗi: **báo, hay bỏ im?** Báo từng cái hay báo tổng? Bỏ im thì có log không? |
| **Input** | Số này **đơn vị gì**, ai đổi, đổi ở đâu? Biên (0, âm, rỗng) xử lý sao? Nguồn là UI, config hay caller? |
| **Output** | Xong thì cái gì đổi trong hệ thống? Tác dụng phụ nào? **Undo trông ra sao** — một bước hay N bước? |
| **Invariants** | Cái gì không được phá, phá thì hỏng gì? Cái gì phải chạy trước cái gì? |

★ đứng đầu vì đó là nhóm hay trôi nhất: hành vi "bỏ im" thường không ai quyết — nó chỉ *xuất hiện*, rồi
6 tháng sau thành một dòng trong feature doc mà người viết doc phải đi phát hiện lại.

Kết quả orient là đầu vào vòng 1 — đừng hỏi lại thứ orient đã trả lời.

## Ghi kết quả ra ba chỗ

| Loại | Đi đâu | Ai ghi |
|---|---|---|
| **Thuật ngữ** domain | `CONTEXT.md` gốc repo | `domain-modeling` |
| Quyết định **khó đảo** (đủ cả ba điều kiện) | `docs/adr/` | `domain-modeling` |
| **Mọi quyết định còn lại** | `## Decisions` trong feature doc | bước này |

Chỗ thứ ba là chỗ hai skill kia không lo — quyết định kiểu *"cột không tạo được thì log Warning + báo
tổng"* không phải thuật ngữ, cũng không khó đảo, nhưng là thứ `## Contract` cần nhất.

```markdown
## Decisions

| # | Câu hỏi | Chốt | Vòng |
|---|---|---|---|
| D1 | Cột không tạo được thì sao | Log Warning + báo tổng ở cuối | 1 |
| D2 | snapDistance đơn vị gì | Display unit, đổi sang feet ở ViewModel | 1 |
| D3 | Chạy trên view hay cả project | **CHƯA CHỐT** — chờ trả lời | 2 |
```

Ghi vào bảng **ngay khi chốt từng câu**, đừng dồn tới cuối — grill kéo dài nhiều lượt, ngắt giữa đường
phải chạy lại được từ chính bảng này.

## Gate G1

Frontier rỗng — mọi nhánh đã thăm, `## Decisions` không còn dòng **CHƯA CHỐT**.

**Frontier rỗng ngay vòng 1 là kết quả hợp lệ**: ghi "không có quyết định nào đang mở" rồi kết thúc. Cấm
bịa câu hỏi cho ra vẻ kỹ — bốn câu vô nghĩa dạy người dùng bỏ qua bước này. Ngược lại: câu trả lời mà
**đổi việc phải làm** thì phải hỏi, kể cả khi đã có đề xuất chắc — đề xuất đi vào `➡️`.

## Kết thúc lượt — hai kết cục, đừng trộn

**Frontier còn câu mở** → in vòng câu hỏi, **kết thúc lượt để chờ trả lời**. Chưa tick gì cả — bước tiếp
vẫn là grill, vòng sau.

**Frontier rỗng** → tóm những gì đã chốt và **chờ người xác nhận đã hiểu nhau**. Chỉ khi người xác nhận
mới tick dòng 1 trong `## Flow-state` và nói bước tiếp là `/sonny-flow:spec <Feature>` — G1 là human
gate, tick trước khi người gật là tự vượt gate.

Ở cả hai kết cục: không viết `## Spec`, không viết `## Contract`, không viết code.
