# sonny-flow

Quy trình làm việc có **gate bằng file thật**: mỗi bước chỉ qua được khi có thứ kiểm được, không phải khi
AI nói "xong rồi". Thứ còn lại sau khi xong là **tài liệu kèm diagram**, không phải một đống sản phẩm
trung gian.

Hai flow, 7 bước mỗi flow, dùng chung 5 bước:

```
FEATURE   0 orient → 1 grill → 2 spec     → 3 plan ─DUYỆT→ 4 implement → 5 verify → 6 doc
REFACTOR  0 orient → 1 grill → 2 baseline → 3 plan ─DUYỆT→ 4 implement → 5 verify → 6 sync-docs
                                  ↑ khác                                              ↑ khác
```

| | `feature` | `refactor` |
|---|---|---|
| **Dùng khi** | thêm/đổi hành vi | **không được** đổi hành vi: chuyển layer, tách class, rename |
| **Bước 2** | viết `## Contract` mới | `## Contract` hiện có *là* spec (*"không đổi một chữ"*); dựng **lưới an toàn** — characterization test trước khi move |
| **Bước 6** | doc 1 feature | quét git diff, sửa **mọi** doc + `docs/architecture/*` + `CLAUDE.md` nhắc tên đã xoá |
| **Trạng thái sống ở** | `docs/features/{Feature}.md` | bản nháp **ADR** `docs/adr/NNNN-*.md` (refactor trải qua nhiều feature) |

---

# Gõ gì

## Chạy cả flow — 1 lệnh

```
/sonny-flow:feature <Feature>       feature: đọc file, biết đang ở bước nào, chạy tiếp từ đó
/sonny-flow:refactor <mô tả>        refactor: y hệt, nhưng đọc bản nháp ADR
```

**Gõ lần đầu** → chạy tới human gate rồi dừng. **Gõ lại lần nữa** → chạy tiếp phần còn lại. Việc bạn gõ
lại *chính là* sự duyệt — không cần trả lời "ok".

```
Lần 1:  /sonny-flow:feature Foo    → orient → grill (hỏi bạn) → DỪNG
Lần 2:  trả lời Q1, Q2…            → grill tiếp → spec → plan → DỪNG
Lần 3:  /sonny-flow:feature Foo    → implement + verify + doc, TỰ ĐỘNG HẾT
```

## Đi từng bước — 1 lệnh mỗi bước

| Bước | Lệnh | Dùng ở flow |
|---|---|---|
| 0 orient | `/sonny-flow:orient <F>` | cả hai |
| 1 grill | `/sonny-flow:grill <F>` | cả hai |
| 2 spec | `/sonny-flow:spec <F>` | feature |
| 2 baseline | `/sonny-flow:baseline <mô tả>` | refactor |
| 3 plan | `/sonny-flow:plan <F>` | cả hai |
| 4 implement | `/sonny-flow:implement <F> [số task]` | cả hai |
| 5 verify | `/sonny-flow:verify <F>` | cả hai |
| 6 doc | `/sonny-flow:doc <F>` | feature |
| 6 sync-docs | `/sonny-flow:sync-docs [base ref]` | refactor |

`implement` nhận số task → làm **đúng** task đó rồi dừng.

## Ba lệnh dùng độc lập, không cần đi kèm task

```
/sonny-flow:verify <F>              chạy lại cổng test bất cứ lúc nào
/sonny-flow:doc <F>                 code đổi mà feature doc cũ
/sonny-flow:sync-docs [base]        vừa rename/move symbol, quét doc nào đã cũ
```

---

# Nguyên tắc

**Không lấy câu "xong rồi" của AI làm căn cứ để đi tiếp.** Ý này lấy từ harness `arent-workflow` (xem
`docs/adr/0005` của repo `sonny-skills`).

Ở đây căn cứ là **chính file đích** — `docs/features/{Feature}.md`, hoặc bản nháp ADR với refactor. Nó vừa
là sản phẩm cuối, vừa là thanh tiến độ, vừa là trạng thái để resume. **Còn `- [ ]` trong `## Plan` là chưa
xong.** Không cần schema JSON, không cần thư mục sản phẩm trung gian, không cần công cụ.

