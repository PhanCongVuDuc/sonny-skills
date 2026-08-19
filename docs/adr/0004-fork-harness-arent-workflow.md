# Fork harness arent-workflow thành kho lưu trữ tiếng Việt, không phải plugin chạy được

`sonny-flow/` chứa bản sao 108 file của harness phát triển bằng AI mà plugin `arent-workflow` đã
inject vào `ArentInc/architecture_routing` (commit `eaf0c2953d`), đã dịch toàn bộ sang tiếng Việt.
Nó là **kho lưu trữ để đọc**, cố ý chưa chạy được.

Harness này không phải một bộ skill rời. Nó là pipeline 5 phase — `/setup` → `/req` → `/spec` →
`/design` → `/implement` → `/test` → `/review` → `/handoff` — với 17 agent, 13 command, 12 rule,
14 skill, và một khung `deliverables/` 8 thư mục. Ý tưởng cốt lõi nằm ở [gates.md](../../sonny-flow/.claude/rules/gates.md):
*không lấy câu "xong rồi" bằng ngôn ngữ tự nhiên của AI làm căn cứ để đi tiếp* — mỗi phase chỉ qua
được khi có file JSON/Markdown đúng schema trong `deliverables/`.

## Ba quyết định

**Nguồn là bản inject, không phải plugin gốc.** [rules/README.md](../../sonny-flow/.claude/rules/README.md)
nói rõ nguồn chuẩn nằm ở `templates/inject/claude/rules/` của plugin `arent-workflow`, cập nhật bằng
`/arent-workflow:re-setup` với so sánh 3 chiều bảo vệ phần sửa tay. Plugin đó **không có trên máy
này** — chỉ có 2 file HTML hướng dẫn trong `Workspace/Arent/`. Nên đây là fork một snapshot
downstream: không còn đường merge ngược lên upstream. Đường cập nhật duy nhất là chạy lại
`/arent-workflow:re-setup` bên repo kia rồi copy lại và dịch lại.

**Mirror nguyên cây `.claude/`, không dùng bố cục plugin.** Plugin Claude Code chỉ tự nạp
`agents/` `commands/` `skills/` `hooks/` ở gốc plugin. Nhưng file nguồn tham chiếu chéo bằng đường
dẫn tương đối — ví dụ [implementer.md](../../sonny-flow/.claude/agents/implementer.md) trỏ
`../../docs/domain/generated/code_map.md`. Đặt agent ở `sonny-flow/agents/` sẽ làm mọi link đó lệch
một cấp. Đặt ở `sonny-flow/.claude/agents/` thì link phân giải đúng, đổi lại plugin nạp được **con
số không**. Đã chọn tính đúng đắn của link, vì mục tiêu trước mắt là *giữ đúng bản gốc*, chưa phải
*chạy được*. `plugin.json` chỉ để giữ chỗ.

**Đăng ký marketplace nhưng không đưa vào `skills.json`.** 14 skill này giả định có `deliverables/`,
`docs/domain/generated/`, và quy trình nhận thầu SIer. Đưa vào `skills.json` là để `/setup-skills`
cài chúng lên mọi máy, khiến 17 agent và 14 skill nói về design doc SIer nhảy vào context của mọi
repo không liên quan. Cần thì cài tay bằng `/plugin install sonny-flow@sonny-skills`.

## Consequences

- **Không push.** Repo `sonny-skills` là public trên GitHub; harness này nhắc đích danh
  `ArentInc/architecture_routing`, quy trình nội bộ, và `deliverables/00_setup/*.json` chứa kết quả
  phân tích codebase thật của công ty. Nhánh `feat/sonny-flow` chỉ commit local cho tới khi có
  quyết định về việc scrub.
- Bố cục hiện tại là bản *đúng*, chưa phải bản *dùng được*. Bước sau — tách cái nào giữ, cái nào
  xoá, cái nào move sang project khác, và gỡ bỏ hoàn toàn phần đặc thù Arent — sẽ cần đổi bố cục
  sang plugin-native và sửa lại toàn bộ đường dẫn tương đối.
- Nội dung vẫn gắn chặt vào Revit add-in, C#, MVVM/DI, SonarQube, và quy trình SIer. Đó là fidelity
  có chủ đích, không phải sót.
- Có `sonny-flow/CLAUDE.md` và `sonny-flow/AGENTS.md`. Claude Code **sẽ nạp** chúng khi làm việc
  bên trong `sonny-flow/`. Chấp nhận vì chúng mô tả chính harness này.
- `sonny-flow/.gitignore` có hiệu lực thật trên cây con đó. Đã kiểm: nó không nuốt file nào trong
  108 file, vì các thư mục nó ignore hiện chỉ chứa `.gitkeep`. Thêm file vào `deliverables/` sau
  này thì phải kiểm lại.

## Quy ước dịch

Giữ nguyên tiếng Anh mọi thứ là định danh trong hệ thống: tên file, tên agent, khoá JSON, khoá
perspective, và các thuật ngữ `gate`, `deliverable`, `handoff`, `devil's advocate`, `business rule`,
`assumption`, `transaction boundary`, `idempotent`, `SIer`. Frontmatter `name` giữ nguyên,
`description` chuyển sang **tiếng Anh** vì đó là trigger để Claude định tuyến skill. Thân bài sang
tiếng Việt.

Đổi có chủ đích: placeholder `{観点}` → `{perspective}`; marker trong code `（推測）` → `(suy đoán)`,
`（要確認）` → `(cần xác nhận)`; enum `verdict` sang tiếng Việt và dùng nhất quán trên toàn harness.
Trong JSON chỉ dịch value dạng prose — khoá, path, hash, version, số liệu giữ nguyên tuyệt đối.
