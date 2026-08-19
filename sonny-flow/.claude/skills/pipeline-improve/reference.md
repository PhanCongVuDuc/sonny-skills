# pipeline-improve ─ thủ tục chi tiết

## Thủ tục
1. Gom log đầu vào:
   - Các mục `verdict: có vấn đề` trong `deliverables/reviews/*.json`
   - Các mục `risk: high` trong `assumptions` của `deliverables/03_implementation/*.report.json`
   - Những chỗ người sửa lại (nếu có phần diff bị sửa sau khi code thì thu thập bằng git diff)
2. Phân loại thất bại theo category (dùng khoá trong [`.claude/rules/risk-categories.md`](../../rules/risk-categories.md))
3. Rút ra 3 category đứng đầu, rồi phân tích từng cái:
   - Vì sao category đó lại nhiều
   - Rule của agent nào là nguyên nhân
   - Phương án sửa rule (Before → After)
4. Nói rõ **những thất bại mà việc sửa rule này không phủ được**
5. Đề xuất **các rule ứng viên nên bỏ đi hoặc gộp lại**

## Định dạng output

```markdown
# Phân tích cải thiện pipeline ({năm tháng})

## Category thất bại nhiều nhất (3 hạng đầu)
1. Tên category - số lượng - nguyên nhân chính
2. ...

## Rule cần sửa
| Đối tượng | Before | After |
|---|---|---|
| .claude/agents/implementer.md | ... | ... |

## Thất bại mà việc sửa rule này không phủ được
- (Những cái vẫn cần người review xử lý tiếp)

## Rule ứng viên bỏ đi / gộp lại
- (Phương án dọn dẹp các rule đang tăng quá nhiều)
```

## Quy tắc chi tiết phải giữ
- Bắt buộc đi tìm cả "rule có thể bỏ đi" (chỉ toàn thêm mới thì rule sẽ phình lên)
- Phương án sửa rule phải ra bằng **câu chữ cụ thể** (cấm diễn đạt trừu tượng kiểu "cần chú ý")
- **Trước khi sửa trực tiếp** `.claude/agents/*.md` dựa trên kết quả của skill này, bắt buộc phải có người duyệt
- Đọc các báo cáo cũ (`pipeline-improve-{YYYY-MM}.md`) để kiểm tra xem có đang lặp lại đúng phương án cải thiện đó không
- Cân nhắc cả **độ nặng của ảnh hưởng** chứ không chỉ số lượng thất bại (1 mục high-impact được ưu tiên hơn 5 mục low-impact)
