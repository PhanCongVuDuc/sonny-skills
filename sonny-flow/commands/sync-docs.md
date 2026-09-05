---
description: Step 6 of the refactor flow. Sweep every document made stale by a rename or a move — feature docs, architecture docs, CLAUDE.md, diagrams and source links — using the identifiers removed in the change. Use after any refactor, or standalone whenever symbols were renamed.
argument-hint: [base ref để so, mặc định là commit trước khi refactor bắt đầu]
model: opus
---

**Bước 6/6 của flow refactor — sync-docs.** Sau một lần rename/move, **bán kính ảnh hưởng lên tài liệu
là thứ không ai nhớ hết** — tìm nó bằng máy thay vì bằng ký ức.

Lệnh này dùng được **độc lập** — bất cứ lúc nào đổi tên symbol hoặc chuyển file giữa layer.

## Vào bước này cần gì

**Gate G5 đã qua** — test cũ xanh (nhìn `## Flow-state` trong bản nháp ADR). Fail hoặc *không kiểm chứng
được* thì **dừng**: sync-docs một refactor chưa được kiểm là ghi vào tài liệu một hành vi có thể đã hỏng.

## Lấy danh sách từ diff, không phải từ ký ức

Câu hỏi đúng **không** phải *"tên này có tồn tại trong source không"* — đo thật trên repo Sonny: 134
identifier trong 6 file docs thì 82 cái "không khớp", gần hết là dương tính giả (type framework, tên
method, tên target build, tên section) — **~60% nhiễu**. Câu hỏi đúng là:

> **"Tên này có tồn tại *trước* thay đổi, và giờ không còn không?"**

`$ARGUMENTS` là base ref để so; không có thì lấy commit trước khi refactor bắt đầu.

```bash
# identifier bi XOA trong thay doi nay
git diff <base> -- '*.cs' | grep '^-' | grep -oE '\b(class|interface|record|struct|enum)\s+\w+' | awk '{print $2}' | sort -u
git diff <base> -- '*.cs' | grep '^-' | grep -oE '\b[A-Z]\w{3,}\b' | sort -u    # rong hon: type + member
```

Rồi grep từng tên trong toàn bộ tài liệu — trúng = chỗ đó cũ. Đổi **namespace/layer mà giữ tên class**
thì diff không thấy tên bị xoá — phải grep thêm đường dẫn file cũ (`source/<Layer>/...`), vì link
`[source](...)` sẽ gãy.

## Quét bốn nhóm — nhóm 3 và 4 hay bị bỏ

| Nhóm | Chỗ hay sót |
|---|---|
| 1. Feature doc | `## Contract`, `## Behaviour`, và **`## Related` → túi symbol cho `codegraph explore`** (rất hay sai, không ai kiểm) |
| 2. Diagram | Tên participant trong `sequenceDiagram` **là tên type**; nhãn node trong `flowchart` thường là tên method |
| 3. Doc kiến trúc | `docs/architecture/*` — không phải feature doc nên không lệnh nào khác phụ trách |
| 4. `CLAUDE.md` / `CONTEXT.md` | Hay khẳng định vị trí layer của một class như sự thật hiện tại — move class là câu đó thành **sai** |

Cộng: mọi link `[source](../../source/...)` — move file là gãy hết.

## Ba luật

**Sửa mô tả, đừng sửa lịch sử.** ADR cũ không viết lại — thêm ADR mới và đánh `status: superseded by`.

**Phải sửa `## Contract` nghĩa là có vấn đề.** Refactor đúng nghĩa không đổi hành vi — Contract cần sửa
thì hoặc refactor đã đổi hành vi (hỏng), hoặc Contract vốn sai. **Báo cả hai, đừng tự chọn.**

**Tên mới tệ hơn tên cũ thì nói ra ngay.** Đây là lúc duy nhất thấy hai tên cạnh nhau — rẻ hơn nhiều so
với 6 tháng sau.

## Gate G6 (biến thể refactor) — tick từng ô con trong `## Flow-state` của ADR

Không còn identifier **bị xoá trong diff** mà vẫn xuất hiện trong `docs/**`, `CLAUDE.md`, `CONTEXT.md`.
Không còn link `[source](...)` trỏ vào đường dẫn không tồn tại — **kiểm bằng máy, đừng đọc bằng mắt**:

```bash
grep -rhoE '\]\(([^)]+)\)' docs/ | sed 's/](\(.*\))/\1/' | grep -v '^http' | sort -u
```

Rồi: retro (`.sonnyflow/retro/` + một dòng LESSONS.md) · làm mới graph đủ mọi lệnh `docs/README.md`
khai · cuối cùng xoá `## Flow-state`/`## Decisions`/`## Plan` khỏi bản nháp ADR, để lại bản ghi quyết định.
