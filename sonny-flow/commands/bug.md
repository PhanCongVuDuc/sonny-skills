---
description: Nhận một bug do người dùng báo — video, file Revit, mô tả — đọc hết kể cả video, chẩn đoán tới file:line, ghi vào docs/bugs/ rồi DỪNG. Không sửa code sản phẩm. Cũng là lệnh để chẩn đoán sâu thêm một bug đã ghi.
argument-hint: <đường dẫn gói | mã bug | đường dẫn docs/bugs/*.md>
model: opus
---

**Phễu trước `docs/bugs/`.** Từ thứ người dùng đưa → một file bug đủ chín để `/sonny-flow:feature` đi
fix được. Lệnh này **ra chẩn đoán, không ra fix**: được chạy Revit và sửa code thăm dò để *hiểu*, nhưng
code sản phẩm về nguyên trạng trước khi báo cáo. Luật sổ nợ ở [`rules/gates.md`](../rules/gates.md).

## Đầu vào — tự phân loại

| Đưa vào | Làm gì |
|---|---|
| Folder / file video / file mô tả | Gói mới → chạy B1→B6 |
| Mã bug (`FFC-003`) hoặc path `docs/bugs/*.md` | Bug đã ghi → xem bảng "Vào bằng bug đã có" cuối file |

Gói nằm **ngoài repo**, không copy vào. Video và `.rvt` của người dùng là tài sản của họ.

## B1 — Kiểm kê

Bảng liệt kê **mọi** file trong gói, chưa đọc sâu gì: video (thời lượng, có stream audio không), `.rvt`
(**version Revit** — nó quyết định configuration nào chạy được, thiếu Revit năm đó thì B5a bất lực và
biết ở đây rẻ hơn biết ở B5), ảnh, mô tả, log.

## B2 — Đọc hết, rẻ trước

1. **File mô tả text trước tiên** — rẻ nhất, và là chỗ duy nhất nói *mong đợi*.
2. **Video: hai lượt.** Lượt 1 `/watch <path>` mặc định (512px, scene-aware) để tìm **khoảnh khắc quyết
   định**; lượt 2 `/watch <path> --resolution 1024 --start <t> --end <t>` quanh khoảnh khắc đó để đọc
   chữ trong dialog Revit / Properties / ô nhập. Chữ trên màn hình ở lượt 1 không đọc được, đừng đoán nó.
3. **Audio.** `/watch` lấy transcript từ caption của yt-dlp — file local không có caption, nên nó rơi
   xuống Whisper và cần `GROQ_API_KEY` trong `~/.config/watch/.env`. **Không có key thì nói thẳng "video
   có tiếng, tôi không nghe được"** — đừng im lặng bỏ qua phần tiếng.
4. Ảnh, log: đọc trực tiếp.

Ra: **hiện tượng** viết bằng lời mình + timestamp khoảnh khắc + nguyên văn chữ đọc được trên màn hình.

## B3 — GATE hiện tượng (NGƯỜI)

Trình đúng ba dòng — *người dùng làm X · thấy Y · mong đợi Z* — rồi **kết thúc lượt**, chờ xác nhận.

Gate rẻ nhất cả flow, và không được bỏ: video cho thấy *cái đã xảy ra*, gần như không bao giờ nói *cái
lẽ ra phải xảy ra*, mà toàn bộ định nghĩa của bug nằm ở khoảng cách giữa hai thứ đó. Với Revit còn một
lý do nữa: rất nhiều "bug" là người dùng chưa hiểu tool.

## B4 — Quét trùng, tạo file, orient

**Quét `docs/bugs/` trước mọi thứ khác.** Trùng → ghi thêm bối cảnh mới vào file cũ, Status `duplicate`
cho lần báo này, **dừng**. Nhánh rẻ nhất của cả flow.

Không trùng → **tạo `docs/bugs/<PREFIX>-<nnn>-<slug>.md`** với `Status: triaging`, `## Flow-state` tick
sẵn B1–B3 kèm bằng chứng. Tạo ở đây chứ không ở B6 vì `gates.md` **cấm xoá file bug** — tạo trước khi
quét trùng là tự sinh rác không được phép dọn.

Rồi gọi `Skill(sonny-flow:orient)`, `args` là tên feature nghi ngờ. Thứ tự nguồn phải đọc nằm trong chính
lệnh đó — đừng chép lại danh sách ra đây, hai bản sẽ lệch nhau ngay lần `orient` đổi đầu tiên.

## B5 — Chẩn đoán. Được mở Revit.

**B5a — probe test (máy làm được).** Test Revit-hosted đọc-only mở đúng `.rvt` của người dùng bằng
**đường dẫn tuyệt đối** tới gói (không qua helper resolve `Resources/RevitFiles`, file nằm ngoài repo),
chạy qua `loopCommand`, dump ra thứ cần biết: element, parameter, trạng thái join, số lượng, exception
thật. Cơ chế probe + luật môi trường test: [`rules/revit-fixture.md`](../rules/revit-fixture.md) và
`.sonnyflow/lessons/test-environment.md`. Deterministic và lặp lại được — tốt hơn mắt người cho phần lớn
bug.

**B5b — cần mắt người.** Bug về ribbon, view, thứ tự dialog, cảm giác UI: nêu **đúng một câu hỏi cụ thể**
cho chủ dự án bấm thử. Không đẩy cả việc chẩn đoán sang người.

Được viết test và sửa code thăm dò, mục đích duy nhất là trả lời *"vì sao"*. Kết thúc B5:
`git stash push -m "probe/<mã-bug>"` mọi edit thăm dò, ghi tên stash vào mục `## Thăm dò` của file bug.
Code sản phẩm về nguyên trạng.

Ra: mục **Bản chất** với `file:line` và cơ chế cụ thể — không phải "có lẽ do".

## B6 — Kết luận, rồi dừng

Điền file bug, đổi Status khỏi `triaging`, cập nhật bảng index `docs/bugs/README.md`, thêm dòng link vào
`## Related` của feature doc — **chỉ khi** Status là `open`.

Báo cáo: hiện tượng · bản chất `file:line` · verdict · các phương án fix kèm **đánh đổi** · lệnh đi tiếp.
**Không sửa code sản phẩm.** Fix là task có spec, không phải việc tiện tay.

## B7 — Đóng sổ

Không thuộc lệnh này. Khi fix xong, `/sonny-flow:doc` đổi Status thành `fixed`, gỡ link khỏi `## Related`
và tick B7. Sổ nợ tự đánh dấu "đã trả" là sổ nợ không đáng tin.

## Flow-state trong file bug

Đứng đầu file, **giữ vĩnh viễn** (khác feature doc — file bug là sổ nợ, "đã chẩn đoán tới đâu, bằng cách
nào" chính là giá trị của nó khi sau này có người báo lại y hệt).

```markdown
## Flow-state

- [ ] B1 kiểm kê — n video / n rvt / mô tả, rvt version R__
- [ ] B2 đọc gói — /watch, khoảnh khắc t=MM:SS, audio: nghe được / không
- [ ] B3 GATE hiện tượng — người xác nhận
- [ ] B4 trùng? → tạo file → orient
- [ ] B5 chẩn đoán — file:line + stash probe/<mã>
- [ ] B6 kết luận — Status, index, Related
- [ ] B7 đóng sổ — fixed + sync-docs (do /sonny-flow:doc tick)
```

## Khuôn file bug

Bốn mục của `gates.md` (Hiện tượng · Tái hiện · Bản chất · Hướng fix đề xuất), thêm hai mục của lệnh này:
**`## Nguồn`** (đường dẫn gói gốc, timestamp khoảnh khắc trong video, ai báo, ngày) và **`## Thăm dò`**
(tên stash, probe test đã viết, số đo lấy được).

`Status`: `triaging` · `open` · `open — giữ có chủ ý` · `fixed` · `not-a-bug` · `duplicate`.
Tất cả nằm trong `docs/bugs/`, kể cả `not-a-bug` — cái tốn tiền là **lần thứ hai có người báo lại**, và
lúc đó thứ cứu ta là *một* chỗ để tra.

`PREFIX`: chữ đầu tên feature (`AutoDimension` → `AD-`); không thuộc feature nào → `APP-`. Bảng prefix
trong `docs/bugs/README.md` để không sinh trùng.

## Vào bằng bug đã có

Bốn file bug không cùng độ chín, nên đừng áp một hành vi cho cả bốn:

| Trạng thái file | Làm gì |
|---|---|
| `open`, mục Bản chất đã có `file:line` | Chuyển tay: `/sonny-flow:feature <F>` |
| `open`, Bản chất còn mỏng | Chạy B4→B6 trên chính file đó |
| `not-a-bug` / `giữ có chủ ý` | Hỏi chủ dự án có mở lại không. Không tự mở |
| `fixed` | Báo là đã fix, hỏi có phải hồi quy không |

## Gate

Qua được B6 khi: Status không còn `triaging` · mục Bản chất có `file:line` thật (không có → Status vẫn
`triaging`, báo "không chẩn đoán được" kèm lý do) · `git status` sạch phần code sản phẩm · index đã cập
nhật.

## Tiếp theo

`/sonny-flow:feature <Feature>` để fix — spec chuyển bug thành failure mode trong `## Contract`,
implement viết test tái hiện **RED trước**.
