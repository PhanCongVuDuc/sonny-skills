---
description: Step 6 of the feature flow. Verify every contract claim and every diagram arrow against the real code, then turn the feature doc from spec-plus-plan into permanent behaviour documentation with Mermaid diagrams. Also the command to run when code changed and a feature doc went stale.
argument-hint: <Feature>
---

**Bước 6/6 — doc.** Bước duy nhất tạo ra thứ còn lại sau khi task kết thúc.

Dùng skill [`feature-doc`](../skills/feature-doc/SKILL.md); template và ví dụ diagram ở
[`reference.md`](../skills/feature-doc/reference.md).

Lệnh này dùng được **độc lập**, không cần đi kèm một task: code đổi mà feature doc cũ thì chạy nó để đối
chiếu và cập nhật.

## 1. Đối chiếu trước, viết sau

**Không viết dòng nào trước khi đối chiếu.** Viết trước thì sẽ viết theo cái mình *nhớ* là đã code, không
phải cái đã code.

- Từng dòng `## Contract` — Input, Output, Invariants, từng named failure mode — kiểm bằng
  `codegraph node` / `codegraph explore` với tên symbol thật
- Từng mũi tên trong `## Flow` — có thật gọi nhau không, đúng thứ tự không
- Từng nhánh trong `flowchart` — điều kiện đúng không, có nhánh mới nào diagram chưa có không

**Lệch thì báo, không tự sửa.** Trình cả hai khả năng ra cho người chọn:

> `## Contract` nói offset nhận feet, code nhận display unit ở `X.cs:42`.
> Contract đúng → code bug. Code đúng → Contract sai từ đầu, và test viết theo nó cũng sai.

Viết đè doc theo code là cách chắc nhất để một bug trở thành đặc tả.

## 2. Viết

Xoá `## Decisions`, `## Spec` và `## Plan` — cả ba là section tạm. Viết `## Flow` (một `sequenceDiagram`), `## Behaviour` (kèm `flowchart TD` cho
mỗi phase có branching thật), `## What a test should prove`, `## Related`.

Bỏ mọi thứ code đã nói rõ. Giữ: silent behaviour, order dependency, unit boundary, và những chỗ **trông
như bug mà là cố ý** — nói rõ là cố ý, không thì người sau sẽ "sửa".

## 3. Retro — output bắt buộc, không phải tuỳ hứng

Tạo/cập nhật `docs/retro/{Feature}-sonny-flow-retro.md` với đúng ba mục: **(a)** chỗ nào flow chạy mượt,
**(b)** chỗ nào phải tự xoay ngoài kịch bản — kèm đề xuất sửa skill cụ thể (file nào, thêm câu gì),
**(c)** bài học kỹ thuật trả giá bằng nhiều vòng chạy. File này là backlog nâng cấp skill; không có nó
thì bài học chết theo phiên chat. Không có gì đáng ghi thì file vẫn phải tồn tại với một dòng nói thế.

Bug phát hiện trong lượt làm mà chưa fix → phải có file trong `docs/bugs/` + dòng index + một dòng
link trong `## Related` của feature doc (luật ở [`rules/gates.md`](../rules/gates.md)). Bug không nằm
trong feature doc — file này là *hành vi hiện tại* và bị viết đè.

## 4. Làm mới graph

Chạy lệnh mà project khai trong `docs/README.md` (thường `graphify update .` rồi `graphify export wiki`),
để prose mới thành node liên kết với code nó mô tả.

## Gate G6

Không còn `## Decisions`/`## Spec`/`## Plan`; không còn `- [ ]` sót; có `sequenceDiagram`; **mọi silent skip có một node
trong diagram**; mọi chỗ lệch đã được báo ra chứ không bị viết đè.

## Cuối cùng

**Trước khi xoá `## Decisions`, soi lại từng dòng của nó:** dòng nào đủ ba điều kiện thì đề xuất đẩy lên
`docs/adr/` — khó đảo · người sau sẽ hỏi "sao lại thế" · có phương án khác thật đã bị loại vì lý do cụ thể.
Thiếu một là không đề xuất. Đây là chỗ ADR xuất hiện tự nhiên thay vì phải nhớ.

Xoá `## Decisions` mà chưa soi là làm mất lý do của những quyết định vừa chốt.
