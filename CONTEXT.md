# sonny-skills

Kho quản lý Agent Skill cho Claude Code của Duc Phan (Sonny). Khai báo bộ skill mong muốn ở một
chỗ, dựng lại được trên bất kỳ máy nào bằng một lệnh.

## Language

### Hai thứ đừng lẫn

**Bộ skill mong muốn**:
Danh sách skill mà Duc muốn có trên mọi máy. Sống trong `skills.json`. Đây là **ý định**.
_Avoid_: "skill đã cài" — đó là thứ khác.

**Trạng thái máy**:
Bộ skill thực sự đang nằm trên một máy cụ thể. Sống trong `~/.claude/`. `SKILLS.md` là ảnh chụp
của nó. Đây là **thực tế**.

Setup là hành động kéo *trạng thái máy* về khớp với *bộ skill mong muốn*. Hai thứ lệch nhau là
chuyện bình thường — chưa setup, hoặc vừa cài tay thứ gì đó để thử.

### Phân phối

**Marketplace**:
Một repo có `.claude-plugin/marketplace.json` ở gốc, liệt kê các plugin. Khi được thêm vào máy,
Claude clone **toàn bộ** repo về `~/.claude/plugins/marketplaces/` — nên đọc được mã nguồn skill.
Đây là lý do marketplace là tầng ưu tiên.

**Plugin**:
Đơn vị cài/gỡ/bật/tắt, và là **namespace** của skill — skill hiện ra dưới dạng `<plugin>:<skill>`.
Kho này ship đúng một plugin own tên `sonny`.
_Avoid_: package, bundle.

**Skill**:
Một thư mục chứa `SKILL.md`. `description` trong frontmatter là thứ Claude đọc để quyết định có
gọi skill hay không — nó là *trigger*, không phải lời giới thiệu.

**Tầng phân phối**:
Đường một skill đi vào máy. Đúng ba tầng, ưu tiên từ trên xuống: **marketplace** (mặc định) →
**vercel** (repo không có marketplace, cài bằng `npx skills`) → **reference** (chỉ clone về để
đọc, không cài).

**Cache-copy**:
Bản sao snapshot của plugin mà Claude tạo trong `~/.claude/plugins/cache/` khi cài. Plugin chạy
từ bản sao này, **không** đọc live từ nguồn.

### Máy

**Máy viết**:
Máy đang soạn skill own. Marketplace `sonny-skills` trỏ vào thư mục repo local, nên sửa xong là
có hiệu lực ngay, không cần push.

**Máy dùng**:
Máy chỉ xài skill. Marketplace trỏ vào GitHub; thư mục repo là thứ vứt đi được sau khi setup.
Đây là mặc định.

### Skill own

**Own**:
Skill do Duc viết, sống trong `sonny/skills/`, và chịu trách nhiệm bảo trì.

**Fork**:
Skill bắt nguồn từ người khác nhưng đã bị sửa. Về mọi mặt vận hành nó **là own** — chỉ khác ở
chỗ ghi credit nguồn gốc trong `SKILL.md`. Không có thư mục riêng cho fork.
_Avoid_: vendored, patched.

**Draft**:
Skill đang viết dở, sống ở `drafts/` — nằm ngoài mọi plugin nên không được nạp vào context.
_Avoid_: in-progress, wip.

**Mirror**:
Bản sao trung thành của cây thư mục người khác, giữ nguyên bố cục nguồn kể cả khi bố cục đó khiến
Claude không nạp được gì. Khác *fork* ở chỗ fork đã bị sửa và **là own**; mirror thì chưa — nó là
bản *đúng*, chưa phải bản *dùng được*. Dịch sang tiếng Việt vẫn là mirror, vì cấu trúc không đổi.
Mirror **nằm ngoài mọi plugin** — giống *draft* ở điểm đó, nhưng vì lý do khác: draft chưa xong,
mirror thì không định chạy. Kho này có đúng một mirror: `arent-mirror/`.
Xem [[0004-fork-harness-arent-workflow]] (vì sao giữ nguyên bố cục nguồn) và
[[0005-bo-harness-giu-lai-y-gate]] (vì sao thôi ship nó thành plugin).
_Avoid_: vendored, snapshot, archive.
