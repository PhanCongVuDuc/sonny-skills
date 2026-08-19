---
description: Phase 1：要件から仕様書ドラフトを生成し、推測箇所レポートも併せて出力する
---

[`spec-drafter`](../agents/spec-drafter.md) エージェントを起動し、[`spec-draft`](../skills/spec-draft/SKILL.md) Skillの構成で仕様書ドラフトを生成する。

進め方：
1. 対象要件ファイル `deliverables/01_requirements/{feature}.requirements.md` を読む
2. [`docs/domain/business_rules.md`](../../docs/domain/business_rules.md) の関連セクションを読む
3. 仕様書ドラフトを `{feature}.spec.md` に書き出す（10セクション固定、「未決定事項」は必ず含める）
4. 続けて [`uncertainty-auditor`](../agents/uncertainty-auditor.md) を起動し `{feature}.uncertainty.json` を生成
5. **人ゲート①**：`impact: high` の推測箇所と「未決定事項」をユーザに確認してもらう

引数（任意）：`$ARGUMENTS` に機能名を渡す。
