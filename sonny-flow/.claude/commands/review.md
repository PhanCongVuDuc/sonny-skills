---
description: 実装コード or 設計を観点別にレビューする。観点は1呼び出し1つに絞る（P1）
---

[`implementation-reviewer`](../agents/implementation-reviewer.md) または [`design-reviewer`](../agents/design-reviewer.md) を、**観点を1つに絞って**起動する。
[`focused-review`](../skills/focused-review/SKILL.md) Skillを使い、`問題あり / 問題なし / 確認不能` の3値で構造化出力する。

進め方：
1. 観点を指定（`$ARGUMENTS` で渡す）：
   - 実装レビュー：`transaction-boundary` / `error-business-logic` / `numeric-precision` / `performance` / `non-functional` / `security` / `spec-conformance` / `cross-file-flow` / `concurrency` / `config-branch`
   - 設計レビュー：`data-integrity` / `error-handling` / `transaction-boundary` / `security` / `non-functional`
2. 対象（差分・ファイル・タスクID）を指定
3. レビュー実行
   - 出力：`deliverables/reviews/impl-{観点}-{task_id}.json` or `design-{観点}-{feature}.json`
4. 結果の `risk_level: high` のみ人が確認するタイミング：
   - **設計レビュー**：その場で人ゲート②として確認 → 通過すれば `/implement` へ
   - **実装レビュー**：Phase 3 内では結果ファイルに保存するだけ。**Phase 4 通過後の人ゲート③で、本コマンドが出力した実装レビュー結果（`deliverables/reviews/impl-{観点}-{task_id}.json`）とテスト実行結果を併せて確認**（`gates.md` / `test.md` と同じ定義）

複数観点が必要なら、複数回 `/review` を呼ぶ（**1回で複数観点を見ない**）。
