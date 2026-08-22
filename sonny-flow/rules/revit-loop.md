# Inner loop — chế độ tự trị sau gate plan

**Inner loop** = sửa code → build → chạy test → đọc verdict. Mỗi vòng tính bằng giây.

Bật khi `CLAUDE.md` của project khai:

```
loopCommand: powershell -ExecutionPolicy Bypass -File scripts\loop.ps1
```

Có khai → sau gate G3 (người duyệt plan), `implement` + `verify` chạy tự trị theo luật dưới, không hỏi
giữa chừng. Không khai → hành vi mặc định, không có gì thay đổi.

## Luật số 1 — reload trước, restart sau

**Revit đang mở, vừa đổi code → ĐỪNG tắt Revit. Chạy lại `loopCommand` — ricaun nạp lại DLL test mỗi
lần chạy, tức là nạp lại code mới. Chỉ khi reload không ăn hoặc Revit kẹt mới đóng model và tắt/mở
Revit.**

Điều kiện để reload hoạt động: code đang test phải nằm **bên trong DLL test**. Hai cách — **đã nghiên
cứu và confirm là đúng** (test đến RED trong cùng một process Revit, không restart), cứ theo thế mà chạy:

| Cách | Dùng khi | Cơ chế |
|---|---|---|
| **Compile-in** (`<Compile Include>`) | project C# thuần, không XAML | compile source thẳng vào DLL test. Nhiều project = nhiều glob, vẫn reload (đã test 2 project cùng lúc) |
| **Repack** (ILRepack) | project có WPF/XAML (vd: Sonny) | **giữ nguyên** `ProjectReference`, merge DLL project vào DLL test sau build; XAML/BAML đi theo |

`ProjectReference` **đứng một mình** = stale binding: code project nằm ở DLL riêng, CLR bind vào bản
Revit nạp lúc đầu — sửa code mấy vẫn chạy bản cũ. Đây là trường hợp **duy nhất** phải tắt/mở Revit mỗi
lần, và là tín hiệu csproj test cần refactor theo một trong hai cách trên.

## Verdict — ba mã, không có mã thứ tư

| Exit | Nghĩa | Làm gì |
|---|---|---|
| `0` | GREEN, ít nhất một test đã chạy thật | đi tiếp |
| `1` | RED hoặc build hỏng — đọc output để phân biệt | sửa |
| `2` | không thấy test nào để chạy | **KHÔNG phải pass.** Chạy lại một lần; lặp lại = môi trường, dừng |

## Luật dừng — cứng

- **Test trước, phải RED.** Test chưa từng fail chưa chứng minh nó test cái gì.
- **3 RED liên tiếp cùng task → dừng, báo cáo.** Loop không giới hạn sẽ học cách làm test xanh thay vì
  làm code đúng.
- **Cấm nới test.** Không `Ignore`/`Skip`, không nới assertion, không bỏ case. Đổi kỳ vọng phải nói
  được kỳ vọng cũ sai chỗ nào.
- **Exit-2 hai lần = môi trường.** Đi xem Revit, đừng sửa code.

## Kẹt thì leo đúng thứ tự

1. Chạy lại `loopCommand` (reload).
2. Nhìn vào model bằng RevitBridge: `send_code` (chỉ đọc), `get_model_warnings_summary`,
   `capture_view_image`.
3. Tắt/mở Revit — nấc gần cuối: 60–90s, mất hết hiện trường trong process.
4. Dừng, báo cáo.

## `send_code` chỉ để nhìn

`send_code` compile trong process Revit nhưng thấy **bản add-in nạp lúc Revit khởi động** — code cũ
cho tới khi restart. Chạy code vừa viết = chỉ qua đường test. Kết quả `send_code` không bao giờ được
tính là pass — Gate of truth là `loopCommand`.

## Quyền trên process Revit

Agent tự mở / tự restart Revit không cần hỏi. Guard duy nhất, không miễn trừ: **trước mọi restart và
mọi lệnh ghi model — kiểm tra document đang mở; thấy file thật của người dùng → huỷ hành động, báo
cáo.**
