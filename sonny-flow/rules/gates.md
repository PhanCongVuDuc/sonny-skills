# Gates

Nguyên tắc duy nhất của plugin này: **không lấy câu "xong rồi" của AI làm căn cứ để đi tiếp.** Mỗi bước
chỉ qua được khi có thứ kiểm được bằng máy hoặc bằng mắt người.

Không có schema JSON, không có thư mục sản phẩm trung gian. Căn cứ là **chính file feature doc** —
`docs/features/{Feature}.md`. Nó vừa là sản phẩm cuối, vừa là thanh tiến độ, vừa là trạng thái để resume.

| Gate | Sau bước | Lệnh | Điều kiện | Ai phán |
|---|---|---|---|---|
| **G0** | orient | `/sonny-flow:orient` | Trả lời được 4 câu: chạm layer nào · ai gọi vào · pattern nào để noi theo · test hiện tại phủ gì | máy |
| **G1** | grill | `/sonny-flow:grill` | `## Decisions` không còn dòng **CHƯA CHỐT** | **NGƯỜI** (mỗi vòng) |
| **G2** | spec | `/sonny-flow:spec` | `## Contract` có đủ Input / Output / Invariants / **Named failure modes** | máy |
| **G3** | plan | `/sonny-flow:plan` | `## Plan` có ít nhất 1 mục `- [ ]`, mỗi mục nêu file + test | **NGƯỜI** |
| **G4** | implement | `/sonny-flow:implement` | Không còn `- [ ]` nào | máy |
| **G5** | verify | `/sonny-flow:verify` | Lệnh test của project **pass** | máy |
| **G6** | doc | `/sonny-flow:doc` | Không còn `## Decisions`/`## Spec`/`## Plan`; có `## Flow` với `sequenceDiagram`; mọi silent skip có node trong diagram; mọi dòng `## Contract` đã đối chiếu code | máy, **lệch thì báo chứ không tự sửa** |

Ba section tạm — `## Decisions`, `## Spec`, `## Plan` — sinh ra ở bước 1/2/3 và bị xoá ở bước 6. Chỉ
`## Contract` và `## Behaviour` ở lại vĩnh viễn.

## Biến thể `/sonny-flow:refactor`

Thay đổi không được đổi hành vi thì G0 · G1 · G3 · G4 · G5 giữ nguyên, hai gate khác đi:

| Gate | Ở `refactor` |
|---|---|
| **G2** | Không viết `## Contract` mới — `## Contract` hiện có *là* spec. Điều kiện: mỗi feature bị chạm đều có test khoá hành vi hiện tại và **đang xanh**; chỗ nào cố tình đi mà không có lưới thì phải là quyết định **tường minh** của người |
| **G6** | Không còn identifier nào **bị xoá trong diff** mà vẫn xuất hiện trong `docs/**`, `CLAUDE.md`, `CONTEXT.md`; không còn link `[source](...)` gãy |

Section tạm của refactor nằm trong bản nháp **ADR**, không phải feature doc. Và G5 ở đây nghiêm hơn: **test
cũ phải xanh mà không được sửa test**. Phải sửa test để nó xanh nghĩa là hành vi đã đổi — tức refactor
hỏng, không phải test sai.

## G1 và G3 được thực thi bằng ranh giới lệnh

Đây là cơ chế, không phải lời khuyên. **Việc người dùng gõ lệnh tiếp theo *chính là* sự duyệt.**
`/sonny-flow:grill` hỏi rồi kết thúc lượt để chờ trả lời; `/sonny-flow:plan` in plan ra rồi kết thúc lượt.
Không có cách nào để tự vượt.

Nên: đừng hỏi "làm tiếp nhé?" rồi tự trả lời trong cùng lượt. Đừng viết code trong lượt của `plan`.

`/sonny-flow:feature` là lệnh duy nhất chạy nhiều bước liền, nên nó cần luật riêng: dừng ở cuối **mỗi vòng
grill**, và **lượt nào *tạo hoặc sửa* `## Plan` thì dừng ngay sau khi in plan ra** (`## Plan` đã tồn tại
nguyên vẹn từ trước lượt đó thì đi tiếp — người gõ lại lệnh là người duyệt).

## Bốn điều cấm

**Cấm bịa câu hỏi ở G1.** Frontier rỗng ngay vòng 1 là kết quả hợp lệ. Bốn câu vô nghĩa tệ hơn không câu
nào — nó dạy người dùng bỏ qua bước này. Ngược lại cũng cấm: **đừng đoán để tránh hỏi.** Câu trả lời mà
*đổi việc phải làm* thì phải hỏi, kể cả khi đã có đề xuất chắc.

**Cấm nới G5.** Test fail thì không đi tiếp. Không sửa test cho pass, không thêm
`Ignore`/`Explicit`/`Skip`, không nới assertion, không bỏ case. Sửa code hoặc sửa spec — nhưng phải hiểu
bên nào sai trước đã. Và **build sạch không phải pass.**

**Cấm chạy bước 6 khi G5 chưa qua.** Doc hoá một hành vi chưa được kiểm là biến một bug thành đặc tả.
G5 ra **fail** hoặc **không kiểm chứng được** thì dừng ở đó.

**Cấm tự sửa doc theo code ở G6.** Khi `## Contract` không khớp code, có hai khả năng: doc cũ, hoặc **code
sai**. Báo cả hai ra cho người chọn.

## Khi không kiểm được

Nói thẳng "không kiểm chứng được" kèm lý do. Đúng ba giá trị được phép dùng khi báo kết quả một gate:
**qua** / **không qua** / **không kiểm chứng được**. Không có "gần xong", không có "về cơ bản là ổn".
