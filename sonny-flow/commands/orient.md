---
description: Step 0 of the feature flow. Build an accurate picture of the code a feature will touch, reading project docs then graphify then codegraph, and report the five things that must be known before any spec is written.
argument-hint: <Feature> [mô tả ngắn việc cần làm]
---

**Bước 0/6 — orient.** Hiểu code trước khi viết chữ nào. Spec viết mà chưa biết những abstraction nào
đang tồn tại thì sẽ mô tả một hệ thống không có ở đây.

Đây là bước **đọc**: không ghi gì vào `docs/features/` (nên chưa có `## Flow-state` để tick — grill sẽ
tạo nó và tick hộ dòng 0).

## Ba nguồn, đúng thứ tự này

Thứ tự không tuỳ ý — mỗi nguồn trả lời loại câu hỏi mà nguồn trước không trả lời được. Không bỏ nguồn
đầu để nhảy vào code: silent behaviour chỉ nằm trong `docs/`, đọc code nhanh sẽ không thấy một
`catch { }` là *có chủ ý* hay là bug.

**1. `docs/` của project — ý định.** Đọc `docs/README.md` trước để biết thứ tự đọc mà project quy định,
rồi doc kiến trúc, rồi feature doc liên quan. Nguồn duy nhất có: silent behaviour, order dependency,
unit boundary, invariant, và những chỗ trông như bug mà là cố ý.

Cách đọc file môi trường (`revit-test-environment.md`…): dòng *"máy này thiếu X"* là ảnh chụp một phạm
vi hẹp — **đừng suy rộng thành "X không có ở đâu cả"**. Muốn biết một file model/CAD chứa gì thì mở nó
ra bằng probe (xem [`rules/revit-fixture.md`](../rules/revit-fixture.md)), đừng suy từ ghi chú.

**2. graphify — cấu trúc và bối cảnh.**

```
graphify query "<câu hỏi tiếng Anh>"
graphify explain "<Symbol>"
graphify affected "<Symbol>" --depth 2
```

Index cả `.md` và `.xaml`. Dùng cho: kiến trúc, binding XAML, khoá resource localization, định hướng khi
chưa biết bắt đầu từ đâu.

**3. codegraph — source thật.**

```
codegraph node "<Type.Member>"
codegraph explore "<Name1 Name2 Name3>"
codegraph impact "<Symbol>"
```

**Đưa nó một túi tên symbol, không đưa câu hỏi tiếng Anh** — hỏi văn xuôi là nó trả file sai. Lấy tên từ
bước 2 hoặc prompt hook trước. Cái nó trả là source thật có số dòng, đọc lại từ disk mỗi lần gọi — coi
như đã đọc, đừng `Read` lại.

## Khi hai graph bất đồng

`CLAUDE.md` của project có bảng phân xử thì bảng đó thắng. Không có thì mặc định:

| Câu hỏi | Tin ai |
|---|---|
| Code nói gì, đúng số dòng | **codegraph** — đọc lại từ disk |
| Phạm vi ảnh hưởng của thay đổi | **codegraph** (`impact` là transitive) |
| Binding `.xaml`, khoá localization | **graphify** — codegraph không index `.xaml` |
| Ý định kiến trúc, mọi thứ dưới `docs/` | **graphify** — codegraph không index `.md` |
| Hai bên trỏ cùng chỗ | Xong, đừng kiểm thêm |
| Doc mâu thuẫn code | **Không tự chọn** — đó là phát hiện, nêu ra cho người quyết |

## Gate G0 — năm câu phải trả lời được

Chưa trả lời được thì tìm tiếp — **không đoán**, và nói thẳng "chưa biết" nếu vẫn không ra:

1. **Chạm layer nào?** Tên project/thư mục cụ thể, và việc này rơi vào tầng test tự chạy được hay tầng
   cần môi trường đặc biệt.
2. **Ai gọi vào?** Đường từ điểm vào của người dùng tới nơi sẽ sửa, kể cả hop graph không thấy
   (DI generic, binding) — lấy từ doc kiến trúc.
3. **Pattern nào đang có để noi theo?** Một chỗ trong codebase đã làm việc tương tự. Với mỗi helper định
   dùng lại: **đọc thân hàm, đừng tin tên** — semantics gần giống nhưng lệch ở biên là loại bug đắt nhất
   khi port. Không có pattern thì nói là không có — tín hiệu cần bàn abstraction mới.
4. **Test hiện tại phủ gì?** File test nào chạm vùng này, cần môi trường gì, lệnh chạy.
5. **Service dùng chung có đủ API chưa?** Feature cần thao tác gì trên transaction / progress / message…
   và interface hiện tại có sẵn chưa — thiếu thì thành một dòng `## Decisions` ngay từ grill, đừng để
   đến implement mới phát hiện phải mở rộng abstraction giữa chừng.

Kèm: mọi chỗ **doc mâu thuẫn code** phát hiện được.

Bước này **không hỏi người câu nào** — tìm dữ kiện là việc của agent. Nhưng output của nó là hạt giống
cho grill: câu G0 không tự trả lời được, doc mâu thuẫn code, service dùng chung thiếu API — đều là
*quyết định của người*, và chỗ hỏi là **vòng 1 của grill**, không phải ở đây.

## Tiếp theo

`/sonny-flow:grill <Feature>` — hoặc `/sonny-flow:feature <Feature>` để chạy tiếp tới gate gần nhất.
