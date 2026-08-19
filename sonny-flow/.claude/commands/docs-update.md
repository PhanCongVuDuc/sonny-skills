---
description: AI向けドキュメント（code_map / dependencies / module_index）を最新の git diff から更新する。手動またはCI/CDから呼び出す。
---

[`docs-keeper`](../agents/docs-keeper.md) エージェントを起動し、AI向けドキュメントを更新する。詳細運用は [`docs/ai-docs.md`](../../docs/ai-docs.md)。

進め方：

1. **差分の取得**：直近の変更（`HEAD~1..HEAD` または PRブランチ）を git diff で取得
2. **影響範囲の判定**：差分が以下の3ファイルに影響するか判定：
   - `docs/domain/generated/code_map.md`
   - `docs/domain/generated/dependencies.md`
   - `docs/domain/generated/module_index.md`
3. **差分マージ更新**：
   - 既存ファイルを残し、変更箇所だけを差分マージ
   - 全文上書きしない
4. **大規模変更検出**：変更が大規模（ファイル50超 / 1000行超）なら自動更新を**停止**し、手動更新を推奨するレポートを出す
5. **更新差分サマリ出力**：`deliverables/00_onboarding/docs-update-{YYYY-MM-DD}.json`

CI/CDから呼ぶ場合：[`scripts/update-ai-docs.sh`](../../scripts/update-ai-docs.sh) または [`scripts/update-ai-docs.ps1`](../../scripts/update-ai-docs.ps1)。GitHub Actions で自動化する場合は [`.github/workflows/ai-docs.yml.example`](../../.github/workflows/ai-docs.yml.example) を参考に追加する（**CI/CD の新規追加は人確認の上で**行う）。

引数（任意）：`$ARGUMENTS` で `--dry-run`（差分のみ表示）か `--force`（大規模変更時も実行）を指定可能。
