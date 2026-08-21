# Inner loop — chế độ tự trị sau gate plan

**Inner loop** = vòng lặp trong cùng, thứ agent lặp nhiều nhất: *sửa code → build → chạy test → đọc
verdict*. Mỗi vòng tính bằng giây, một task đi qua hàng chục vòng.

Chế độ này chỉ tồn tại ở project đã khai nó trong `CLAUDE.md`:

```
loopCommand: powershell -ExecutionPolicy Bypass -File scripts\loop.ps1
```

Có khai báo → sau human gate G3 (duyệt plan), `implement` và `verify` chạy tự trị theo luật dưới đây,
không hỏi giữa chừng — tiếng nói duy nhất được phép dừng flow là luật dừng. Không khai báo → hai bước
đó giữ nguyên hành vi mặc định.

sonny-flow không biết gì về Revit hay bất kỳ môi trường nào. Nó chỉ biết project có **một lệnh trả
verdict 0/1/2** và **một bộ luật dừng**. Phần "Riêng Revit" cuối file là tri thức của loại project đó,
kích hoạt khi CLAUDE.md của project nói test chạy trong Revit.

## Verdict — ba mã, không có mã thứ tư

| Exit | Nghĩa | Việc phải làm |
|---|---|---|
| `0` | GREEN, và ít nhất một test đã thật sự chạy | đi tiếp |
| `1` | RED, hoặc build hỏng — đọc output để biết là cái nào | sửa. Đừng lẫn hai trường hợp |
| `2` | **Không tìm thấy test nào để chạy** | KHÔNG phải pass. Chạy lại một lần; lặp lại → môi trường có vấn đề, dừng — **đừng sửa code** |

Mã `2` tồn tại vì `dotnet test` trần trả exit 0 kể cả khi nó không chạy test nào — "xanh giả".

## Luật dừng — cứng, không thương lượng

| Luật | Nội dung |
|---|---|
| **Test trước, phải RED** | Acceptance test viết trước code và phải được nhìn thấy ĐỎ. Test chưa từng fail chưa chứng minh nó test cái gì |
| **3-RED-thì-dừng** | Cùng một task RED 3 lần liên tiếp → dừng, báo cáo cho người. Vòng tự-debug không giới hạn sẽ hội tụ về *làm test xanh* thay vì *làm code đúng* — nới assertion, nuốt exception, xoá case fail |
| **Cấm nới test** | Không sửa test cho dễ pass, không `Ignore`/`Explicit`/`Skip`, không nới assertion, không bỏ case. Đổi giá trị kỳ vọng chỉ hợp lệ khi nói được vì sao kỳ vọng cũ sai. Đang bị cám dỗ sửa assertion chính là tín hiệu dừng |
| **Exit-2 hai lần** | Là môi trường, không phải code. Đi xem process host / môi trường, không đụng code |

## Escalation ladder — khi RED khó hiểu, leo đúng thứ tự

1. Đọc kỹ output test, chạy lại `loopCommand`.
2. **Nhìn vào trong**: dùng kênh chẩn đoán của project để biết trạng thái thật (với Revit: RevitBridge
   `send_code` đọc model, `get_model_warnings_summary`, `capture_view_image`).
3. Restart process host (với Revit: 60–90s và mất hết hiện trường trong process — vì thế nó đứng gần
   cuối, không phải phản xạ đầu).
4. Dừng và báo cáo.

Không nhảy cóc. Mỗi nấc đắt hơn và phá nhiều ngữ cảnh hơn nấc trước.

## Riêng Revit — hai đường code vào process, đừng lẫn

| Đường | Phiên bản code | Dùng để |
|---|---|---|
| **Test** (ricaun.RevitTest) | DLL test được nạp **lại mỗi lần chạy** → luôn là code mới nhất | Chạy code vừa viết. Đường **duy nhất** |
| **`send_code`** (RevitBridge MCP) | Assembly add-in nạp lúc Revit khởi động → **code cũ**, đứng yên đến khi restart Revit | **Chỉ để nhìn**: đếm element, đọc parameter, hỏi "trong model thực sự có gì" — bằng Revit API trần |

Gọi method của add-in qua `send_code` rồi thắc mắc sao sửa code mà kết quả không đổi = **stale
binding**, cái bẫy đắt nhất của loại loop này. Kết quả `send_code` không bao giờ được tính là pass —
Gate of truth là `loopCommand`.

## Quyền trên process Revit

Ở project đã bật chế độ này, agent được **tự khởi động và tự restart Revit không cần hỏi**. Một guard
duy nhất, không miễn trừ: **trước mọi restart và mọi lệnh ghi model qua MCP, kiểm tra danh sách
document đang mở; thấy document không thuộc phạm vi test (file thật của người dùng) → huỷ hành động,
báo cáo.** Guard này là thứ duy nhất đứng giữa vòng lặp và công việc thật của con người trên cùng máy.
