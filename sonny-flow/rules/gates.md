# Gates

Nguyên tắc duy nhất của plugin này: **không lấy câu "xong rồi" của AI làm căn cứ để đi tiếp.** Mỗi bước
chỉ qua được khi có thứ kiểm được bằng máy hoặc bằng mắt người.

Không có schema JSON, không có thư mục sản phẩm trung gian. Căn cứ là **chính file feature doc** —
`docs/features/{Feature}.md`. Nó vừa là sản phẩm cuối, vừa là thanh tiến độ, vừa là trạng thái để resume.

| Gate | Sau bước | Lệnh | Điều kiện | Ai phán |
|---|---|---|---|---|
| **G0** | orient | `/sonny-flow:orient` | Trả lời được 6 câu: chạm layer nào · ai gọi vào · pattern nào để noi theo · test hiện tại phủ gì · service dùng chung có đủ API chưa · **project đã có kinh nghiệm nào về vùng này chưa** (`.sonnyflow/lessons/` + hàng đợi `retro/`) | máy |
| **G1** | grill | `/sonny-flow:grill` | `## Decisions` không còn dòng **CHƯA CHỐT** | **NGƯỜI** (mỗi vòng) |
| **G2** | spec | `/sonny-flow:spec` | `## Contract` có đủ Input / Output / Invariants / **Named failure modes** | máy |
| **G3** | plan | `/sonny-flow:plan` | `## Plan` có ít nhất 1 mục `- [ ]`, mỗi mục nêu file + test | **NGƯỜI** |
| **G4** | implement | `/sonny-flow:implement` | Không còn `- [ ]` trong `## Plan`; task `pinned-by #N` chỉ được tick khi #N đã `[x]` | máy |
| **G5** | verify | `/sonny-flow:verify` | Lệnh test của project **pass** | máy |
| **G6** | doc | `/sonny-flow:doc` | Mọi ô con của bước 6 trong `## Flow-state` đã tick — đối chiếu · diagram · soi ADR · retro · graph — rồi mới xoá section tạm | máy, **lệch thì báo chứ không tự sửa** |

Bốn section tạm — `## Flow-state`, `## Decisions`, `## Spec`, `## Plan` — sinh ra ở bước 1/2/3 và bị xoá
ở ô cuối của bước 6. Chỉ `## Contract` và `## Behaviour` ở lại vĩnh viễn.

## Flow-state — thanh tiến độ của chính flow

`## Plan` có tick nên bước 4 không bao giờ bị bỏ sót giữa chừng. Sáu bước còn lại thì "xong" từng là một
câu trong tài liệu — và câu thì bị bỏ qua đúng lúc deliverable *trông như* đã xong (retro, soi ADR, graph
đều từng rơi kiểu đó). `## Flow-state` áp cùng cơ chế tick cho cả flow: **trạng thái nằm trong file, không
nằm trong trí nhớ.**

Section tạm này đứng **đầu** `docs/features/{Feature}.md`, do grill tạo cùng file, và là thứ đầu tiên mọi
bước đọc. Bốn luật:

1. **Vào bước nào cũng mở feature doc trước.** Doc có trước cơ chế này (chưa có `## Flow-state`) → chép
   template dưới vào đầu file, tick sẵn những bước có bằng chứng đã xong (section tương ứng tồn tại).
2. **Ô của bước trước còn trống → dừng, báo.** Đừng làm bù im lặng.
3. **Xong bước thì tick ô của mình ngay**, kèm ghi chú ngắn sau dấu `—` (số task, kết quả test).
4. "Xong chưa" trả lời bằng cách **nhìn ô**, không bằng trí nhớ. Bước 6 chỉ được tick khi **mọi ô con**
   đã tick, và ô 6f là việc cuối cùng của cả flow.

