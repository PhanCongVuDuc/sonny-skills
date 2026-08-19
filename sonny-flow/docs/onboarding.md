# オンボーディング手順（AI向け根拠ドキュメント）

`/arent-workflow:onboarding` と `/bootstrap` コマンドが従う全体手順をここに定義する。
**新規プロジェクト**と**既存コードベース**の2パスがあり、いずれも各フェーズ終了後に人確認ゲートを通す。

> 初回ハーネス注入（`.claude/`・`deliverables/`・`docs/domain/` の生成）は `/arent-workflow:setup` の役割。
> このドキュメントは、その後の「プロジェクト理解・ドメイン知識生成」の手順を扱う。

---

## 新規プロジェクトパス（`/arent-workflow:onboarding new`）

1. プロジェクト名・業界・システム種別を聞く（質問は**1つずつ**）。
2. `docs/domain/` の4ファイル（`business_rules.md` / `tech_stack.md` / `glossary.md` / `known_patterns.md`）を、業界・技術スタック・暗黙ルールのインタビューで埋める。
3. `CLAUDE.md` の残りの `[REPLACE]` プレースホルダを対話式に埋める。
4. 完了後、`/arent-workflow:requirements` で要件整理へ進む。

---

## 既存コードベースパス（`/arent-workflow:onboarding existing [path]`）

各フェーズ終了後に**人確認**を行ってから次へ進む。並列解析は必ず別セッションで2回実行する。

| フェーズ | 内容 | 成果物 | 人ゲート |
|---|---|---|---|
| Phase 0-1 領域定義 | 対象パスをドメイン領域に分割 | `deliverables/00_onboarding/regions.json` | 領域分割の妥当性を確認（番号なしの事前確認。承認後 Phase 0-2 へ） |
| Phase 0-2 並列解析 | 各領域を `parallel-analysis` スキルで解析（`legacy-analyzer` を独立2回）→ `analysis-aggregator` で突き合わせ | `00_onboarding/{region}/analysis-run1.json`・`analysis-run2.json`・`aggregation.json` | **人ゲート⓪-1**：`divergent`/`partial` を有識者が確認 |
| Phase 0-3 ドキュメント生成 | `doc-bootstrap` スキルで自動層3ファイルを生成 | `docs/domain/generated/{code_map,dependencies,module_index}.md` | **人ゲート⓪-2**：生成物の妥当性 |
| Phase 0-4 業務ルール抽出 | `code-archeology` スキルで業務ルール候補を抽出 | `00_onboarding/business-rules-candidates.json` | **人ゲート⓪-3**：候補を有識者承認 → `docs/domain/business_rules.md` に反映 |

> ゲートの自動判定条件は [`.claude/rules/gates.md`](../.claude/rules/gates.md)（ゲート⓪）を参照。
> 各成果物のフォーマットは [`.claude/rules/output-formats.md`](../.claude/rules/output-formats.md)（§8 / §8b）を参照。

---

## 必ず守るルール

- 質問は**1つずつ**出す（一度に複数質問しない）。
- 推測でドメイン情報を埋めない。不明箇所は `（要確認）` を残す。
- 各人確認ゲートで**必ず承認を得てから**次フェーズへ進む。自動で全フェーズを連続実行しない。
- 既存コードパスの並列解析は必ず別セッションで2回実行し、`aggregation.json` で突き合わせる。

---

## 完了チェックリスト

オンボーディング完了の判定。`/bootstrap` はこのチェックリストに戻って残作業を確認する。

- [ ] `docs/domain/business_rules.md` が `[REPLACE]` を残さず、有識者承認済みの業務ルールで埋まっている
- [ ] `docs/domain/tech_stack.md` に採用技術・バージョン・選定理由が記載されている
- [ ] `docs/domain/glossary.md` に主要な業務用語・略語が登録されている
- [ ] （既存コードパス）`docs/domain/generated/` の3ファイルが生成され、人確認⓪-2 済み
- [ ] （既存コードパス）`business-rules-candidates.json` が人確認⓪-3 済みで `business_rules.md` に反映
- [ ] `CLAUDE.md` に未置換の `[REPLACE]` が残っていない
- [ ] 残りのセットアップ（LSP設定 = `/setup-lsp`、ドメインインタビュー）が完了している
- [ ] 次フェーズ `/arent-workflow:requirements` に進める状態である
