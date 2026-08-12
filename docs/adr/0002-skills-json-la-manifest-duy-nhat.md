# `skills.json` là manifest duy nhất — không dùng lockfile

Cả ba tầng phân phối được khai trong một file `skills.json` do ta tự định nghĩa. Tầng Vercel
**không** dùng `skills-lock.json` của CLI đó, dù file ấy tồn tại sẵn và `npx skills install`
khôi phục được từ nó.

Hai lý do:

1. **Lockfile ghim phiên bản.** Mục tiêu của kho này là *luôn mới nhất*, không phải *tái lập
   chính xác*. Lockfile được sinh ra để làm điều ngược lại với thứ ta cần.
2. **Hai manifest sẽ lệch nhau.** `skills.json` và `skills-lock.json` cùng mô tả "máy này nên có
   skill gì". Đến lúc chúng mâu thuẫn, không có quy tắc nào nói file nào đúng.

## Consequences

- Mất khả năng tái lập chính xác một bộ skill của quá khứ. Chấp nhận: skill là văn bản hướng dẫn,
  không phải dependency có breaking change.
- `setup.mjs` phải tự sinh lệnh `npx skills add ...` từ `skills.json`. Đó là ~10 dòng code, rẻ hơn
  nhiều so với việc đồng bộ hai manifest.
- Nếu một ngày một bản skill mới làm hỏng việc, cách lùi là ghim tay trong `skills.json` — lúc đó
  hãy thêm trường `ref`/`version` vào schema, chứ đừng kéo lockfile vào.
