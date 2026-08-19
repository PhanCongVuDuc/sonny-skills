---
description: Canonical definition of review-perspective keys, risk categories and severity levels. Shared reference for implementation/design review, risk-flag, uncertainty and pipeline-improve. No `paths:` (referenced explicitly from each command / agent / skill).
---

# Risk Categories Rules (khoá perspective, risk category, mức nghiêm trọng)

Không có frontmatter `paths:` — rule này không gắn với file cụ thể nào, mà được từng command, agent, skill tham chiếu tường minh.

File này là nơi định nghĩa duy nhất (single source of truth) cho **khoá perspective review**, **risk category**, và **mức nghiêm trọng** dùng trong toàn bộ harness.
Phần `{perspective}` trong tên file thuộc `deliverables/`, cũng như giá trị của các field `category` / `risk_level` / `impact` trong từng JSON, **bắt buộc phải khớp** với khoá định nghĩa ở đây.

Nơi tham chiếu:
- [`implementation-reviewer`](../agents/implementation-reviewer.md), [`design-reviewer`](../agents/design-reviewer.md) (review theo perspective)
- Skill [`risk-flag`](../skills/risk-flag/SKILL.md) (category của `human_review_required`)
- Skill [`focused-review`](../skills/focused-review/SKILL.md) (review 1 perspective)
- [`uncertainty-auditor`](../agents/uncertainty-auditor.md) (mức ảnh hưởng của các chỗ suy đoán)
- Skill [`pipeline-improve`](../skills/pipeline-improve/SKILL.md) (phân loại category thất bại)
- [`deliverables/README.md`](../../deliverables/README.md) (quy ước đặt tên `{perspective}`)

---

## Mức nghiêm trọng (severity)

Thống nhất **3 bậc** trong toàn bộ harness. Tên field khác nhau tuỳ ngữ cảnh, nhưng giá trị luôn là `high / medium / low`.

| Field | Chỗ dùng | Ý nghĩa |
|---|---|---|
| `risk_level` | Điểm nêu ra khi review và `human_review_required` (`implementation-reviewer` / `design-reviewer` / `risk-flag` / `focused-review`) | Mức nguy hiểm của điểm nêu ra / flag đó |
| `impact` | Chỗ suy đoán (`uncertainty-auditor` / `uncertainty.json`) | Mức ảnh hưởng khi suy đoán đó sai |
| `risk` | `assumptions` trong báo cáo implementation (`{task_id}.report.json`) | Rủi ro khi tiền đề đó sụp đổ |

### Tiêu chí phán định `high`
Rơi vào bất kỳ mục nào sau đây thì là `high`:
- **Ảnh hưởng nghiệp vụ**: sai là lệch quyết định nghiệp vụ, lệch số tiền, lệch chứng từ
- **Hỏng dữ liệu**: có thể gây bất nhất, mất dữ liệu, hoặc ghi nhận trùng
- **Bảo mật**: liên quan tới xác thực, phân quyền, rò rỉ thông tin

→ `high` thì **bắt buộc đẩy lên human gate** (xem [`.claude/rules/gates.md`](gates.md)).

### Khi phân vân
- Phân vân khi đánh giá mức ảnh hưởng: chọn **cao hơn một bậc** (nghiêng về phía an toàn).
- Chính mình cũng không rõ đó là suy đoán hay khẳng định: không giấu, ghi lại ở mức độ tin cậy thấp nhất.

---

## Kết quả phán định review (verdict)

Output của review theo perspective (`design-reviewer` / `implementation-reviewer` / `focused-review`) bắt buộc phân loại theo **3 giá trị**.

| verdict | Ý nghĩa |
|---|---|
| `có vấn đề` | Có điểm cần nêu. Gắn kèm `location`, `issue`, `risk_level` |
| `không vấn đề` | Nói rõ perspective đã kiểm tra bằng `scope` (không im lặng cho qua) |
| `không kiểm chứng được` | Thiếu thông tin cần để phán đoán (business rule v.v.). Nói rõ `needed_info` |

- Nghiêm ngặt **1 lần gọi 1 perspective**. Có nhận ra vấn đề không thuộc perspective đó cũng bỏ qua (xử lý ở lần gọi khác).
- Không xuất "điểm tốt / khuyến nghị" (chỉ nêu vấn đề).

---

## Khoá perspective review implementation (implementation review)

Dùng cho `implementation-reviewer` / `/review` (implementation) / `focused-review` (code).
Tên file là `deliverables/reviews/impl-{perspective}-{task_id}.json`.

