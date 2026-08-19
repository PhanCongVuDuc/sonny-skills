---
name: test-scenario
description: 異常系・境界値・部分失敗・競合・業務ルール境界に絞ったテストシナリオを生成する。unit/e2eに対応。正常系は出さない。
---

# test-scenario

## いつ使うか
- 機能実装後、テストすべき内容を洗い出すとき
- 既存テストの抜け漏れを補完したいとき

## 入出力
- 入力：仕様書、[`docs/domain/business_rules.md`](../../../docs/domain/business_rules.md)、レベル指定（`unit` / `e2e`）
- 出力：
  - 単体：`deliverables/04_test/scenarios-{feature}.unit.json`
  - e2e：`deliverables/04_test/scenarios-{feature}.e2e.json`
- 形式：[`.claude/rules/output-formats.md`](../../rules/output-formats.md) §4

## 最低限の守るルール
- **正常系（happy-path）シナリオを出さない**（人が追加する）
- `miss_impact`（見落とした場合の影響）を1行で必ず付ける
- 単体とe2eを**1ファイルに混ぜない**
- 仕様書ベースで生成（実装コードから逆算しない）

レベル別のカテゴリ・各カテゴリの観点詳細は [`reference.md`](reference.md) を参照。
