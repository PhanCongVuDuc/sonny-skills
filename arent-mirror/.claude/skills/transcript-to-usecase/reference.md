# transcript-to-usecase ─ thủ tục chi tiết

## Thủ tục
1. Xem mục bố trí Input trong CLAUDE.md để biết "chỗ đặt file transcript"
2. Đọc file mục tiêu. **Trên 5000 dòng / trên 100KB thì chia theo chương/chủ đề** rồi mới xử lý
3. Rút các thứ sau ở từng chương:
   - Use case ứng viên (các câu kiểu "muốn –", "cần phải – được")
   - User story (As a / I want / So that)
   - Business rule ứng viên (các câu kiểu "trường hợp này thì xử lý thế này", "cái này bắt buộc")
   - Điểm chưa chốt (kiểu "cái này chưa quyết", "để sau tính")
   - Điểm mâu thuẫn (chỗ nhiều phát biểu lệch nhau)
4. Mọi mục rút ra **bắt buộc kèm tham chiếu số dòng của file gốc** (`source: inputs/transcripts/xxx.vtt:L120-180`)
5. Ghép kết quả từng chương lại thành output cuối cùng
6. Rút xong thì dùng [`uncertainty-report`](../uncertainty-report/SKILL.md) để xuất các chỗ suy đoán ra file riêng

## Gợi ý về việc chia chương

Tiêu chí chia transcript (chọn cho hợp project):
- Theo thời gian: mỗi 30 phút (phỏng vấn 1 tiếng → 2 chương)
- Theo chủ đề: cắt ở chỗ đổi đề tài
- Theo người nói: cắt ở chỗ đổi lượt hỏi đáp

Chia đều một cách máy móc cũng được. Ưu tiên cao nhất là **đừng cố nhồi tất cả vào 1 context**.

## Cấu trúc Markdown output

```markdown
# Kết quả rút từ transcript của {feature}

## Use case ứng viên
- UC1: ... (source: xxx.vtt:L120-130)

## User story ứng viên
- US1: As a ..., I want ..., so that ... (source: xxx.vtt:L200-215)

## Business rule ứng viên
- R1: ... (source: xxx.vtt:L300-310)

## Điểm chưa chốt
- TBD1: ... (source: xxx.vtt:L450)

## Điểm mâu thuẫn
- Conflict1: lệch với phát biểu A (source: A=L100, B=L350)

## Tán gẫu, lạc đề (tham khảo)
- ...
```

## Quy tắc chi tiết phải giữ
- **Không tự bù thêm cách diễn giải phát biểu**. Giữ nguyên theo phát biểu, chỗ nào cần bù thì gắn `(suy đoán)`
- Không đưa tên người nói, tên cá nhân vào (thay bằng tên vai trò "PM", "người phụ trách nghiệp vụ", v.v.)
- Phần tán gẫu, lạc đề thì chỉ ghi vào `out_of_scope`, không đưa vào phần rút chính
- Chia chương một cách máy móc cũng được (cắt theo khung giờ, v.v.). **Đừng cố nhồi tất cả vào 1 context**
- Rút xong bắt buộc bổ sung bằng buổi phỏng vấn người thật của `requirements-organizer` (không chốt requirement chỉ bằng transcript)
