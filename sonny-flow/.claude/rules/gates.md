---
description: Criteria for phase transitions. Never trust an AI's natural-language "done" report — decide whether work may proceed via automated gates and human gates over structured deliverables. No `paths:` (referenced explicitly from each command / agent).
---

# Gates Rules (gate chuyển phase)

Không có frontmatter `paths:` — rule này không gắn với file cụ thể nào, mà được từng command và agent tham chiếu tường minh.

Workflow của project này là **không qua được gate của phase thì không đi tiếp được**.
Có 2 loại gate.

- **Gate tự động (machine-checkable)**: các điều kiện mà AI/script phán định được một cách máy móc, dựa trên file có cấu trúc (JSON / Markdown) nằm dưới `deliverables/`. **Không thoả thì không cho sang phase kế tiếp.**
- **Human gate (human approval)**: checkpoint để người kiểm tra deliverable rồi duyệt. AI không tự động vượt qua được.

> **Nguyên tắc lớn: không lấy câu "xong rồi", "không có vấn đề gì" bằng ngôn ngữ tự nhiên của AI agent làm căn cứ để đi tiếp.** Luôn lấy file có cấu trúc trong `deliverables/` làm căn cứ, và phán định theo các điều kiện gate dưới đây.

---

## Đối chiếu số hiệu gate và phase

