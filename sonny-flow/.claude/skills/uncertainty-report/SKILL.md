---
name: uncertainty-report
description: 仕様書・設計書・実装コードに含まれる推測箇所をABCDに分類し、影響度・確認質問付きで棚卸しする。
---

# uncertainty-report

## いつ使うか
- 仕様書・設計書・実装後に、人レビューゲートで「何を確認すべきか」を絞り込みたいとき
- AIの自信度を可視化したいとき

## 入出力
- 入力：対象成果物（仕様書・設計書・コード）
- 出力：`deliverables/{phase}/{target}.uncertainty.json`（[`.claude/rules/output-formats.md`](../../rules/output-formats.md) §3 形式）

## 最低限の守るルール
- 「推測なし」を返すのは本当にすべて明示情報のみで作った場合のみ（沈黙NG）
- 影響度判定に迷ったら**一段上**を選ぶ（保守側に倒す）
- 分類が曖昧な場合は **D** にする（隠さない）

ABCD分類の定義と詳細な棚卸し手順は [`reference.md`](reference.md) を参照。
