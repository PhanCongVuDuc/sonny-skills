# rules/

このディレクトリのルールファイルはプロジェクトの `.claude/rules/` に注入されます。

`/arent-workflow:setup` の Subagent② がここのファイルを解析し、
プロジェクト既存のルールと衝突検出を行います。

## ファイル一覧

### path-scoped ルール（`paths:` frontmatter で対象ファイル編集時に自動ロード）

- `database.md` — DB操作・マイグレーションのルール
- `api-design.md` — APIエンドポイント設計のルール
- `testing.md` — テスト方針・モック戦略
- `domain-knowledge.md` — ドメイン知識参照ルール
- `lsp-navigation.md` — LSP を使ったコードナビゲーションのルール

### 全体適用ルール（`paths:` なし・常時適用）

- `security.md` — セキュリティ（全ファイル対象）

### 契約（contract）ルール（`paths:` なし・各 agent / skill / command から明示参照）

- `output-formats.md` — 成果物の構造化フォーマット契約（§1〜§9）
- `gates.md` — フェーズ移行ゲートの判定基準（自動ゲート／人ゲート）
- `risk-categories.md` — レビュー観点キー・リスクカテゴリ・重大度の正典定義

## 管理方法

これらのルールは `arent-workflow` プラグインが注入したもの（正ソースは `templates/inject/claude/rules/`）。プラグイン更新分の取り込みは `/arent-workflow:re-setup` で行う（手修正は3方向比較で保護される）。
プロジェクト固有の追加ルールは `.claude/rules/` に直接追加してよい（プラグイン管理外として保持される）。
