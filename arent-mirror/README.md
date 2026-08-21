# arent-mirror

Bản sao 108 file của harness phát triển bằng AI mà plugin `arent-workflow` inject vào
`ArentInc/architecture_routing` (commit `eaf0c2953d`), đã dịch toàn bộ sang tiếng Việt.

**Đây là kho chỉ để đọc.** Nó không phải plugin — `.claude-plugin/` đã bị xoá và nó không có trong
`.claude-plugin/marketplace.json`, nên `/plugin` và `/setup-skills` đều không thấy nó.

## Đọc gì ở đây

Ý đáng giá nhất nằm ở [`.claude/rules/gates.md`](.claude/rules/gates.md): *không lấy câu "xong rồi"
bằng ngôn ngữ tự nhiên của AI làm căn cứ để đi tiếp* — mỗi phase chỉ qua được khi có file đúng
schema. Plugin `sonny-flow` giữ đúng nguyên tắc đó và bỏ phần còn lại.

[`.claude/rules/output-formats.md`](.claude/rules/output-formats.md) (480 dòng, §1–§9) là ví dụ đầy
đủ nhất về cách đặc tả schema deliverable, nếu sau này cần tham khảo.

## Đừng làm việc bên trong thư mục này

[`CLAUDE.md`](CLAUDE.md) và [`AGENTS.md`](AGENTS.md) ở đây mô tả repo Revit của Arent, không phải
repo này. Claude Code **sẽ nạp** chúng nếu bạn mở session bên trong `arent-mirror/`.

Vì sao giữ lại thay vì xoá: xem [`docs/adr/0004`](../docs/adr/0004-fork-harness-arent-workflow.md)
và [`docs/adr/0005`](../docs/adr/0005-bo-harness-giu-lai-y-gate.md).
