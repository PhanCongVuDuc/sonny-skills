---
description: Step 3 of the feature flow. Break an approved contract into an ordered task checklist inside the feature doc, one concern per task, each naming the file it touches and the test it will get. Stops for human review.
argument-hint: <Feature>
---

**Bước 3/6 — plan.** Chẻ `## Contract` thành checklist trong `docs/features/{Feature}.md`.

## Vào bước này cần gì

File có `## Contract`. Không có thì dừng và bảo người dùng chạy `/sonny-flow:spec` trước — **đừng tự viết
Contract rồi tự chẻ nó ra**, như thế là tự bịa yêu cầu.

## Làm gì

Phần `## Plan` của skill [`feature-spec`](../skills/feature-spec/SKILL.md):

```markdown
## Plan

- [ ] <việc> — `path/to/file.ext` — phục vụ AC #<n> — test: <một dòng test sẽ viết>
```

Bốn luật:

- **Một mối quan tâm một task.** "Thêm field và validate và hiển thị lỗi" là ba task.
- **Nêu file.** Task không biết sẽ sửa file nào là task chưa nghĩ xong.
- **Mỗi task một dòng test.** Nghĩ không ra thì ghi `test: không có — <vì sao>`. Đừng ghi "kiểm bằng tay"
  cho đủ hình thức — ghi *không có* là thông tin, ghi "bằng tay" là che.
- **Thứ tự thi hành được.** Task sau không phụ thuộc thứ chưa tồn tại.

Task nào đòi đổi abstraction đang có thì **đánh dấu và hỏi**, đừng nhét vào giữa plan.

## Gate G3 — human gate

Làm ba việc rồi **kết thúc lượt**:

1. In `## Plan` ra
2. Nêu từng chỗ đã phải suy đoán, kèm câu hỏi cụ thể
3. Nói bước tiếp là `/sonny-flow:implement <Feature>`

**Không viết code, không tạo file source, không chạy build.** Việc người dùng gõ lệnh tiếp theo *chính là*
sự duyệt — nên đừng tự hỏi "làm tiếp nhé?" rồi tự trả lời trong cùng lượt.
