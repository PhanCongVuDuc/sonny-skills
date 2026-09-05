---
description: Step 2 of the feature flow. Write the spec and the contract for one feature into its feature doc — what it does, acceptance criteria, invariants, and every named failure mode. Does not plan and does not write code.
argument-hint: <Feature> [mô tả ngắn việc cần làm]
model: opus
---

**Bước 2/6 — spec + contract.** Ghi hai section vào `docs/features/{Feature}.md`. `## Spec` sẽ bị xoá ở
bước 6; `## Contract` ở lại vĩnh viễn — nó là section mà lần sau người ta *sửa để yêu cầu một hành vi
khác*, nên nó nói *cái gì*, không nói *làm thế nào*.

## Vào bước này cần gì

Mở feature doc, nhìn `## Flow-state`: dòng 1 đã tick, `## Decisions` không còn **CHƯA CHỐT**. Chưa đạt
thì dừng và bảo người dùng chạy `/sonny-flow:grill` trước.

**Bước này chỉ *ghi lại* thứ đã chốt — không quyết định thay.** Gặp chỗ cần quyết mà `## Decisions` chưa
có thì quay lại grill đúng chỗ đó, đừng tự chọn rồi ghi vào Contract như thể đã thống nhất.

## `## Spec` — làm gì, và biết xong bằng cách nào

```markdown
## Spec

**Việc**: <1–3 câu. Người dùng làm được gì sau khi xong.>

**Trong phạm vi**: <gạch đầu dòng>
**Ngoài phạm vi**: <gạch đầu dòng — quan trọng ngang mục trên>

**Acceptance criteria**:
- [ ] <điều kiện kiểm được. "Nhanh hơn" không kiểm được; "trả về trong 1 giây với 500 phần tử" thì được.>

**Chỗ đang phải suy đoán**:
| Suy đoán | Ảnh hưởng | Câu hỏi cho người |
|---|---|---|
```

Bảng suy đoán **nên gần như rỗng** — grill đã dọn trước nó. Còn dòng nào là có chỗ lọt qua grill: ghi ra,
đừng lấp. Không còn gì thì ghi "không có". Có suy đoán mà không ghi là cách chắc nhất để build sai thứ.

Feature đang sửa (đã có `## Contract`): nói rõ trong `## Spec` **phần nào của Contract hiện tại sẽ đổi,
đổi thành gì** — dấu hiệu duy nhất phân biệt *đổi yêu cầu* với *sửa implementation*. Không tạo file mới,
không xoá `## Behaviour`.

## `## Contract` — bốn phần, không thiếu phần nào

**Input** — mỗi field: tên, nguồn (UI? caller? config?), default, và **đơn vị nếu là số đo**. Đơn vị là
chỗ sai nhiều nhất và im lặng nhất.

**Output** — cái gì thay đổi trong hệ thống sau khi chạy xong, kể cả tác dụng phụ: thứ gì được chọn, thứ
gì được log, **undo trông ra sao**.

**Invariants** — thứ không được phá, **kèm hậu quả nếu phá**. "Đừng cache X" là vô dụng; "đừng cache X vì
consumer là singleton nên mọi lệnh sau lệnh đầu làm trên document sai, âm thầm" thì dùng được.

**Named failure modes** — dạng bảng: tên · trigger · hành vi. Mỗi nhánh lỗi phải **có tên**. Nhánh không
có tên vì không có gì báo cho người dùng thì ghi `*(unnamed)* **silent skip**` — chính những dòng đó là
thứ đáng giá nhất trong cả file. Mỗi hàng của bảng sẽ thành một test ở bước 4: **bảng nghèo → test nghèo.**

## Gate G2

`## Contract` đủ bốn phần trên. Tick dòng 2 trong `## Flow-state`.

## Tiếp theo

`/sonny-flow:plan <Feature>`. **Chưa viết `## Plan`, không viết code ở bước này.**
