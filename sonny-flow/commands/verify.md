---
description: Step 5 of the feature flow. Run the project's own test command as the gate and report pass, fail, or not-verifiable. Never weakens a test to make it pass.
argument-hint: <Feature>
---

**Bước 5/6 — verify.** Cổng duy nhất quyết định "code có đúng không".

## Chế độ Inner loop — khi CLAUDE.md của project khai `loopCommand`

G5 chạy đúng lệnh đó và đọc verdict theo [`rules/revit-loop.md`](../rules/revit-loop.md):
exit `0` = **pass** · exit `1` = **fail** · exit `2` = chạy lại một lần, lặp lại thì là **không kiểm
chứng được** (môi trường, không phải code). Phần còn lại của file này vẫn áp dụng nguyên.

## Lệnh test

Lấy từ `CLAUDE.md` của project (mục build/test). **Không tự đoán** — cấu hình build hay có bẫy (tên
configuration có dấu cách phải quote, project test bị CI bỏ qua, test cần môi trường riêng).

Không tìm thấy: hỏi người dùng **một lần**, rồi ghi câu trả lời vào `## Related` của feature doc để lần
sau không phải hỏi lại.

Chạy hẹp lại được thì chạy hẹp (`--filter` theo tên test của feature này) cho nhanh, nhưng **trước khi
kết thúc phải chạy đủ bộ liên quan** — test hẹp xanh mà bộ rộng đỏ là hồi quy.

## "Đủ bộ" = mọi project test mà CLAUDE.md liệt kê

Không chỉ project quen tay. Với Sonny hiện tại là **hai** project, chạy theo thứ tự rẻ-trước:

1. `Sonny.Application.UnitTests` — `dotnet test ... -c "Debug R25"`: vài giây, không cần Revit, fail sớm.
2. `Sonny.Application.Tests` — `dotnet test ... -c "Debug R23"`: launch Revit thật.

Riêng gate Revit, **pass chỉ có nghĩa khi Revit load binary mới**: Revit load DLL của add-in từ thư mục
Addins vào AppDomain *trước* test assembly, và ricaun giữ Revit mở giữa các lần chạy. Quy trình đúng:
đóng Revit test host (`CloseMainWindow()`, chờ ~20s — đừng kill) → build **có deploy** → chạy test.
Skip deploy (`-p:DeployRevitAddin=false`) chỉ hợp lệ khi Addins vừa được deploy từ đúng commit đang
test. Lệch version thì hoặc gate xanh vô nghĩa (chạy code cũ) hoặc `TypeLoadException` cho type mới.

## Gate G5 — ba giá trị, không có giá trị thứ tư

**pass** → đi tiếp `/sonny-flow:doc <Feature>`.

**fail** → dừng. Báo test nào fail và thông báo lỗi thật, nguyên văn. Quay lại `/sonny-flow:implement`.
Cấm: sửa test cho pass, thêm `Ignore`/`Explicit`/`Skip`, nới assertion, bỏ case. Sửa code hoặc sửa spec —
nhưng phải hiểu bên nào sai trước đã.

**không kiểm chứng được** → thiếu môi trường, thiếu license, thiếu fixture, không build được vì lý do
ngoài phạm vi. Nói thẳng như vậy, kèm lý do và lệnh cần chạy. **Đừng báo pass.** Đừng báo "về cơ bản là ổn".

Build sạch **không phải** pass. Một số project ghi rõ điều này trong `CLAUDE.md`; kể cả không ghi thì vẫn
vậy.
