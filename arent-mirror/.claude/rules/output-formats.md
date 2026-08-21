---
description: The structured-format contract for deliverables (§1–§9). The single authoritative format for every JSON/Markdown artifact each agent and skill writes into deliverables. No paths (explicit reference only).
---

# output-formats (định nghĩa định dạng có cấu trúc của deliverable)

Không có frontmatter `paths:` — file này không tự động load theo path, mà là rule dạng "hợp đồng (contract)" được từng agent, từng skill tham chiếu tường minh. Toàn bộ schema JSON / Markdown của mọi deliverable ghi vào `deliverables/` được quản lý tập trung tại đây.

Mỗi section `§N` là **định dạng chuẩn duy nhất** của deliverable do một nguồn sinh cụ thể (agent hoặc skill) xuất ra. Nguồn sinh phải xuất đúng nghiêm ngặt theo schema định nghĩa ở đây.

## Quy tắc chung

- **JSON phải là JSON nghiêm ngặt** (cấm comment, cấm dấu phẩy thừa ở cuối). Một file một root object.
- Bảng mã là UTF-8. Giá trị có thể viết bằng tiếng Việt. Tên field (key) cố định theo khoá tiếng Anh định nghĩa ở đây.
- Giá trị chưa rõ / chưa chốt thì **không được lược bỏ**, phải ghi rõ bằng `null` hoặc chuỗi `"(cần xác nhận)..."` (không lấp bằng im lặng).
- Ý nghĩa của các placeholder trong path (`{feature}` `{task_id}` `{region}` `{perspective}` `{decision_id}` `{phase}` `{target}` `{runN}` `{YYYY-MM-DD}` `{seq}` `{YYYY-MM}`) tuân theo quy ước đặt tên trong [`deliverables/README.md`](../../deliverables/README.md).
- `verdict` của nhóm review chỉ nhận đúng 3 giá trị **`có vấn đề` / `không vấn đề` / `không kiểm chứng được`**. `risk_level` chỉ nhận **`high` / `medium` / `low`**.

---

## §1 Báo cáo tự kiểm tra implementation — implementer

**Nguồn sinh**: [`implementer`](../agents/implementer.md) (gồm cả khi đi qua command [`implement`](../commands/implement.md))
**Nơi xuất**: `deliverables/03_implementation/{task_id}.report.json`
**Mục đích**: với code được viết từ spec đã duyệt, khai báo có cấu trúc các chỗ suy đoán, chỗ cần xác nhận, và chỗ cần người review. Dùng để đi tiếp dựa trên JSON này chứ không tin câu "xong rồi" bằng ngôn ngữ tự nhiên.

```json
{
  "task_id": "form_001_convert",
  "spec_source": "deliverables/01_requirements/order-create.spec.md",
  "summary": "Đã implement validation phía server và phần lưu trữ cho form tạo đơn hàng",
  "status": "completed",
  "todo_remaining": 0,
  "changed_files": [
    { "path": "src/order/create.ts", "change": "added", "reason": "Kiểm tra input và lưu theo spec §3" }
  ],
  "scope_adherence": {
    "in_scope_only": true,
    "added_outside_spec": []
  },
  "assumptions": [
    {
      "id": "A1",
      "location": "src/order/create.ts:42",
      "description": "(suy đoán) spec không có giới hạn số lượng nên lấy 9999 làm cận trên",
      "risk": "high",
      "basis": "spec không ghi cận trên. Chưa xác nhận business rule"
    }
  ],
  "human_review_required": [
    {
      "location": "src/order/create.ts:88",
      "category": "numeric-precision",
      "description": "Hướng làm tròn khi tính tiền chưa được spec định nghĩa. Rơi vào mục độ chính xác số của risk-categories.md",
      "risk_level": "high",
      "question_for_human": "Làm tròn số tiền là cắt xuống, làm tròn thường, hay làm tròn lên?"
    }
  ],
  "questions": [
    "Spec và code có sẵn mâu thuẫn nhau về thời điểm trừ tồn kho. Cần xác nhận theo bên nào"
  ],
  "tests_written": false,
  "self_check": {
    "spec_uncovered_items": [],
    "known_patterns_followed": true
  }
}
```

