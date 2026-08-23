---
description: Wire sonny-flow into the current project. Everything it creates lives in one folder — .sonnyflow/ — plus three mandatory pointer lines in CLAUDE.md and .claude/settings.json. Idempotent; rerun any time to repair.
argument-hint: (không có tham số)
---

**Lắp sonny-flow vào project hiện tại.** Nguyên tắc một câu: **mọi thứ setup tạo đều nằm trong
`.sonnyflow/` của project** — chỉ có con trỏ là bắt buộc nằm ngoài (`CLAUDE.md`,
`.claude/settings.json`, vì hệ thống chỉ đọc ở đó). Tài liệu sản phẩm (`docs/features|adr|bugs`)
KHÔNG thuộc setup — flow tạo chúng khi chạy.

Idempotent: mỗi mục **đã có thì giữ nguyên, thiếu thì tạo**. Không hỏi giữa chừng; cuối lượt in
checklist `đã có / vừa tạo / bỏ qua — lý do`. Template nằm ở `templates/` cạnh `commands/` (lấy đường
dẫn từ "Base directory for this skill" mà harness in đầu lượt).

## Layout đích

```
<project>/
├── .sonnyflow/
│   ├── README.md                    bản đồ folder (template: templates/sonnyflow-readme.md)
│   ├── loop.ps1                     loopCommand — build + trust + test + verdict 0/1/2
│   ├── watch-always-load.ps1        tự click dialog trust
│   ├── hooks/revit-test-guard.ps1   chặn dotnet test trần
│   ├── revit-test-environment.md    bẫy môi trường — đọc trước khi test Revit
│   └── retro/                       kinh nghiệm mỗi lần chạy flow (bước doc bắt buộc ghi)
├── CLAUDE.md                        + loopCommand & pointer về .sonnyflow/ (con trỏ, không nội dung)
└── .claude/settings.json            + hook entry & claudeMdExcludes (con trỏ, không nội dung)
```

## Các mục — theo thứ tự

1. **Nhận diện project.** Đọc `CLAUDE.md`: tìm test project chạy trong Revit (ricaun.RevitTest) và
   configuration mặc định (vd `Debug R23`). Không có test project Revit → chỉ làm mục 5–6, ghi rõ
   trong checklist các mục Revit bị bỏ qua vì sao.

2. **`.sonnyflow/loop.ps1` + `.sonnyflow/watch-always-load.ps1` + `.sonnyflow/README.md`** — copy từ
   `templates/` nếu chưa có; sửa hai biến đầu `loop.ps1` (`$project`, default `$Configuration`) theo
   mục 1. File đã tồn tại thì **không đè**.

3. **Csproj của test project** — bảo đảm có cặp property `RevitTestOpenNew`/`RevitTestCloseAfter` gắn
   vào metadata `NUnit.Open`/`NUnit.Close` (mặc định **true/true**; `-p:RevitTestKeepOpen=true` mới đổi)
   và target `RepackForRevitReload` (ILRepack, merge assembly repo + Nice3point). Bản tham chiếu:
   `source/Sonny.Application.Tests/Sonny.Application.Tests.csproj` của repo Sonny.
   **Build thử một lần với `-p:RevitTestKeepOpen=true` — exit 0 mới tính.**

4. **`.sonnyflow/hooks/revit-test-guard.ps1`** — copy từ `templates/` (sửa tên test project trong
   regex nếu khác), rồi đăng ký vào `.claude/settings.json` → `hooks.PreToolUse`, matcher
   `"Bash|PowerShell"`, command
   `powershell -NoProfile -ExecutionPolicy Bypass -File .sonnyflow/hooks/revit-test-guard.ps1`.
   **Không đụng các hook khác đang có.**

5. **`CLAUDE.md`** — bảo đảm có, đặt cạnh phần lệnh test:
   - `loopCommand: powershell -ExecutionPolicy Bypass -File .sonnyflow\loop.ps1`
   - một câu: mọi cơ khí sonny-flow nằm ở `.sonnyflow/` — **đọc `revit-test-environment.md` trong đó
     trước khi chạy/viết test Revit**; knowledge graph không index `.ps1` lẫn dotfolder, phải tự mở.

6. **`.claude/settings.json`** — bảo đảm `claudeMdExcludes` chứa `"docs/features/**"`.

7. **`.sonnyflow/revit-test-environment.md`** — chưa có thì tạo khung đúng các heading của bản Sonny
   (bản tham chiếu đầy đủ): *Chạy test thế nào* (verdict 0/1/2, "đủ bộ" gồm những project nào) ·
   *Trust "Always Load"* · *Bốn quy tắc vàng* · *Fixture tự sinh* · *Máy này có gì/thiếu gì* ·
   *Automation*. Nội dung máy-cụ-thể để trống kèm ghi chú "điền khi trả giá xong".

8. **`docs/bugs/README.md`** — chưa có thì tạo khung index (Mã · Mô tả một dòng · Feature · Status)
   kèm hai câu luật từ `rules/gates.md` mục Bugs. (Bug là sản phẩm nên ở `docs/`, không ở `.sonnyflow/`.)
