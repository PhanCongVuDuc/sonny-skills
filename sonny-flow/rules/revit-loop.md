# Inner loop — chế độ tự trị sau gate plan

**Inner loop** = sửa code → build → chạy test → đọc verdict. Mỗi vòng tính bằng giây.

Bật khi `CLAUDE.md` của project khai:

```
loopCommand: powershell -ExecutionPolicy Bypass -File .sonnyflow\loop.ps1
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

## Bốn bẫy của chế độ attach — xác nhận trên Sonny (2026-08-22, 5 vòng reload trong một Revit)

Repack đã chạy thật trên Sonny (`RepackForRevitReload` trong test csproj, bật bằng
`-p:RevitTestKeepOpen=true`). Bốn thứ vỡ trước khi xanh — mỗi cái là điều kiện bắt buộc của attach:

1. **Build dev-loop phải tắt deploy add-in** (`-p:DeployRevitAddin=false`): Revit đang mở khoá thư mục
   Addins, target deploy của Nice3point fail cả build. Add-in cũ trong Revit không sao — code mới đi
   trong DLL test đã repack.
2. **Merge cả Nice3point.Revit.\*** vào DLL test: add-in khác trên máy (AlphaBIM, PentaOcean…) ship bản
   Nice3point CŨ, resolve theo simple-name trúng bản đó → `MissingMethodException`. Merge ghim đúng bản
   repo compile.
3. **Attach chỉ copy assembly, KHÔNG copy thư mục `Resources\`** (khác cold start) — helper tìm fixture
   phải có fallback về thư mục source qua `[CallerFilePath]`.
4. **Cấm NSubstitute trong test chạy attach**: mỗi lần attach nạp thêm một bản test assembly cùng tên;
   Castle proxy resolve interface theo tên assembly → trúng bản nạp ĐẦU → `InvalidCastException
   (ObjectProxy_2)`. Dùng fake viết tay (`TestDoubles.cs`) — `new` trực tiếp thì không có tầng
   resolve nào.

Đổi lại: một vòng sửa-code-chạy-test còn ~30 giây thay vì ~2 phút tắt/mở Revit.

## Test chạy trong Revit: viết `void`, đừng viết `async Task`

NUnit chạy test `async` dưới synchronization context riêng của nó — continuation sau `await` đầu tiên
rời khỏi Revit API thread, và transaction kế tiếp chết với *"Cannot modify the document... changes are
temporarily disabled"*. Viết test `void`, block bằng `.GetAwaiter().GetResult()`, và dùng task runner
chạy inline (fake trong `TestDoubles.cs`). Đã trả giá trên FramingFromCad (2026-08-23).

## Verdict — ba mã, không có mã thứ tư

| Exit | Nghĩa | Làm gì |
|---|---|---|
| `0` | GREEN, ít nhất một test đã chạy thật | đi tiếp |
| `1` | RED hoặc build hỏng — đọc output để phân biệt | sửa |
| `2` | không thấy test nào để chạy | **KHÔNG phải pass.** Chạy lại một lần; lặp lại = môi trường, dừng |

Một dạng exit-1 thực chất là môi trường: **mọi test Failed trong ~20ms, không test nào có Error
Message** — chế độ attach không có Revit nào để bám (hoặc Revit vừa được khởi động, chưa attach kịp).
Chạy lại một lần trước khi chẩn đoán code. Tương tự: sau khi rebuild add-in, lần `-Final`/cold-start đầu
có thể cháy timeout vì dialog trust "Always Load" quay lại (hash DLL đổi) — chạy lại là xanh.

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
