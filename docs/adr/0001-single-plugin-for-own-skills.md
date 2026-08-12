# Mọi skill tự viết nằm trong một plugin duy nhất

Marketplace `duc-skills` ship đúng **một** plugin own tên `duc`, không tách theo domain — dù
`revit-skills` (nguồn tham khảo gần nhất) tách 34 skill của họ thành 7 plugin.

Lý do: giá trị thật của việc tách plugin là **bật/tắt theo dự án** — không ai muốn 34 skill Revit
nạp vào context khi đang viết tài liệu. Skill cá nhân thì hầu như luôn muốn bật, nên tách chỉ
thêm chi phí quản lý mà không đổi lại được gì.

## Consequences

Tên plugin là namespace của skill (`duc:hello-skill`), nên đảo quyết định này về sau là **đổi
namespace**: phải gỡ và cài lại plugin, sửa `enabledPlugins` trong `settings.json`, và mọi ghi
chú `duc:*` cũ đều sai. Nếu một ngày kho skill phình ra và xuất hiện nhóm rõ ràng chỉ dùng cho
một loại dự án, đó là tín hiệu xem lại quyết định này — chứ không phải số lượng skill.
