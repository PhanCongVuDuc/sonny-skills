---
description: 初回セットアップ。AIが質問してドメイン情報と入力ファイルの場所を聞き取り、必要なら既存コード解析を実行してプロジェクトをカスタマイズする。
---

このテンプレートをプロジェクトに導入したあと、**最初に実行する**コマンド。AIが質問を1つずつ出して、回答に応じて以下を自動でカスタマイズする：

- `docs/domain/business_rules.md`、`docs/domain/glossary.md`、`docs/domain/known_patterns.md`、`docs/domain/tech_stack.md` を埋める
- [`CLAUDE.md`](../../CLAUDE.md) の「初回セットアップ結果」セクションを埋める（Input配置・有効なオプション処理）
- 既存コードがあれば「既存解析パス」を実行する（[`onboarding.md`](../../docs/onboarding.md) 参照）

進め方：

1. **プロジェクト名・業界・システム種別**を聞く
2. **既存コードはあるか**を聞く
   - 「はい」→ [`onboarding.md`](../../docs/onboarding.md) の手順に沿って既存解析パス（`legacy-analyzer × 2並列` → `analysis-aggregator` → 人ゲート⓪-1 → `docs-keeper` → 人ゲート⓪-2 → `code-archeology` → 人ゲート⓪-3）を実行
   - 「いいえ」→ スキップ
3. **SIer受領の設計書はあるか**を聞く
   - 「はい」→ Input配置（例：`inputs/sier-design/`）を確認し、CLAUDE.md の「初回セットアップ結果」に「Phase 1 入口で `/from-sier` を使う」と記録
   - 「いいえ」→ スキップ
4. **インタビュー書き起こし（vtt等）はあるか**を聞く
   - 「はい」→ Input配置（例：`inputs/transcripts/`）を確認し、CLAUDE.md に「Phase 1 で `/from-transcript` を使う」と記録
   - 「いいえ」→ スキップ
5. **業界・技術スタック・暗黙ルールのインタビュー**を [`usecase-interview`](../skills/usecase-interview/SKILL.md) Skill の手順で実施し、`docs/domain/` の4ファイルを埋める

完了時に、次に実行すべきコマンドを提案する：
- 通常：`/req` で要件整理に進む
- 設計書受領あり：`/from-sier` で派生仕様作成に進む
- 書き起こしあり：`/from-transcript` で要件抽出に進む

守るルール：
- 質問は**1つずつ**出す（一度に複数質問しない）
- 推測でドメイン情報を埋めない。不明箇所は CLAUDE.md と `docs/domain/` に `（要確認）` を残す
- 既存コード解析を実行する場合、必ず人ゲート⓪-1〜⓪-3 を通す（[`onboarding.md`](../../docs/onboarding.md) 参照）
