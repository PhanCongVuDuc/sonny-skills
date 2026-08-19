---
description: Phase 3：承認済み仕様書・設計書から実装し、自己チェックレポートを構造化形式で出力する
---

実装フェーズを起動する。

進め方：
1. **前提確認**：人ゲート①②が通過していること（SIer受領設計書経由の場合は ①' のみで可）
2. [`implementer`](../agents/implementer.md) を起動
   - 通常の入力：`deliverables/01_requirements/{feature}.spec.md` + `deliverables/02_design/{feature}.design.md` + [`docs/domain/`](../../docs/domain/) 配下
   - SIer受領設計書経由の入力：`deliverables/01_requirements/{feature}.derived-spec.md` + [`docs/domain/`](../../docs/domain/) 配下
   - 実装前に必ず [`docs/domain/generated/code_map.md`](../../docs/domain/generated/code_map.md) と [`module_index.md`](../../docs/domain/generated/module_index.md) の関連箇所を読ませる
   - 出力：実装コード + `deliverables/03_implementation/{task_id}.report.json`（[`.claude/rules/output-formats.md`](../rules/output-formats.md) §1 形式）
   - 実装時は [`risk-flag`](../skills/risk-flag/SKILL.md) Skillで `human_review_required` を必ず埋める
3. レポートの**自動ゲート**確認（[`.claude/rules/gates.md`](../rules/gates.md) ゲート③）：
   - `status: completed` か
   - `todo_remaining: 0` か
   - `assumptions` の `risk: high` がゼロまたは承認済か
4. 続けて `/review` で観点別レビューに進む

引数（任意）：`$ARGUMENTS` にタスクID/機能名を渡す。