- `status` là `completed` / `in_progress` / `blocked`, `todo_remaining` là số task còn lại. **Gate ③ ([`gates.md`](gates.md)) bắt buộc phải là `status: completed` và `todo_remaining: 0`**.
- Mỗi `description` trong `assumptions` cũng phải để lại dưới dạng comment `(suy đoán) [nội dung]` bên phía code (ghi kép). Mỗi `risk` là `high/medium/low`.
- Mỗi mục trong `human_review_required` bắt buộc có đủ **`location` / `category` (khoá trong [`risk-categories.md`](risk-categories.md)) / `description` / `risk_level` (high/medium/low) / `question_for_human`**. Chỗ nào rơi vào diện đó thì bắt buộc liệt kê (không được cho qua bằng mảng rỗng).
- `questions` chứa các phán đoán đã tạm gác lại chứ không cố code (mâu thuẫn giữa spec và cái có sẵn, cải tiến ngoài scope).
- `tests_written` luôn là `false` (test là trách nhiệm của `test-implementer`).

---

## §2 Kết quả review theo perspective — implementation-reviewer / design-reviewer / test-reviewer / focused-review

**Nguồn sinh**: [`implementation-reviewer`](../agents/implementation-reviewer.md), [`design-reviewer`](../agents/design-reviewer.md), [`test-reviewer`](../agents/test-reviewer.md), [`focused-review`](../skills/focused-review/SKILL.md)
**Nơi xuất**:
- Review implementation: `deliverables/reviews/impl-{perspective}-{task_id}.json`
- Review design: `deliverables/reviews/design-{perspective}-{feature}.json`
- Review test: `deliverables/reviews/test-{feature}.json` (đưa 5 perspective dưới đây vào mảng perspective)

**Mục đích**: mỗi lần gọi 1 perspective, vừa nói rõ phần nằm ngoài phạm vi, vừa review có cấu trúc theo 3 giá trị `có vấn đề / không vấn đề / không kiểm chứng được`. Không xuất "điểm tốt", chỉ nêu vấn đề.

```json
{
  "target": "src/order/create.ts",
  "review_type": "implementation",
  "perspective": "transaction-boundary",
  "verdict": "có vấn đề",
  "out_of_scope_note": "Đặt tên, format, và tính hợp lý của happy path nằm ngoài phạm vi",
  "findings": [
    {
      "id": "F1",
      "location": "src/order/create.ts:120-138",
      "risk_level": "high",
      "issue": "Trừ tồn kho và lưu đơn hàng nằm ở hai transaction khác nhau. Thất bại giữa chừng sẽ để lại dữ liệu bất nhất",
      "evidence": "Sau saveOrder() lại gọi decrementStock() bằng một await riêng",
      "suggested_direction": "Gộp vào cùng một transaction boundary (không khẳng định chắc chắn giải pháp)"
    }
  ],
  "unverifiable": [
    {
      "location": "src/order/create.ts:88",
      "reason": "Không rõ business rule về hướng làm tròn",
      "need": "Section tính tiền trong docs/domain/business_rules.md, hoặc hỏi người"
    }
  ],
  "observed_but_out_of_scope": []
}
```

- `review_type` là một trong `implementation` / `design` / `test`.
- `verdict` là `có vấn đề` → `findings` phải có tối thiểu 1 mục. `không kiểm chứng được` → ghi rõ thông tin cần thiết vào `unverifiable`. Kể cả `không vấn đề` cũng bắt buộc nói rõ `perspective`.
- Mỗi finding bắt buộc có `risk_level` (`high/medium/low`).
- **Trường hợp test-reviewer**: thay vì một `perspective` đơn, đưa 5 perspective (độ phủ scenario / tính hợp lý của mock / lặp thừa / khả năng truy vết / khớp level) vào `findings[].perspective`, còn ở root thì để `"review_type": "test"`.

