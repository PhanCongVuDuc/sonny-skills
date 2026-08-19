---
description: Phase 2：承認済み仕様書から設計書ドラフトを生成し、観点別レビューと悪魔の代弁者を回す
---

設計フェーズを起動する。

進め方：
1. **前提確認**：人ゲート①（仕様の妥当性）が通過していること
2. [`design-architect`](../agents/design-architect.md) を起動
   - 入力：`deliverables/01_requirements/{feature}.spec.md`、[`docs/domain/`](../../docs/domain/) 配下
   - 出力：`deliverables/02_design/{feature}.design.md`
   - 複数候補の判断は [`design-decision`](../skills/design-decision/SKILL.md) Skillでディベート形式に展開
3. [`design-reviewer`](../agents/design-reviewer.md) を**観点別**に呼ぶ：
   - `data-integrity` / `error-handling` / `transaction-boundary` / `security` / `non-functional` から必要なものを選択
   - 出力：`deliverables/reviews/design-{観点}-{feature}.json`
4. [`devils-advocate`](../agents/devils-advocate.md) を呼んで失敗シナリオを列挙
5. **人ゲート②**：`risk_level: high` の指摘と失敗シナリオへの対応方針を確認

引数（任意）：`$ARGUMENTS` に機能名を渡す。
