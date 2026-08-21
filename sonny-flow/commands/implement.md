---
description: Step 4 of the feature flow. Implement tasks from an approved plan, writing the test for each task alongside its code, and tick them off in the feature doc. Takes an optional task number to do exactly one task.
argument-hint: <Feature> [số task, hoặc bỏ trống để làm hết phần còn lại]
---

**Bước 4/6 — implement.** Làm các mục `- [ ]` trong `## Plan` của `docs/features/{Feature}.md`.

## Vào bước này cần gì

File có `## Plan` với ít nhất một `- [ ]`. Không có `## Plan` thì dừng và bảo người dùng chạy
`/sonny-flow:plan` trước. **Đừng tự viết plan rồi tự làm theo.**

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
4. Đổi `- [ ]` thành `- [x]`.

## Ba lúc phải dừng lại hỏi

- **Việc vượt ra ngoài plan.** Đừng mở rộng lặng lẽ.
- **`## Contract` sai.** Sửa Contract là đổi yêu cầu — không phải việc của bước implement. Quay lại
  `/sonny-flow:spec`.
- **Cần một abstraction mới** mà plan chưa nói tới.

## Gate G4

Không còn `- [ ]` nào trong `## Plan`. Còn sót mà không làm được thì nói rõ task nào và vì sao — đừng tick
cho đủ.

## Tiếp theo

`/sonny-flow:verify <Feature>`
