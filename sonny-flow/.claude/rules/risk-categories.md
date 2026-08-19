---
description: レビュー観点キー・リスクカテゴリ・重大度レベルの正典定義。実装/設計レビュー、risk-flag、uncertainty、pipeline-improve が共通参照する。`paths:` なし（各 command / agent / skill から明示参照される）。
---

# Risk Categories Rules（観点キー・リスクカテゴリ・重大度）

`paths:` frontmatter なし — このルールは特定ファイルに紐づかず、各 command・agent・skill から明示的に参照される。

このファイルは、ハーネス全体で使う **レビュー観点キー** と **リスクカテゴリ** と **重大度レベル** の唯一の定義元（single source of truth）。
`deliverables/` のファイル名 `{観点}` や、各 JSON の `category` / `risk_level` / `impact` フィールドの値は、ここで定義したキーと**必ず一致させる**こと。

参照元：
- [`implementation-reviewer`](../agents/implementation-reviewer.md)・[`design-reviewer`](../agents/design-reviewer.md)（観点別レビュー）
- [`risk-flag`](../skills/risk-flag/SKILL.md) Skill（`human_review_required` のカテゴリ）
- [`focused-review`](../skills/focused-review/SKILL.md) Skill（1観点レビュー）
- [`uncertainty-auditor`](../agents/uncertainty-auditor.md)（推測箇所の影響度）
- [`pipeline-improve`](../skills/pipeline-improve/SKILL.md) Skill（失敗カテゴリ分類）
- [`deliverables/README.md`](../../deliverables/README.md)（`{観点}` 命名規約）

---

## 重大度レベル（severity）

ハーネス全体で **3段階** に統一する。フィールド名は文脈によって異なるが、値は常に `high / medium / low`。

| フィールド | 使う場所 | 意味 |
|---|---|---|
| `risk_level` | レビュー指摘・`human_review_required`（`implementation-reviewer` / `design-reviewer` / `risk-flag` / `focused-review`） | その指摘・フラグの危険度 |
| `impact` | 推測箇所（`uncertainty-auditor` / `uncertainty.json`） | 推測が外れたときの影響度 |
| `risk` | 実装レポートの `assumptions`（`{task_id}.report.json`） | その前提が崩れたときのリスク |

### high の判定基準
次のいずれかに該当すれば `high`：
- **業務影響**：誤ると業務上の意思決定・金額・帳票が狂う
- **データ破損**：データの不整合・消失・二重計上が起きうる
- **セキュリティ**：認証・認可・情報漏洩に関わる

→ `high` は**必ず人ゲートに上げる**（[`.claude/rules/gates.md`](gates.md) 参照）。

### 判定に迷ったとき
- 影響度判定に迷う：**一段上**を選ぶ（保守側に倒す）。
- 推測か断定か自分でも分からない：隠さず最も低い確度として記録する。

---

## レビュー判定（verdict）

観点別レビュー（`design-reviewer` / `implementation-reviewer` / `focused-review`）の出力は **3値** で必ず分類する。

| verdict | 意味 |
|---|---|
| `問題あり` | 指摘あり。`location` と `issue`、`risk_level` を付ける |
| `問題なし` | 確認した観点を `scope` で明示する（沈黙で済ませない） |
| `確認不能` | 判断に必要な情報（業務ルール等）が不足。`needed_info` を明示する |

- **1呼び出し1観点**を厳守する。観点に該当しない問題に気づいても黙殺（別呼び出しで対応）。
- 「良い点・推奨」は出さない（指摘のみ）。

---

## 実装レビュー観点キー（implementation review）

`implementation-reviewer` / `/review`（実装）/ `focused-review`（コード）で使う。
ファイル名は `deliverables/reviews/impl-{観点}-{task_id}.json`。