| Khoá | Perspective | Điểm kiểm tra chính |
|---|---|---|
| `transaction-boundary` | Transaction boundary | Việc tách nhiều thao tác DB, khôi phục khi thất bại một phần, có cần nested transaction không |
| `error-business-logic` | Business logic nằm trong phần xử lý lỗi | Trong catch có xử lý gì ngoài "log và re-throw", nhánh nghiệp vụ theo loại lỗi, việc ghi bảng khác / gửi thông báo / bù trừ khi có lỗi |
| `numeric-precision` | Độ chính xác số | Trộn lẫn int/float với decimal, bị cắt cụt do chia số nguyên, cách làm tròn có khớp business rule không |
| `performance` | Hiệu năng | Query DB trong vòng lặp (N+1), lấy toàn bộ rồi lọc ở phía app, nạp lượng lớn dữ liệu vào memory một lần |
| `non-functional` | Phi chức năng | Log, giám sát, timeout, retry, giới hạn tài nguyên |
| `security` | Bảo mật | Xác thực, phân quyền, kiểm tra input, rò rỉ thông tin (chi tiết xem [`.claude/rules/security.md`](security.md)) |
| `spec-conformance` | Tuân thủ spec | Có lẫn vào xử lý / tối ưu hoá / refactor không ghi trong spec không (vi phạm P10), có bỏ sót spec không |
| `cross-file-flow` | Luồng xuyên file | Tính nhất quán của xử lý trải qua nhiều file, lệch tiền đề giữa phía gọi và phía implement |
| `concurrency` | Tính đồng thời | Bất đồng bộ và an toàn luồng, tranh chấp và deadlock, bảo vệ trạng thái dùng chung |
| `config-branch` | Cấu hình và rẽ nhánh | Độ phủ các nhánh theo giá trị cấu hình, khác biệt giữa các môi trường, cách xử lý feature flag |

---

## Khoá perspective review design (design review)

Dùng cho `design-reviewer` / `/design` / `focused-review` (design).
Tên file là `deliverables/reviews/design-{perspective}-{feature}.json`.

| Khoá | Perspective | Điểm kiểm tra chính |
|---|---|---|
| `data-integrity` | Tính toàn vẹn dữ liệu | Ràng buộc duy nhất, toàn vẹn tham chiếu, tính hợp lý của chuyển trạng thái, duy trì điều kiện bất biến |
| `error-handling` | Error handling | Thiết kế các nhánh thất bại, phương châm retry / bù trừ / rollback |
| `transaction-boundary` | Transaction boundary | Thiết kế đơn vị transaction, phạm vi nhất quán |
| `security` | Bảo mật | Ranh giới xác thực và phân quyền, việc kiểm tra tại biên tin cậy (chi tiết xem [`.claude/rules/security.md`](security.md)) |
| `non-functional` | Phi chức năng | Cân nhắc về tính sẵn sàng, hiệu năng, khả năng mở rộng, khả năng vận hành trong thiết kế |

---

## Khoá risk category (risk-flag / human_review_required)

Category của các flag mà skill `risk-flag` cắm vào `human_review_required`.
`human_review_required` của `implementer` cũng dùng bộ khoá này.

| Khoá | Đối tượng cần rút ra |
|---|---|
| `numeric-precision` | Làm tròn, ép kiểu, chia số nguyên |
| `transaction-boundary` | Nhiều thao tác DB, thất bại một phần |
| `error-business-logic` | Business logic nằm trong catch |
| `business-rule` | Phụ thuộc vào business rule ngầm |
| `concurrency` | Bất đồng bộ, an toàn luồng |
| `security` | Xác thực, phân quyền, kiểm tra input, rò rỉ thông tin |

Mỗi mục trong `human_review_required` bắt buộc kèm `location` / `category` / `description` / `risk_level` / `question_for_human`.
Khi trả về "không có flag" thì phải nói rõ các category đã kiểm tra qua `confirmed_categories: [...]`.

---

## Category suy đoán (uncertainty)

Nhãn **ABCD** mà `uncertainty-auditor` dùng để phân loại các chỗ suy đoán. Mỗi mục bắt buộc kèm `impact: high/medium/low` và "một câu hỏi nên hỏi người".

| Nhãn | Ý nghĩa |
|---|---|
| `A` | Suy đoán vì thiếu thông tin |
| `B` | Có nhiều cách diễn giải, đã chọn một trong số đó |
| `C` | Không rõ business rule nên làm theo hành vi thông thường |
| `D` | Hoàn toàn chưa hiểu |

- Mục mà chính mình cũng không rõ có phải suy đoán hay không thì ghi là `D` (không giấu).
- `impact: high` sẽ trở thành đối tượng review của human gate ①.

---

## Quy tắc vận hành category

- **Muốn thêm khoá perspective mới thì trước hết phải định nghĩa trong file này.** Không dùng khoá chưa có định nghĩa trong tên file hay trong JSON.
- Phần phân loại category thất bại của `pipeline-improve` dùng đúng bộ khoá trong file này (không tự phát minh category riêng).
- Khi khoá tăng lên quá nhiều thì dùng `pipeline-improve` để cân nhắc **các ứng viên bỏ đi hoặc gộp lại** (chống phình).
- Các điểm nêu ra bị trùng nhau (cùng loại vấn đề trong cùng một file) thì có thể gộp lại làm một.

---

## Tham chiếu

- Gate chuyển phase và thời điểm human review: [`.claude/rules/gates.md`](gates.md)
- Tiêu chí chi tiết của perspective bảo mật: [`.claude/rules/security.md`](security.md)
- Định dạng của file có cấu trúc: [`.claude/rules/output-formats.md`](output-formats.md)
- Quy ước đặt tên deliverable (`{perspective}`): [`deliverables/README.md`](../../deliverables/README.md)
