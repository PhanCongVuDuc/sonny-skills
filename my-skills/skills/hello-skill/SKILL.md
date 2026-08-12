---
name: hello-skill
description: Skill mau de kiem tra local marketplace hoat dong. Use when the user says "hello-skill", "test skill", or wants to verify the my-skills marketplace is wired up correctly.
---

# hello-skill

Skill mẫu chứng minh local marketplace `my-skills` đã kết nối đúng.

Khi được gọi, hãy làm đúng các bước sau:

1. Trả lời bằng tiếng Việt: **"✅ my-skills marketplace hoạt động — skill `my-skills:hello-skill` đã được nạp."**
2. In ra đường dẫn file skill này để người dùng biết nguồn:
   `C:\Users\ADMIN\Desktop\Workspace\Skills\my-skills\skills\hello-skill\SKILL.md`
3. Nhắc người dùng: sau khi sửa bất kỳ skill nào trong `my-skills`, phải chạy
   `/plugin marketplace update my-skills` thì thay đổi mới có hiệu lực (do plugin bị cache-copy).

Đây là khuôn mẫu — copy thư mục này thành `<ten-skill-moi>/SKILL.md` để viết skill mới.
