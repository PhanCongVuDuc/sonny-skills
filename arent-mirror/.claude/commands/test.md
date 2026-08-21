---
description: "Phase 4: test-scenario design → test implementation → test review. Specify the level (unit / e2e). Independent from the implementation AI."
---

Khởi động test phase. **Dùng agent khác với implementation agent** (tránh thiên kiến tự kiểm chứng).

Chỉ định `unit` / `e2e` / `both` qua `$ARGUMENTS`:
- `unit`: chỉ unit test
- `e2e`: chỉ e2e test
- `both`: chạy cả hai **lần lượt** (unit→e2e, file scenario tạo riêng từng cái)

Cách tiến hành (lặp lại cho từng level được chỉ định):
1. Khởi động [`test-scenario-designer`](../agents/test-scenario-designer.md) (skill [`test-scenario`](../skills/test-scenario/SKILL.md))
   - Input: spec (`{feature}.spec.md`, hoặc `{feature}.derived-spec.md` nếu đi qua design doc SIer) + `business_rules.md`
   - Bắt buộc chỉ định level `unit` / `e2e`
   - Output: `deliverables/04_test/scenarios-{feature}.unit.json` hoặc `.e2e.json` (**không bao gồm happy path**)
2. **Human review**: nếu có phần cần thêm/sửa đặc thù nghiệp vụ thì bổ sung vào scenario
3. Khởi động [`test-implementer`](../agents/test-implementer.md)
   - Input: scenario JSON, code (**chỉ để tham khảo**)
   - e2e thì **mock tối thiểu** (chỉ mock hệ thống ngoài, API nội bộ dùng đồ thật)
   - Output: code test + `scenario-map.json`
4. Khởi động [`test-reviewer`](../agents/test-reviewer.md)
   - Perspective: độ phủ scenario / tính hợp lý của mock / có bị lặp thừa không / khả năng truy vết / khớp level
   - Output: `deliverables/reviews/test-{feature}.json`
5. Chạy test → **human gate ③** (đánh giá tổng hợp implementation + test): xem **cùng lúc** kết quả review theo perspective của `implementation-reviewer` và kết quả test. Nếu là bug implementation thì trả về Phase 3; nếu vấn đề nằm ở phía test thì sửa trong Phase 4; nếu thiếu coverage thì thêm scenario trong Phase 4; không vấn đề gì thì **sang bước tạo PR**

Tham số: `$ARGUMENTS = "{feature} {level}"` (ví dụ: `order-create unit`, `order-create both`).
