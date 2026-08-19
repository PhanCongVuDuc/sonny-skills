---
name: parallel-analysis
description: Analyse the same target with several independent agents in parallel, then cross-check the results to build a high-confidence analysis. The workhorse skill for guaranteeing accuracy in the /setup existing-analysis path.
---

# parallel-analysis

## Khi nào dùng
- Khi **độ chính xác của lần đầu** là quan trọng trong việc phân tích code có sẵn
- Khi muốn lợi dụng chính tính bất định của AI để lấy "phần khớp nhau giữa nhiều run" làm mức tin cậy = cao
- Khi muốn thu hẹp phạm vi review chỉ còn "những chỗ lệch nhau"

## Input / output
- Input: định nghĩa region (một region trong `deliverables/00_onboarding/regions.json`)
- Output:
  - `deliverables/00_onboarding/{region}/analysis-run1.json`
  - `deliverables/00_onboarding/{region}/analysis-run2.json`
  - `deliverables/00_onboarding/{region}/aggregation.json`

## Quy tắc tối thiểu phải giữ
- Mỗi run **bắt buộc chạy trong session khác nhau** (chống nhiễu context)
- **Không đổi prompt** giữa các run (đổi là mất tính so sánh trong cùng điều kiện)
- `confidence_rate` dưới 70% thì có khả năng việc chia region đang quá thô. Cân nhắc chia lại
- Vấn đề nằm vắt qua nhiều region thì không viết vào báo cáo của region đang xét

Thủ tục chạy song song cụ thể: xem [`reference.md`](reference.md).
