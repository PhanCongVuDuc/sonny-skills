# sonny-skills

Bộ Agent Skill cho Claude Code của Duc Phan. Khai một chỗ, dựng lại được trên mọi máy bằng một
lệnh.

Thuật ngữ: [CONTEXT.md](CONTEXT.md). Quyết định kiến trúc và lý do: [docs/adr/](docs/adr/).
Ảnh chụp skill đang có trên máy này: [SKILLS.md](SKILLS.md) — sinh tự động, đừng sửa tay.

## Máy mới

```bash
git clone https://github.com/PhanCongVuDuc/sonny-skills.git
cd sonny-skills
claude
```

Rồi trong Claude Code gõ:

```
/setup-skills
```

Hết. Nếu đây là máy **viết** skill (chứ không chỉ dùng), nói thêm "máy này là máy viết" —
skill sẽ chạy với cờ `--dev`.

Chạy trần không cần Claude Code cũng được:

```bash
node scripts/setup.mjs            # áp dụng
node scripts/setup.mjs --dry-run  # xem trước, không đổi gì
node scripts/setup.mjs --dev      # đánh dấu đây là máy viết skill (nhớ luôn)
```

Idempotent — máy trống hay máy đã cài đều chạy được, gõ bao nhiêu lần cũng không sao.

## Ba tầng phân phối

Sửa [skills.json](skills.json) rồi chạy lại `/setup-skills`. Ưu tiên từ trên xuống:

| Tầng | Khi nào | Cơ chế | Skill nằm ở |
|---|---|---|---|
| `marketplaces` | Repo có `.claude-plugin/marketplace.json` | `claude plugin install` | `~/.claude/plugins/` |
| `vercel` | Repo **không** có marketplace | `npx skills add --copy` | `~/.claude/skills/` |
| `reference` | Chỉ muốn đọc, không cài | `git clone --depth 1` | `~/.claude/reference/` |

Tầng marketplace là mặc định vì Claude clone **cả repo** về `plugins/marketplaces/` — đọc được
mã nguồn skill, không chỉ chạy nó. Hai tầng dưới là ngoại lệ; đừng dùng khi tầng trên làm được.

> Hệ sinh thái đã chuẩn hoá quanh marketplace — `anthropics/skills`, `obra/superpowers`,
> `revit-skills` đều có sẵn manifest. Trước khi tụt xuống tầng `vercel`, kiểm tra lại đã.

Tầng `vercel` luôn dùng `--copy` thay vì symlink: symlink trên Windows đòi Developer Mode hoặc
quyền admin.

## Viết skill mới

1. Bắt đầu ở `drafts/`. Ba điều kiện để lên `sonny/skills/`: xem [drafts/README.md](drafts/README.md).
2. Tên thư mục = `name` trong frontmatter, kebab-case, **dạng động từ/gerund**
   (`review-drawing`), **không** prefix cá nhân — namespace `sonny:` đã làm việc đó.
3. `description` viết **tiếng Anh** (Claude đọc nó để quyết định có gọi skill không), thân viết
   **tiếng Việt**. `SKILL.md` ≤ 200 dòng, dài hơn thì tách sang `references/`.
4. Áp dụng thay đổi — **plugin là cache-copy, không đọc live từ nguồn**:

```bash
git commit -am "..."                     # version của plugin CHÍNH LÀ commit SHA
claude plugin update sonny@sonny-skills  # /plugin marketplace update KHÔNG thay được bước này
                                         # rồi /reload-plugins
```

> Hai cái bẫy đã kiểm chứng:
> **(a) Chưa commit thì không có gì đổi** — version plugin là commit SHA, sửa file mà chưa commit
> thì SHA không đổi nên cache giữ nguyên.
> **(b) `/plugin marketplace update` báo thành công nhưng plugin vẫn ở version cũ** — nó chỉ làm
> mới *marketplace*, nâng *plugin đã cài* là việc của `claude plugin update`.

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

- Skill mới chỉ xuất hiện sau `/reload-plugins` hoặc khởi động lại Claude Code.
- `setup` **im lặng bỏ qua** marketplace/plugin không có trong `skills.json` — nó không dọn máy
  hộ bạn. Gỡ một marketplace là gỡ theo mọi plugin cài từ nó, việc đó bạn tự quyết.
- `setup` chỉ đụng vào `extraKnownMarketplaces` và `enabledPlugins` trong `~/.claude/settings.json`,
  merge theo khoá. `model`, `effortLevel`, `tui` của từng máy được giữ nguyên.
- Cursor và các agent khác: ngoài phạm vi.
