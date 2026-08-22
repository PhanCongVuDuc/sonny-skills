---
description: Wire sonny-flow into the current project — loopCommand, loop scripts, the raw-dotnet-test guard hook, the Revit test environment doc, and claudeMdExcludes. Idempotent; run once per project, rerun any time to repair.
argument-hint: (không có tham số)
---

**Lắp sonny-flow vào project hiện tại.** Idempotent: mỗi mục kiểm tra **đã có thì giữ nguyên, thiếu thì
tạo** — chạy lại bao nhiêu lần cũng vô hại. Không hỏi giữa chừng; cuối lượt in checklist.

Template nằm ở `templates/` cạnh thư mục `commands/` này (dùng "Base directory for this skill" mà harness
in ra ở đầu lượt để lấy đường dẫn tuyệt đối).

## Các mục — theo đúng thứ tự

1. **Nhận diện project.** Đọc `CLAUDE.md` gốc repo: tìm test project chạy trong Revit (kiểu
   `*.Tests.csproj` dùng ricaun.RevitTest) và configuration mặc định (vd `Debug R23`). Không tìm thấy
   test project Revit nào → chỉ làm mục 5–6, ghi rõ trong checklist là các mục Revit bị bỏ qua vì sao.

2. **`scripts/loop.ps1` + `scripts/Watch-AlwaysLoad.ps1`** — copy từ `templates/` nếu chưa có. Sau khi
   copy `loop.ps1`, sửa hai biến đầu file (`$project`, default của `$Configuration`) cho khớp project
   vừa nhận diện. File đã tồn tại thì **không đè** — người dùng có thể đã chỉnh.

3. **Csproj của test project** — kiểm tra có cặp property `RevitTestOpenNew`/`RevitTestCloseAfter` gắn
   vào metadata `NUnit.Open`/`NUnit.Close`, và target `RepackForRevitReload` (ILRepack,
   `Condition="'$(RevitTestKeepOpen)' == 'true'"`). Thiếu thì thêm theo mẫu trong repo Sonny
   (`source/Sonny.Application.Tests/Sonny.Application.Tests.csproj` là bản tham chiếu):
   metadata mặc định **true/true** (mở-đóng sạch), chỉ đổi false/false khi build với
   `-p:RevitTestKeepOpen=true`; target repack merge các assembly của repo vào DLL test rồi xoá bản rời.
   **Xong phải build thử một lần với `-p:RevitTestKeepOpen=true` — exit 0 mới tính.**

4. **`.claude/hooks/revit-test-guard.ps1`** — copy từ `templates/` nếu chưa có (sửa tên test project
   trong regex nếu khác), rồi đăng ký vào `.claude/settings.json` → `hooks.PreToolUse`, matcher
   `"Bash|PowerShell"`, command
   `powershell -NoProfile -ExecutionPolicy Bypass -File .claude/hooks/revit-test-guard.ps1`.
   Đã có entry này thì thôi. **Không đụng các hook khác đang có.**

5. **`CLAUDE.md`** — bảo đảm có (thiếu dòng nào thêm dòng đó, đặt cạnh phần lệnh test):
   - `loopCommand: powershell -ExecutionPolicy Bypass -File scripts\loop.ps1`
   - một câu trỏ tới `docs/architecture/revit-test-environment.md` ("đọc trước khi chạy/viết test Revit")
   - một câu: automation nằm ở `scripts/`, knowledge graph không index `.ps1`, phải tự mở xem.

6. **`docs/architecture/revit-test-environment.md`** — chưa có thì tạo khung với đúng các heading của
   bản Sonny (bản tham chiếu đầy đủ): *Chạy test thế nào* (loopCommand + verdict 0/1/2) · *Trust
   "Always Load"* · *Bốn quy tắc vàng* · *Fixture tự sinh* · *Máy này có gì/thiếu gì* · *`scripts/`*.
   Nội dung máy-cụ-thể để trống kèm ghi chú "điền khi trả giá xong".

7. **`.claude/settings.json`** — bảo đảm `claudeMdExcludes` chứa `"docs/features/**"`.

8. **`docs/bugs/README.md`** — chưa có thì tạo khung index (bảng: Mã · Mô tả một dòng · Feature ·
   Status) kèm hai câu luật từ `rules/gates.md` mục Bugs.

## Checklist cuối lượt

In bảng: mục · trạng thái (`đã có` / `vừa tạo` / `bỏ qua — lý do`). Có mục `vừa tạo` ở 3 thì nhắc: lần
chạy `loop.ps1` đầu tiên sau rebuild sẽ gặp dialog trust — watcher lo, nhưng đừng hoảng khi thấy Revit
đứng im ~1 phút lúc khởi động.
