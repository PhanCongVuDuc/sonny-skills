# AI向けドキュメント運用（ai-docs）

`docs/domain/generated/` の**自動生成層**（AI向けドキュメント）の運用ルールを定義する。
`docs-update` コマンド・`docs-keeper` エージェント・`scripts/update-ai-docs.*` がこのルールに従う。

---

## 対象ファイル（自動生成層）

`docs-keeper` エージェントだけが書き換える。**人間は手で編集しない**（次回更新で上書きされる）。

| ファイル | 内容 |
|---|---|
| `docs/domain/generated/code_map.md` | モジュール・クラス・関数の地図（1モジュール＝数行＋関連リンク） |
| `docs/domain/generated/dependencies.md` | 依存関係グラフ |
| `docs/domain/generated/module_index.md` | エントリポイント・公開API一覧 |

> 業務ルール（`business_rules.md`）・技術選定（`tech_stack.md`）・用語（`glossary.md`）は
> **人間管理の正典**であり、自動生成の対象外。役割分担は [`docs/domain/README.md`](domain/README.md) を参照。

---

## 更新フロー

1. **起動**：手動（`/arent-workflow:docs-update`）／フック（`Edit`・`Write` 後に dry-run）／CI（後述）。
2. **差分取得**：直近の変更（`HEAD~1..HEAD` または PR ブランチ）を `git diff` で取得。
3. **影響判定**：差分が上記3ファイルに影響するか判定。
4. **差分マージ更新**：既存記述を残し、変更箇所のみ差分マージ（**全文上書きしない**）。
5. **大規模変更検出**：ファイル50超／1000行超なら**自動更新を停止**し、手動更新を推奨するレポートを出す。
6. **サマリ出力**：`deliverables/00_onboarding/docs-update-{YYYY-MM-DD}.json`。

引数：`--dry-run`（差分のみ表示）／`--force`（大規模変更でも実行）。

---

## 起動経路

| 経路 | コマンド |
|---|---|
| 手動（Claude Code内） | `/arent-workflow:docs-update`（`docs-keeper` を起動） |
| フック（自動 dry-run） | `Edit`／`Write` 後に `scripts/update-ai-docs.sh dry-run`（プラグインの PostToolUse フック） |
| ローカル一括 | `scripts/update-ai-docs.sh force`（macOS/Linux）／`scripts/update-ai-docs.ps1 force`（Windows） |
| CI/CD（任意） | `.github/workflows/ai-docs.yml.example` を参考に追加（**CI/CD の新規追加は人確認の上で**） |

---

## docs-keeper が守るルール

- 人が承認していない項目（`aggregation.json` の `human_verdict` 空）は反映しない。
- 既存ファイルは差分マージ。矛盾時は上書きせず両方残し `// TODO: docs-keeper review` を付ける。
- AIが参照しやすい構造を保つ（1モジュール数行・関連リンク必須・高リスクモジュールは強調）。
- 500行を超えたらテーマ別ファイルに分割し `code_map.md` をインデックス化。
- 業務ルールは扱わない（`business_rules.md` で人が管理）。
