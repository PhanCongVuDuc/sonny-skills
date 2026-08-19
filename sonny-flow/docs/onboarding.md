# Thủ tục onboarding (tài liệu căn cứ dành cho AI)

Định nghĩa ở đây toàn bộ thủ tục mà command `/arent-workflow:onboarding` và `/bootstrap` tuân theo.
Có 2 path — **project mới** và **codebase có sẵn** — cả hai đều phải đi qua gate xác nhận của người sau khi kết thúc mỗi phase.

> Việc inject harness lần đầu (sinh ra `.claude/`, `deliverables/`, `docs/domain/`) là vai trò của `/arent-workflow:setup`.
> Tài liệu này xử lý thủ tục "hiểu project, sinh tri thức domain" diễn ra sau đó.

---

## Path project mới (`/arent-workflow:onboarding new`)

1. Hỏi tên project, ngành nghề, loại hệ thống (câu hỏi ra **từng cái một**).
2. Điền 4 file trong `docs/domain/` (`business_rules.md` / `tech_stack.md` / `glossary.md` / `known_patterns.md`) bằng cách phỏng vấn về ngành nghề, tech stack, và các quy tắc ngầm.
3. Điền nốt các placeholder `[REPLACE]` còn lại trong `CLAUDE.md` theo lối đối thoại.
4. Xong thì sang bước sắp xếp requirement bằng `/arent-workflow:requirements`.

---

## Path codebase có sẵn (`/arent-workflow:onboarding existing [path]`)

Sau khi kết thúc mỗi phase phải **có người xác nhận** rồi mới đi tiếp. Parallel analysis bắt buộc chạy 2 lần trong 2 session khác nhau.

| Phase | Nội dung | Deliverable | Human gate |
|---|---|---|---|
| Phase 0-1 định nghĩa region | Chia path mục tiêu thành các domain region | `deliverables/00_onboarding/regions.json` | Xác nhận việc chia region có hợp lý không (xác nhận trước, không đánh số. Duyệt xong thì sang Phase 0-2) |
| Phase 0-2 parallel analysis | Phân tích từng region bằng skill `parallel-analysis` (chạy `legacy-analyzer` 2 lần độc lập) → đối chiếu bằng `analysis-aggregator` | `00_onboarding/{region}/analysis-run1.json`, `analysis-run2.json`, `aggregation.json` | **Human gate ⓪-1**: người có chuyên môn kiểm `divergent`/`partial` |
| Phase 0-3 sinh tài liệu | Sinh 3 file thuộc tầng tự động bằng skill `doc-bootstrap` | `docs/domain/generated/{code_map,dependencies,module_index}.md` | **Human gate ⓪-2**: tính hợp lý của sản phẩm sinh ra |
| Phase 0-4 rút business rule | Rút các business rule ứng viên bằng skill `code-archeology` | `00_onboarding/business-rules-candidates.json` | **Human gate ⓪-3**: người có chuyên môn duyệt các ứng viên → phản ánh vào `docs/domain/business_rules.md` |

> Điều kiện phán định tự động của gate: xem [`.claude/rules/gates.md`](../.claude/rules/gates.md) (gate ⓪).
> Định dạng của từng deliverable: xem [`.claude/rules/output-formats.md`](../.claude/rules/output-formats.md) (§8 / §8b).

---

## Quy tắc bắt buộc

- Đặt câu hỏi **từng cái một** (không hỏi nhiều câu cùng lúc).
- Không điền thông tin domain bằng suy đoán. Chỗ nào chưa rõ thì để lại `(cần xác nhận)`.
- Ở mỗi gate xác nhận của người, **bắt buộc phải được duyệt rồi** mới sang phase kế tiếp. Không tự động chạy liên tục hết mọi phase.
- Parallel analysis của path codebase có sẵn bắt buộc chạy 2 lần trong 2 session khác nhau, rồi đối chiếu bằng `aggregation.json`.

---

## Checklist hoàn thành

Dùng để phán định onboarding đã xong hay chưa. `/bootstrap` sẽ quay lại checklist này để kiểm phần việc còn lại.

- [ ] `docs/domain/business_rules.md` không còn sót `[REPLACE]`, và đã được điền bằng các business rule đã được người có chuyên môn duyệt
- [ ] `docs/domain/tech_stack.md` đã ghi công nghệ đang dùng, phiên bản, và lý do chọn
- [ ] `docs/domain/glossary.md` đã đăng ký các thuật ngữ nghiệp vụ chính và các từ viết tắt
- [ ] (path codebase có sẵn) 3 file trong `docs/domain/generated/` đã được sinh ra và đã qua xác nhận ⓪-2
- [ ] (path codebase có sẵn) `business-rules-candidates.json` đã qua xác nhận ⓪-3 và đã phản ánh vào `business_rules.md`
- [ ] `CLAUDE.md` không còn sót `[REPLACE]` nào chưa thay
- [ ] Phần setup còn lại (cấu hình LSP = `/setup-lsp`, phỏng vấn domain) đã hoàn thành
- [ ] Đã ở trạng thái sang được phase kế tiếp `/arent-workflow:requirements`
