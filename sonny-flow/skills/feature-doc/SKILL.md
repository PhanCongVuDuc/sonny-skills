---
name: feature-doc
description: Turn a feature doc from spec-plus-plan into permanent behaviour documentation with Mermaid diagrams, after verifying every claim and every arrow against the real code. Use as the last step of a feature, and whenever an existing feature doc needs updating because the code changed.
---

# feature-doc

Biến `docs/features/{Feature}.md` từ *spec + plan* thành *tài liệu hành vi*. Đây là bước cuối, và là bước
duy nhất tạo ra thứ còn lại sau khi task kết thúc.

Template đầy đủ + 2 ví dụ diagram: [`reference.md`](reference.md).

## Đối chiếu trước, viết sau

**Không viết một dòng nào trước khi đối chiếu.** Thứ tự này quan trọng vì viết trước thì sẽ viết theo cái
mình *nhớ* là đã code, không phải cái đã code.

1. Từng dòng trong `## Contract` — Input, Output, Invariants, mỗi named failure mode — kiểm bằng
   `codegraph node` / `codegraph explore` với tên symbol thật.
2. Từng mũi tên trong `## Flow` — có thật gọi nhau không, đúng thứ tự không.
3. Từng nhánh trong `flowchart` — điều kiện có đúng không, có nhánh nào mới mà diagram chưa có không.

**Lệch thì báo, không tự sửa.** Có hai khả năng và bạn không phân biệt được: doc cũ, hoặc **code sai**.
Trình cả hai ra:

> `## Contract` nói offset nhận feet, code nhận display unit ở `X.cs:42`.
> Nếu Contract đúng → code bug, cột sai cao độ.
> Nếu code đúng → Contract sai từ đầu và test viết theo nó cũng sai.
> Chọn bên nào?

Viết đè doc theo code là cách chắc chắn nhất để một bug trở thành đặc tả.

## Rồi viết

Xoá `## Decisions`, `## Spec` và `## Plan` — cả ba là section tạm. Viết theo template. Bốn luật:

**Bỏ mọi thứ code đã nói rõ.** Doc nhắc lại signature không thêm gì so với graph — và mỗi câu nhắc lại
code là một chỗ có thể lệch. Viết cái đọc code nhanh sẽ không thấy: silent behaviour, order dependency,
unit boundary, và những chỗ *trông như bug mà là cố ý* (nói rõ là cố ý, không thì người sau sẽ "sửa").

**Mỗi silent skip một node trong diagram.** Nếu một cột/phần tử bị bỏ mà không báo gì, nó phải hiện ra
thành một node — mục đích là nhìn một giây thấy ba mũi tên chụm vào `skip — SILENT`, thay vì phải đọc kỹ
một đoạn văn.

**`## What a test should prove` ghi cả chỗ chưa phủ.** Và với mỗi chỗ chưa phủ, nói rõ nó có cần môi
trường đặc biệt không. Đó là thông tin quyết định test đó viết được hôm nay hay không.

**Quyết định thiết kế đi ra ADR, không nhét vào đây.** File này là *hành vi hiện tại* — nó bị viết đè mỗi
lần feature đổi. ADR là *quyết định tại một thời điểm* — không bao giờ sửa, chỉ superseded. Trộn vào nhau
thì lần refactor đầu tiên xoá mất lý do.

**Trước khi xoá `## Decisions`, soi lại từng dòng.** Dòng nào đủ ba điều kiện — khó đảo · người sau sẽ hỏi
"sao lại thế" · có phương án khác thật đã bị loại vì lý do cụ thể — thì đề xuất đẩy lên `docs/adr/`. Thiếu
một là không đề xuất. Đây là chỗ ADR xuất hiện tự nhiên thay vì phải nhớ; xoá mà chưa soi là làm mất lý do
của những quyết định vừa chốt.

## Diagram

Mermaid, không SVG/HTML. Lý do là vận hành: Mermaid là text — cùng file, diff được trong PR, task thường
sửa 2 dòng là xong. SVG là toạ độ tuyệt đối do người giữ, nên sau lần đổi đầu tiên nó sẽ ngừng được cập
nhật, và **diagram không còn khớp code thì tệ hơn không có diagram**.

Hai loại, mỗi loại đúng một mức trừu tượng, không trộn:

- **`sequenceDiagram`** — đường gọi xuyên layer. Đây là thứ graph không dựng được (call qua DI generic và
  qua binding không thành edge trong AST).
- **`flowchart TD`** — nhánh quyết định và đường thất bại trong một phase.

Đừng dùng syntax `C4Context` của Mermaid: còn experimental và **GitHub không render** nó — diagram sẽ hiện
ra dưới dạng khối code thô. Giữ *cách nghĩ* C4 (một mức trừu tượng một diagram), dùng hai loại trên.

## Cuối cùng

Làm mới graph bằng lệnh mà project khai trong `docs/README.md`, để prose mới thành node liên kết với code
nó mô tả.
