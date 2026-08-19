# Rule thiết kế agent (agent-rules)

Các rule thiết kế mà định nghĩa subagent trong `.claude/agents/`, cùng những skill và command gọi chúng, phải giữ.
Dùng khi thêm mới hoặc tách agent, và làm tiêu chí phán đoán cho lần review định kỳ (`pipeline-improve`).

---

## Nguyên tắc nền

1. **1 agent = 1 trách nhiệm, 1 perspective**. Nhóm review thì nghiêm ngặt "1 lần gọi 1 perspective", có nhận ra vấn đề ngoài perspective cũng bỏ qua (xử lý ở lần gọi khác).
2. **Output phải có cấu trúc**. Định dạng deliverable của từng agent tuân theo [`.claude/rules/output-formats.md`](../.claude/rules/output-formats.md) (§1–§9). Không lấy câu "xong rồi" bằng ngôn ngữ tự nhiên làm căn cứ để đi tiếp.
3. **Khoá perspective và risk category dùng định nghĩa chung**. Không tự phát minh category riêng, mà dùng khoá trong [`.claude/rules/risk-categories.md`](../.claude/rules/risk-categories.md).
4. **Không giấu suy đoán**. Điểm nào chưa có bằng chứng chắc chắn thì bắt buộc khai báo bằng `(suy đoán)` / `uncertainty` / phân loại ABCD ([`output-formats.md`](../.claude/rules/output-formats.md) §3).
5. **Chuyển phase là human gate**. Agent chỉ làm tới mức lọc ra "những mục người cần kiểm tra". Quyết định duyệt là của người ([`.claude/rules/gates.md`](../.claude/rules/gates.md)).

---

## Tiêu chí tách agent

| Khi nào nên tách | Ví dụ |
|---|---|
| Perspective tăng lên khiến trách nhiệm của 1 agent phình ra | Song song hoá review implementation theo từng perspective (transaction boundary / độ chính xác số / hiệu năng…) |
| "Sinh ra" và "kiểm chứng" đang bị trộn lẫn | Tách `implementer` (sinh ra) và `implementation-reviewer` (kiểm chứng) |
| "Phân tích" và "tổng hợp" đang bị trộn lẫn | Tách `legacy-analyzer` (phân tích 1 region) và `analysis-aggregator` (đối chiếu) |
| Muốn chạy nhiều lần trong các session độc lập | Parallel analysis (cùng 1 region 2 lần) → đối chiếu |

Nếu agent tăng quá nhiều thì dùng `pipeline-improve` để cân nhắc **các ứng viên bỏ đi hoặc gộp lại** (chống phình).

---

## Quy ước frontmatter

```yaml
---
name: <kebab-case. Khớp với tên file>
description: mô tả ngôi thứ ba, đủ để người ngoài phán đoán khi nào nên khởi động
model: sonnet | opus | haiku    # nhóm review cần cẩn trọng thì dùng opus cũng được
tools: Read, Grep, Glob, ...    # tối thiểu cần thiết. Nhóm phân tích thì thu về chỉ đọc
---
```

- `name` bắt buộc khớp với tên file (không tính phần mở rộng).
- Nhóm phân tích và review không kèm việc sửa code nên không gắn `Write`/`Edit` (chỉ đọc).

---

## Chu kỳ review định kỳ

- **3 tháng một lần**, dùng skill `pipeline-improve` để phân tích "những chỗ người đã sửa và lý do", rồi ra phương án cải thiện rule / agent / pipeline dưới dạng Before/After ([`output-formats.md`](../.claude/rules/output-formats.md) §7).
- Phương án cải thiện phải ra bằng **câu chữ cụ thể có thể dán thẳng vào**, và việc phản ánh vào `.claude/rules/*.md` hay `.claude/agents/*.md` thì làm **sau khi có người duyệt** (agent không tự ghi thẳng vào).
- Để rule không phình lên vì chỉ toàn thêm mới, **bắt buộc đi tìm cả rule và agent có thể bỏ đi**.
