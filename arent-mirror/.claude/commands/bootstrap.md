---
description: Run the existing-code analysis path standalone. Normally invoked automatically from /setup Q2, so manual execution is rarely needed.
---

Chạy riêng lẻ existing-analysis path (nhánh phân tích codebase có sẵn). Bình thường nó tự chạy khi bạn trả lời "có" ở Q2 của `/setup` (đã có code sẵn chưa?), nên không cần gọi tay.

Khi nào cần đến command này:
- Sau khi setup xong mới quyết định "thôi vẫn nên chạy existing-analysis"
- Muốn phân tích lại (ví dụ code đã thay đổi lớn)

Căn cứ cho toàn bộ thủ tục nằm ở [`docs/onboarding.md`](../../docs/onboarding.md).

Cách tiến hành:

1. **Xác nhận việc chia region**: kiểm tra `deliverables/00_onboarding/regions.json` có tồn tại không. Không có thì nhờ người dùng định nghĩa region (ví dụ: `domain` / `infra` / `ui` / `auth` / `batch`)
2. **Chạy parallel analysis theo từng region** (skill [`parallel-analysis`](../skills/parallel-analysis/SKILL.md))
   - Với mỗi region, chạy `legacy-analyzer` **2 lần trong 2 session độc lập**
   - Output: `deliverables/00_onboarding/{region}/analysis-run1.json` `analysis-run2.json`
3. **Đối chiếu**: dùng `analysis-aggregator` sinh `aggregation.json`. Bắt buộc kiểm tra `confidence_rate`
4. **Human gate ⓪-1**: để người dùng xác nhận các mục `divergent` và `partial`. Cột `human_verdict` được điền xong thì đi tiếp
5. **Sinh lần đầu bộ docs dành cho AI** (skill [`doc-bootstrap`](../skills/doc-bootstrap/SKILL.md) là cửa vào, nó khởi động agent `docs-keeper`)
   - `docs-keeper` sinh `code_map.md` `dependencies.md` `module_index.md` (bản tóm tắt: `deliverables/00_onboarding/docs-update-{YYYY-MM-DD}.json`)
6. **Human gate ⓪-2**: xác nhận 3 file vừa sinh có hợp lý không
7. **Trích xuất business rule** (skill [`code-archeology`](../skills/code-archeology/SKILL.md))
   - Rút các business rule ứng viên từ từng region → `deliverables/00_onboarding/business-rules-candidates.json`
8. **Human gate ⓪-3**: người có chuyên môn duyệt các business rule ứng viên → phản ánh vào `docs/domain/business_rules.md`
9. Kiểm tra checklist hoàn thành (cuối [`docs/onboarding.md`](../../docs/onboarding.md)), rồi quay lại phần setup còn dở (Q3/Q4 + phỏng vấn domain)

Tham số (tuỳ chọn): truyền tên region vào `$ARGUMENTS` để chỉ chạy region đó.
