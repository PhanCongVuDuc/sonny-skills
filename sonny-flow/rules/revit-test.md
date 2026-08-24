# Viết test/builder chạy trong Revit — danh sách mở

Đọc rule này khi **viết** một test hay builder sẽ chạy trong process Revit (host ricaun.RevitTest).
Chuyện *chạy* test là [`revit-loop.md`](revit-loop.md); chuyện *dựng fixture* là
[`revit-fixture.md`](revit-fixture.md).

Danh sách mở — trả giá xong bài nào thêm bài đó, mỗi bài: **hiện tượng → nguyên nhân → cách đúng**.
Bài học đúng cho mọi project Revit nằm ở đây; bài học chỉ đúng cho một project nằm trong
`.sonnyflow/revit-test-environment.md` của project đó.

- **Cấm đưa cho Revit callback định nghĩa trong test assembly** (`IFailuresPreprocessor`,
  `IFamilyLoadOptions`). Hiện tượng: MỌI commit trả `RolledBack` không một failure message,
  `LoadFamily` trả false. Nguyên nhân: DLL test bị ricaun shadow-copy nên callback native→managed
  resolve fail, lỗi bị nuốt. Cách đúng: `Commit()` trần; load family **in-memory**
  (`familyDocument.LoadFamily(document, options)` — riêng đường này chạy được); preprocessor chỉ dùng
  loại đã có trong assembly sản phẩm.
- **Document phải được mở ở `OnSetup`** (một sự kiện API riêng), không mở-rồi-commit trong cùng test
  method. Hiện tượng: mọi commit bị hủy ngầm ("attempt to modify wrong element during regeneration") —
  Revit chưa dọn xong trạng thái post-open. Base class mở-document của project là điều kiện đúng đắn,
  không phải tiện nghi.
- **Test viết `void`, đừng viết `async Task`.** NUnit chạy test `async` dưới synchronization context
  riêng — continuation sau `await` đầu tiên rời khỏi Revit API thread, transaction kế tiếp chết với
  *"Cannot modify the document... changes are temporarily disabled"*. Cách đúng: test `void`, block
  bằng `.GetAwaiter().GetResult()`, task runner fake chạy inline.
- **View mới trong file nền sinh từ template kết cấu ẩn category kiến trúc** (Columns, Ceilings,
  Roofs…) → mọi collector view-scoped lặng lẽ trả rỗng. Cách đúng: `SetCategoryHidden(false)` tường
  minh cho từng category test dùng đến.
- **Mock động (NSubstitute/Castle) chết dưới chế độ attach** — dùng fake viết tay trong một file
  `TestDoubles` của project. Lý do đầy đủ ở điều kiện attach #4 trong [`revit-loop.md`](revit-loop.md).
- **Kẹt không rõ vì sao → đọc journal Revit** (`%LOCALAPPDATA%\Autodesk\Revit\<version>\Journals`):
  dialog đang chặn (`TaskDialog "..."`), lỗi regeneration, undo loop — đều được ghi ở đó.
