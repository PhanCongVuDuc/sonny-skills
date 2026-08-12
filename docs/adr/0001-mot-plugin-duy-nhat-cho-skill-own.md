# Mọi skill tự viết nằm trong một plugin duy nhất

Marketplace `sonny-skills` ship đúng **một** plugin own tên `sonny`, không tách theo domain — dù
`revit-skills` (nguồn tham khảo gần nhất) tách 34 skill của họ thành 7 plugin.

Giá trị thật của việc tách plugin là **bật/tắt theo dự án** — không ai muốn 34 skill Revit nạp
vào context khi đang viết tài liệu. Skill cá nhân thì hầu như luôn muốn bật, nên tách chỉ thêm
chi phí quản lý mà không đổi lại được gì.

## Consequences

Tên plugin là namespace của skill (`sonny:review-drawing`), nên đảo quyết định này về sau là
**đổi namespace**: phải gỡ và cài lại plugin, sửa `enabledPlugins` trong `settings.json`, và mọi
ghi chú `sonny:*` cũ đều sai. Trường `renames` trong `marketplace.json` đỡ được phần nào nhưng
không đỡ được ghi chú.

Tín hiệu xem lại quyết định này là **xuất hiện một nhóm skill chỉ dùng cho một loại dự án** —
không phải số lượng skill.

`sonny/.claude-plugin/plugin.json` cố tình **không khai `version`**. Khi thiếu, Claude lấy commit
SHA làm version, nên `git commit` xong là `claude plugin update` thấy ngay bản mới — không phải
nhớ bump số tay. Đổi lại, `claude plugin validate` sẽ luôn cảnh báo "No version specified"; đó là
cảnh báo đã biết, không phải lỗi.
