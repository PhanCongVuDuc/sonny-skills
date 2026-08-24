---
description: Step 6 of the feature flow. Verify every contract claim and every diagram arrow against the real code, then turn the feature doc from spec-plus-plan into permanent behaviour documentation with Mermaid diagrams. Also the command to run when code changed and a feature doc went stale.
argument-hint: <Feature>
---

**Bước 6/6 — doc.** Bước duy nhất tạo ra thứ còn lại sau khi task kết thúc.

Bước này có sáu output và lịch sử cho thấy ba cái cuối bị bỏ đúng lúc tài liệu *trông như* xong — nên
toàn bộ bước chạy theo **sáu ô con 6a–6f trong `## Flow-state`** của feature doc (template ở
[`rules/gates.md`](../rules/gates.md)): làm ô nào tick ô đó, và **dòng 6 chỉ được tick khi cả sáu ô con
đã tick**. Doc cũ chưa có `## Flow-state` thì chép template vào trước, tick các dòng 0–5 theo bằng chứng.

Vào bước: dòng 5 (verify pass) đã tick. Chưa tick → dừng: doc hoá hành vi chưa kiểm là biến bug thành
đặc tả. Lệnh này cũng dùng **độc lập** khi code đổi mà feature doc cũ — khi đó bỏ Flow-state, chỉ chạy
6a/6b/6e.

Template feature doc + ví dụ diagram: [`templates/feature-doc-reference.md`](../templates/feature-doc-reference.md).

## 6a — Đối chiếu trước, viết sau

**Không viết dòng nào trước khi đối chiếu** — viết trước thì viết theo cái mình *nhớ* là đã code:

- Từng dòng `## Contract` — Input, Output, Invariants, từng named failure mode — kiểm bằng
  `codegraph node` / `codegraph explore` với tên symbol thật
- Từng mũi tên trong `## Flow` — có thật gọi nhau không, đúng thứ tự không
- Từng nhánh trong `flowchart` — điều kiện đúng không, có nhánh mới nào diagram chưa có không

**Lệch thì báo, không tự sửa.** Trình cả hai khả năng cho người chọn:

> `## Contract` nói offset nhận feet, code nhận display unit ở `X.cs:42`.
> Contract đúng → code bug. Code đúng → Contract sai từ đầu, và test viết theo nó cũng sai.

Viết đè doc theo code là cách chắc nhất để một bug trở thành đặc tả.

## 6b — Viết

Viết `## Flow` (một `sequenceDiagram`), `## Behaviour` (một `flowchart TD` cho mỗi phase có branching
thật), `## What a test should prove` (ghi cả **chỗ chưa phủ**, kèm mỗi chỗ có cần môi trường đặc biệt
không), `## Related`.

**Bỏ mọi thứ code đã nói rõ.** Giữ cái đọc code nhanh sẽ không thấy: silent behaviour, order dependency,
unit boundary, và những chỗ **trông như bug mà là cố ý** — nói rõ là cố ý, không thì người sau sẽ "sửa".

**Mỗi silent skip một node trong diagram** — nhìn một giây thấy ba mũi tên chụm vào `skip — SILENT`,
thay vì phải đọc kỹ một đoạn văn.

Diagram là **Mermaid, không SVG/HTML** (Mermaid là text: cùng file, diff được trong PR; SVG là toạ độ
tay nên sau lần đổi đầu tiên sẽ ngừng được cập nhật — diagram không khớp code thì tệ hơn không có).
Hai loại, mỗi loại đúng một mức trừu tượng, không trộn. Đừng dùng `C4Context` — GitHub không render.

## 6c — Soi `## Decisions` tìm ADR

Từng dòng: đủ **cả ba** điều kiện — khó đảo · người sau sẽ hỏi "sao lại thế" · có phương án khác thật đã
bị loại vì lý do cụ thể — thì đề xuất đẩy lên `docs/adr/`; thiếu một thì ghi "không đủ". Quyết định thiết
kế đi ra ADR, không nhét vào doc hành vi: doc bị viết đè mỗi lần feature đổi, ADR thì không bao giờ sửa,
chỉ superseded.

## 6d — Retro

Tạo/cập nhật `.sonnyflow/retro/{Feature}-retro.md` với đúng ba mục: **(a)** chỗ nào flow chạy mượt ·
**(b)** chỗ nào phải tự xoay ngoài kịch bản — kèm đề xuất sửa skill cụ thể (file nào, thêm câu gì) ·
**(c)** bài học kỹ thuật trả giá bằng nhiều vòng chạy. Rồi thêm **một dòng** vào
`.sonnyflow/retro/LESSONS.md`: `- {ngày} [{Feature}]({Feature}-retro.md) — <bài học đắt nhất, một câu>`.
Không có gì đáng ghi thì file vẫn phải tồn tại với một dòng nói thế. File này là backlog nâng cấp skill —
không có nó thì bài học chết theo phiên chat.

**Mỗi bài học gắn một nhãn nhà**, bằng câu kiểm định: *"đổi sang project khác dùng sonny-flow, bài học
này còn đúng không?"* — còn → `→ plugin` (đề xuất chép vào `rules/` — đụng repo khác nên chờ người gật);
hết → `→ .sonnyflow` (chép vào file môi trường của project ngay). Kèm trạng thái **đã chép / chờ duyệt**
— bài học nằm trong retro là bài học chưa chắc ai đọc lại; nó chỉ sống khi được chép sang đúng nhà, và
nhãn là dấu tick cho việc chép đó. Chi tiết ba nhà: `docs/adr/0001` của sonny-flow.

Bug phát hiện trong lượt mà chưa fix → file trong `docs/bugs/` + dòng index + link trong `## Related`
(luật ở [`rules/gates.md`](../rules/gates.md)) — nếu chưa làm lúc phát hiện thì đây là chốt chặn cuối.

## 6e — Làm mới graph

Chạy **đủ mọi lệnh** mà project khai trong `docs/README.md` (vd `graphify update .` **và**
`graphify export wiki`) — không chỉ lệnh đầu.

## 6f — Xoá section tạm

Việc cuối cùng, chỉ khi 6a–6e đã tick: xoá `## Flow-state`, `## Decisions`, `## Spec`, `## Plan`.

## Gate G6

Sáu ô con đã tick theo đúng thứ tự trên; mọi chỗ lệch doc/code đã được báo ra chứ không bị viết đè.