---

## §3 Báo cáo độ bất định (phân loại ABCD) — uncertainty-auditor / uncertainty-report

**Nguồn sinh**: [`uncertainty-auditor`](../agents/uncertainty-auditor.md), [`uncertainty-report`](../skills/uncertainty-report/SKILL.md)
**Nơi xuất**: `deliverables/{phase}/{target}.uncertainty.json` (ví dụ: `deliverables/01_requirements/order-create.uncertainty.json`)
**Mục đích**: khai báo những "chỗ đã lấp bằng suy đoán vì thông tin không được nói rõ" lúc tạo deliverable, sắp theo mức ảnh hưởng để lọc ra những điểm cần kiểm ở human review gate.

```json
{
  "target": "deliverables/01_requirements/order-create.spec.md",
  "phase": "01_requirements",
  "has_uncertainty": true,
  "items": [
    {
      "id": "U1",
      "category": "A",
      "impact": "high",
      "location": "spec §3 kiểm tra input",
      "description": "Vì không ghi cận trên của số lượng nên đã suy đoán là 9999",
      "question": "Cận trên của số lượng trên mỗi đơn hàng là bao nhiêu?",
      "chosen": "Cận trên 9999",
      "alternatives": []
    },
    {
      "id": "U2",
      "category": "B",
      "impact": "medium",
      "location": "spec §5 huỷ đơn",
      "description": "\"Có thể huỷ\" có 2 cách hiểu: chỉ trước khi xuất hàng, hay bao gồm cả sau khi xuất hàng",
      "question": "Sau khi xuất hàng có huỷ được không?",
      "chosen": "Chỉ trước khi xuất hàng",
      "alternatives": ["Sau khi xuất hàng vẫn được, tính là trả hàng"]
    }
  ]
}
```

- `category` là một trong **A** (suy đoán vì thiếu thông tin) / **B** (chọn một trong nhiều cách diễn giải) / **C** (không rõ business rule nên làm theo hành vi thông thường) / **D** (chưa hiểu hoàn toàn). Phân vân thì chọn **D**.
- `impact` là `high/medium/low`. Phân vân thì nghiêng lên một bậc. Xếp `impact: high` lên đầu mảng.
- Mỗi mục bắt buộc có "một câu hỏi nên hỏi người" (`question`).
- Chỉ khi thật sự không có suy đoán nào thì mới để `has_uncertainty: false` và `items: []`.

---

## §4 Test scenario — test-scenario-designer / test-scenario

**Nguồn sinh**: [`test-scenario-designer`](../agents/test-scenario-designer.md), [`test-scenario`](../skills/test-scenario/SKILL.md)
**Nơi xuất**:
- Unit: `deliverables/04_test/scenarios-{feature}.unit.json`
- e2e: `deliverables/04_test/scenarios-{feature}.e2e.json`

**Mục đích**: thiết kế scenario dựa trên spec, gói gọn vào error path, boundary value, thất bại một phần, tranh chấp, ranh giới business rule, và luồng thao tác của người dùng. **Không sinh happy path**. Không trộn unit và e2e trong cùng một file.

```json
{
  "feature": "order-create",
  "level": "unit",
  "spec_source": "deliverables/01_requirements/order-create.spec.md",
  "scenarios": [
    {
      "id": "UT-001",
      "category": "boundary-value",
      "title": "Lỗi kiểm tra khi số lượng là cận trên + 1",
      "preconditions": ["Sản phẩm còn tồn kho"],
      "input": "quantity = 10000",
      "expected": "400 kèm mã lỗi QTY_OVER",
      "miss_impact": "Đơn vượt cận trên lọt qua và tồn kho bị âm"
    }
  ]
}
```

Trường hợp e2e (`"level": "e2e"`) thì mỗi scenario thêm `entry_point` và `actors`:

