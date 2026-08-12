---
name: setup-skills
description: Install and update every Claude Code skill listed in this repo's skills.json on the current machine. Use when the user says "setup-skills", sets up a new machine, or asks to update / reinstall / sync their skills.
---

# setup-skills

Đưa máy hiện tại về đúng bộ skill khai trong `skills.json`. Chạy được trên máy trống lẫn
máy đã cài — cùng một lệnh, bao nhiêu lần cũng được.

## Làm gì

1. Chạy `node scripts/setup.mjs` từ gốc repo. Nếu người dùng nói rằng đây là **máy để viết
   skill** (chứ không chỉ dùng), thêm cờ `--dev`.
2. Đọc output. Script tự in ✓ / · / ✗ cho từng việc, và tổng kết ở cuối.
3. Báo lại **bằng tiếng Việt**, ngắn gọn:
   - Máy đang ở chế độ nào (viết hay dùng).
   - Những gì vừa cài mới, những gì chỉ cập nhật.
   - Từng việc thất bại, kèm cách sửa (xem bảng dưới).
4. Nếu không có lỗi, nhắc người dùng chạy `/reload-plugins`.

Không tự ý sửa `skills.json`, `~/.claude/settings.json`, hay chạy `claude plugin ...` bằng tay.
Script là nơi duy nhất làm những việc đó — nếu nó chưa làm được gì, đó là bug của script,
sửa script chứ đừng làm thay.

## Chế độ máy

Script phân biệt hai loại máy, ghi nhớ bằng file `.sonny-dev` (gitignored) ở gốc repo:

| Chế độ | Kích hoạt | Marketplace `sonny-skills` trỏ vào | Dùng khi |
|---|---|---|---|
| **Dùng** | mặc định | GitHub | Máy chỉ xài skill. Xoá thư mục repo đi vẫn chạy. |
| **Viết** | `--dev` một lần | thư mục repo local | Máy đang viết skill. Sửa xong `plugin update` ăn ngay, không cần push. |

Đã đặt `--dev` một lần thì các lần sau chạy trần vẫn giữ chế độ viết. Gỡ bằng `--no-dev`.

## Khi có lỗi

| Triệu chứng | Nguyên nhân | Cách sửa |
|---|---|---|
| `claude: command not found` | Claude Code CLI không có trong PATH | Cài lại Claude Code, hoặc chạy script từ terminal đã có `claude` |
| `npx: command not found` | Chưa có Node/npm | Cài Node.js ≥ 18 |
| Marketplace add thất bại với repo private | Chưa đăng nhập GitHub | `gh auth login`, rồi chạy lại |
| Skill mới cài không xuất hiện | Plugin chỉ nạp lúc khởi động | `/reload-plugins`, hoặc khởi động lại Claude Code |
| Plugin `sonny` báo không có skill | Đúng — nó đang rỗng cho tới khi có skill đầu tiên | Không phải lỗi |

## Thêm skill mới vào bộ

Sửa `skills.json` rồi chạy lại skill này. Ba tầng, ưu tiên từ trên xuống:

- **`marketplaces`** — repo có `.claude-plugin/marketplace.json`. Đây là đường mặc định.
- **`vercel`** — repo không có marketplace, cài bằng `npx skills`.
- **`reference`** — chỉ clone về `~/.claude/reference/` để đọc, không cài.

Muốn xem trước mà không đổi gì: `node scripts/setup.mjs --dry-run`.
