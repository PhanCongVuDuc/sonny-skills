---
name: sync-docs
description: Find and fix every document that a rename or a move made stale, by taking the identifiers removed in the change and sweeping all docs for them. Use after a refactor, or whenever symbols were renamed or moved between layers.
---

# sync-docs

Sau một lần rename hoặc move, **bán kính ảnh hưởng lên tài liệu là thứ không ai nhớ hết.** Skill này tìm
nó bằng máy thay vì bằng ký ức.

## Gate đúng: lấy từ diff, không phải từ "tên này có tồn tại không"

Cách ngây thơ — quét mọi identifier trong docs rồi hỏi *"nó có trong source không"* — **không dùng được.**
Đo thật trên repo Sonny: 134 identifier trong 6 file docs, **82 cái "không khớp"** — mà gần hết là dương
tính giả: type của framework (`BasisZ`, `BuiltInCategory`), tên method (`Assimilate`, `CreateColumns`), tên
target build (`Compile`, `DeployRevitAddin`), tên section (`Contract`, `Behaviour`). ~60% nhiễu.

Câu hỏi đúng là:

> **"Tên này có tồn tại *trước* thay đổi, và giờ không còn không?"**

Lấy từ diff. Chính xác, gần như không nhiễu, và **vét cạn** — nó bắt cả những chỗ bạn không nhớ.

```bash
# identifier bi XOA trong thay doi nay
git diff <base> -- '*.cs' | grep '^-' | grep -oE '\b(class|interface|record|struct|enum)\s+\w+' | awk '{print $2}' | sort -u
git diff <base> -- '*.cs' | grep '^-' | grep -oE '\b[A-Z]\w{3,}\b' | sort -u    # rong hon: type + member
```

Rồi grep từng tên đó trong toàn bộ tài liệu. Trúng = chỗ đó cũ.

Đổi **namespace/layer** mà giữ tên class thì diff không thấy tên bị xoá — nên phải grep thêm đường dẫn
file cũ (`source/<Layer>/...`) trong docs, vì link `[source](...)` sẽ gãy.

## Quét những chỗ nào

Đừng chỉ quét feature doc. Bốn nhóm, nhóm 3 và 4 là nhóm hay bị bỏ:

| Nhóm | Cụ thể |
|---|---|
| 1. Feature doc | `## Contract`, `## Behaviour`, và **`## Related` → túi symbol cho `codegraph explore`** (rất hay sai, không ai kiểm) |
| 2. Diagram | Tên participant trong `sequenceDiagram` **là tên type**; nhãn node trong `flowchart` thường là tên method |
| 3. Doc kiến trúc | `docs/architecture/*` — **không phải feature doc nên không lệnh nào phụ trách nó** |
| 4. `CLAUDE.md` / `CONTEXT.md` | `CLAUDE.md` hay khẳng định vị trí layer của một class dưới dạng sự thật hiện tại. Move class là câu đó thành **sai** |

Cộng: link `[source](../../source/...)` trong mọi doc — move file là gãy hết.

## Ba luật

**Sửa mô tả, đừng sửa lịch sử.** ADR cũ **không** được viết lại — nó là quyết định tại một thời điểm.
Quyết định mới thì thêm ADR mới và đánh `status: superseded by <NNNN>` lên cái cũ.

**Doc nói sai về hành vi thì báo, đừng lẳng lặng viết đè.** Refactor đúng nghĩa **không đổi hành vi** — nên
nếu bạn thấy phải sửa `## Contract` thì có hai khả năng: refactor đã đổi hành vi (tức là hỏng), hoặc
Contract vốn đã sai. Cả hai đều phải nói ra, không tự chọn.

**Đừng đổi tên trong doc để khớp code nếu tên mới tệ hơn.** Đây là lúc duy nhất bạn thấy tên cũ và tên mới
cạnh nhau. Tên mới khó hiểu hơn thì nói ra ngay — rẻ hơn nhiều so với 6 tháng sau.

## Gate

Không còn identifier nào **bị xoá trong diff** mà vẫn xuất hiện trong `docs/**`, `CLAUDE.md`, hay
`CONTEXT.md`. Không còn link `[source](...)` trỏ vào đường dẫn không tồn tại.

Kiểm link bằng máy được, nên kiểm — đừng chỉ đọc bằng mắt:

```bash
# moi link tuong doi trong docs co phan giai duoc khong
grep -rhoE '\]\(([^)]+)\)' docs/ | sed 's/](\(.*\))/\1/' | grep -v '^http' | sort -u
```

Xong thì làm mới graph bằng lệnh project khai trong `docs/README.md`, để tên mới thành node trong graph.
