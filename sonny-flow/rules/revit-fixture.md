# Fixture .rvt tự sinh — builder-test vẽ model, integration test mở nó

Đọc rule này khi một task cần **fixture `.rvt` mới** cho integration test. Pattern đã chạy thật ở
AutoJoin (`AutoJoinFixtureBuilder` + `AutoJoinIntegrationTest`, repo Sonny) — lấy đó làm mẫu.

## Xin dữ liệu thật của chủ dự án TRƯỚC khi tự dựng

Với feature đọc dữ liệu ngoài (CAD, IFC, Excel…): **hỏi xin một file thật trước.** Fixture tự soạn chỉ
chứa những trường hợp người viết đã nghĩ ra — nó xác nhận hiểu biết của người viết, không thăm dò code.
Đo thật trên FramingFromCad (2026-08-23): DXF tự soạn 22 nét không kích hoạt nổi một quirk nào của thuật
toán; DWG thật 168 nét kích hoạt cả ba (nhóm ≥3 nét, nét bịt đầu ghép nhau, thứ tự tiết diện ăn dầm của
nhau). Chỉ tự dựng khi không xin được file thật, hoặc khi cần hình học chính-xác-từng-mm cho một case mà
file thật không có (như AutoJoin cần khối đặc chồng nhau). Tốt nhất là cả hai: file thật cho hành vi
thật, file tối giản cho đường code file thật không đi qua.

Nhận một file dữ liệu mới thì **đo, đừng thiết kế kỳ vọng**: viết probe test đọc-only chạy chính các
helper của feature trên file đó, lấy số ra làm kỳ vọng test (kiểu `FixtureFacts`), và builder tự kiểm
lại các số đó trước khi save.

## Mở file nền ra xem TRƯỚC khi hỏi về family

Muốn biết một `.rvt` chứa family/type/parameter gì: viết probe test đọc-only kế thừa base mở-document
của project, dump ra file text, chạy qua `loopCommand` (~1 phút). **`grep` trên `.rvt`/`.rfa` là bằng
chứng vô giá trị** — định dạng nén, 0 hit không nghĩa là "không có". Và ghi chú môi trường kiểu "máy này
thiếu X trên đĩa" không nói gì về thứ đã nạp sẵn trong file — chỉ hỏi người khi probe cho thấy thật sự
thiếu.

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

## Bẫy khi dựng fixture

Luật viết test/builder nói chung (callback, OnSetup, `void` không `async`, category ẩn, journal…) nằm ở
[`revit-test.md`](revit-test.md) — đọc trước khi viết dòng builder nào. Riêng cho fixture:

- **Hai kẻ cắt chồng vùng cắt trên một element → Revit lặng lẽ gỡ join sau tại commit.** Dựng case join
  thì mỗi kẻ cắt một vùng tách biệt.

## Nghiệm thu

Fixture mới phải kèm: dòng trong file kiểm kê test của project (Sonny: `.sonnyflow/lessons/test-safety-net.md` —
test bind vào tag nào, view nào), mục "cách vẽ lại" trong feature doc, và toàn bộ suite xanh qua
`loopCommand`.
