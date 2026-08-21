# deliverables/

Nơi ghi ra deliverable và báo cáo của từng phase. **Không tin câu "báo cáo hoàn thành" bằng ngôn ngữ tự nhiên của AI agent, mà phán định dựa trên các file có cấu trúc trong thư mục này.**

---

## Công dụng theo từng thư mục

| Thư mục | Chứa gì | Nguồn sinh chính |
|---|---|---|
| `00_setup/` | `harness-manifest.json` (danh sách file được inject kèm hash), `existing-analysis.json`, `harness-analysis.json`, `merge-plan.json` | Skill `/setup`, `/re-setup` |
| `00_onboarding/` | Deliverable của existing-analysis path: `regions.json`, `{region}/analysis-run*.json`, `{region}/aggregation.json`, `business-rules-candidates.json`, `docs-update-*.json` | `legacy-analyzer`, `analysis-aggregator`, `docs-keeper`, skill `code-archeology` |
| `01_requirements/` | `{feature}.requirements.md` (use case, user story)<br>`{feature}.spec.md` (bản nháp spec)<br>`{feature}.derived-spec.md` (derived spec khi đi qua design doc SIer)<br>`{feature}.sier-readout.json` (danh sách mâu thuẫn trong design doc SIer)<br>`{feature}.from-transcript.md` (rút từ vtt v.v.)<br>`{feature}.transcript-refs.json` (số dòng của file gốc)<br>`{feature}.uncertainty.json` (báo cáo các chỗ suy đoán) | `requirements-organizer`, `spec-drafter`, `sier-spec-reader`, `transcript-extractor`, `uncertainty-auditor` |
| `02_design/` | `{feature}.design.md` (design doc)<br>`{decision_id}.debate.md` (tranh luận quyết định thiết kế) | `design-architect`, skill `design-decision` |
| `03_implementation/` | `{task_id}.report.json` (báo cáo tự kiểm tra của implementation agent) | `implementer` |
| `04_test/` | `scenarios-{feature}.unit.json` (scenario unit)<br>`scenarios-{feature}.e2e.json` (scenario e2e)<br>`scenario-map.json` (ánh xạ scenario ⇔ test) | `test-scenario-designer`, `test-implementer` |
| `reviews/` | `design-{perspective}-{feature}.json` (review design)<br>`impl-{perspective}-{task_id}.json` (review implementation)<br>`test-{feature}.json` (review test)<br>`devils-advocate-*.md` (devil's advocate)<br>`pipeline-improve-*.md` (cải thiện pipeline) | Các reviewer và skill khác nhau |
| `handoff/` | `handoff-{YYYY-MM-DD}-{seq}.md` (handoff giữa các session) | `handoff-writer` |

---

## Quy ước đặt tên

- `{feature}` là tên chức năng viết kebab-case (ví dụ: `order-create`, `invoice-export`)
- `{task_id}` là task ID (ví dụ: `form_001_convert`)
- `{perspective}` là khoá perspective trong [`.claude/rules/risk-categories.md`](../.claude/rules/risk-categories.md)
- `{decision_id}` là ID của quyết định thiết kế (ví dụ: `db-engine-choice`, `auth-method`)

---

## Định dạng có cấu trúc

Định dạng chi tiết của JSON/Markdown: xem [`.claude/rules/output-formats.md`](../.claude/rules/output-formats.md).

---

## Cách xử lý file

- Mỗi phase kết thúc thì lấy file trong thư mục này làm căn cứ để sang phase kế tiếp
- Về cơ bản không xoá (sau này chúng là nguyên liệu để skill cải thiện pipeline phân tích)
- Không ghi thông tin nhạy cảm (thông tin cá nhân, token) vào

## Chính sách quản lý git (mặc định của template)

| Thư mục | Mặc định | Lý do |
|---|---|---|
| `00_setup/` | commit | Giữ lại căn cứ và lịch sử của việc inject harness |
| `00_onboarding/` | commit (chỉ ignore `docs-update-*.json`) | Giữ lại căn cứ của existing-analysis |
| `01_requirements/*.spec.md` `*.derived-spec.md` `*.requirements.md` | commit | Spec thì muốn review theo diff |
| `01_requirements/*.uncertainty.json` `*.sier-readout.json` | commit | Chỗ suy đoán và mâu thuẫn là nguyên liệu để học |
| `02_design/*.design.md` `*.debate.md` | commit | Design doc thì muốn review theo diff |
| `03_implementation/*.report.json` | **ignore** | Dễ bay hơi, bị ghi đè sau mỗi lần code |
| `04_test/scenarios-*.json` | commit | Scenario test thì muốn review theo diff |
| `04_test/scenario-map.json` | **ignore** | Sinh lại được cùng với code test |
| `reviews/*.json` `*.md` | commit | Lịch sử review có giá trị cao như nguyên liệu để học |
| `handoff/*.md` | **ignore** | Ghi chú công việc riêng của từng session |

`.gitignore` đã ghi sẵn các mặc định trên. Có thể điều chỉnh tuỳ theo phương châm của project.
