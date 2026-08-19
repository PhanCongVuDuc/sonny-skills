# deliverables/

各フェーズの成果物・レポートを書き出す場所。**AIエージェントの自然言語の「完了報告」は信用せず、このフォルダの構造化ファイルを根拠に判断する。**

---

## ディレクトリ別の用途

| ディレクトリ | 入るもの | 主な生成元 |
|---|---|---|
| `00_setup/` | `harness-manifest.json`（注入ファイル一覧・ハッシュ）、`existing-analysis.json`、`harness-analysis.json`、`merge-plan.json` | `/setup`・`/re-setup` Skill |
| `00_onboarding/` | 既存解析パスの成果物：`regions.json`、`{region}/analysis-run*.json`、`{region}/aggregation.json`、`business-rules-candidates.json`、`docs-update-*.json` | `legacy-analyzer`、`analysis-aggregator`、`docs-keeper`、`code-archeology` Skill |
| `01_requirements/` | `{feature}.requirements.md`（ユースケース・ユーザストーリー）<br>`{feature}.spec.md`（仕様書ドラフト）<br>`{feature}.derived-spec.md`（SIer受領設計書経由の派生仕様）<br>`{feature}.sier-readout.json`（SIer設計書の矛盾リスト）<br>`{feature}.from-transcript.md`（vtt等からの抽出）<br>`{feature}.transcript-refs.json`（元ファイル行番号）<br>`{feature}.uncertainty.json`（推測箇所レポート） | `requirements-organizer`、`spec-drafter`、`sier-spec-reader`、`transcript-extractor`、`uncertainty-auditor` |
| `02_design/` | `{feature}.design.md`（設計書）<br>`{decision_id}.debate.md`（設計判断ディベート） | `design-architect`、`design-decision` Skill |
| `03_implementation/` | `{task_id}.report.json`（実装エージェントの自己チェックレポート） | `implementer` |
| `04_test/` | `scenarios-{feature}.unit.json`（単体シナリオ）<br>`scenarios-{feature}.e2e.json`（e2eシナリオ）<br>`scenario-map.json`（シナリオ⇔テストの対応） | `test-scenario-designer`、`test-implementer` |
| `reviews/` | `design-{観点}-{feature}.json`（設計レビュー）<br>`impl-{観点}-{task_id}.json`（実装レビュー）<br>`test-{feature}.json`（テストレビュー）<br>`devils-advocate-*.md`（悪魔の代弁者）<br>`pipeline-improve-*.md`（パイプライン改善） | 各種レビュアー・Skill |
| `handoff/` | `handoff-{YYYY-MM-DD}-{seq}.md`（セッション引き継ぎ） | `handoff-writer` |

---

## 命名規約

- `{feature}` は機能名のkebab-case（例：`order-create`、`invoice-export`）
- `{task_id}` はタスクID（例：`form_001_convert`）
- `{観点}` は [`.claude/rules/risk-categories.md`](../.claude/rules/risk-categories.md) の観点キー
- `{decision_id}` は設計判断ID（例：`db-engine-choice`、`auth-method`）

---

## 構造化フォーマット

JSON/Markdownの詳細フォーマットは [`.claude/rules/output-formats.md`](../.claude/rules/output-formats.md) を参照。

---

## ファイルの取り扱い

- 各フェーズが終わったら、このフォルダにあるファイルを根拠に次フェーズへ進む
- 削除は基本しない（後でパイプライン改善Skillが分析する材料になる）
- 機密情報（個人情報・トークン）は書き込まないこと

## git 管理ポリシー（テンプレートのデフォルト）

| ディレクトリ | デフォルト | 理由 |
|---|---|---|
| `00_setup/` | commit | ハーネス注入の根拠・履歴を残す |
| `00_onboarding/` | commit（`docs-update-*.json` のみ ignore） | 既存解析の根拠を残す |
| `01_requirements/*.spec.md` `*.derived-spec.md` `*.requirements.md` | commit | 仕様書は差分レビューしたい |
| `01_requirements/*.uncertainty.json` `*.sier-readout.json` | commit | 推測箇所・矛盾は学習材料 |
| `02_design/*.design.md` `*.debate.md` | commit | 設計書は差分レビューしたい |
| `03_implementation/*.report.json` | **ignore** | 揮発的・実装ごとに上書きされる |
| `04_test/scenarios-*.json` | commit | テストシナリオは差分レビューしたい |
| `04_test/scenario-map.json` | **ignore** | テストコードと一緒に再生成可能 |
| `reviews/*.json` `*.md` | commit | レビュー履歴は学習材料として価値が高い |
| `handoff/*.md` | **ignore** | セッション固有の作業メモ |

`.gitignore` には上記のデフォルトが書かれている。プロジェクトの方針に応じて調整可。