| キー | 観点 | 主な確認ポイント |
|---|---|---|
| `transaction-boundary` | トランザクション境界 | 複数DB操作の分割、部分失敗時のリカバリ、ネストトランザクションの要否 |
| `error-business-logic` | エラー処理内の業務ロジック | catch内に「ログ・再スロー」以外の処理、エラー種別による業務分岐、エラー時の別テーブル書込・通知・補正 |
| `numeric-precision` | 数値精度 | int/float と decimal の混在、整数除算による切り捨て、丸め方式が業務ルールと合うか |
| `performance` | 性能 | ループ内DBクエリ（N+1）、全件取得後のアプリ側フィルタ、大量データの一括メモリ展開 |
| `non-functional` | 非機能 | ログ・監視・タイムアウト・リトライ・リソース上限 |
| `security` | セキュリティ | 認証・認可・入力検証・情報漏洩（詳細は [`.claude/rules/security.md`](security.md)） |
| `spec-conformance` | 仕様適合 | 仕様書に記載のない処理・最適化・リファクタの混入（P10違反）、仕様の取りこぼし |
| `cross-file-flow` | ファイル横断フロー | 複数ファイルにまたがる処理の整合、呼び出し側と実装側の前提ズレ |
| `concurrency` | 並行性 | 非同期・スレッド安全性、競合・デッドロック、共有状態の保護 |
| `config-branch` | 設定・分岐 | 設定値による分岐網羅、環境差分、フィーチャーフラグの取り扱い |

---

## 設計レビュー観点キー（design review）

`design-reviewer` / `/design` / `focused-review`（設計）で使う。
ファイル名は `deliverables/reviews/design-{観点}-{feature}.json`。

| キー | 観点 | 主な確認ポイント |
|---|---|---|
| `data-integrity` | データ整合性 | 一意制約・参照整合性・状態遷移の妥当性、不変条件の維持 |
| `error-handling` | エラーハンドリング | 失敗パスの設計、リトライ・補償・ロールバック方針 |
| `transaction-boundary` | トランザクション境界 | トランザクションの単位設計、整合性スコープ |
| `security` | セキュリティ | 認証・認可境界、信頼境界での検証（詳細は [`.claude/rules/security.md`](security.md)） |
| `non-functional` | 非機能 | 可用性・性能・拡張性・運用性の設計上の考慮 |

---

## リスクカテゴリキー（risk-flag / human_review_required）

`risk-flag` Skill が `human_review_required` に立てるフラグのカテゴリ。
`implementer` の `human_review_required` もこのキーを使う。

| キー | 抽出対象 |
|---|---|
| `numeric-precision` | 丸め・型変換・整数除算 |
| `transaction-boundary` | 複数DB操作・部分失敗 |
| `error-business-logic` | catch内のビジネスロジック |
| `business-rule` | 暗黙の業務ルールへの依存 |
| `concurrency` | 非同期・スレッド安全性 |
| `security` | 認証・認可・入力検証・情報漏洩 |

`human_review_required` の各項目には `location` / `category` / `description` / `risk_level` / `question_for_human` を必ず付ける。
「フラグなし」を返す場合は確認したカテゴリを `confirmed_categories: [...]` で明示する。

---

## 推測カテゴリ（uncertainty）

`uncertainty-auditor` が推測箇所を分類する **ABCD** ラベル。各項目に `impact: high/medium/low` と「人に聞くべき1文の質問」を必ず付ける。

| ラベル | 意味 |
|---|---|
| `A` | 情報不足で推測した |
| `B` | 複数解釈が可能でどちらかを選んだ |
| `C` | 業務ルール不明で一般動作にした |
| `D` | 完全に理解できていない |

- 推測かどうか自分でも分からない項目は `D` として記録（隠さない）。
- `impact: high` は人ゲート①のレビュー対象になる。

---

## カテゴリ運用ルール

- **新しい観点キーを追加するときは、まずこのファイルに定義する。** 定義のないキーをファイル名や JSON に使わない。
- `pipeline-improve` の失敗カテゴリ分類は、このファイルのキーを使う（独自カテゴリを発明しない）。
- キーが増えすぎたら `pipeline-improve` で**廃止・統合候補**を検討する（肥大化防止）。
- 重複する指摘（同一ファイル内の同種問題）は1つにまとめてよい。

---

## 参照

- フェーズ移行ゲートと人レビューのタイミング：[`.claude/rules/gates.md`](gates.md)
- セキュリティ観点の詳細基準：[`.claude/rules/security.md`](security.md)
- 構造化ファイルのフォーマット：[`.claude/rules/output-formats.md`](output-formats.md)
- 成果物の命名規約（`{観点}`）：[`deliverables/README.md`](../../deliverables/README.md)
