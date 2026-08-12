# Setup là skill cấp project, không phải script terminal

Điểm vào để dựng lại skill trên máy mới là `/setup-skills` — một skill nằm ở
`.claude/skills/setup-skills/`, gõ **bên trong** Claude Code. Không phải `./setup.sh`, không phải
một snippet JSON dán tay.

Con gà–quả trứng: skill setup không thể nằm trong plugin `sonny`, vì trên máy mới plugin đó chưa
được cài. Skill cấp project thì có mặt ngay sau `git clone` — không cần cài gì trước.

Phương án đã loại:

- **Dán `settings.json` snippet.** Đây là cách cũ của kho này và nó **không hoạt động**: khai
  `enabledPlugins` chỉ tuyên bố ý định, plugin từ nguồn ngoài không tự cài. Tài liệu Claude Code
  nói rõ là nó chỉ in ra lệnh `claude plugin install` để người dùng tự chạy.
- **Chỉ có script terminal.** Chạy được, nhưng phải nhớ tên file và cờ. Trong khi thứ luôn có sẵn
  trên mọi máy là chính Claude Code.

## Consequences

- Việc thật do `scripts/setup.mjs` làm, skill chỉ là vỏ. Cố ý: kết quả phải **xác định**, không
  phụ thuộc vào việc Claude hôm nay suy luận thế nào. Script vẫn chạy trần được khi không muốn mở
  Claude Code.
- Phải mở Claude Code **đúng trong thư mục repo** thì `/setup-skills` mới xuất hiện, và thư mục
  phải được trust.
- Skill này không được ship trong plugin `sonny`, nên nó không dùng được từ project khác. Đúng ý
  đồ — nó chỉ có việc để làm khi đứng cạnh `skills.json`.
