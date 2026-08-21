---
status: accepted (thay thế [[0004-fork-harness-arent-workflow]])
---

# Bỏ harness arent-workflow, giữ lại đúng một ý của nó

`sonny-flow` không còn là bản mirror 108 file của harness `arent-workflow`. Nó là plugin **9 file**
dựng quanh đúng một ý lấy từ harness đó — *không lấy câu "xong rồi" bằng ngôn ngữ tự nhiên của AI
làm căn cứ để đi tiếp, phải có file thật* — ốp vào quy trình tài liệu mà dự án Sonny **đã có sẵn**.
Bản mirror đổi tên thành `arent-mirror/`, rút khỏi `marketplace.json`, giữ lại chỉ để đọc.

## Vì sao 108 file đó không dùng được

ADR 0004 giữ nguyên bản mirror vì mục tiêu lúc đó là *đúng bản gốc*. Khi bắt đầu tách nó ra để
dùng thật cho Sonny, đọc kỹ từng file thì phần lớn hoá ra không có nội dung để tách:

- **`docs/domain/` là form trắng.** 4 file được coi là "tri thức domain" chứa 18 / 20 / 12 / 6
  marker `[REPLACE]` và **không một chữ nào** về Arent hay routing. Không có gì để bỏ, cũng không
  có gì để chuyển.
- **3 rule là boilerplate web-stack.** `api-design.md` scope `src/routes/**` và toàn HTTP status
  code; `database.md` scope `prisma/**` với migration Postgres; `testing.md` scope `**/*.test.ts`
  và nói Vitest/pytest. Trong một repo C#/Revit. Chính `CLAUDE.md` của bản inject đã thừa nhận
  chúng "stay **dormant** for this .NET repo".
- **Bộ SIer là giả định về mô hình thầu Nhật**, không phải về code: khách đặt hàng SIer → SIer viết
  設計書 → vendor implement y theo, không được sửa. Sonny là sản phẩm tự làm, tự viết spec.
- **`docs/domain/generated/` + `docs-keeper` + `scripts/update-ai-docs.*` trùng hạ tầng đã có.**
  Sonny có hai index code sống: graphify (index cả `.md` và `.xaml`, có wiki) và codegraph
  (auto-sync ~1s sau khi save, trả source có số dòng). Một `code_map.md` sinh bằng LLM là bản tĩnh,
  kém hơn, và sẽ cũ.

Cái còn lại đáng giữ là nguyên tắc trong `gates.md`. Và nó không cần 480 dòng schema JSON để thực
thi: **file tài liệu đích tự nó là thanh tiến độ** — còn `- [ ]` trong `## Plan` là chưa xong.

## Ba thứ Sonny đã có, và chúng đổi hình bài toán

Harness được thiết kế cho một dự án chưa có gì. Sonny thì đã có:

1. **`docs/README.md`** đặc tả sẵn quy ước feature doc — *silent behaviour, order dependencies,
   unit boundaries, invariants, what a test should prove* — kèm luật chống nhồi rác: *"Skip anything
   the code already states plainly."* Nó cụ thể hơn mọi file trong harness.
2. **Hai index code** đã nối hook, và `CLAUDE.md` đã có bảng phân xử khi hai bên bất đồng.
3. **`CLAUDE.md` 211 dòng** đã phủ đúng phần mà `tech_stack.md` và `known_patterns.md` định phủ —
   ma trận R21–R26, `IsRepackable` on-Release/off-Debug, composition root, và cạnh sắc nhất của
   dự án: `UIDocument` không được cache trong field.

Nên plugin chỉ cần lấp 3 chỗ trống thật: **bước orient** (bắt đọc 3 nguồn dữ liệu trước khi viết
spec), **bước verify** (`dotnet test` pass/fail), và **bước doc** (viết `docs/features/X.md` rồi
đối chiếu lại với code).

## Phương án đã loại

- **Bọc `agent-skills`.** Nó đã có đúng chuỗi `/spec → /plan → /build → /test`. Nhưng nó là repo
  người khác với `autoUpdate: true` trong `skills.json` — upstream sửa `/spec` là quy trình chạy
  mỗi feature đổi mà không báo. Và nó không biết `Debug R25` có dấu cách phải quote, không biết
  `Sonny.Application.Features/` là orphan.
- **Giữ pipeline 5 phase + `deliverables/` 8 thư mục.** Sản phẩm trung gian dạng JSON đúng schema
  không ai mở lại lần thứ hai. Tài liệu vĩnh viễn trong `docs/` thì có.
- **Tham số hoá cho "nhiều dự án" ngay từ đầu.** Đó chính là cách harness này được thiết kế, và kết
  quả là `prisma/**` trong một repo C#. Viết cho Sonny thật trước; cái gì tổng quát hoá được sẽ tự
  lộ ra sau vài feature.

## Consequences

- **Thay thế ADR 0004.** Kết luận "giữ bố cục mirror để 169 link phân giải đúng" không còn hiệu lực,
  và lý do của nó cũng lệch: trong 138 markdown link, **90 là quan hệ cùng cấp trong harness** và
  sống sót nguyên vẹn qua bước đổi bố cục. Phần thật sự gãy là 29 link cắt sang phía dự án và 9 link
  chiều ngược lại — gãy vì **ranh giới repo**, không vì độ sâu thư mục.
- `arent-mirror/` vẫn nằm trong repo, đã xoá `.claude-plugin/` nên không còn là plugin. Nó là dẫn
  chứng cho ADR này. `arent-mirror/CLAUDE.md` và `AGENTS.md` vẫn mô tả repo của Arent — Claude Code
  sẽ nạp chúng nếu làm việc **bên trong** thư mục đó; đừng làm việc bên trong nó.
- `sonny-flow` mới **không vào `skills.json`**. Lý do đổi so với ADR 0004 nhưng kết luận giữ nguyên:
  không còn vì "nhắc SIer", mà vì flow này chỉ có nghĩa ở dự án có `docs/features/` và hai index
  code. Cài lên mọi máy là mời `/sonny-flow:build` chạy ở repo không có gate nào.
- **Diagram bằng Mermaid, không bằng SVG.** Yêu cầu là *task sửa feature phải cập nhật diagram*.
  Mermaid khai báo node và edge, layout do máy tính → sửa 2 dòng. SVG là toạ độ tuyệt đối do người
  giữ → một task thường sẽ không cập nhật. Bỏ syntax `C4Context` của Mermaid vì nó còn experimental
  và GitHub không render; lấy **cách nghĩ** C4 (mỗi diagram đúng một mức trừu tượng) với
  `sequenceDiagram` + `flowchart`.
- Mất phần đã dịch: 14 skill, 17 agent, 13 command tiếng Việt không được dùng. Chấp nhận — công dịch
  đã trả rồi, còn giữ chúng thì phải bảo trì một bộ không ai gọi.
