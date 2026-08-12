# drafts/

Skill đang viết dở. Thư mục này **nằm ngoài plugin `duc`** nên Claude không nạp gì ở đây — viết
dở bao nhiêu cũng không tốn context và không tự kích hoạt nhầm.

Một skill nháp chỉ được chuyển sang `duc/skills/` khi đủ **cả ba**:

1. `description` có trigger tiếng Anh cụ thể — nêu rõ *khi nào* dùng, không chỉ *là gì*.
2. `SKILL.md` ≤ 200 dòng. Dài hơn thì tách phần chi tiết sang `references/`.
3. **Đã chạy thật ít nhất một lần và cho kết quả đúng.** Skill chưa từng kích hoạt thì
   `description` của nó mới chỉ là giả thuyết.

Dùng `mattpocock-skills:writing-for-agents` khi viết; ba điều trên là cổng cuối, không phải
hướng dẫn viết.
