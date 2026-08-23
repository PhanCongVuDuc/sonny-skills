---
description: Step 4 of the feature flow. Implement tasks from an approved plan, writing the test for each task alongside its code, and tick them off in the feature doc. Takes an optional task number to do exactly one task.
argument-hint: <Feature> [số task — bỏ trống thì làm hết]
---

**Bước 4/6 — implement.** Làm các mục `- [ ]` trong `## Plan` của `docs/features/{Feature}.md`.

## Vào bước này cần gì

Mở feature doc, nhìn `## Flow-state`: dòng 3 đã tick, file có `## Plan` với ít nhất một `- [ ]`. Không có
`## Plan` thì dừng và bảo người dùng chạy `/sonny-flow:plan` trước. **Đừng tự viết plan rồi tự làm theo.**

Việc lệnh này được gõ ra nghĩa là người đã duyệt plan. Đó là human gate G3, không cần xác nhận lại.

## Phạm vi

`$ARGUMENTS` có số → làm **đúng** task số đó rồi dừng. Không có số → làm hết các task còn lại, theo đúng
thứ tự trong plan.

## Với mỗi task

1. **Code**, chỉ cho task đó.
2. **Viết test.** Test case rút từ `## Contract`, **không** rút từ code vừa viết. Đọc lại code mình vừa
   viết rồi viết test mô tả nó là cách để code sai và test sai cùng lúc, cả hai đều xanh. Mỗi named
   failure mode trong Contract xứng đáng một test.
3. **Chạy** những test chạy được ngay mà không cần môi trường đặc biệt.
4. Đổi `- [ ]` thành `- [x]`. Task ghi `test: pinned-by #N` chỉ được tick khi #N đã `[x]`.

## Chế độ Inner loop — khi CLAUDE.md của project khai `loopCommand`

Luật đầy đủ: [`rules/revit-loop.md`](../rules/revit-loop.md). Khác với mặc định ở ba điểm:

- **Thứ tự đảo và siết lại**: viết test trước (vẫn rút từ `## Contract`) → chạy `loopCommand` → **phải
  thấy RED** → viết code → lặp `loopCommand` đến GREEN → tick. Test chưa từng fail chưa chứng minh nó
  test cái gì.
- **Không dừng hỏi giữa các task.** Tiếng nói duy nhất được dừng flow là luật dừng trong rule
  (3-RED-thì-dừng, exit-2 hai lần). "Ba lúc phải dừng lại hỏi" bên dưới vẫn nguyên hiệu lực — đó là
  chuyện phạm vi, không phải chuyện môi trường.
- **Môi trường agent tự lo** theo rule: tự khởi động / restart process host (Revit…), tự chẩn đoán khi
  RED khó hiểu theo escalation ladder. Không hỏi người về môi trường.

## Task cần fixture mới

Đọc [`rules/revit-fixture.md`](../rules/revit-fixture.md) **trước khi viết dòng builder nào** — xin file
thật của chủ dự án trước, probe file nền trước khi hỏi, và luật cứng về family.

## Ba lúc phải dừng lại hỏi

- **Việc vượt ra ngoài plan.** Đừng mở rộng lặng lẽ.
- **`## Contract` sai.** Sửa Contract là đổi yêu cầu — không phải việc của bước implement. Quay lại
  `/sonny-flow:spec`.
- **Cần một abstraction mới** mà plan chưa nói tới.

Bug phát hiện ngoài scope thì **không hỏi, không fix** — ghi thẳng vào `docs/bugs/` theo luật trong
[`rules/gates.md`](../rules/gates.md).

## Gate G4

Không còn `- [ ]` nào trong `## Plan`. Còn sót mà không làm được thì nói rõ task nào và vì sao — đừng
tick cho đủ. Xong thì tick dòng 4 trong `## Flow-state` kèm số task (vd `— 23/23`).

## Tiếp theo

`/sonny-flow:verify <Feature>`