## Bảy bước và gate của nó

| Bước | Làm gì | Gate để đi tiếp |
|---|---|---|
| **0 orient** | `docs/` → `graphify` → `codegraph`, đúng thứ tự đó | **G0** — trả lời được 4 câu: chạm layer nào · ai gọi vào · pattern nào để noi theo · test hiện tại phủ gì |
| **1 grill** | Hỏi theo vòng, mỗi câu kèm đề xuất. Chốt gì ghi ngay vào `## Decisions` | **G1 — NGƯỜI**, mỗi vòng. Xong khi không còn dòng **CHƯA CHỐT** |
| **2 spec** | `## Spec` + `## Contract`, viết từ `## Decisions` — **không đoán** | **G2** — `## Contract` có đủ Input / Output / Invariants / **Named failure modes** |
| **2 baseline**<br>*(refactor)* | Liệt kê feature bị chạm, tìm test đang khoá hành vi, thiếu thì viết characterization test | **G2'** — mỗi feature bị chạm có lưới **đang xanh**, hoặc người **tường minh** chấp nhận đi không lưới |
| **3 plan** | `## Plan`, checklist `- [ ]`, mỗi task nêu file + test | **G3 — NGƯỜI DUYỆT** |
| **4 implement** | Mỗi task: code + test. **Test rút từ `## Contract`, không rút từ code vừa viết** | **G4** — không còn `- [ ]` |
| **5 verify** | Lệnh test của project, lấy từ `CLAUDE.md` | **G5** — **pass** |
| **6 doc** | Đối chiếu Contract + diagram với code → xoá section tạm → viết `## Behaviour` → làm mới graph | **G6** — có `sequenceDiagram`; mọi silent skip có node trong diagram |
| **6 sync-docs**<br>*(refactor)* | Lấy identifier **bị xoá trong git diff**, quét mọi doc + `CLAUDE.md` + link `[source]` | **G6'** — không tên cũ nào còn sót, không link gãy |

Chi tiết: [`rules/gates.md`](rules/gates.md). Template doc + ví dụ diagram:
[`skills/feature-doc/reference.md`](skills/feature-doc/reference.md).

## Section tạm vs vĩnh viễn

**Tạm** — `## Decisions` (b1) · `## Spec` (b2) · `## Plan` (b3). Cả ba bị xoá ở bước 6.

Trước khi xoá `## Decisions`, bước 6 soi từng dòng: cái nào **khó đảo** + **người sau sẽ hỏi "sao lại thế"**
+ **có phương án khác thật đã bị loại** thì đề xuất đẩy lên `docs/adr/`. Đó là chỗ ADR xuất hiện tự nhiên
thay vì phải nhớ.

**Vĩnh viễn** — `## Contract` (mặt cắt để đổi yêu cầu) và `## Behaviour` (hành vi hiện tại).

---

# Cài

```
/plugin marketplace add PhanCongVuDuc/sonny-skills
/plugin install sonny-flow@sonny-skills
```

Rồi thêm một dòng vào `.claude/settings.json` của project:

```json
"claudeMdExcludes": ["docs/features/**"]
```

Không có nó thì mọi feature doc vào context ở **mọi lượt**. Chúng là thứ tra cứu theo nhu cầu.

**Không** có trong `skills.json`, nên `/setup-skills` sẽ không cài nó lên mọi máy. Cố ý: flow này chỉ có
nghĩa ở project đáp ứng bảng dưới. Cài khắp nơi là mời `/sonny-flow:implement` chạy trong repo không có
gate nào.

## Project cần có gì

Plugin này **không** dựng hạ tầng. Nó giả định đã có:

