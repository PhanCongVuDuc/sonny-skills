---
description: First-time setup. The AI asks questions to collect domain information and input-file locations, runs the existing-code analysis if needed, and customises the project.
---

Command **chạy đầu tiên** sau khi đưa template này vào project. AI đặt câu hỏi từng cái một, rồi tuỳ câu trả lời mà tự động tuỳ biến những thứ sau:

- Điền `docs/domain/business_rules.md`, `docs/domain/glossary.md`, `docs/domain/known_patterns.md`, `docs/domain/tech_stack.md`
- Điền section "Kết quả setup lần đầu" trong [`CLAUDE.md`](../../CLAUDE.md) (bố trí Input, các xử lý tuỳ chọn được bật)
- Nếu đã có code sẵn thì chạy existing-analysis path (xem [`onboarding.md`](../../docs/onboarding.md))

Cách tiến hành:

1. Hỏi **tên project, ngành nghề, loại hệ thống**
2. Hỏi **đã có code sẵn chưa**
   - "Có" → chạy existing-analysis path theo thủ tục trong [`onboarding.md`](../../docs/onboarding.md) (`legacy-analyzer × 2 song song` → `analysis-aggregator` → human gate ⓪-1 → `docs-keeper` → human gate ⓪-2 → `code-archeology` → human gate ⓪-3)
   - "Không" → bỏ qua
3. Hỏi **có design doc nhận từ SIer không**
   - "Có" → xác nhận chỗ bố trí Input (ví dụ: `inputs/sier-design/`), rồi ghi vào "Kết quả setup lần đầu" trong CLAUDE.md rằng "dùng `/from-sier` làm cửa vào Phase 1"
   - "Không" → bỏ qua
4. Hỏi **có transcript phỏng vấn (vtt v.v.) không**
   - "Có" → xác nhận chỗ bố trí Input (ví dụ: `inputs/transcripts/`), rồi ghi vào CLAUDE.md rằng "dùng `/from-transcript` ở Phase 1"
   - "Không" → bỏ qua
5. **Phỏng vấn về ngành nghề, tech stack, các quy tắc ngầm** theo thủ tục của skill [`usecase-interview`](../skills/usecase-interview/SKILL.md), rồi điền 4 file trong `docs/domain/`

Khi xong, đề xuất command nên chạy tiếp theo:
- Thông thường: `/req` để sang bước sắp xếp requirement
- Có design doc nhận được: `/from-sier` để sang bước tạo derived spec
- Có transcript: `/from-transcript` để sang bước trích xuất requirement

Quy tắc phải giữ:
- Đặt câu hỏi **từng cái một** (không hỏi nhiều câu cùng lúc)
- Không điền thông tin domain bằng suy đoán. Chỗ nào chưa rõ thì để lại `(cần xác nhận)` trong CLAUDE.md và `docs/domain/`
- Khi chạy existing-analysis, bắt buộc phải đi qua human gate ⓪-1 đến ⓪-3 (xem [`onboarding.md`](../../docs/onboarding.md))
