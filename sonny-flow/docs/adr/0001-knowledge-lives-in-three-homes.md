# 0001 — Kiến thức Revit sống ở ba nhà, phân loại theo từng bài học

| | |
|---|---|
| **Status** | accepted (2026-08-23) |
| **Quyết định bởi** | chủ dự án, sau grill session về ba file revit-test-environment / test-safety-net / revit-fixture |

## Bối cảnh

Kiến thức về làm task Revit nằm rải ở ba file và bị cảm nhận là "lộn xộn". Nguyên nhân đo được: ranh giới
đang cắt theo **file**, trong khi kiến thức lệch nhau theo **từng bài học** — file môi trường của project
chứa 4/5 bài học tổng quát (callback, OnSetup, async, category ẩn), còn rule chung của plugin lại chứa chi
tiết riêng của Sonny; một bài học (`async`) tồn tại ở **ba** chỗ cùng lúc và đã bắt đầu trôi dạt — đúng căn
bệnh duplication vừa chữa ở commands/skills cùng ngày.

## Quyết định

Ba nhà, phân loại theo **từng bài học** bằng một câu kiểm định:

> **"Đổi sang một project Revit khác dùng sonny-flow, bài học này còn đúng không?"**

| Nhà | Loại | Chứa | Điều kiện vào |
|---|---|---|---|
| `rules/` của plugin | **RULES** — cách làm đúng, mọi project | reload-trước-restart, xin-file-thật-trước, test-`void`… | đổi project khác vẫn đúng **và** chủ dự án gật (đụng repo khác) |
| `.sonnyflow/lessons/` của project | **LESSONS** — luật riêng project, đã duyệt | `test-environment.md`, `test-safety-net.md` | **chủ dự án confirm** |
| `.sonnyflow/retro/` | **RETRO** — hàng đợi | bài học thô của từng lượt flow, mỗi mục một status | không điều kiện — agent ghi tự do |

Luật đi kèm: **một bài học một nhà duy nhất** — nhà kia chỉ được đặt con trỏ.

`rules/` chia theo ba câu hỏi: **chạy** test (`revit-loop.md`) · **viết** test/builder (`revit-test.md`) ·
**dựng** fixture (`revit-fixture.md`).

## Vòng đời một bài học — retro là hàng đợi, không phải kho luật

```
lượt flow phát hiện  →  retro/ (chờ xét)  →  CHỦ DỰ ÁN XÉT  →  lessons/ hoặc rules/  (đã nhận)
                                                            └→  không nhận — <lý do>
                        ↑ tồn dư ở đây là BÌNH THƯỜNG, không chặn gate
```

Ba status, mỗi bài học đúng một cái: **`chờ xét`** (agent ghi ở ô 6d) · **`đã nhận → <file>`** ·
**`không nhận — <lý do>`**. Đây là chỗ học từ ADR: quyết định *"bài học này có thành luật không"* có vòng
đời riêng, nên nó cần status tường minh chứ không phải nằm im trong một file ghi chú.

**Mục đã ra khỏi hàng đợi thì gạch ngang, không xoá trắng.** Lý do: bản chép sang `lessons/` ghi *luật
gọn*, còn retro ghi *chuyện gì đã xảy ra để ra luật đó* — bối cảnh đó mất là mất luôn khả năng đánh giá
lại. Và dấu vết là cách duy nhất để lần sau biết bài này **đã có nhà**: 2026-08-23, cùng một bài học
(`async` làm mất Revit API context) bị thêm vào hai chỗ trong một ngày vì retro không nói được điều đó.

**Read-path — quan trọng ngang write-path.** Bài học chỉ có giá trị nếu được đọc lại. Nên:
`lessons/` là **nguồn đọc thứ nhất của bước 0 (orient)**, trước cả `docs/`, và **câu hỏi G0 số 6** biến
việc đọc nó thành điều kiện qua gate. Bước 0 cũng quét hàng đợi `retro/` để không phát hiện lại thứ đã
có trong đó, và không đề xuất lại thứ đã bị gạt. Trước 0.7.2 không có bước nào bảo agent đọc `.sonnyflow/`
— nó chỉ tình cờ được đọc qua con trỏ trong `CLAUDE.md` của project.

## Phương án bị loại

**Hai loại theo file** (file project vs file chung — đề xuất ban đầu): bị loại vì chính nó là hiện trạng
gây lộn xộn — một file luôn chứa lẫn hai loại bài học, và bài học chung kẹt trong file project thì project
sau không bao giờ thấy.

**Gộp retro vào lessons** (một tầng, agent ghi thẳng vào luật): bị loại vì mất người gác cổng. Một lượt
flow sinh ra nhiều phát hiện hơn số bài đáng thành luật; không có cửa xét thì `lessons/` phình lên bằng
phỏng đoán của agent, và luật thật bị chìm trong đó.

**Xoá trắng mục retro sau khi chép** (đề xuất ban đầu của chủ dự án): điều chỉnh thành gạch ngang, vì lý
do bối cảnh + dấu vết ở trên. Hàng đợi vẫn sạch về mặt vận hành.

## Hệ quả chấp nhận

- File trong `.sonnyflow/` vô hình với cả hai knowledge graph (không index dotfolder) — bù bằng con trỏ
  bắt buộc trong `CLAUDE.md` của project.
- Status trong retro là bước thủ công; ô 6d kiểm *đã ghi + đã trình*, không kiểm status đúng.
- Hàng đợi có thể phình mãi. Chấp nhận: tồn dư là trạng thái đúng, và bảng trong `retro/README.md` làm nó
  nhìn thấy được. Cái gate chặn là **không ghi** hoặc **confirm rồi mà không chép**, không phải tồn dư.
- Bài học `→ rules/` cần chủ dự án gật vì đụng repo khác, nên nó chậm hơn bài `→ lessons/`. Chấp nhận.