```json
{
  "id": "E2E-001",
  "category": "auth-boundary",
  "title": "Bị từ chối khi cố xem đơn hàng của người dùng khác",
  "entry_point": "GET /orders/{id} màn hình chi tiết đơn hàng",
  "actors": ["Người dùng thường B (không phải chủ đơn hàng)"],
  "expected": "403. Không hiển thị dữ liệu đơn hàng của người khác",
  "miss_impact": "Rò rỉ dữ liệu ngoài quyền (IDOR)"
}
```

- `level` là `unit` / `e2e`. **Cấm `category: happy-path`**.
- Category của unit: `boundary-value` / `business-rule-boundary` / `processing-order` / `partial-failure` / `concurrency`.
- Category của e2e: `user-flow-error` / `cross-module-state` / `integration-failure` / `auth-boundary` / `data-leak`.
- Mọi scenario bắt buộc có 1 dòng `miss_impact` (ảnh hưởng nếu bỏ sót). Khi không rõ business rule thì gắn `(cần xác nhận)` vào `title` v.v.

---

## §5 Tranh luận quyết định thiết kế — design-decision / design-architect

**Nguồn sinh**: [`design-decision`](../skills/design-decision/SKILL.md), [`design-architect`](../agents/design-architect.md) (cho mỗi quyết định có nhiều phương án)
**Nơi xuất**: `deliverables/02_design/{decision_id}.debate.md`
**Mục đích**: bày các quyết định thiết kế có nhiều phương án ra dưới dạng tranh luận giữa người ủng hộ A, người ủng hộ B (và C, D) cùng một trọng tài trung lập. **AI không đưa ra kết luận**, mà trình bày nguyên liệu đều tay để người quyết.

```markdown
# Tranh luận quyết định thiết kế: {decision_id}

## Vấn đề cần quyết
[Quyết cái gì. 1–2 câu]

## Điều kiện tiền đề
- Quy mô: [ví dụ: 10.000 đơn hàng/tháng]
- Kỹ năng team: [ví dụ: chủ yếu TypeScript, SQL mức trung]
- Ràng buộc: [ví dụ: on-premise, không dùng được SaaS ngoài]
- Kế hoạch tương lai: [ví dụ: 1 năm nữa chuyển sang multi-tenant]
(Tiền đề nào còn thiếu thì ghi rõ "(cần xác nhận)", không lấp bằng suy đoán)

## Các phương án
- Phương án A: [tên]
- Phương án B: [tên]

## Người ủng hộ A (đẩy phương án A)
1. [Lập luận 1]
2. [Lập luận 2]
3. [Lập luận 3]

## Người ủng hộ B (đẩy phương án B)
1. [Lập luận 1]
2. [Lập luận 2]
3. [Lập luận 3]

## Trọng tài trung lập
- Điều kiện khiến phương án A có lợi: [...]
- Điều kiện khiến phương án B có lợi: [...]
- Thông tin cần để quyết nhưng đang thiếu: [...]

## Phần người quyết
[Chỗ này AI không viết kết luận. Là ô để người chọn rồi ghi thêm vào]
```

- Lập luận của mỗi người ủng hộ phải ra **đều tay, mỗi bên 3 điểm** (không để một bên mỏng hơn).
- Ngay cả trong section "Trọng tài trung lập" cũng **không khẳng định bên nào tốt hơn**. Chỉ dừng ở việc nêu điều kiện và thông tin còn thiếu.
- Tối đa 4 phương án. Từ 3 phương án trở lên thì chuẩn bị số section người ủng hộ bằng số phương án.

---

## §6 Handoff giữa các session — handoff-writer / handoff

**Nguồn sinh**: [`handoff-writer`](../agents/handoff-writer.md), [`handoff`](../skills/handoff/SKILL.md)
**Nơi xuất**: `deliverables/handoff/handoff-{YYYY-MM-DD}-{seq}.md`
**Mục đích**: cấu trúc hoá tình hình hiện tại, các sự kiện quan trọng, việc tiếp theo, và lưu ý, để session sau tiếp tục được từ đúng trạng thái đó. **Bắt buộc có đủ cả 4 section** (rỗng thì vẫn giữ tiêu đề).

