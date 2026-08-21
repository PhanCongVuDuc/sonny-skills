---
name: orient
description: Build an accurate picture of the code a feature will touch, from three sources in a fixed order — project behaviour docs, the graphify knowledge graph, and the codegraph index. Use before writing any spec or plan, and whenever a task lands in unfamiliar code.
---

# orient

Hiểu code **trước** khi viết spec. Spec viết mà chưa biết những abstraction nào đang tồn tại thì sẽ mô tả
một hệ thống không có ở đây.

## Ba nguồn, đúng thứ tự này

Thứ tự không phải tuỳ ý — mỗi nguồn trả lời loại câu hỏi mà nguồn trước không trả lời được.

**1. `docs/` của project — ý định.**
Đọc `docs/README.md` trước để biết thứ tự đọc mà project quy định. Rồi doc kiến trúc, rồi feature doc
liên quan. Đây là nguồn duy nhất có: silent behaviour, order dependency, unit boundary, invariant, và
những chỗ trông như bug mà là cố ý. Graph **không** có mấy thứ đó.

**2. graphify — cấu trúc và bối cảnh.**

```
graphify query "<câu hỏi bằng tiếng Anh>"
graphify explain "<Symbol>"
graphify affected "<Symbol>" --depth 2
```

Nó index cả `.md` và `.xaml`. Dùng cho: kiến trúc, binding trong XAML, khoá resource localization, và
định hướng khi chưa biết bắt đầu từ đâu. Nó nhận câu hỏi bằng ngôn ngữ tự nhiên.

**3. codegraph — source thật.**

```
codegraph node "<Type.Member>"
codegraph explore "<Name1 Name2 Name3>"
codegraph impact "<Symbol>"
```

**Đưa cho nó một túi tên symbol, không đưa câu hỏi tiếng Anh.** Đây là lỗi tốn thời gian nhất khi dùng
codegraph: hỏi *"where is IColumnDataExtractor registered in dependency injection?"* thì nó trả về file
sai; đưa `"AddColumnFromCadServices IColumnDataExtractor ServiceRegistration"` thì nó trả về đúng dòng.
Lấy tên từ bước 2 hoặc từ prompt hook, rồi mới gọi codegraph.

Cái nó trả về là **source thật, có số dòng, đọc lại từ disk mỗi lần gọi** — coi như đã đọc rồi, đừng
`Read` lại.

## Khi hai graph bất đồng

Project có thể đã khai bảng phân xử trong `CLAUDE.md` — nếu có thì bảng đó thắng. Không có thì mặc định:

| Câu hỏi | Tin ai |
|---|---|
| Code nói gì, đúng số dòng | **codegraph** — nó đọc lại từ disk |
| Phạm vi ảnh hưởng đầy đủ của một thay đổi | **codegraph** (`impact` là transitive) |
| Binding `.xaml`, khoá localization | **graphify** — codegraph không index `.xaml` |
| Ý định kiến trúc, mọi thứ dưới `docs/` | **graphify** — codegraph không index `.md` |
| Hai bên trỏ cùng một chỗ | Xong. Đừng kiểm thêm |
| Doc mâu thuẫn code | **Không tự chọn.** Xem dưới |

**Doc mâu thuẫn code là phát hiện, không phải nhiễu.** Nêu ra ngay ở bước này, đừng lặng lẽ tin bên nào.
Có khi doc cũ; có khi code đã lệch khỏi yêu cầu. Người quyết.

## Gate G0 — bốn câu phải trả lời được

Chưa trả lời được thì tìm tiếp, **không đoán**:

1. **Chạm layer nào?** Kể tên project/thư mục cụ thể. Nếu có tầng nào là "pure" (không phụ thuộc framework
   nặng, mock được) thì nói rõ việc này rơi vào tầng pure hay không — nó quyết định test có tự chạy được.
2. **Ai gọi vào?** Đường từ điểm vào của người dùng tới nơi sẽ sửa. Kể cả những hop mà graph không thấy
   (DI generic, binding), lấy từ doc kiến trúc.
3. **Pattern nào đang có để noi theo?** Chỉ ra một chỗ trong codebase đã làm việc tương tự. Không có thì
   nói là không có — đó là tín hiệu rằng đây là abstraction mới và cần bàn.
4. **Test hiện tại phủ gì?** File test nào chạm vùng này, chúng cần môi trường gì, và lệnh chạy chúng.

## Đừng làm

- Đừng `grep` cả repo khi codegraph trả lời được. Nó nhanh hơn và không bỏ sót caller.
- Đừng đọc cả file lớn để tìm một member. `codegraph node "Type.Member"` trả đúng phần đó.
- Đừng bỏ bước 1 để nhảy vào code. Silent behaviour chỉ nằm trong `docs/`; đọc code nhanh sẽ không thấy
  một `catch { }` là *có chủ ý* hay là bug.
