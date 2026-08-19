---
name: focused-review
description: 設計・コードに対して1観点だけを絞り込んでレビューする。対象外を明示し、問題あり/問題なし/確認不能の3値で構造化出力する。
---

# focused-review

## いつ使うか
- 「全体をレビューして」と言いたくなったとき（→ 観点を絞る）
- 特定の観点（トランザクション境界・数値精度等）を集中的に確認したいとき
- `design-reviewer` や `implementation-reviewer` を呼び出すとき

## 入出力
- 入力：レビュー対象 + **1つの観点**（[`.claude/rules/risk-categories.md`](../../rules/risk-categories.md) から選ぶ）
- 出力：
  - 設計：`deliverables/reviews/design-{観点}-{feature}.json`
  - 実装：`deliverables/reviews/impl-{観点}-{task_id}.json`
- 形式：[`.claude/rules/output-formats.md`](../../rules/output-formats.md) §2（`verdict: 問題あり / 問題なし / 確認不能` の3値）

## 最低限の守るルール
- **1呼び出し1観点**を厳守
- 「良い点」は出さない（指摘のみ）
- 「問題なし」も観点を明示して出す（沈黙で済ませない）
- 観点に該当しない問題に気づいたら黙殺し、別呼び出しで対応

詳細な観点別の確認ポイントは [`reference.md`](reference.md) を参照。
