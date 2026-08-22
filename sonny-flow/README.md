# sonny-flow

Quy trình làm feature có **gate bằng file thật**: mỗi bước chỉ qua khi có thứ kiểm được bằng máy hoặc
bằng mắt người — không lấy câu "xong rồi" của AI làm căn cứ. Trạng thái sống trong chính
`docs/features/{Feature}.md`; thứ còn lại sau cùng là **tài liệu kèm diagram**.

```
FEATURE   0 orient → 1 grill → 2 spec     → 3 plan ─NGƯỜI DUYỆT→ 4 implement → 5 verify → 6 doc
REFACTOR  0 orient → 1 grill → 2 baseline → 3 plan ─NGƯỜI DUYỆT→ 4 implement → 5 verify → 6 sync-docs
BUG FIX   = chạy lại FEATURE trên feature đó (điểm vào: dòng trong ## Known bugs của feature doc)
```

## Gõ gì

```
/sonny-flow:setup                   lắp plugin vào project (một lần, idempotent) — xem bảng dưới
/sonny-flow:feature <F>             chạy cả flow; đọc file để biết đang ở bước nào, chạy tiếp từ đó
/sonny-flow:refactor <mô tả>        biến thể không-đổi-hành-vi; trạng thái ở bản nháp ADR
```

Gõ lần đầu → chạy tới human gate rồi dừng; **gõ lại chính là sự duyệt**. Từng bước rời:
`orient` · `grill` · `spec`/`baseline` · `plan` · `implement [số task]` · `verify` · `doc`/`sync-docs`
(ba lệnh cuối dùng độc lập được, không cần đi kèm task).

## Gate — chi tiết ở [`rules/gates.md`](rules/gates.md)

| Gate | Điều kiện qua | Ai phán |
|---|---|---|
| G0 orient | trả lời 4 câu: layer · ai gọi vào · pattern noi theo · test phủ gì | máy |
| G1 grill | `## Decisions` hết dòng CHƯA CHỐT | **người**, mỗi vòng |
| G2 spec | `## Contract` đủ Input/Output/Invariants/**failure modes** (refactor: lưới test xanh) | máy |
| G3 plan | checklist `- [ ]`, mỗi task nêu file + test | **người duyệt** |
| G4 implement | không còn `- [ ]`; test rút từ Contract, không rút từ code vừa viết | máy |
| G5 verify | lệnh test của project **pass** — cấm nới test, build sạch ≠ pass | máy |
| G6 doc | xoá 3 section tạm; `sequenceDiagram` + mỗi silent skip một node; **retro bắt buộc**; lệch doc/code thì báo, không tự sửa | máy |

## Tình huống nào → đọc rule nào

| Tình huống | Rule |
|---|---|
| Chạy/viết test trong Revit, project có `loopCommand:` trong CLAUDE.md | [`rules/revit-loop.md`](rules/revit-loop.md) — reload trước restart sau, verdict 0/1/2, 3-RED-thì-dừng |
| Task cần fixture `.rvt` mới | [`rules/revit-fixture.md`](rules/revit-fixture.md) — builder-tự-vẽ, bẫy môi trường, **family phải hỏi người trước** |
| Phát hiện bug ngoài scope | [`rules/gates.md`](rules/gates.md) mục Known bugs — ghi vào feature doc, cấm fix im lặng |
| Bất kỳ gate nào | [`rules/gates.md`](rules/gates.md) |

## Cài & lắp

```
/plugin marketplace add PhanCongVuDuc/sonny-skills
/plugin install sonny-flow@sonny-skills
/sonny-flow:setup            ← trong Claude Code của project
```

`setup` idempotent, kiểm-thiếu-thì-tạo: `loopCommand` + pointer trong `CLAUDE.md` ·
`scripts/loop.ps1` + `scripts/Watch-AlwaysLoad.ps1` · khung `docs/architecture/revit-test-environment.md` ·
hook chặn `dotnet test` trần · `claudeMdExcludes` cho `docs/features/**`. Xong in checklist đã-có/vừa-tạo.

Project cần sẵn: **graphify** + **codegraph** đã index (bước 0/6), plugin **mattpocock-skills** (bước 1
gọi lại `grilling`), `docs/` + `docs/adr/` + `CONTEXT.md`, và một lệnh test trong `CLAUDE.md`.

## Năm điều cố ý không làm

Không tự vượt human gate (ranh giới gate = ranh giới lệnh) · không bịa câu hỏi ở grill, cũng không đoán
để né hỏi · không nới test cho pass · G5 chưa qua thì cấm chạy doc · không tự sửa doc theo code — lệch
thì trình cả hai khả năng cho người chọn.

## Nguồn

Bước 1 gọi lại `grilling` + `domain-modeling` của [mattpocock/skills](https://github.com/mattpocock/skills).
Ý "gate bằng file thật" từ harness `arent-workflow` (ADR 0005 repo `sonny-skills`). Viết cho một project
thật (Sonny — Revit add-in C#); chỗ phụ thuộc project đọc từ chính project, không hardcode.
