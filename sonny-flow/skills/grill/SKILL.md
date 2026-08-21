---
name: grill
description: Interview the user until every open decision about a feature is settled, then record the answers where the spec can use them. Use before writing a spec or contract, so nothing has to be guessed.
---

# grill

Hỏi cho hết chỗ chưa rõ **trước khi** viết spec. Không phải viết spec rồi ghi chú lại chỗ đã đoán — thứ
đã ghi vào file là mặc định, và mặc định do AI đoán thì không ai đọc lại.

## Cơ chế: dùng lại `/grilling`

Chạy **skill [`mattpocock-skills:grilling`](https://github.com/mattpocock/skills)**. Đừng viết lại cơ
chế đó ở đây. Nó lo phần khó:

- Cây quyết định — mỗi quyết định phân nhánh ra các quyết định treo dưới nó
- **Frontier** — chỉ hỏi những câu mà tiền đề đã chốt. Câu phụ thuộc một câu còn mở thì để **vòng sau**
- Hỏi cả frontier trong một vòng, đánh số `❓ **Qn**`, **mỗi câu kèm `➡️` đề xuất**
- Chờ trả lời, rồi tính lại frontier, rồi vòng tiếp
- **Tìm dữ kiện là việc của agent** — đừng hỏi người thứ mình tra được. *Quyết định* mới là việc của người

Và chạy **`mattpocock-skills:domain-modeling`** cùng lúc, để phần thuật ngữ và ADR tự vào đúng chỗ.

Hai skill này thuộc plugin `mattpocock-skills`. Không có nó thì skill này không chạy được — xem mục yêu
cầu trong [`README.md`](../../README.md).

## Seed cây từ hình dạng `## Contract`

`/grilling` chung bắt đầu từ con số không. Ở đây đã biết `## Contract` cần gì, nên vòng 1 sắc luôn. Bốn
nhóm hạt giống — **nhóm ★ hỏi trước**:

| Nhóm | Hỏi gì |
|---|---|
| ★ **Named failure modes** | Từng nhánh lỗi: **báo, hay bỏ im?** Báo thì báo từng cái hay báo tổng? Bỏ im thì có log không? |
| **Input** | Số này **đơn vị gì**, ai đổi, đổi ở đâu? Giá trị biên (0, âm, rỗng) xử lý sao? Nguồn là UI, config, hay caller? |
| **Output** | Xong thì cái gì đổi trong hệ thống? Tác dụng phụ nào? **Undo trông ra sao** — một bước hay N bước? |
| **Invariants** | Cái gì không được phá, và phá thì hỏng gì? Cái gì phải chạy trước cái gì? |

Vì sao ★ đứng đầu: đó là nhóm hay bị trôi nhất. Hành vi "bỏ im" thường không phải ai quyết định — nó chỉ
*xuất hiện*, rồi 6 tháng sau thành một dòng trong feature doc mà người viết doc phải đi phát hiện lại.

Kết quả `orient` là đầu vào của vòng 1: đã biết chạm layer nào, ai gọi vào, pattern nào đang có. Đừng hỏi
lại những thứ đó.

## Ghi kết quả ra ba chỗ

| Loại | Đi đâu | Ai ghi |
|---|---|---|
| **Thuật ngữ** của domain | `CONTEXT.md` ở gốc repo | `domain-modeling` |
| Quyết định **khó đảo** | `docs/adr/` | `domain-modeling` — chỉ khi đủ **cả ba** điều kiện |
| **Mọi quyết định còn lại** | `## Decisions` trong `docs/features/{Feature}.md` | skill này |

Chỗ thứ ba là chỗ `domain-modeling` không lo, vì `CONTEXT.md` **chỉ là glossary** và ADR thì phải đủ ba
điều kiện. Quyết định kiểu *"cột không tạo được thì log Warning + báo tổng ở cuối"* không phải thuật ngữ,
cũng không khó đảo — nhưng nó chính là thứ `## Contract` cần nhất. Không ghi ra là mất khi hết session.

```markdown
## Decisions

| # | Câu hỏi | Chốt | Vòng |
|---|---|---|---|
| D1 | Cột không tạo được thì sao | Log Warning + báo tổng ở cuối, không dialog từng cột | 1 |
| D2 | snapDistance đơn vị gì | Display unit, đổi sang feet ở ViewModel | 1 |
| D3 | Chạy trên view hay cả project | **CHƯA CHỐT** — chờ trả lời | 2 |
```

`## Decisions` là section **tạm**, như `## Spec` và `## Plan` — bước 6 xoá nó. Nó tồn tại vì hai lý do:
grill kéo dài nhiều lượt nên context sẽ bị nén, và **ngắt giữa đường phải chạy lại được** — vòng sau đọc
bảng này để biết cái gì đã chốt thay vì hỏi lại.

Ghi vào bảng **ngay khi chốt từng câu**, đừng dồn tới cuối.

## Frontier rỗng là kết quả hợp lệ

Task rõ ràng thì vòng 1 không có gì để hỏi. Khi đó: ghi `## Decisions` với dòng "không có quyết định nào
đang mở", nói rằng đi tiếp được, **kết thúc**.

**Cấm bịa câu hỏi cho ra vẻ kỹ.** Bốn câu vô nghĩa tệ hơn không câu nào — nó dạy người dùng bỏ qua bước
này. Không hỏi được câu nào mà câu trả lời sẽ *đổi việc phải làm* thì đừng hỏi.

Ngược lại: **đừng đoán để tránh hỏi.** Nếu câu trả lời đổi việc phải làm thì đó là câu phải hỏi, kể cả khi
bạn đã có đề xuất khá chắc — đề xuất đi vào `➡️`, không đi vào giả định im lặng.

## Xong khi nào

Frontier rỗng: mọi nhánh của cây đã thăm, không còn gì bị giả định lặng lẽ. Lúc đó tóm lại những gì đã
chốt và **chờ người xác nhận đã hiểu nhau** trước khi nói sang bước tiếp.
