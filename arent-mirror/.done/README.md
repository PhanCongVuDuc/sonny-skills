# .done/

Nơi đặt các **file cờ hoàn thành** để bảo đảm tính idempotent của agent.

## Cơ chế

Trước khi bắt đầu xử lý, agent kiểm tra ở đây có `{task_id}.done` hay không, có thì bỏ qua.
Nhờ vậy:

- Khi pipeline hỏng giữa chừng rồi retry thì không chạy lại cùng một xử lý 2 lần
- Sau khi đụng usage limit rồi chạy tiếp thì chỉ đi tiếp phần chưa xử lý
- Chống việc sinh lại cùng một chức năng

## Quy ước tên file

- `{task_id}.done`: theo đơn vị task
- `{feature}-{phase}.done`: theo đơn vị phase (ví dụ: `order-create-spec.done`)

## Nội dung

Ví dụ ghi timestamp, phase đã hoàn thành, và path của deliverable trên 1 dòng JSON:

```json
{"task_id": "form_001", "completed_at": "2026-05-19T10:30:00+09:00", "phase": "implementation", "artifact": "deliverables/03_implementation/form_001.report.json"}
```

## Xoá

- Muốn chạy lại thì xoá file tương ứng trong thư mục này
- Muốn reset toàn bộ thì làm rỗng thư mục này (trừ `.gitkeep` và `README.md`)
