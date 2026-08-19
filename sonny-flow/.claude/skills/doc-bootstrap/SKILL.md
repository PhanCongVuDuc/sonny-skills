---
name: doc-bootstrap
description: /setup の既存解析パスで、解析突き合わせ済みデータから AI向けドキュメント（code_map / dependencies / module_index）の初回生成を行う。
---

# doc-bootstrap

## いつ使うか
- /setup の既存解析パスで AI向けドキュメントを初回整備するとき
- 既存ドキュメントが古く、再生成したいとき

## 入出力
- 入力：全領域の `aggregation.json`（`human_verdict` 付き）
- 実行主体：このスキルは入口（オーケストレータ）で、実際の生成は `docs-keeper` エージェントの初回（全文生成）モードを起動して行う
- 出力：
  - `docs/domain/generated/code_map.md`（新規作成）
  - `docs/domain/generated/dependencies.md`（新規作成）
  - `docs/domain/generated/module_index.md`（新規作成）
  - `deliverables/00_onboarding/docs-update-{YYYY-MM-DD}.json`：生成サマリ（`docs-keeper` が出力。差分更新時と同じ命名・インベントリ）

## 最低限の守るルール
- **初回生成のみ**。差分更新は `docs-keeper` の差分マージモードを使う
- 推測情報を初期ドキュメントに含めない（`human_verdict: confirmed` のものだけ反映）
- ファイルが既に存在する場合は上書き確認を求める（自動上書き禁止）
- 生成後、必ず人ゲート⓪-2に進む（自動で次フェーズに進ませない）

生成方針の詳細は [`reference.md`](reference.md) を参照。
