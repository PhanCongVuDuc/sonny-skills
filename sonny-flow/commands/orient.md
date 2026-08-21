---
description: Step 0 of the feature flow. Build an accurate picture of the code a feature will touch, reading project docs then graphify then codegraph, and report the four things that must be known before any spec is written.
argument-hint: <Feature> [mô tả ngắn việc cần làm]
---

**Bước 0/6 — orient.** Hiểu code trước khi viết chữ nào.

Dùng skill [`orient`](../skills/orient/SKILL.md). Đọc theo đúng thứ tự trong đó: `docs/` → graphify →
codegraph. Không đảo thứ tự, không bỏ nguồn đầu tiên (`docs/`) để nhảy thẳng vào code.

## Đầu ra

Trả lời **4 câu** của gate **G0** ([`rules/gates.md`](../rules/gates.md)). Câu nào chưa trả lời được thì
tìm tiếp — **không đoán**, và nói thẳng là chưa biết nếu vẫn không tìm ra:

1. Chạm layer nào — và rơi vào tầng test tự chạy được hay tầng cần môi trường đặc biệt
2. Ai gọi vào — kể cả hop mà graph không thấy (DI generic, binding UI)
3. Pattern nào đang có để noi theo — không có thì nói là không có
4. Test hiện tại phủ gì — file nào, cần gì để chạy, lệnh gì

Kèm: mọi chỗ **doc mâu thuẫn code** phát hiện được. Đó là phát hiện, không phải nhiễu — nêu ra, đừng tự
chọn tin bên nào.

Không ghi gì vào `docs/features/` ở bước này. Đây là bước đọc.

## Tiếp theo

`/sonny-flow:grill <Feature>` — hoặc `/sonny-flow:feature <Feature>` để chạy tiếp tới gate gần nhất.
