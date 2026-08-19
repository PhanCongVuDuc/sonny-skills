---
description: Phase 4：テストシナリオ設計 → テスト実装 → テストレビュー。レベル（unit / e2e）を指定する。実装AIとは独立。
---

テストフェーズを起動する。**実装エージェントとは別エージェントを使う**（自己検証バイアス回避）。

`$ARGUMENTS` で `unit` / `e2e` / `both` を指定する：
- `unit`：単体テストのみ
- `e2e`：e2eテストのみ
- `both`：両方を**順に**実行（unit→e2e、シナリオファイルは別個に作る）

進め方（指定レベルごとに繰り返す）：
1. [`test-scenario-designer`](../agents/test-scenario-designer.md) を起動（[`test-scenario`](../skills/test-scenario/SKILL.md) Skill）
   - 入力：仕様書（`{feature}.spec.md` または SIer受領設計書経由の `{feature}.derived-spec.md`）+ `business_rules.md`
   - レベル `unit` / `e2e` を必ず指定
   - 出力：`deliverables/04_test/scenarios-{feature}.unit.json` または `.e2e.json`（**正常系は対象外**）
2. **人レビュー**：シナリオに業務固有の追加・修正があれば加える
3. [`test-implementer`](../agents/test-implementer.md) を起動
   - 入力：シナリオJSON、実装コード（**参考としてのみ**）
   - e2eは**モック最小限**（外部システムのみ、内部APIは実物）
   - 出力：テストコード + `scenario-map.json`
4. [`test-reviewer`](../agents/test-reviewer.md) を起動
   - 観点：シナリオ網羅性 / モック妥当性 / 同義反復の有無 / 追跡可能性 / レベル整合
   - 出力：`deliverables/reviews/test-{feature}.json`
5. テスト実行 → **人ゲート③**（実装＋テスト総合判定）：`implementation-reviewer` の観点別レビュー結果 + テスト結果を**併せて確認**。実装バグなら Phase 3 へ差し戻し、テスト側問題なら Phase 4 で修正、カバレッジ不足なら Phase 4 でシナリオ追加、問題なければ **PR 作成へ進む**

引数：`$ARGUMENTS = "{feature} {level}"`（例：`order-create unit`、`order-create both`）
