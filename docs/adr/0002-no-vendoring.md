# Không clone skill bên thứ 3 về kho — dùng `git-subdir`

Skill third-party được khai báo thẳng trong `.claude-plugin/marketplace.json` bằng plugin source
`git-subdir` trỏ vào repo upstream, thay vì clone repo đó về một thư mục `vendored/` rồi tự gắn
manifest vào bản clone.

Trước đây `find-skills` phải vendored vì repo `vercel-labs/skills` không có
`.claude-plugin/marketplace.json` nên không `marketplace add` trực tiếp được. Nhưng cái thiếu đó
là **manifest marketplace**, mà marketplace ở đây là của ta — chỉ cần trỏ *plugin source* vào
thư mục con của họ là đủ. Bản clone local hoá ra không giải quyết vấn đề gì.

## Consequences

- Không còn repo git lồng trong repo git, không còn manifest tự chế nằm trong cây mã của người
  khác (thứ mà git submodule cũng không chứa nổi).
- Version của plugin giải ra thành commit SHA của upstream (`c6f69c631292-ed96bd46`), nên
  `/plugin marketplace update duc-skills` tự phát hiện commit mới — **không** cần pin `sha` thủ
  công như các entry trong marketplace chính thức của Anthropic vẫn làm.
- Đổi lại: không đọc được mã nguồn skill third-party ngay trong kho, và không sửa được nó tại
  chỗ. Muốn sửa thì copy vào `duc/skills/` — lúc đó nó thành **fork**, tức là own (xem
  `CONTEXT.md`).
