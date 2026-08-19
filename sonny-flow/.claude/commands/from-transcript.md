---
description: Extract use cases and user stories from a meeting transcript (vtt/srt/txt). Use as the Phase 1 entry point when /setup Q4 answered "transcript available". Long files are processed chapter by chapter.
---

Dùng làm cửa vào Phase 1 khi bạn trả lời "có transcript" ở Q4 của `/setup`. Bắt đầu Phase 1 từ file transcript.

Cách tiến hành:

1. **Xác nhận input**: xem mục bố trí Input trong CLAUDE.md để biết chỗ đặt "file transcript"
2. Khởi động agent [`transcript-extractor`](../agents/transcript-extractor.md) (dùng skill [`transcript-to-usecase`](../skills/transcript-to-usecase/SKILL.md))
   - File lớn thì chia theo chương/chủ đề để xử lý
   - Output:
     - `deliverables/01_requirements/{feature}.from-transcript.md`
     - `deliverables/01_requirements/{feature}.transcript-refs.json` (tham chiếu tới số dòng trong file gốc)
3. Chạy tiếp [`uncertainty-auditor`](../agents/uncertainty-auditor.md)
4. **Human review**: chỉ dựa vào transcript thì thường chưa chốt được requirement. Chạy tiếp `/req` để `requirements-organizer` phỏng vấn, bù vào phần còn thiếu
5. Sau đó dùng `/spec` để sang bước dựng bản nháp spec

**Quan trọng:** transcript có chứa chỗ người nói lỡ lời, nhớ nhầm, hoặc lược bỏ tiền đề. **Không được chốt requirement chỉ bằng nội dung transcript.** Luôn phải bổ sung bằng phỏng vấn người thật.

Tham số (tuỳ chọn): truyền tên feature vào `$ARGUMENTS`.
