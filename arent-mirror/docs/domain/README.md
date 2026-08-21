# docs/domain — tài liệu tri thức domain

Thư mục này là nơi chứa tri thức domain mà `/arent-workflow:setup` đã inject vào project.
Đây là **bản chính thống mà AI tham chiếu làm căn cứ khi code và thiết kế**; nơi gom lại những tri thức nghiệp vụ, bối cảnh lựa chọn công nghệ, và thuật ngữ mà đọc code không suy ra được.

> Cách vận hành cũ là copy tay `docs/domain-template/` (`cp -r`) đã bị bỏ.
> `/arent-workflow:setup` của plugin sẽ inject khung mẫu, còn `/arent-workflow:onboarding` sẽ đề xuất nội dung ban đầu.

## Cấu trúc 3 tầng (mô hình sở hữu)

```
docs/domain/
├── business_rules.md   ← 【tầng bất biến】người có chuyên môn nghiệp vụ quản lý. AI chỉ đọc (muốn đề xuất thì phải được người duyệt trước)
├── tech_stack.md       ← 【tầng bất biến】căn cứ của việc chọn công nghệ. AI chỉ đọc
├── glossary.md         ← 【tầng bất biến】định nghĩa thuật ngữ. AI chỉ đọc
├── known_patterns.md   ← 【tầng bán cố định】tập hợp pattern. AI đề xuất, người duyệt rồi mới ghi lại
└── generated/          ← 【tầng sinh tự động】agent docs-keeper tự động cập nhật
    ├── code_map.md
    ├── dependencies.md
    └── module_index.md
```

| File | Công dụng | Người quản lý |
|---|---|---|
| `business_rules.md` | Business rule (ràng buộc bất biến, công thức tính, chuyển trạng thái, ngoại lệ, quy định pháp lý, luồng duyệt) | Người (chuyên môn nghiệp vụ) |
| `tech_stack.md` | Công nghệ đang dùng, phiên bản, lý do chọn | Người (chuyên môn kỹ thuật) |
| `glossary.md` | Từ điển thuật ngữ (thuật ngữ ngành, từ viết tắt nội bộ, ánh xạ sang từ vựng trong code) | Người (chuyên môn + developer) |
| `known_patterns.md` | Ví dụ thực tế của pattern thiết kế và quy ước code | AI đề xuất → người duyệt |
| `generated/*.md` | Bản đồ code, quan hệ phụ thuộc, danh sách API công khai | Agent `docs-keeper` (tự động) |

## Phối hợp với plugin arent-workflow

- Agent `docs-keeper` phát hiện thay đổi code rồi tự động cập nhật 3 file trong `generated/` (không đụng business rule = do người quản lý).
- `.claude/rules/domain-knowledge.md` nhắc Claude tham chiếu `business_rules.md` khi sửa `src/**` v.v. Khi code và tài liệu mâu thuẫn thì **lấy tài liệu làm chuẩn**, và đề xuất phần khác biệt cho người.
- `/arent-workflow:onboarding existing` phân tích code có sẵn lúc setup lần đầu, sinh ra `generated/` và **đề xuất** phần bổ sung cho `business_rules.md` / `known_patterns.md` (không tự động phản ánh).
- Muốn sinh lại bằng CI hoặc bằng tay thì chạy `scripts/update-ai-docs.sh force` (hoặc `.ps1 force`).

## Rule chỉnh sửa

- Tầng bất biến (business_rules / tech_stack / glossary) là **do người viết**. AI chỉ đọc, không tự ý ghi đè.
- Tầng bán cố định (known_patterns) thì AI đề xuất ứng viên, chỉ ghi lại những gì người đã duyệt.
- Tầng sinh tự động (generated/) thì **không sửa tay** (sẽ bị ghi đè ở lần cập nhật tự động sau).
