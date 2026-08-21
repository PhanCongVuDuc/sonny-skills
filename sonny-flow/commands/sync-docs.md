---
description: Step 6 of the refactor flow. Sweep every document made stale by a rename or a move — feature docs, architecture docs, CLAUDE.md, diagrams and source links — using the identifiers removed in the change. Use after any refactor, or standalone whenever symbols were renamed.
argument-hint: [base ref để so, mặc định là commit trước khi refactor bắt đầu]
---

**Bước 6/6 của flow refactor — sync-docs.** Tìm mọi tài liệu đã cũ vì lần rename/move này.

Dùng skill [`sync-docs`](../skills/sync-docs/SKILL.md).

Lệnh này dùng được **độc lập** — bất cứ lúc nào đổi tên symbol hoặc chuyển file giữa layer.

## Vào bước này cần gì

**Gate G5 đã qua** — test cũ xanh. Fail hoặc *không kiểm chứng được* thì **dừng**: sync-docs một refactor
chưa được kiểm là ghi vào tài liệu một hành vi có thể đã hỏng.

## Lấy danh sách từ diff, không phải từ ký ức

Câu hỏi đúng **không** phải *"tên này có tồn tại trong source không"* — cách đó ~60% dương tính giả (type
của framework, tên method, tên target build, tên section đều trượt). Câu hỏi đúng là:

> **"Tên này có tồn tại *trước* thay đổi, và giờ không còn không?"**

`$ARGUMENTS` là base ref để so; không có thì lấy commit trước khi refactor bắt đầu.

## Quét bốn nhóm

| Nhóm | Chỗ hay sót |
|---|---|
| Feature doc | `## Contract`, `## Behaviour`, và **`## Related` → túi symbol cho `codegraph explore`** |
| Diagram | Tên participant trong `sequenceDiagram` **là tên type**; nhãn node trong `flowchart` thường là tên method |
| Doc kiến trúc | `docs/architecture/*` — **không phải feature doc nên không lệnh nào khác phụ trách** |
| `CLAUDE.md` / `CONTEXT.md` | `CLAUDE.md` hay khẳng định vị trí layer của một class như sự thật hiện tại. Move class là câu đó thành **sai** |

Cộng: mọi link `[source](../../source/...)` — move file là gãy hết.

## Ba luật

**Sửa mô tả, đừng sửa lịch sử.** ADR cũ không viết lại — thêm ADR mới và đánh `status: superseded by`.

**Phải sửa `## Contract` nghĩa là có vấn đề.** Refactor đúng nghĩa không đổi hành vi. Nên nếu Contract cần
sửa thì hoặc refactor đã đổi hành vi (hỏng), hoặc Contract vốn sai. **Báo cả hai, đừng tự chọn.**

**Tên mới tệ hơn tên cũ thì nói ra ngay.** Đây là lúc duy nhất bạn thấy hai tên cạnh nhau. Rẻ hơn nhiều so
với 6 tháng sau.

## Gate G6 (biến thể refactor)

Không còn identifier nào **bị xoá trong diff** mà vẫn xuất hiện trong `docs/**`, `CLAUDE.md`, `CONTEXT.md`.
Không còn link `[source](...)` trỏ vào đường dẫn không tồn tại — **kiểm bằng máy, đừng đọc bằng mắt**.

Rồi xoá `## Decisions` và `## Plan` khỏi bản nháp ADR, để lại bản ghi quyết định. Làm mới graph bằng lệnh
project khai trong `docs/README.md`.
