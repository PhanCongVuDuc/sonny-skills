# 0001 — Kiến thức Revit sống ở ba nhà, phân loại theo từng bài học

| | |
|---|---|
| **Status** | accepted (2026-08-23) |
| **Quyết định bởi** | chủ dự án, sau grill session về ba file revit-test-environment / test-safety-net / revit-fixture |

## Bối cảnh

Kiến thức về làm task Revit nằm rải ở ba file và bị cảm nhận là "lộn xộn". Nguyên nhân đo được: ranh giới
đang cắt theo **file**, trong khi kiến thức lệch nhau theo **từng bài học** — file môi trường của project
chứa 4/5 bài học tổng quát (callback, OnSetup, async, category ẩn), còn rule chung của plugin lại chứa chi
tiết riêng của Sonny; một bài học (`async`) tồn tại ở **ba** chỗ cùng lúc và đã bắt đầu trôi dạt — đúng căn
bệnh duplication vừa chữa ở commands/skills cùng ngày.

## Quyết định

Ba nhà, phân loại theo **từng bài học** bằng một câu kiểm định:

> **"Đổi sang một project Revit khác dùng sonny-flow, bài học này còn đúng không?"**

| Nhà | Loại | Chứa |
|---|---|---|
| `rules/` của plugin | **RULES** — cách làm đúng | còn đúng khi đổi project (reload-trước-restart, xin-file-thật-trước, test-`void`…) |
| `.sonnyflow/` của project | **FACTS** — sự thật hiện tại | sai khi đổi project hoặc đổi máy (env doc, test-safety-net, fixture facts) |
| `.sonnyflow/retro/` | **RETRO** — inbox | bài học thô chưa phân loại; mỗi bài gắn nhãn `→ plugin` / `→ .sonnyflow` + trạng thái đã chép chưa |

Luật đi kèm: **một bài học một nhà duy nhất** — nhà kia chỉ được đặt con trỏ. Write-path: bài học sinh ra
trong retro (ô 6d của Flow-state), gắn nhãn bằng câu kiểm định; `→ .sonnyflow` chép ngay, `→ plugin` là đề
xuất chờ người gật vì đụng repo khác.

`rules/` chia theo ba câu hỏi: **chạy** test (`revit-loop.md`) · **viết** test/builder (`revit-test.md`) ·
**dựng** fixture (`revit-fixture.md`).

## Phương án bị loại

**Hai loại theo file** (file project vs file chung — đề xuất ban đầu): bị loại vì chính nó là hiện trạng
gây lộn xộn — một file luôn chứa lẫn hai loại bài học, và bài học chung kẹt trong file project thì project
sau không bao giờ thấy.

## Hệ quả chấp nhận

- File trong `.sonnyflow/` vô hình với cả hai knowledge graph (không index dotfolder) — bù bằng con trỏ
  bắt buộc trong `CLAUDE.md` của project.
- Nhãn trong retro là bước thủ công; gate 6d kiểm sự tồn tại của nhãn chứ không kiểm nhãn đúng.