| Gate | Phase | Gate tự động (file đối tượng) | Human gate đi kèm sau đó |
|---|---|---|---|
| Gate ⓪ | Phase 0 (onboarding / bootstrap) | `deliverables/00_onboarding/*.json` | Human gate ⓪-1 / ⓪-2 / ⓪-3 |
| Gate ① | Phase 1 (requirement, spec) | `deliverables/01_requirements/{feature}.spec.md` + `{feature}.uncertainty.json` (đi qua SIer thì là `{feature}.derived-spec.md` + `{feature}.sier-readout.json`) | Human gate ① (đi qua SIer thì là ①') |
| Gate ② | Phase 2 (design) | `deliverables/reviews/design-{perspective}-{feature}.json` + `devils-advocate-*.md` | Human gate ② |
| Gate ③ | Phase 3 (implementation) | `deliverables/03_implementation/{task_id}.report.json` | Human gate ③ (sau khi qua Phase 4) |
| Gate ④ | Phase 4 (test) | `deliverables/04_test/scenarios-*.json` + `deliverables/reviews/test-*.json` + kết quả chạy test | Human gate ③ (đánh giá tổng hợp implementation + test) |

> Định nghĩa khoá perspective (`{perspective}`): xem [`.claude/rules/risk-categories.md`](risk-categories.md).
> Định dạng chi tiết của file có cấu trúc: xem [`.claude/rules/output-formats.md`](output-formats.md).

---

## Gate ⓪ — onboarding / bootstrap

Chỉ đi qua trong existing-analysis path (project mới thì không cần).

**Điều kiện gate tự động**
- `deliverables/00_onboarding/{region}/aggregation.json` đã đủ cho tất cả các region
- Mỗi mục trong kết quả phân tích đều có gắn `status: confirmed / partial / divergent`

**Human gate (không thể tự động vượt qua)**
- **Human gate ⓪-1**: người kiểm tra các mục `divergent` và `partial`, rồi điền cột `human_verdict` (`confirmed` thì về cơ bản cho qua)
- **Human gate ⓪-2**: kiểm tra tính hợp lý của 3 file được sinh ra (khung tài liệu domain)
- **Human gate ⓪-3**: người có chuyên môn duyệt các business rule ứng viên (kể cả loại `confidence: guess`) → phản ánh vào `docs/domain/business_rules.md`

---

## Gate ① — requirement, spec

Phán định phần spec do `/spec` (thông thường) hoặc `/from-sier` (đi qua design doc nhận từ SIer) xuất ra.

**Điều kiện gate tự động**
- Spec `{feature}.spec.md` cố định 10 section, và có chứa section "Các điểm chưa chốt"
- `{feature}.uncertainty.json` tồn tại, và mỗi mục suy đoán đều có `impact: high/medium/low` cùng "một câu hỏi nên hỏi người"
- Trường hợp đi qua SIer: `{feature}.derived-spec.md` tồn tại, và `issues` (mâu thuẫn / chưa định nghĩa) trong `{feature}.sier-readout.json` đã được liệt kê

**Human gate (không thể tự động vượt qua)**
- **Human gate ①**: người kiểm tra và duyệt các chỗ suy đoán có `impact: high` cùng mục "Các điểm chưa chốt"
- **Human gate ①'** (đi qua SIer): người kiểm tra hướng xử lý cho `issues` trong `sier-readout.json` + các mục `impact: high` trong `uncertainty.json`

---

## Gate ② — design

Phán định design doc và kết quả review do `/design` xuất ra.

**Điều kiện gate tự động**
- `{feature}.design.md` tồn tại
- Kết quả chạy `design-reviewer` theo từng perspective, tức `deliverables/reviews/design-{perspective}-{feature}.json`, tồn tại, và mỗi mục được phân loại theo 3 giá trị `verdict: có vấn đề / không vấn đề / không kiểm chứng được`
- `devils-advocate-*.md` (kịch bản thất bại) tồn tại

**Human gate (không thể tự động vượt qua)**
- **Human gate ②**: người kiểm tra và duyệt các điểm `risk_level: high` cùng hướng xử lý cho các kịch bản thất bại → qua được thì sang `/implement`

---

## Gate ③ — implementation (gate tự động)

Phán định `deliverables/03_implementation/{task_id}.report.json` do `/implement` xuất ra.
**Step 3 của `/implement` tham chiếu gate này.**

**Điều kiện gate tự động (phải thoả tất cả)**

| # | Điều kiện | Phán định |
|---|---|---|
| 3-1 | Phải là `status: completed` | Còn đang `in_progress` / `blocked` thì không cho đi tiếp |
| 3-2 | Phải là `todo_remaining: 0` | Từ 1 trở lên thì coi là chưa xong, trả về |
| 3-3 | Trong `assumptions`, số mục `risk: high` phải bằng **không**, hoặc **đã được người duyệt** | Còn sót suy đoán rủi ro cao chưa được duyệt thì không cho qua |
| 3-4 | Nếu `human_review_required` không rỗng, mỗi mục phải có đủ `category` (khoá trong [risk-categories.md](risk-categories.md)), `question_for_human`, và `risk_level` | Thiếu dù chỉ một cái cũng coi là báo cáo khuyết, trả về |

> Thiếu bất kỳ điều kiện nào thì **trả về Phase 3** (không cho sang phase kế tiếp mà chưa có người kiểm tra).
> Gate này không bảo đảm "code viết đúng", mà bảo đảm "những chỗ người cần kiểm tra đã được khai báo đúng trong báo cáo". Việc phán định tính hợp lý của phần code thì làm ở human gate ③.

---

## Gate ④ — test (gate tự động)

Phán định scenario, test, và kết quả chạy do `/test` xuất ra.

**Điều kiện gate tự động**
- `scenarios-{feature}.{level}.json` (unit / e2e) tồn tại, và **không phải là loại scenario chỉ có happy path** (phải có error path, boundary value)
- `deliverables/reviews/test-{feature}.json` tồn tại, và được phân loại theo 3 giá trị `verdict`
- Kết quả chạy test đã được ghi lại, và **toàn bộ test đều pass** (không cho đi tiếp khi còn test fail)
- `scenario-map.json` đã ánh xạ được scenario ⇔ test (khả năng truy vết)

**Human gate (không thể tự động vượt qua)**
- **Human gate ③ (đánh giá tổng hợp)**: người kiểm tra **đồng thời** kết quả review theo perspective của `implementation-reviewer` + kết quả test.
  - Bug ở implementation → trả về Phase 3
  - Vấn đề nằm ở phía test → sửa trong Phase 4
  - Thiếu coverage → thêm scenario trong Phase 4
  - Không vấn đề gì → **sang bước tạo PR**

---

## Quy tắc nền của việc phán định gate

- **Chưa thoả gate tự động thì chưa đẩy lên human gate.** Cái gì máy loại được thì để máy loại.
- **AI không làm thay human gate.** AI chỉ làm tới mức lọc ra và trình bày "những mục người cần kiểm tra". Quyết định duyệt là của người.
- **Kể cả khi trả về "không vấn đề" cũng phải nói rõ perspective và các mục đã kiểm tra** (không im lặng cho qua).
- **`risk: high` / `impact: high` / `risk_level: high` bắt buộc phải đẩy lên human gate.** Phân vân khi đánh giá mức ảnh hưởng thì nghiêng lên một bậc (phía an toàn).
- Căn cứ để qua gate luôn là file có cấu trúc trong `deliverables/`. Không lấy báo cáo hoàn thành bằng ngôn ngữ tự nhiên làm căn cứ.

---

## Tham chiếu

- Định nghĩa khoá perspective và risk category: [`.claude/rules/risk-categories.md`](risk-categories.md)
- Định dạng của file có cấu trúc: [`.claude/rules/output-formats.md`](output-formats.md)
- Thủ tục khởi động từng phase: `.claude/commands/spec.md`, `design.md`, `implement.md`, `test.md`, `review.md`, `from-sier.md`