```markdown
# Handoff: {YYYY-MM-DD}-{seq}

## Trạng thái hiện tại
- Xong: [...]
- Chưa xong: [...]
- Đang làm dở: [...]

## Sự kiện quan trọng đã xác nhận trong session này
- [Cách hiểu spec, kết quả xác nhận business rule]
- [Bắt buộc viết **những chỗ AI hiểu sai lúc đầu rồi được sửa lại** ← chống tái phát hiểu lầm]

## Việc phải làm đầu tiên ở session sau
1. [Cụ thể. Có đánh số]
2. [...]

## Lưu ý
- [Vấn đề phát sinh trong session này và cách xử lý]
- [Những cái bẫy dễ giẫm phải]
```

- Trong "sự kiện quan trọng", bắt buộc lấy **những chỗ bị người dùng sửa lại** làm điểm xuất phát.
- Suy đoán và tóm lược ở mức tối thiểu. Phủ đủ thông tin cần để tiếp tục.
- **Không viết thông tin nhạy cảm (mật khẩu, token, v.v.).**

---

## §7 Đề xuất cải thiện pipeline (Before/After) — pipeline-improve

**Nguồn sinh**: [`pipeline-improve`](../skills/pipeline-improve/SKILL.md)
**Nơi xuất**: `deliverables/reviews/pipeline-improve-{YYYY-MM}.md`
**Mục đích**: phân tích "những chỗ người đã sửa và lý do", rồi đưa ra phương án cải thiện rule và pipeline bằng Before/After với **câu chữ cụ thể**. Để rule không phình lên vì chỉ toàn thêm mới, **bắt buộc phải đi tìm cả những rule có thể bỏ đi**.

```markdown
# Báo cáo cải thiện pipeline: {YYYY-MM}

## Đối tượng phân tích
- `verdict: có vấn đề` trong reviews/*.json: [N mục]
- `assumptions(risk: high)` trong *.report.json: [N mục]
- git diff do người sửa lại: [phạm vi đối tượng]

## Các pattern lặp lại nhiều lần
| # | Triệu chứng | Số lần xảy ra | Nguyên nhân gốc (ước đoán) |
|---|---|---|---|
| 1 | [ví dụ: sai hướng làm tròn số] | 4 | risk-categories không có perspective về làm tròn |

## Phương án cải thiện (Before / After)
### Cải thiện 1: [tiêu đề]
- File đối tượng: `.claude/rules/risk-categories.md`
- Before:
  > [câu chữ hiện tại, hoặc "không có mô tả tương ứng"]
- After:
  > [câu chữ cụ thể sẽ thêm/sửa. Cấm diễn đạt trừu tượng kiểu "cần chú ý"]
- Căn cứ: [tương ứng mục số mấy trong bảng trên]

## Ứng viên bỏ đi / gộp lại
- [Bắt buộc cân nhắc tối thiểu 1 rule không còn dùng hoặc bị trùng. Không có thì ghi rõ "đã cân nhắc nhưng không có"]

## Kiểm tra trùng lặp với báo cáo cũ
- [Kết quả kiểm tra xem có đang lặp lại đúng phương án cải thiện của các lần trước không]
```

- Phương án sửa rule bắt buộc viết bằng **câu chữ cụ thể có thể dán thẳng vào**.
- **Không ghi thẳng** nội dung báo cáo này vào `.claude/agents/*.md` hay `rules/*.md` (tiền đề là phải có người duyệt).

---

## §8 Báo cáo phân tích code có sẵn (1 region, 1 run) — legacy-analyzer

**Nguồn sinh**: [`legacy-analyzer`](../agents/legacy-analyzer.md)
**Nơi xuất**: `deliverables/00_onboarding/{region}/analysis-{runN}.json` (`runN` = `run1` / `run2`)
**Mục đích**: phân tích code của 1 region được chỉ định theo 6 perspective cố định. Tiền đề là cùng region đó sẽ được phân tích thêm một run nữa rồi đem đối chiếu ở §8b. Thứ tự perspective cũng cố định.