```markdown
## Flow-state

- [ ] 0 orient — 5 câu G0
- [ ] 1 grill — Decisions hết CHƯA CHỐT, người xác nhận
- [ ] 2 spec — Contract đủ 4 phần
- [ ] 3 plan — plan đã in ra, chờ người duyệt
- [ ] 4 implement — Plan hết ô trống
- [ ] 5 verify — <lệnh test> → <kết quả>
- [ ] 6 doc — chỉ tick khi 6a–6f đã tick hết:
  - [ ] 6a đối chiếu từng dòng Contract với code — lệch thì báo, không tự sửa
  - [ ] 6b Flow + Behaviour + What a test should prove — mọi silent skip có node trong diagram
  - [ ] 6c soi từng dòng Decisions: đề xuất ADR, hoặc ghi "không đủ ba điều kiện"
  - [ ] 6d retro: ghi vào hàng đợi (3 mục a/b/c, status `chờ xét`) + LESSONS.md + bảng retro/README.md,
        rồi TRÌNH danh sách chờ xét cho người; người confirm bài nào thì chép sang nhà của nó và gạch
        ngang mục đó. Tồn dư hàng đợi không chặn gate — không ghi hoặc confirm-mà-không-chép mới chặn
  - [ ] 6e làm mới graph — đủ MỌI lệnh docs/README.md khai, không chỉ lệnh đầu
  - [ ] 6f xoá Flow-state/Decisions/Spec/Plan — việc CUỐI CÙNG, sau khi mọi ô trên đã tick
```

Flow refactor dùng cùng cơ chế trong **bản nháp ADR**: dòng 2 là `baseline`, dòng 6 là `sync-docs` với ô
con 6a quét identifier bị xoá trong diff · 6b kiểm link `[source](...)` bằng máy · 6c retro + LESSONS ·
6d graph · 6e xoá section tạm khỏi ADR.

## Biến thể `/sonny-flow:refactor`

Thay đổi không được đổi hành vi thì G0 · G1 · G3 · G4 giữ nguyên, ba gate khác đi:

| Gate | Ở `refactor` |
|---|---|
| **G2** | Không viết `## Contract` mới — `## Contract` hiện có *là* spec. Điều kiện: mỗi feature bị chạm đều có test khoá hành vi hiện tại và **đang xanh**; chỗ nào cố tình đi mà không có lưới thì phải là quyết định **tường minh** của người |
| **G5** | Nghiêm hơn: **test cũ phải xanh mà không được sửa test.** Phải sửa test để nó xanh nghĩa là hành vi đã đổi — tức refactor hỏng, không phải test sai |
| **G6** | Không còn identifier nào **bị xoá trong diff** mà vẫn xuất hiện trong `docs/**`, `CLAUDE.md`, `CONTEXT.md`; không còn link `[source](...)` gãy |

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

## Bug phát hiện giữa chừng — ghi vào `docs/bugs/`, không hỏi, không fix im lặng

Đang làm việc mà phát hiện một defect **ngoài phạm vi task hiện tại** thì có đúng một việc phải làm —
**không cần xin phép để ghi** (chỉ *fix* mới cần người duyệt): tạo **`docs/bugs/<mã>-<slug>.md`** (mã theo
feature: `AJ-001`…; nội dung: status `open` · feature bị ảnh hưởng · hiện tượng · repro · bản chất · hướng
fix đề xuất), thêm dòng vào bảng index `docs/bugs/README.md`, và một dòng link trong `## Related` của
feature doc bị ảnh hưởng. Bug KHÔNG nằm trong feature doc — feature doc là *hành vi hiện tại* và bị viết
đè, bug là sổ nợ có vòng đời riêng (cùng lý do ADR ở folder riêng). Ba điều cấm: **cấm fix im lặng** (fix
là một task có spec, không phải việc tiện tay), **cấm bỏ quên** (không có file bug = bug chết theo phiên
chat), **cấm xoá file bug**.

Fix bug = chạy lại chính flow này trên feature đó (`/sonny-flow:feature <F>` — doc đã có `## Behaviour`
nên rơi vào nhánh "việc mới trên feature cũ"), với ba ràng buộc: spec chuyển bug thành failure mode
trong `## Contract` · implement viết test **tái hiện bug RED trước** rồi mới sửa · xong thì đổi Status
file bug thành `fixed` (giữ file làm lịch sử), cập nhật index, gỡ dòng link khỏi `## Related`.

## Khi không kiểm được

Nói thẳng "không kiểm chứng được" kèm lý do. Đúng ba giá trị được phép dùng khi báo kết quả một gate:
**qua** / **không qua** / **không kiểm chứng được**. Không có "gần xong", không có "về cơ bản là ổn".
