# sonny-flow

Quy trình làm feature có **gate bằng file thật**: mỗi bước chỉ qua khi có thứ kiểm được bằng máy hoặc
bằng mắt người — không lấy câu "xong rồi" của AI làm căn cứ. Trạng thái và tiến độ sống trong chính
`docs/features/{Feature}.md` — section `## Flow-state` tick từng bước, "xong chưa" trả lời bằng cách
nhìn ô chứ không bằng trí nhớ; thứ còn lại sau cùng là **tài liệu kèm diagram**.

```
FEATURE   0 orient → 1 grill → 2 spec     → 3 plan ─NGƯỜI DUYỆT→ 4 implement → 5 verify → 6 doc
REFACTOR  0 orient → 1 grill → 2 baseline → 3 plan ─NGƯỜI DUYỆT→ 4 implement → 5 verify → 6 sync-docs
BUG FIX   = chạy lại FEATURE trên feature đó (điểm vào: file trong docs/bugs/, link từ ## Related)
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
| G0 orient | trả lời 6 câu: layer · ai gọi vào · pattern noi theo · test phủ gì · service dùng chung đủ API chưa · **project đã có kinh nghiệm nào về vùng này chưa** | máy |
| G1 grill | `## Decisions` hết dòng CHƯA CHỐT | **người**, mỗi vòng |
| G2 spec | `## Contract` đủ Input/Output/Invariants/**failure modes** (refactor: lưới test xanh) | máy |
| G3 plan | checklist `- [ ]`, mỗi task nêu file + test | **người duyệt** |
| G4 implement | không còn `- [ ]`; test rút từ Contract, không rút từ code vừa viết | máy |
| G5 verify | lệnh test của project **pass** — cấm nới test, build sạch ≠ pass | máy |
| G6 doc | 6 ô con trong `## Flow-state` tick hết: đối chiếu code · diagram (mỗi silent skip một node) · soi ADR · **retro + dòng LESSONS.md** · graph đủ mọi lệnh · xoá section tạm cuối cùng; lệch doc/code thì báo, không tự sửa | máy |

## Kiến thức nằm ở đâu — ba nhà

| Nhà | Chứa gì | Điều kiện vào | Ai đọc, ở bước nào |
|---|---|---|---|
| `rules/` của plugin này | **RULES** — cách làm đúng, mọi project | đổi project khác **vẫn đúng** | mọi bước, qua con trỏ trong command |
| `.sonnyflow/lessons/` của project | **LESSONS** — luật riêng của project, **đã được chủ dự án confirm** | chủ dự án gật | **bước 0 (orient), nguồn đọc thứ nhất** — câu G0 số 6; bước 4 khi viết test |
| `.sonnyflow/retro/` | **RETRO** — hàng đợi thứ agent *phát hiện*, chưa ai xét | không điều kiện — agent ghi tự do | bước 0 quét hàng đợi; bước 6d ghi + trình cho người xét |

**Vòng đời một bài học:** lượt flow phát hiện → `retro/` (`chờ xét`) → chủ dự án confirm → `lessons/`
(`đã nhận`, gạch ngang mục retro nhưng **không xoá** để giữ bối cảnh) hoặc bị gạt (`không nhận — lý do`).
Tồn dư trong hàng đợi là **bình thường**, không chặn gate. Một bài học một nhà duy nhất — nhà kia chỉ
được đặt con trỏ. Vì sao thiết kế thế:
[`docs/adr/0001`](docs/adr/0001-knowledge-lives-in-three-homes.md).

## Tình huống nào → đọc rule nào

| Tình huống | Rule |
|---|---|
| Chạy test trong Revit, project có `loopCommand:` trong CLAUDE.md | [`rules/revit-loop.md`](rules/revit-loop.md) — reload trước restart sau, verdict 0/1/2, 3-RED-thì-dừng |
| **Viết** test/builder chạy trong Revit | [`rules/revit-test.md`](rules/revit-test.md) — callback, OnSetup, `void` không `async`, category ẩn, journal |
| Task cần fixture `.rvt` mới | [`rules/revit-fixture.md`](rules/revit-fixture.md) — xin file thật trước, builder-tự-vẽ, **family phải hỏi người trước** |
| Phát hiện bug ngoài scope | [`rules/gates.md`](rules/gates.md) mục Bugs — ghi vào `docs/bugs/`, link từ feature doc, cấm fix im lặng |
| Bất kỳ gate nào | [`rules/gates.md`](rules/gates.md) |

## Cài & lắp

```
/plugin marketplace add PhanCongVuDuc/sonny-skills
/plugin install sonny-flow@sonny-skills
/sonny-flow:setup            ← trong Claude Code của project
```

`setup` idempotent — **mọi thứ nó tạo nằm trong `.sonnyflow/` của project**: `loop.ps1` +
`watch-always-load.ps1` + `hooks/revit-test-guard.ps1` + `revit-test-environment.md` + `retro/`.
Ngoài folder đó chỉ có con trỏ: `loopCommand` trong `CLAUDE.md`, hook entry + `claudeMdExcludes`
trong `.claude/settings.json`. Xong in checklist đã-có/vừa-tạo.

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
