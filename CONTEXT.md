# Skills

Kho quản lý Agent Skill cho Claude Code trên máy của Duc Phan — skill tự viết lẫn skill bên
thứ 3, phân phối qua cơ chế plugin marketplace native của Claude Code.

## Language

### Hai trục độc lập

**Provenance**:
Ai là người viết ra một skill. Nhận đúng ba giá trị: **own**, **third-party**, **fork**.
_Avoid_: "skill của mình" / "skill ngoài" khi đang nói về đường phân phối.

**Distribution**:
Con đường một skill đi vào máy. Độc lập với provenance — skill own vẫn có thể phân phối
qua remote marketplace.
_Avoid_: dùng lẫn với provenance.

### Provenance

**Own**:
Skill do Duc Phan viết, sống trong `duc/skills/`, và chịu trách nhiệm bảo trì.

**Third-party**:
Skill người khác viết và bảo trì; kho này chỉ trỏ tới, không sửa.

**Fork**:
Skill bắt nguồn từ third-party nhưng đã bị sửa. Về mọi mặt vận hành nó **là own** — chỉ khác
ở chỗ ghi credit nguồn gốc trong `SKILL.md`. Không có thư mục riêng cho fork.
_Avoid_: vendored, patched.

### Distribution

**Marketplace**:
Một repo (hoặc thư mục) có `.claude-plugin/marketplace.json` ở gốc, liệt kê các plugin.
Đây là thứ `/plugin marketplace add` nhận vào.

**Plugin**:
Đơn vị cài đặt và bật/tắt, và là **namespace** của skill — skill hiện ra dưới dạng
`<plugin>:<skill>`. Kho này ship đúng một plugin own tên `duc`.
_Avoid_: package, bundle.

**Skill**:
Một thư mục chứa `SKILL.md`, nằm trong `skills/` của một plugin.

**Cache-copy**:
Bản sao snapshot của plugin mà Claude tạo trong `~/.claude/plugins/cache/` khi cài. Plugin
chạy từ bản sao này, **không** đọc live từ nguồn — nên sửa nguồn xong phải update mới có hiệu lực.

**Draft**:
Skill đang viết dở, sống ở `drafts/` — nằm ngoài mọi plugin nên không được nạp vào context.
_Avoid_: in-progress, wip.