| Thứ | Vì sao |
|---|---|
| **graphify** đã cài và đã index | Bước 0 dùng `graphify query` / `explain` cho kiến trúc, `.xaml`, và mọi thứ dưới `docs/` |
| **codegraph** đã cài và đang chạy | Bước 0 và bước 6 dùng `codegraph node` / `explore` / `impact` để lấy source thật và đối chiếu doc với code |
| **plugin [`mattpocock-skills`](https://github.com/mattpocock/skills)** | Bước 1 chạy lại `grilling` + `domain-modeling`. Gỡ nó thì `/sonny-flow:grill` gãy |
| **`docs/`** với `docs/README.md` khai thứ tự đọc, và `docs/features/` | Bước 0 đọc, bước 6 ghi |
| **`docs/adr/`** và **`CONTEXT.md`** ở gốc repo | Nơi bước 1 đổ thuật ngữ và quyết định khó đảo; nhà của bản nháp refactor |
| Một **lệnh test** khai trong `CLAUDE.md` | Gate G5 chạy đúng lệnh đó. Plugin không tự đoán lệnh build/test |

Thiếu graphify hoặc codegraph thì bước 0 mất phần lớn giá trị — nó tụt về `grep`, và `grep` bỏ sót caller.

---

# Năm điều nó cố ý không làm

**Không tự vượt human gate — và đó là cơ chế, không phải lời khuyên.** Với lệnh rời, ranh giới gate *là*
ranh giới lệnh: `grill` hỏi rồi hết lượt; `plan` in plan ra rồi hết lượt. `feature`/`refactor` là hai lệnh
duy nhất chạy nhiều bước liền, nên mang luật riêng: dừng cuối mỗi vòng grill, và **lượt nào tạo hoặc sửa
`## Plan` thì dừng ngay sau khi in plan ra**.

**Không bịa câu hỏi để trông kỹ.** Task rõ ràng thì grill báo "không có quyết định nào đang mở" rồi cho đi
tiếp. Bốn câu vô nghĩa tệ hơn không câu nào — nó dạy người dùng bỏ qua bước quan trọng nhất. Ngược lại cũng
cấm: **đừng đoán để tránh hỏi.**

**Không nới test cho pass.** Fail là fail. Không `Ignore`, không hạ assertion. Không chạy được thì báo
*"không kiểm chứng được"* — không báo pass. **Build sạch không phải pass.**

**G5 chưa qua thì cấm chạy bước 6.** Doc hoá một hành vi chưa được kiểm là biến một bug thành đặc tả.

**Không tự sửa doc theo code.** `## Contract` lệch code có hai khả năng: doc cũ, hoặc **code sai**. Nó
trình cả hai ra cho người chọn.

---

# Diagram

Mermaid, hai loại, mỗi loại đúng một mức trừu tượng:

- **`sequenceDiagram`** — đường gọi xuyên layer. Đây là thứ knowledge graph **không dựng được**, vì call
  qua DI generic không thành edge trong AST.
- **`flowchart TD`** — nhánh quyết định và đường thất bại trong một phase. **Mỗi silent skip một node.**

Không dùng SVG/HTML: layout của chúng là toạ độ do người giữ, nên một task thường sẽ không cập nhật, và
**diagram lệch code thì tệ hơn không có diagram**. Không dùng syntax `C4Context` của Mermaid: còn
experimental và GitHub không render. Giữ *cách nghĩ* C4 — một mức trừu tượng một diagram.

---

# Nguồn

Cơ chế phỏng vấn ở bước 1 là `grilling` + `domain-modeling` của
[mattpocock/skills](https://github.com/mattpocock/skills) — **gọi lại, không viết lại**. Phần riêng của
plugin này: seed câu hỏi từ bốn phần của `## Contract` (nhóm failure modes hỏi trước), và ghi quyết định
thường vào `## Decisions` — thứ mà `domain-modeling` không lo, vì `CONTEXT.md` chỉ là glossary và ADR thì
phải đủ ba điều kiện.

Ý "gate bằng file thật" lấy từ harness `arent-workflow`; xem `docs/adr/0005` của repo `sonny-skills`.

# Chưa tổng quát hoá

Viết cho một project thật (Sonny — Revit add-in C#) trước, không tham số hoá trước cho project tưởng tượng.
Chỗ phụ thuộc project được đọc **từ chính project** (lệnh test lấy từ `CLAUDE.md`, thứ tự đọc doc lấy từ
`docs/README.md`) chứ không hardcode. Cái gì tổng quát hoá được sẽ tự lộ ra sau vài feature.
