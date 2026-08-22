# Fixture .rvt tự sinh — builder-test vẽ model, integration test mở nó

Đọc rule này khi một task cần **fixture `.rvt` mới** cho integration test. Pattern đã chạy thật ở
AutoJoin (`AutoJoinFixtureBuilder` + `AutoJoinIntegrationTest`, repo Sonny) — lấy đó làm mẫu.

## Luật cứng — hỏi trước, làm sau

**Mọi việc đụng đến family (tạo, load, sửa) phải hỏi chủ dự án và được xác nhận trước khi làm** — kể cả
family hộp tối giản cho fixture. Trình phương án: dùng family sẵn có trong file nào / xin file `.rfa` /
xin phép tự tạo từ template.

## Pattern

1. **Builder là một `[Test]`** trong chính test project, kế thừa base mở-document của project
   (`SonnyDocumentTestBase`). Nó tự `Assert.Ignore` khi fixture đã tồn tại hoặc chạy sai version Revit
   — nên nằm chung suite vô hại. Xóa file `.rvt` = yêu cầu vẽ lại.
2. **Fixture lưu ở version Revit THẤP NHẤT** mà dự án hỗ trợ test (Sonny: 2023) — version cao hơn mở
   được, chiều ngược lại thì không.
3. **Mỗi test case một "station" cách ly** (AutoJoin dùng 15 m) — test dùng chung document đang mở,
   station xa nhau thì mutation của test này không lây sang test kia, thứ tự chạy hết quan trọng.
4. **Element tìm bằng tag trong param Comments** (`ALL_MODEL_INSTANCE_COMMENTS`), tên tag đặt trong một
   class hằng dùng chung builder + test — không pin `UniqueId` với fixture generated.
5. **Builder tự kiểm trước khi save**: từng cặp element phải thật sự giao nhau (hoặc thật sự không, với
   case negative) bằng đúng phép kiểm mà feature dùng; sai là fail với tên case — không bao giờ save
   fixture hỏng. Fail giữa chừng phải xóa file dở để lần chạy sau không tự-skip nhầm.
6. **Đường dẫn nguồn lấy bằng `[CallerFilePath]`** — assembly bị shadow-copy nên đi ngược từ
   `Assembly.Location` không tìm được project.

## Bẫy môi trường — mỗi cái từng đốt nhiều vòng chạy

- **Cấm đưa cho Revit callback định nghĩa trong test assembly** (`IFailuresPreprocessor`,
  `IFamilyLoadOptions`): commit trả `RolledBack` / `LoadFamily` trả false, không một dòng lỗi. Dùng
  `Commit()` trần; load family in-memory; preprocessor lấy từ assembly sản phẩm.
- **Document mở ở `OnSetup`**, không mở-rồi-commit trong cùng test method (event API chưa kết thúc →
  mọi commit bị hủy ngầm).
- **Getter `DocumentFilePath` bị base đọc 2 lần** — có side effect thì phải cache.
- **View mới trong file nền gốc kết cấu ẩn category kiến trúc** → collector view-scoped trả rỗng lặng
  lẽ. `SetCategoryHidden(false)` tường minh cho mọi category fixture dùng.
- **Hai kẻ cắt chồng vùng cắt trên một element → Revit lặng lẽ gỡ join sau tại commit.** Dựng case join
  thì mỗi kẻ cắt một vùng tách biệt.
- Kẹt không rõ vì sao → đọc **journal Revit** (`%LOCALAPPDATA%\Autodesk\Revit\...\Journals`): dialog
  đang chặn, lỗi regeneration, undo loop — đều nằm ở đó.

## Nghiệm thu

Fixture mới phải kèm: dòng trong `test-safety-net.md` (test bind vào tag nào, view nào), mục "cách vẽ
lại" trong feature doc, và toàn bộ suite xanh qua `loopCommand`.
