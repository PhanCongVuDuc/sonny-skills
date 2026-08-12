# Skills — quản lý Agent Skill cho Claude Code

Skill cho Claude Code được quản lý bằng **plugin marketplace** (cơ chế native của Claude Code),
KHÔNG dùng Vercel `npx skills` CLI. Lý do: một marketplace là **bản git clone đầy đủ cả repo**
nên lấy về **toàn bộ skill + các claude///skill phụ thuộc lẫn nhau** (tránh cảnh cài `grill-me` mà thiếu
`grilling`), và cập nhật bằng `git pull` qua `/plugin`, có thể bật `autoUpdate` để tự động.

## Mô hình

- **Skill bên thứ 3** → dùng **remote marketplace** (Claude tự clone vào
  `~/.claude/plugins/marketplaces/<tên>/`, tự cập nhật). Không gom repo vào folder này.
- **Skill tự viết** → nằm trong `my-skills/` (folder này) và đăng ký làm **local marketplace**.

```
Workspace/Skills/
├─ README.md                              # file này — manifest + cheat-sheet
├─ my-skills/                             # local marketplace: skill tự viết
│  ├─ .claude-plugin/marketplace.json     # khai báo marketplace "my-skills"
│  └─ skills/
│     └─ hello-skill/SKILL.md             # skill mẫu (copy để tạo skill mới)
└─ vendored/                              # repo clone của bên thứ 3 (không phải marketplace gốc)
   └─ vercel-skills/                      # git clone vercel-labs/skills + manifest tự thêm
      ├─ .claude-plugin/marketplace.json  # BẠN tự viết (repo gốc không có)
      └─ skills/find-skills/SKILL.md
```

## Marketplace đang subscribe (chạy lại trên máy mới)

Các lệnh này gõ trong phiên Claude Code (slash-command), hoặc dùng `claude plugin ...` ở terminal.

```
# Skill Revit + .NET (Nice3point) — 7 plugin
/plugin marketplace add https://github.com/Nice3point/revit-skills.git

# Skill của Matt Pocock — grilling, tdd, code-review, diagnosing-bugs... (35 skill)
/plugin marketplace add mattpocock/skills
/plugin install mattpocock-skills@mattpocock

# Skill tự viết (local)
/plugin marketplace add C:/Users/ADMIN/Desktop/Workspace/Skills/my-skills
/plugin install my-skills@my-skills

# find-skills (vendored: clone vercel-labs/skills + manifest tự thêm — xem mục Vendored bên dưới)
/plugin marketplace add C:/Users/ADMIN/Desktop/Workspace/Skills/vendored/vercel-skills
/plugin install find-skills@vercel-skills
```

Sau khi add remote marketplace, vào `/plugin` → tab **Marketplaces** bật **autoUpdate** để tự
cập nhật, hoặc set `"autoUpdate": true` cho marketplace đó trong `settings.json`.
(Đã bật autoUpdate cho `revit-skills` và `mattpocock`.)

## Nhà cung cấp đang có

| Marketplace | Nguồn | Loại | Skills | autoUpdate |
|---|---|---|---|---|
| `revit-skills` | github `Nice3point/revit-skills` | remote | 34 (7 plugin) | ✅ |
| `mattpocock` | github `mattpocock/skills` | remote | 35 (1 plugin) | ✅ |
| `my-skills` | local `my-skills/` | local (tự viết) | 1 | — |
| `vercel-skills` | vendored `vendored/vercel-skills/` | vendored | 1 | — (pull tay) |

**Tổng: 71 skill.** Danh sách chi tiết từng skill + mô tả: xem **[SKILLS.md](SKILLS.md)**.

## Vendored (repo bên thứ 3 KHÔNG phải marketplace)

Repo như `vercel-labs/skills` thiếu `.claude-plugin/marketplace.json` nên không add trực tiếp.
Cách dùng: clone vào `vendored/<tên>/` rồi TỰ thêm file manifest trỏ plugin vào skill.
Cập nhật (không tự động):
```
cd vendored/vercel-skills && git pull
claude plugin marketplace update vercel-skills
```
(Vì là git repo thật, version = commit SHA nên `update` nhận diện được thay đổi và refresh cache;
không cần uninstall/install tay như `my-skills`.)

## Cheat-sheet lệnh `/plugin` (hoặc `claude plugin ...`)

| Việc | Slash-command | CLI terminal |
|---|---|---|
| Thêm marketplace | `/plugin marketplace add <repo\|url\|path>` | `claude plugin marketplace add <...>` |
| Liệt kê marketplace | `/plugin marketplace list` | `claude plugin marketplace list` |
| Cập nhật marketplace | `/plugin marketplace update [tên]` | `claude plugin marketplace update [tên]` |
| Gỡ marketplace | `/plugin marketplace remove <tên>` | `claude plugin marketplace remove <tên>` |
| Cài plugin | `/plugin install <plugin>@<mp>` | `claude plugin install <plugin>@<mp>` |
| Liệt kê plugin đã cài | `/plugin` (UI) | `claude plugin list` |
| Bật / tắt plugin | `/plugin enable`/`disable <plugin>@<mp>` | `claude plugin enable/disable <...>` |
| Gỡ plugin | — | `claude plugin uninstall <plugin>@<mp>` |

## Viết skill mới trong `my-skills`

1. Copy `my-skills/skills/hello-skill/` thành `my-skills/skills/<ten-skill>/`.
2. Sửa `SKILL.md`: frontmatter `name` + `description` (mô tả rõ khi nào dùng — Claude dựa vào
   đây để tự gọi skill).
3. Chạy `/plugin marketplace update my-skills` để nạp thay đổi.

## Lưu ý quan trọng

- **Plugin bị cache-copy, KHÔNG live:** khi cài, Claude copy plugin thành snapshot vào
  `~/.claude/plugins/cache/<mp>/<plugin>/<ver>/`. Sửa file ở nguồn (kể cả `my-skills`) chưa có
  hiệu lực cho tới khi `/plugin marketplace update` + cài lại/update.
- **State lưu ở:** `~/.claude/plugins/known_marketplaces.json`, `installed_plugins.json`, và
  `enabledPlugins` trong `settings.json`.
- Skill trong plugin được đặt tên `plugin:skill` (vd `my-skills:hello-skill`,
  `revit-api:revit-element-collector`).
- Cursor: bỏ qua — quản lý riêng, không thuộc phạm vi setup này.
