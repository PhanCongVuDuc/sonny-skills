---
description: フェーズ移行の判定基準。AIの自然言語の「完了報告」を信用せず、構造化成果物に対する自動ゲートと人ゲートで進行可否を判断する。`paths:` なし（各 command / agent から明示参照される）。
---

# Gates Rules（フェーズ移行ゲート）

`paths:` frontmatter なし — このルールは特定ファイルに紐づかず、各 command・agent から明示的に参照される。

このプロジェクトのワークフローは **フェーズごとにゲートを通過しないと次へ進めない**。
ゲートには2種類ある。

- **自動ゲート（machine-checkable）**：`deliverables/` 配下の構造化ファイル（JSON / Markdown）に対して、AI／スクリプトが機械的に判定できる条件。**満たさなければ次フェーズに進ませない。**
- **人ゲート（human approval）**：人が成果物を確認して承認する checkpoint。AIは自動で通過できない。

> **大原則：AIエージェントの自然言語の「できました」「問題ありません」を進行根拠にしない。** 必ず `deliverables/` の構造化ファイルを根拠に、下記のゲート条件で判定する。

---

## ゲート番号とフェーズの対応

| ゲート | フェーズ | 自動ゲート（対象ファイル） | それに続く人ゲート |
|---|---|---|---|
| ゲート⓪ | Phase 0（オンボーディング / ブートストラップ） | `deliverables/00_onboarding/*.json` | 人ゲート⓪-1 / ⓪-2 / ⓪-3 |
| ゲート① | Phase 1（要件・仕様） | `deliverables/01_requirements/{feature}.spec.md` ＋ `{feature}.uncertainty.json`（SIer経由は `{feature}.derived-spec.md` ＋ `{feature}.sier-readout.json`） | 人ゲート①（SIer経由は ①'） |
| ゲート② | Phase 2（設計） | `deliverables/reviews/design-{観点}-{feature}.json` ＋ `devils-advocate-*.md` | 人ゲート② |
| ゲート③ | Phase 3（実装） | `deliverables/03_implementation/{task_id}.report.json` | （Phase 4 通過後の）人ゲート③ |
| ゲート④ | Phase 4（テスト） | `deliverables/04_test/scenarios-*.json` ＋ `deliverables/reviews/test-*.json` ＋ テスト実行結果 | 人ゲート③（実装＋テスト総合判定） |

> 観点キー（`{観点}`）の定義は [`.claude/rules/risk-categories.md`](risk-categories.md) を参照。
> 構造化ファイルの詳細フォーマットは [`.claude/rules/output-formats.md`](output-formats.md) を参照。

---

## ゲート⓪ — オンボーディング / ブートストラップ

既存コード解析パスでのみ通過する（新規プロジェクトでは不要）。

**自動ゲート条件**
- `deliverables/00_onboarding/{region}/aggregation.json` が全リージョン分そろっている
- 解析結果の各項目に `status: confirmed / partial / divergent` が付いている

**人ゲート（自動では通過不可）**
- **人ゲート⓪-1**：`divergent` と `partial` を人が確認し、`human_verdict` 列を埋める（`confirmed` は基本通す）
- **人ゲート⓪-2**：生成3ファイル（ドメインドキュメント雛形）の妥当性を確認
- **人ゲート⓪-3**：業務ルール候補（`confidence: guess` 含む）を有識者承認 → `docs/domain/business_rules.md` に反映

---

## ゲート① — 要件・仕様

`/spec`（通常）または `/from-sier`（SIer受領設計書経由）が出力する仕様を判定する。

**自動ゲート条件**
- 仕様書 `{feature}.spec.md` が10セクション固定で、「未決定事項」セクションを含む
- `{feature}.uncertainty.json` が存在し、各推測項目に `impact: high/medium/low` と「人に聞くべき1文の質問」が付いている
- SIer経由の場合：`{feature}.derived-spec.md` が存在し、`{feature}.sier-readout.json` の `issues`（矛盾・未定義）が列挙されている

