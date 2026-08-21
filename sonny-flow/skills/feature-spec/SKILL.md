---
name: feature-spec
description: Write the spec, the contract and the task plan for one feature directly into its feature doc, so the doc itself becomes the progress tracker. Use after orienting in the code and before writing any implementation.
---

# feature-spec

Viết `## Spec`, `## Contract`, `## Plan` vào `docs/features/{Feature}.md`. Ba section này sống trong
**chính file tài liệu cuối** — không có thư mục sản phẩm trung gian. `## Spec` và `## Plan` sẽ bị xoá ở
bước cuối; `## Contract` thì ở lại vĩnh viễn.

**Đầu vào là `## Decisions`** — bảng do bước grill để lại. Skill này *ghi lại* thứ đã chốt, **không quyết
định thay**. Gặp chỗ chưa có trong `## Decisions` mà vẫn cần một quyết định thì quay lại grill cho đúng chỗ
đó, đừng tự chọn rồi ghi vào Contract như thể đã thống nhất.

Vì sao đặt trong file đó: task nửa dở commit được, resume được, và **gate cuối trở thành "còn `- [ ]` nào
không"** — không cần schema, không cần công cụ.

## `## Spec` — làm gì, và biết xong bằng cách nào

Ngắn. Bốn mục:

```markdown
## Spec

**Việc**: <1–3 câu. Người dùng làm được gì sau khi xong.>

**Trong phạm vi**: <gạch đầu dòng>
**Ngoài phạm vi**: <gạch đầu dòng — mục này quan trọng bằng mục trên>

**Acceptance criteria**:
- [ ] <điều kiện kiểm được. "Nhanh hơn" không kiểm được; "trả về trong 1 giây với 500 phần tử" thì được.>

**Chỗ đang phải suy đoán**:
| Suy đoán | Ảnh hưởng | Câu hỏi cho người |
|---|---|---|
```

Bảng suy đoán **nên gần như rỗng** — grill đã dọn trước nó. Còn dòng nào nghĩa là có chỗ lọt qua grill:
ghi ra, đừng lấp. Không còn gì thì ghi "không có". Có suy đoán mà không ghi là cách chắc nhất để build sai
thứ.

Feature đang sửa (đã có `## Contract`): nói rõ trong `## Spec` phần nào của Contract hiện tại sẽ đổi, và
đổi thành gì. Đó là dấu hiệu duy nhất cho biết đây là *đổi yêu cầu* chứ không phải *sửa implementation*.

## `## Contract` — mặt cắt ổn định

Đây là section mà lần sau người ta sẽ **sửa để yêu cầu một hành vi khác**. Nên nó phải nói *cái gì*, không
nói *làm thế nào*. Bốn phần, không thiếu phần nào:

**Input** — mỗi field: tên, nguồn (UI? caller? config?), default, và **đơn vị nếu là số đo**. Đơn vị là
chỗ hay sai nhất và im lặng nhất.

**Output** — cái gì thay đổi trong hệ thống sau khi chạy xong. Kể cả tác dụng phụ (thứ gì được chọn, thứ
gì được ghi log, undo trông ra sao).

**Invariants** — thứ không được phá, **kèm hậu quả nếu phá**. "Đừng cache X" là vô dụng; "đừng cache X vì
consumer là singleton nên mọi lệnh sau lệnh đầu sẽ làm trên document sai, âm thầm" thì dùng được.

**Named failure modes** — dạng bảng: tên · trigger · hành vi. Mỗi nhánh lỗi phải **có tên**. Nhánh nào
không có tên vì không có gì báo cho người dùng thì ghi `*(unnamed)* **silent skip**` — chính những dòng đó
là thứ đáng giá nhất trong cả file.

Mỗi hàng trong bảng này sẽ thành một test ở bước implement. Bảng nghèo → test nghèo.

## `## Plan` — checklist

```markdown
## Plan

- [ ] <việc> — `path/to/file.ext` — phục vụ AC #<n> — test: <một dòng test sẽ viết>
- [ ] ...
```

Luật:

- **Một mối quan tâm một task.** "Thêm field và validate và hiển thị lỗi" là ba task.
- **Nêu file.** Task không biết sẽ sửa file nào là task chưa nghĩ xong.
- **Mỗi task một dòng test.** Nghĩ không ra test thì ghi thẳng `test: không có — <vì sao>`. Đừng ghi
  "kiểm bằng tay" cho đủ hình thức; ghi *không có* là một thông tin, ghi "bằng tay" là che.
- **Thứ tự thi hành được.** Task sau không phụ thuộc thứ chưa tồn tại.
- Task nào cần đổi abstraction đang có thì đánh dấu và **hỏi trước**, đừng nhét vào giữa plan.

## Rồi dừng

Gate **G3** là human gate. In plan ra, nêu các chỗ suy đoán, và kết thúc lượt. Không viết code.

Đừng hỏi "tôi làm tiếp nhé?" rồi tự trả lời trong cùng một lượt — như thế là tự vượt gate.
