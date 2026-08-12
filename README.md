# Skills — quản lý Agent Skill cho Claude Code

Skill được quản lý bằng **plugin marketplace** (cơ chế native của Claude Code), KHÔNG dùng
Vercel `npx skills` CLI — CLI đó chỉ cài đúng skill được chỉ định nên bỏ sót skill phụ thuộc
(vd `grill-with-docs` cần `grilling`), còn marketplace lấy về cả repo.

Thuật ngữ dùng trong kho này: xem [CONTEXT.md](CONTEXT.md). Quyết định kiến trúc và lý do:
[docs/adr/](docs/adr/).

## Mô hình

Hai trục **độc lập** — đừng gộp:

- **Provenance** (ai viết): `own` · `third-party` · `fork` (fork = own có ghi credit).
- **Distribution** (đường vào máy): remote marketplace · marketplace của chính kho này.

Repo này **chính là** marketplace `duc-skills`, ship 2 plugin:

| Plugin | Provenance | Nguồn |
|---|---|---|
| `duc` | own | `./duc` trong repo này |
| `find-skills` | third-party | `git-subdir` → `vercel-labs/skills` (không clone về) |

```
Workspace/Skills/
├─ .claude-plugin/marketplace.json   # marketplace "duc-skills"
├─ duc/                              # ← DUY NHẤT phần được ship vào plugin cache
│  └─ skills/hello-skill/SKILL.md    #   → duc:hello-skill
├─ drafts/                           # skill viết dở — ngoài plugin nên KHÔNG bị nạp
├─ scripts/gen-skills.mjs            # sinh SKILLS.md
├─ bootstrap/settings.snippet.json   # dựng lại trên máy mới
├─ docs/adr/                         # 2 quyết định khó đảo
├─ CONTEXT.md                        # glossary
├─ README.md
└─ SKILLS.md                         # SINH RA — đừng sửa tay
```

Mọi thứ nằm ngoài `duc/` đều **không** vào plugin cache: `drafts/`, `docs/`, `scripts/` không
tốn context và không tự kích hoạt.

## Viết skill mới

1. Skill mới bắt đầu ở `drafts/`. Copy `duc/skills/hello-skill/` làm khuôn — nó ghi sẵn quy ước.
2. Quy ước: tên thư mục = `name` trong frontmatter, kebab-case, **dạng động từ/gerund**
   (`review-drawing`), **không** prefix cá nhân (namespace `duc:` đã làm việc đó), và không
   trùng tên với 71 skill đang có — xem [SKILLS.md](SKILLS.md).
3. `description` viết **tiếng Anh** (Claude đọc nó để quyết định có gọi skill không), thân viết
   **tiếng Việt**. `SKILL.md` ≤ 200 dòng, dài hơn thì tách sang `references/`.
4. Chuyển từ `drafts/` sang `duc/skills/` khi qua cổng 3 điểm ở [drafts/README.md](drafts/README.md).
5. `git commit` rồi `/plugin marketplace update duc-skills`.

> ⚠️ **Phải commit thì sửa đổi mới có hiệu lực.** Repo là git nên version của plugin `duc` chính
> là commit SHA. Sửa file mà chưa commit → SHA không đổi → cache không refresh. (Đây là lợi ích
> của việc `git init`: thời `my-skills` version là `unknown` nên thường phải uninstall + install
> lại mới nạp được thay đổi.)

## Cập nhật SKILLS.md

```bash
node scripts/gen-skills.mjs
```

Đọc `~/.claude/plugins/installed_plugins.json` nên không trôi khỏi thực tế. Không in timestamp —
chạy lại mà không có gì đổi thì diff rỗng.

## Dựng lại trên máy mới

Dán 2 key trong [bootstrap/settings.snippet.json](bootstrap/settings.snippet.json) vào
`~/.claude/settings.json` (merge, đừng ghi đè — file đó còn `model`, `effortLevel`, `tui` của máy).
Đây là **trạng thái khai báo**, không phải hướng dẫn gõ lệnh, nên nó không lỗi thời.

Riêng entry `duc-skills` đang trỏ `directory` vào đường dẫn của máy này. Sau khi push GitHub, đổi
thành nguồn remote thì mới thật sự portable:

```json
"duc-skills": { "source": { "source": "github", "repo": "<owner>/<repo>" }, "autoUpdate": true }
```

Lưu ý: `autoUpdate: true` chỉ hợp lý trên máy *dùng*. Trên máy *đang viết skill* thì giữ nguồn
`directory` để sửa xong là update được ngay, không phải push trước.

## Cheat-sheet `/plugin`

| Việc | Slash-command | CLI terminal |
|---|---|---|
| Thêm marketplace | `/plugin marketplace add <repo\|url\|path>` | `claude plugin marketplace add <...>` |
| Cập nhật marketplace | `/plugin marketplace update [tên]` | `claude plugin marketplace update [tên]` |
| Gỡ marketplace | `/plugin marketplace remove <tên>` | `claude plugin marketplace remove <tên>` |
| Cài plugin | `/plugin install <plugin>@<mp>` | `claude plugin install <plugin>@<mp>` |
| Liệt kê plugin | `/plugin` (UI) | `claude plugin list` |
| Bật / tắt | `/plugin enable`/`disable <plugin>@<mp>` | `claude plugin enable/disable <...>` |
| Gỡ plugin | — | `claude plugin uninstall <plugin>@<mp>` |

## Lưu ý

- **Plugin là cache-copy, không live.** Khi cài, Claude copy snapshot vào
  `~/.claude/plugins/cache/<mp>/<plugin>/<version>/`.
- **State nằm ở** `~/.claude/plugins/known_marketplaces.json`, `installed_plugins.json`, và
  `extraKnownMarketplaces` / `enabledPlugins` trong `settings.json`.
- Skill hiện ra dưới dạng `plugin:skill` — `duc:hello-skill`, `revit-api:revit-element-collector`.
- Skill mới chỉ xuất hiện sau khi **khởi động lại** Claude Code.
- Cursor: ngoài phạm vi.