**人ゲート（自動では通過不可）**
- **人ゲート①**：`impact: high` の推測箇所と「未決定事項」を人が確認・承認
- **人ゲート①'**（SIer経由）：`sier-readout.json` の `issues` への対処方針 ＋ `uncertainty.json` の `impact: high` 項目を人が確認

---

## ゲート② — 設計

`/design` が出力する設計書とレビュー結果を判定する。

**自動ゲート条件**
- `{feature}.design.md` が存在する
- `design-reviewer` を観点別に実行した結果 `deliverables/reviews/design-{観点}-{feature}.json` が存在し、各項目が `verdict: 問題あり / 問題なし / 確認不能` の3値で分類されている
- `devils-advocate-*.md`（失敗シナリオ）が存在する

**人ゲート（自動では通過不可）**
- **人ゲート②**：`risk_level: high` の指摘と失敗シナリオへの対応方針を人が確認・承認 → 通過すれば `/implement` へ

---

## ゲート③ — 実装（自動ゲート）

`/implement` が出力する `deliverables/03_implementation/{task_id}.report.json` を判定する。
**`/implement` Step 3 がこのゲートを参照する。**

**自動ゲート条件（すべて満たすこと）**

| # | 条件 | 判定 |
|---|---|---|
| 3-1 | `status: completed` であること | `in_progress` / `blocked` のまま次へ進まない |
| 3-2 | `todo_remaining: 0` であること | 1以上なら未完了として差し戻し |
| 3-3 | `assumptions` のうち `risk: high` が **ゼロ**、または**人による承認済み**であること | 未承認の高リスク推測が残っていたら通過不可 |
| 3-4 | `human_review_required` が空でない場合、各項目に `category`（[risk-categories.md](risk-categories.md) のキー）・`question_for_human`・`risk_level` がそろっていること | 1つでも欠けていたらレポート不備として差し戻し |

> いずれか満たさない場合は **Phase 3 に差し戻す**（人の確認なしに次フェーズへ進ませない）。
> このゲートは「実装が正しい」ことを保証するものではなく、「人が確認すべき箇所がレポートに正しく申告されているか」を保証するもの。実装の妥当性判定は人ゲート③で行う。

---

## ゲート④ — テスト（自動ゲート）

`/test` が出力するシナリオ・テスト・実行結果を判定する。

**自動ゲート条件**
- `scenarios-{feature}.{level}.json`（unit / e2e）が存在し、**正常系のみのシナリオになっていない**（異常系・境界値を含む）
- `deliverables/reviews/test-{feature}.json` が存在し、`verdict` の3値で分類されている
- テスト実行結果が記録され、**全テストがパス**している（失敗テストが残ったまま次へ進まない）
- `scenario-map.json` でシナリオ⇔テストの対応が取れている（追跡可能性）

**人ゲート（自動では通過不可）**
- **人ゲート③（総合判定）**：`implementation-reviewer` の観点別レビュー結果 ＋ テスト結果を**併せて**人が確認する。
  - 実装バグ → Phase 3 へ差し戻し
  - テスト側の問題 → Phase 4 で修正
  - カバレッジ不足 → Phase 4 でシナリオ追加
  - 問題なし → **PR 作成へ進む**

---

## ゲート判定の基本ルール

- **自動ゲートを満たさない限り、人ゲートに上げない。** 機械的に弾けるものは機械で弾く。
- **人ゲートはAIが代行しない。** AIは「人が確認すべき項目」を絞り込んで提示するところまで。承認の判断は人が行う。
- **「問題なし」を返すときも観点・確認済み項目を明示する**（沈黙で通過しない）。
- **`risk: high` / `impact: high` / `risk_level: high` は必ず人ゲートに上げる。** 影響度判定に迷ったら一段上に倒す（保守側）。
- ゲート通過の根拠は常に `deliverables/` の構造化ファイル。自然言語の完了報告は根拠にしない。

---

## 参照

- 観点キー・リスクカテゴリの定義：[`.claude/rules/risk-categories.md`](risk-categories.md)
- 構造化ファイルのフォーマット：[`.claude/rules/output-formats.md`](output-formats.md)
- 各フェーズの起動手順：`.claude/commands/spec.md`・`design.md`・`implement.md`・`test.md`・`review.md`・`from-sier.md`