```json
{
  "region": "order",
  "run": "run1",
  "paths_analyzed": ["src/order/**"],
  "responsibilities": [
    { "module": "src/order/create.ts", "responsibility": "Tạo và kiểm tra đơn hàng" }
  ],
  "dependencies": [
    { "from": "src/order/create.ts", "to": "src/stock/index.ts", "direction": "calls" }
  ],
  "implicit_preconditions": [
    "Tiền đề ngầm là người dùng đã xác thực trước khi gọi create()"
  ],
  "dead_code": [
    { "location": "src/order/legacy.ts:10-40", "note": "Bị comment. Không có chỗ nào tham chiếu" }
  ],
  "business_rule_evidence": [
    { "location": "src/order/create.ts:88", "magic": "0.08", "meaning": "(suy đoán) thuế suất tiêu thụ 8%" }
  ],
  "high_risk_changes": [
    { "location": "src/order/create.ts:120", "why": "Gắn chặt với việc trừ tồn kho. Sửa vào là có nguy cơ bất nhất" }
  ],
  "assumptions": ["(suy đoán) thuế suất đang hardcode nhưng có khả năng đã được đưa ra cấu hình"],
  "interpretations": [
    { "location": "src/order/create.ts:88", "options": ["Thuế suất cố định", "Thuế suất theo vùng"] }
  ],
  "uncertainty": ["Chưa kiểm chứng được tài liệu làm căn cứ cho thuế suất"]
}
```

- Bắt buộc điền đủ 6 perspective (trách nhiệm / phụ thuộc / tiền đề ngầm / dead code / căn cứ của business rule / chỗ rủi ro cao) theo đúng thứ tự này.
- Phần suy đoán thì gắn `(suy đoán)` và ghi vào `assumptions`. Nhiều cách diễn giải thì liệt kê **cả hai** vào `interpretations`, không tự chọn.
- Không khẳng định. Điểm nào chưa có bằng chứng chắc chắn thì dồn vào `uncertainty`. Chỉ đọc (cấm sửa code).

---

## §8b Báo cáo đối chiếu kết quả phân tích — analysis-aggregator

**Nguồn sinh**: [`analysis-aggregator`](../agents/analysis-aggregator.md)
**Nơi xuất**: `deliverables/00_onboarding/{region}/aggregation.json`
**Mục đích**: đối chiếu `analysis-run1.json` và `analysis-run2.json` của cùng một region, phân loại thành khớp nhau (confirmed) / lệch nhau (divergent) / chỉ một bên có (partial), để thu hẹp phạm vi cần người review. Không phân tích lại từ đầu.

```json
{
  "region": "order",
  "sources": [
    "deliverables/00_onboarding/order/analysis-run1.json",
    "deliverables/00_onboarding/order/analysis-run2.json"
  ],
  "confirmed": [
    { "topic": "Trách nhiệm của create.ts", "statement": "Tạo và kiểm tra đơn hàng" }
  ],
  "divergent": [
    {
      "topic": "Ý nghĩa của thuế suất",
      "run1": "Thuế suất tiêu thụ 8% (suy đoán)",
      "run2": "Thuế suất theo vùng (khẳng định)",
      "note": "Một bên suy đoán, một bên khẳng định nên cần human gate"
    }
  ],
  "partial": [
    { "topic": "Dead code trong legacy.ts", "mentioned_in": "run1", "statement": "Không có chỗ nào tham chiếu" }
  ],
  "uncomparable": [
    { "topic": "...", "reason": "Độ mịn của perspective khác nhau giữa hai run nên không so sánh được" }
  ],
  "confidence_rate": 0.62
}
```

- Bắt buộc map phân loại vào 3 giá trị `confirmed` / `divergent` / `partial`. **Chỉ giống hoàn toàn mới là confirmed** ("gần giống" thì không được).
- `divergent` thì **giữ lập luận của cả hai bên** (không chọn bên nào). Một bên là `(suy đoán)` còn bên kia khẳng định thì xử lý như `divergent`.
- `confidence_rate` = `số mục confirmed / tổng số mục`.
- Mục không đối chiếu được thì đưa vào `uncomparable` và ghi rõ lý do.

