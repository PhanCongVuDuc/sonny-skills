---
description: Step 1 of the feature flow. Interview the user in rounds until every open decision about the feature is settled, recording answers into the feature doc, the glossary and ADRs so the spec never has to guess.
argument-hint: <Feature> [mô tả ngắn việc cần làm]
---

**Bước 1/6 — grill.** Hỏi cho hết chỗ chưa rõ, trước khi có chữ nào của spec.

Dùng skill [`grill`](../skills/grill/SKILL.md).

## Vào bước này cần gì

Đã orient. Chưa chạy `/sonny-flow:orient` thì chạy skill
[`orient`](../skills/orient/SKILL.md) trước tại đây — vòng hỏi đầu tiên chỉ sắc khi đã biết code có những
abstraction nào. Hỏi người dùng thứ mình tra được là sai nguyên tắc.

## Làm gì

Chạy `/grilling` (cơ chế: cây quyết định · frontier · vòng · `❓ Qn` kèm `➡️`) cùng với
`/domain-modeling` (thuật ngữ → `CONTEXT.md`, quyết định khó đảo → `docs/adr/`).

Seed câu hỏi từ bốn phần của `## Contract`, **nhóm failure modes hỏi trước**: từng nhánh lỗi báo hay bỏ
im · input đơn vị gì và biên xử lý sao · output đổi gì kể cả undo · invariant nào không được phá.

Ghi từng câu đã chốt vào `## Decisions` của `docs/features/{Feature}.md` **ngay khi chốt**, không dồn tới
cuối — grill kéo dài nhiều lượt, ngắt giữa đường phải chạy lại được.

Chưa có file thì tạo, chỉ với đoạn mở đầu + `## Decisions`. Feature đang sửa thì thêm `## Decisions` vào
sau đoạn mở đầu, **không xoá `## Behaviour`**.

## Gate G1

Frontier rỗng — mọi nhánh đã thăm, không còn gì bị giả định lặng lẽ. Trong `## Decisions` không còn dòng
nào **CHƯA CHỐT**.

**Frontier rỗng ngay vòng 1 là kết quả hợp lệ.** Task rõ ràng thì ghi "không có quyết định nào đang mở" rồi
kết thúc. Cấm bịa câu hỏi cho ra vẻ kỹ — bốn câu vô nghĩa dạy người dùng bỏ qua bước này.

Ngược lại cũng cấm: đừng đoán để tránh hỏi. Câu trả lời mà **đổi việc phải làm** thì phải hỏi, kể cả khi
đã có đề xuất chắc — đề xuất đi vào `➡️`.

## Kết thúc

Tóm lại những gì đã chốt, **chờ người xác nhận đã hiểu nhau**, rồi nói bước tiếp là
`/sonny-flow:spec <Feature>`.

Không viết `## Spec`, không viết `## Contract`, không viết code.
