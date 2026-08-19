---
name: risk-flag
description: 実装結果に「人レビューが必要なフラグ」を立てる。リスクカテゴリ・行番号・確認質問・優先度を構造化出力する。
---

# risk-flag

## いつ使うか
- 実装エージェントの自己チェックレポートを生成するとき
- 既存実装に対して「ここは人が見るべき」と明示したいとき

## 入出力
- 入力：実装コード（差分でも可）
- 出力：`deliverables/03_implementation/{task}.report.json` の `human_review_required` フィールドに統合

## 最低限の守るルール
- フラグを立てる基準は [`.claude/rules/risk-categories.md`](../../rules/risk-categories.md) と一致させる
- `question_for_human` を必ず付ける（人が見たときの確認内容を明示）
- 「フラグなし」を返す場合は、確認したカテゴリを明示する

リスクカテゴリ一覧と判定基準は [`reference.md`](reference.md) を参照。