---

## §9 Báo cáo đọc design doc nhận từ SIer — sier-spec-reader

**Nguồn sinh**: [`sier-spec-reader`](../agents/sier-spec-reader.md)
**Nơi xuất**: `deliverables/01_requirements/{feature}.sier-readout.json`
**Mục đích**: rút ra mâu thuẫn, chỗ chưa định nghĩa, và tiền đề ngầm từ design doc nhận từ bên ngoài rồi dồn vào `issues`. Những thứ này **không được đưa vào derived spec (`{feature}.derived-spec.md`)**, mà là nguyên liệu để bắt buộc đi qua human gate ①'.

```json
{
  "feature": "order-create",
  "source_documents": [
    { "file": "inputs/sier-design/basic-design_v2.docx", "version": "v2" }
  ],
  "extracted_points": {
    "io": ["Request: ID sản phẩm, số lượng", "Response: ID đơn hàng, tổng tiền"],
    "business_rules": ["Tổng = đơn giá × số lượng × (1 + thuế suất)"],
    "error_handling": ["Hành vi khi thiếu tồn kho (không được ghi)"],
    "transaction_idempotency": ["Tính idempotent khi gửi trùng chưa được ghi"]
  },
  "issues": {
    "conflicts": [
      {
        "id": "C1",
        "documents": ["basic-design_v2 §3", "screen-design §5"],
        "description": "Cận trên số lượng: một bên ghi 1000, bên kia ghi 9999",
        "both_statements": ["Thiết kế cơ bản: 1000", "Thiết kế màn hình: 9999"]
      }
    ],
    "undefined": [
      { "id": "U1", "topic": "Phản hồi lỗi khi thiếu tồn kho", "need": "Cần chỉ định mã lỗi và message" }
    ],
    "implicit_assumptions": [
      { "id": "I1", "description": "Có vẻ đang giả định là theo thông lệ ngành thì có bước kiểm tra tín dụng trước khi chốt đơn" }
    ]
  },
  "version_diff": [
    { "from": "v1", "to": "v2", "change": "Mô tả thuế suất đổi từ cố định sang tham chiếu cấu hình" }
  ]
}
```

- **Không tóm tắt, không phóng tác lại** design doc nhận được. Chỉ rút thông tin cần cho việc code vào `extracted_points`.
- Mâu thuẫn thì **giữ mô tả của cả hai bên** trong `issues.conflicts`. Chỗ chưa định nghĩa vào `issues.undefined`, tiền đề ngầm vào `issues.implicit_assumptions`.
- Có nhiều phiên bản thì ưu tiên bản mới nhất, đồng thời ghi phần khác biệt vào `version_diff`.
- Những `issues` nêu ở đây không được trộn vào derived spec, mà phải giải quyết ở human gate ①'.

---

## Bản đồ nhanh phía được tham chiếu

| §  | Deliverable | Nguồn sinh |
|----|--------|--------|
| §1  | `03_implementation/{task_id}.report.json` | implementer / implement |
| §2  | `reviews/{impl,design,test}-*.json` | implementation-reviewer / design-reviewer / test-reviewer / focused-review |
| §3  | `{phase}/{target}.uncertainty.json` | uncertainty-auditor / uncertainty-report |
| §4  | `04_test/scenarios-{feature}.{unit,e2e}.json` | test-scenario-designer / test-scenario |
| §5  | `02_design/{decision_id}.debate.md` | design-decision / design-architect |
| §6  | `handoff/handoff-{YYYY-MM-DD}-{seq}.md` | handoff-writer / handoff |
| §7  | `reviews/pipeline-improve-{YYYY-MM}.md` | pipeline-improve |
| §8  | `00_onboarding/{region}/analysis-{runN}.json` | legacy-analyzer |
| §8b | `00_onboarding/{region}/aggregation.json` | analysis-aggregator |
| §9  | `01_requirements/{feature}.sier-readout.json` | sier-spec-reader |
