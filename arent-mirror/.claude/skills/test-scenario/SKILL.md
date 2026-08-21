---
name: test-scenario
description: Generate test scenarios scoped to error paths, boundary values, partial failures, races and business-rule boundaries. Supports unit and e2e. Does not emit happy paths.
---

# test-scenario

## Khi nào dùng
- Sau khi code xong chức năng, khi cần rà ra những gì phải test
- Khi muốn bù vào chỗ thiếu sót của bộ test có sẵn

## Input / output
- Input: spec, [`docs/domain/business_rules.md`](../../../docs/domain/business_rules.md), và chỉ định level (`unit` / `e2e`)
- Output:
  - Unit: `deliverables/04_test/scenarios-{feature}.unit.json`
  - e2e: `deliverables/04_test/scenarios-{feature}.e2e.json`
- Định dạng: [`.claude/rules/output-formats.md`](../../rules/output-formats.md) §4

## Quy tắc tối thiểu phải giữ
- **Không xuất scenario happy path** (phần đó người tự thêm)
- Bắt buộc kèm 1 dòng `miss_impact` (ảnh hưởng nếu bỏ sót)
- **Không trộn unit và e2e trong cùng 1 file**
- Sinh dựa trên spec (không suy ngược từ code)

Category theo từng level và perspective chi tiết của từng category: xem [`reference.md`](reference.md).
