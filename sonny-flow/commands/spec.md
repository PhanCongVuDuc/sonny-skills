---
description: Step 2 of the feature flow. Write the spec and the contract for one feature into its feature doc — what it does, acceptance criteria, invariants, and every named failure mode. Does not plan and does not write code.
argument-hint: <Feature> [mô tả ngắn việc cần làm]
---

**Bước 2/6 — spec + contract.** Ghi vào `docs/features/{Feature}.md`.

## Vào bước này cần gì

`## Decisions` trong `docs/features/{Feature}.md` không còn dòng nào **CHƯA CHỐT**. Chưa có `## Decisions`
thì dừng và bảo người dùng chạy `/sonny-flow:grill` trước.

**Không đoán.** Bước này chỉ *ghi lại* thứ đã chốt ở bước 1. Gặp chỗ chưa có trong `## Decisions` mà vẫn
cần quyết định thì quay lại grill cho chỗ đó, đừng tự chọn rồi ghi vào Contract.

## Làm gì

Dùng skill [`feature-spec`](../skills/feature-spec/SKILL.md), viết đúng hai section: `## Spec` và
`## Contract`. **Chưa viết `## Plan`** — đó là bước 3.

`docs/features/{Feature}.md` **đã tồn tại** (đang sửa feature cũ): không tạo file mới, không xoá
`## Behaviour`. Thêm `## Spec` vào ngay sau đoạn mở đầu, và trong đó nói rõ **phần nào của `## Contract`
hiện tại sẽ đổi, đổi thành gì**. Đó là dấu hiệu duy nhất phân biệt *đổi yêu cầu* với *sửa implementation*.

## Gate G2

`## Contract` có đủ bốn phần: **Input** (kèm đơn vị nếu là số đo) · **Output** (kể cả tác dụng phụ) ·
**Invariants** (kèm hậu quả nếu phá) · **Named failure modes** (dạng bảng, nhánh nào không báo gì cho
người dùng thì ghi `*(unnamed)* **silent skip**`).

Mỗi hàng trong bảng failure modes sẽ thành một test ở bước 4. Bảng nghèo thì test nghèo.

Bảng "chỗ đang phải suy đoán" trong `## Spec` **nên gần như rỗng** — grill đã dọn trước. Còn dòng nào
trong đó nghĩa là có chỗ lọt qua grill: ghi ra, đừng lấp.

## Tiếp theo

`/sonny-flow:plan <Feature>`. **Không viết code ở bước này.**
