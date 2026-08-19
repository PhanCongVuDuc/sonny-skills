---
description: 既存コード解析パスを単独で起動する。通常は /setup の Q2 から自動で呼ばれるため手動実行は不要。
---

既存コード解析パスを単独で実行する。通常は `/setup` の Q2（既存コードはあるか？）で「はい」と答えた場合に自動的に走るため、手動実行は不要。

このコマンドが必要になるのは：
- セットアップ後に「やはり既存解析を実施したい」と判断したとき
- 解析をやり直したいとき（コードが大幅に変わったなど）

全体手順の根拠は [`docs/onboarding.md`](../../docs/onboarding.md)。

進め方：

1. **領域分割の確認**：`deliverables/00_onboarding/regions.json` が存在するか確認。なければユーザに領域定義を依頼（例：`domain` / `infra` / `ui` / `auth` / `batch`）
2. **領域ごとに並列解析を起動**（[`parallel-analysis`](../skills/parallel-analysis/SKILL.md) Skill）
   - 各領域に対し `legacy-analyzer` を**独立セッションで2回**走らせる
   - 出力：`deliverables/00_onboarding/{region}/analysis-run1.json` `analysis-run2.json`
3. **突き合わせ**：`analysis-aggregator` で `aggregation.json` 生成。`confidence_rate` を必ず確認
4. **人ゲート⓪-1**：`divergent` と `partial` をユーザに確認してもらう。`human_verdict` 列が埋まったら次へ
5. **AI向けドキュメント初回生成**（[`doc-bootstrap`](../skills/doc-bootstrap/SKILL.md) Skill が入口となり `docs-keeper` エージェントを起動）
   - `docs-keeper` が `code_map.md` `dependencies.md` `module_index.md` を生成（サマリ：`deliverables/00_onboarding/docs-update-{YYYY-MM-DD}.json`）
6. **人ゲート⓪-2**：生成3ファイルの妥当性を確認
7. **業務ルール抽出**（[`code-archeology`](../skills/code-archeology/SKILL.md) Skill）
   - 各領域から業務ルール候補を抽出 → `deliverables/00_onboarding/business-rules-candidates.json`
8. **人ゲート⓪-3**：業務ルール候補を有識者承認 → `docs/domain/business_rules.md` に反映
9. 完了チェックリスト（[`docs/onboarding.md`](../../docs/onboarding.md) 末尾）を確認して、セットアップの残り（Q3/Q4 + ドメインインタビュー）に戻る

引数（任意）：`$ARGUMENTS` に領域名を渡せば、その領域だけ実行する。
