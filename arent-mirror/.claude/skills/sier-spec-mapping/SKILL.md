---
name: sier-spec-mapping
description: Map a design doc received from an SIer into an implementable derived spec. Used at the Phase 1 entry point when /setup answered "design doc available".
---

# sier-spec-mapping

## Khi nào dùng
- Khi bắt đầu code từ design doc nhận từ bên ngoài như SIer (cửa vào Phase 1 khi trả lời "có design doc" ở Q3 của /setup)
- Khi không thể đưa thẳng design doc nhận được cho implementer (vì độ mịn, vì mâu thuẫn, vì chỗ chưa định nghĩa)

## Input / output
- Input: design doc nhận được (vị trí xem section "Bố trí Input" trong CLAUDE.md)
- Output:
  - `deliverables/01_requirements/{feature}.derived-spec.md`: derived spec (input cho implementer)
  - `deliverables/01_requirements/{feature}.sier-readout.json`: danh sách mâu thuẫn, chỗ chưa định nghĩa
  - `deliverables/01_requirements/{feature}.uncertainty.json`: báo cáo các chỗ suy đoán

## Quy tắc tối thiểu phải giữ
- **Không tóm tắt, không diễn đạt lại** design doc nhận được. Chỉ rút thông tin cần cho việc code
- Không "tự giác" thêm những xử lý không có trong design doc
- Mâu thuẫn và chỗ chưa định nghĩa thì không đưa vào derived spec (dồn vào `issues`)
- Bắt buộc đi qua **human gate ①'**. Giải quyết xong `issues` rồi mới sang implementer
- Bắt buộc ghi rõ phiên bản của design doc nhận được ở đầu `derived-spec.md`

Chi tiết các perspective cần rút: xem [`reference.md`](reference.md).
