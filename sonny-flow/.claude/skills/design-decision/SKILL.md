---
name: design-decision
description: Lay out a design decision that has multiple candidates as a debate (advocate A, advocate B, neutral referee). The AI does not conclude — the human decides.
---

# design-decision

## Khi nào dùng
- Khi muốn so sánh các phương án về kiến trúc hoặc lựa chọn công nghệ
- Khi muốn sắp xếp nhiều phương án thiết kế một cách trung lập
- Khi muốn hỏi "có phương án nào khác không" đối với một thiết kế trông như chỉ có một đường

## Input / output
- Input: các phương án (tối đa 4), điều kiện tiền đề (quy mô, kỹ năng team, ràng buộc, kế hoạch tương lai)
- Output: `deliverables/02_design/{decision_id}.debate.md` (định dạng [`.claude/rules/output-formats.md`](../../rules/output-formats.md) §5)

## Quy tắc tối thiểu phải giữ
- Cấm AI phát biểu kết luận "bên nào tốt hơn"
- Lập luận của mỗi người ủng hộ phải ra đều tay, mỗi bên 3 điểm (để không bên nào bị mỏng)
- Nếu điều kiện tiền đề còn thiếu thì báo lại bằng "(cần xác nhận)", không lấp bằng suy đoán

Cách tiến hành 3 bước chi tiết: xem [`reference.md`](reference.md).
