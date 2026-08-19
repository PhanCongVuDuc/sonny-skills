---
name: transcript-to-usecase
description: Extract use cases, user stories and candidate business rules from a meeting transcript (vtt etc.). Long files are split and processed chapter by chapter.
---

# transcript-to-usecase

## Khi nào dùng
- Khi cần dựng requirement từ bản ghi lời (vtt/srt/txt) của buổi họp phỏng vấn
- Làm phương án thay thế khi không thể phỏng vấn bằng skill `usecase-interview`

## Input / output
- Input: file transcript (vị trí xem section "Bố trí Input" trong CLAUDE.md)
- Output:
  - `deliverables/01_requirements/{feature}.from-transcript.md`
  - `deliverables/01_requirements/{feature}.transcript-refs.json` (ánh xạ số dòng)
  - `deliverables/01_requirements/{feature}.uncertainty.json`

## Quy tắc tối thiểu phải giữ
- File trên 5000 dòng / trên 100KB thì **chia theo chương/chủ đề** rồi mới xử lý (không nạp toàn bộ một lần)
- Không tự bù thêm cách diễn giải phát biểu. Giữ nguyên theo phát biểu, chỗ nào cần bù thì gắn `(suy đoán)`
- Không đưa tên người nói, tên cá nhân vào (thay bằng tên vai trò "PM", "người phụ trách nghiệp vụ", v.v.)
- Rút xong bắt buộc bổ sung bằng buổi phỏng vấn người thật của `requirements-organizer` (không chốt requirement chỉ bằng transcript)

Perspective cần rút và cách chia chương: xem [`reference.md`](reference.md).
