---
name: hello-skill
description: Verify the duc-skills marketplace is wired up and loading. Use when the user says "hello-skill", "test skill", or asks whether their own skills marketplace is working.
---

# hello-skill

Skill mẫu chứng minh marketplace `duc-skills` đã kết nối đúng. Đây cũng là **khuôn mẫu** — copy
thư mục này để viết skill mới.

Khi được gọi, làm đúng các bước sau:

1. Trả lời bằng tiếng Việt: **"✅ marketplace `duc-skills` hoạt động — skill `duc:hello-skill` đã được nạp."**
2. In đường dẫn nguồn để người dùng biết sửa ở đâu:
   `C:\Users\ADMIN\Desktop\Workspace\Skills\duc\skills\hello-skill\SKILL.md`
3. Nhắc: sau khi sửa bất kỳ skill nào trong `duc/`, phải chạy
   `/plugin marketplace update duc-skills` thì thay đổi mới có hiệu lực (plugin bị cache-copy,
   không đọc live từ nguồn).

## Quy ước khi copy thư mục này thành skill mới

- Tên thư mục = `name` trong frontmatter, kebab-case, **dạng động từ/gerund** (`review-drawing`,
  `writing-adr`), không thêm prefix cá nhân — namespace `duc:` đã làm việc đó.
- `description` viết **tiếng Anh** (đây là thứ Claude đọc để quyết định có gọi skill không),
  phần thân viết **tiếng Việt**.
- `SKILL.md` ≤ 200 dòng; chi tiết dài đẩy sang `references/*.md` để chỉ đọc khi cần.
- Viết dở thì để ở `drafts/`, không để trong `duc/skills/` — xem `drafts/README.md`.
