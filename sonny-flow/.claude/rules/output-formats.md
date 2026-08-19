---
description: 成果物の構造化フォーマット契約（§1〜§9）。各エージェント・スキルが deliverables に書き出す JSON/Markdown の唯一の正フォーマット。paths なし（明示参照）。
---

# output-formats（成果物の構造化フォーマット定義）

`paths:` frontmatter なし — このファイルは path 自動ロードではなく、各エージェント・スキルが明示的に参照する「契約（contract）」ルールです。`deliverables/` に書き出す全成果物の JSON / Markdown スキーマをここで一元管理します。

各セクション `§N` は、特定の生成元（エージェント or スキル）が出力する成果物の**唯一の正フォーマット**です。生成元はここで定義されたスキーマに厳密に従って出力してください。

## 共通ルール

- **JSON は厳密な JSON**（コメント・末尾カンマ禁止）。1ファイル1ルートオブジェクト。
- 文字コードは UTF-8。値は日本語可。フィールド名（キー）はここで定義した英語キーで固定。
- 不明・未確定の値は**省略せず**、`null` か `"（要確認）..."` の文字列で明示する（沈黙で埋めない）。
- パスのプレースホルダ（`{feature}` `{task_id}` `{region}` `{観点}` `{decision_id}` `{phase}` `{target}` `{runN}` `{YYYY-MM-DD}` `{seq}` `{YYYY-MM}`）の意味は [`deliverables/README.md`](../../deliverables/README.md) の命名規約に従う。
- レビュー系の `verdict` は **`問題あり` / `問題なし` / `確認不能`** の3値のみ。`risk_level` は **`high` / `medium` / `low`** のみ。

---

## §1 実装自己チェックレポート — implementer

**生成元**：[`implementer`](../agents/implementer.md)（[`implement`](../commands/implement.md) コマンド経由含む）
**出力先**：`deliverables/03_implementation/{task_id}.report.json`
**目的**：承認済み仕様から実装したコードについて、推測箇所・要確認箇所・人レビュー必要箇所を構造化申告する。自然言語の「できました」を信用せず、このJSONを根拠に次へ進むためのもの。

```json
{
  "task_id": "form_001_convert",
  "spec_source": "deliverables/01_requirements/order-create.spec.md",
  "summary": "注文作成フォームのサーバ側バリデーションと永続化を実装",
  "status": "completed",
  "todo_remaining": 0,
  "changed_files": [
    { "path": "src/order/create.ts", "change": "added", "reason": "仕様§3の入力検証と保存" }
  ],
  "scope_adherence": {
    "in_scope_only": true,
    "added_outside_spec": []
  },
  "assumptions": [
    {
      "id": "A1",
      "location": "src/order/create.ts:42",
      "description": "（推測）数量上限が仕様に無いため 9999 を上限とした",
      "risk": "high",
      "basis": "spec に上限記述なし。業務ルール未確認"
    }
  ],
  "human_review_required": [
    {
      "location": "src/order/create.ts:88",
      "category": "numeric-precision",
      "description": "金額計算の丸め方向が仕様未定義。risk-categories.md の数値精度に該当",
      "risk_level": "high",
      "question_for_human": "金額の丸めは切り捨て・四捨五入・切り上げのどれですか？"
    }
  ],
  "questions": [
    "仕様書と既存実装で在庫減算のタイミングが矛盾。どちらに合わせるか要確認"
  ],
  "tests_written": false,
  "self_check": {
    "spec_uncovered_items": [],
    "known_patterns_followed": true
  }
}
```

- `status` は `completed` / `in_progress` / `blocked`、`todo_remaining` は残タスク数。**ゲート③（[`gates.md`](gates.md)）は `status: completed` かつ `todo_remaining: 0` を必須とする**。
- `assumptions` の各 `description` は実装コード側にも `（推測）[内容]` コメントとして残す（二重記録）。各 `risk` は `high/medium/low`。
- `human_review_required` の各項目は **`location` / `category`（[`risk-categories.md`](risk-categories.md) のキー）/ `description` / `risk_level`（high/medium/low）/ `question_for_human`** を必ず持つ。該当箇所は必ず列挙する（空配列で済ませない）。
- `questions` は無理に実装せず保留した判断（仕様と既存の矛盾・スコープ外改善）を入れる。
- `tests_written` は常に `false`（テストは `test-implementer` の責務）。

---

## §2 観点別レビュー結果 — implementation-reviewer / design-reviewer / test-reviewer / focused-review

**生成元**：[`implementation-reviewer`](../agents/implementation-reviewer.md)、[`design-reviewer`](../agents/design-reviewer.md)、[`test-reviewer`](../agents/test-reviewer.md)、[`focused-review`](../skills/focused-review/SKILL.md)
**出力先**：
- 実装レビュー：`deliverables/reviews/impl-{観点}-{task_id}.json`
- 設計レビュー：`deliverables/reviews/design-{観点}-{feature}.json`
- テストレビュー：`deliverables/reviews/test-{feature}.json`（観点配列に下記5観点を入れる）

**目的**：1呼び出し1観点で、対象外を明示しつつ `問題あり / 問題なし / 確認不能` の3値で構造化レビューする。「良い点」は出さず指摘のみ。

```json
{
  "target": "src/order/create.ts",
  "review_type": "implementation",
  "perspective": "transaction-boundary",
  "verdict": "問題あり",
  "out_of_scope_note": "命名・フォーマット・正常系の妥当性は対象外",
  "findings": [
    {
      "id": "F1",
      "location": "src/order/create.ts:120-138",
      "risk_level": "high",
      "issue": "在庫減算と注文保存が別トランザクション。途中失敗で不整合が残る",
      "evidence": "saveOrder() 後に decrementStock() を別 await で呼んでいる",
      "suggested_direction": "同一トランザクション境界に統合（解決策の断定はしない）"
    }
  ],
  "unverifiable": [
    {
      "location": "src/order/create.ts:88",
      "reason": "丸め方向の業務ルールが不明",
      "need": "docs/domain/business_rules.md の金額計算セクション、または人への確認"
    }
  ],
  "observed_but_out_of_scope": []
}
```

- `review_type` は `implementation` / `design` / `test` のいずれか。
- `verdict` が `問題あり` → `findings` に最低1件。`確認不能` → `unverifiable` に必要情報を明記。`問題なし` でも `perspective` を必ず明示。
- 各 finding に `risk_level`（`high/medium/low`）を必須。
- **test-reviewer の場合**：`perspective` 単一の代わりに、シナリオ網羅性 / モック妥当性 / 同義反復 / 追跡可能性 / レベル整合の5観点を `findings[].perspective` に持たせ、ルートは `"review_type": "test"` とする。

---

## §3 不確実性レポート（ABCD分類） — uncertainty-auditor / uncertainty-report

**生成元**：[`uncertainty-auditor`](../agents/uncertainty-auditor.md)、[`uncertainty-report`](../skills/uncertainty-report/SKILL.md)
**出力先**：`deliverables/{phase}/{target}.uncertainty.json`（例：`deliverables/01_requirements/order-create.uncertainty.json`）
**目的**：成果物作成時に「明示されていない情報を推測で補った箇所」を申告し、影響度順に並べて人レビューゲートで確認すべき点を絞り込む。

```json
{
  "target": "deliverables/01_requirements/order-create.spec.md",
  "phase": "01_requirements",
  "has_uncertainty": true,
  "items": [
    {
      "id": "U1",
      "category": "A",
      "impact": "high",
      "location": "spec §3 入力検証",
      "description": "数量上限が記載されていなかったため 9999 と推測した",
      "question": "注文1件あたりの数量上限はいくつですか？",
      "chosen": "上限 9999",
      "alternatives": []
    },
    {
      "id": "U2",
      "category": "B",
      "impact": "medium",
      "location": "spec §5 キャンセル",
      "description": "「キャンセル可能」が出荷前のみか出荷後も含むか2解釈ある",
      "question": "キャンセルは出荷後も可能ですか？",
      "chosen": "出荷前のみ",
      "alternatives": ["出荷後も返品扱いで可能"]
    }
  ]
}
```

- `category` は **A**（情報不足で推測）/ **B**（複数解釈から選択）/ **C**（業務ルール不明で一般動作）/ **D**（完全には理解できていない）のいずれか。迷ったら **D**。
- `impact` は `high/medium/low`。迷ったら一段上に倒す。`impact: high` を配列の上位に並べる。
- 各項目に「人に聞くべき1文の質問」（`question`）を必須。
- 推測が本当に無い場合のみ `has_uncertainty: false` かつ `items: []`。

---

## §4 テストシナリオ — test-scenario-designer / test-scenario

**生成元**：[`test-scenario-designer`](../agents/test-scenario-designer.md)、[`test-scenario`](../skills/test-scenario/SKILL.md)
**出力先**：
- 単体：`deliverables/04_test/scenarios-{feature}.unit.json`
- e2e：`deliverables/04_test/scenarios-{feature}.e2e.json`

**目的**：異常系・境界値・部分失敗・競合・業務ルール境界・ユーザ動線に絞ったシナリオを仕様書ベースで設計する。**正常系（happy-path）は生成しない**。単体とe2eを1ファイルに混ぜない。

```json
{
  "feature": "order-create",
  "level": "unit",
  "spec_source": "deliverables/01_requirements/order-create.spec.md",
  "scenarios": [
    {
      "id": "UT-001",
      "category": "boundary-value",
      "title": "数量が上限+1のとき検証エラー",
      "preconditions": ["商品が在庫あり"],
      "input": "quantity = 10000",
      "expected": "400 とエラーコード QTY_OVER",
      "miss_impact": "上限超過注文が通り在庫がマイナスになる"
    }
  ]
}
```

e2e の場合（`"level": "e2e"`）は各シナリオに `entry_point` と `actors` を追加する：

```json
{
  "id": "E2E-001",
  "category": "auth-boundary",
  "title": "他ユーザの注文を閲覧しようとして拒否される",
  "entry_point": "GET /orders/{id} 注文詳細画面",
  "actors": ["一般ユーザB（注文の所有者ではない）"],
  "expected": "403。他人の注文データが表示されない",
  "miss_impact": "権限外データ漏洩（IDOR）"
}
```

- `level` は `unit` / `e2e`。**`category: happy-path` は禁止**。
- unit カテゴリ：`boundary-value` / `business-rule-boundary` / `processing-order` / `partial-failure` / `concurrency`。
- e2e カテゴリ：`user-flow-error` / `cross-module-state` / `integration-failure` / `auth-boundary` / `data-leak`。
- 全シナリオに `miss_impact`（見落とした場合の影響）を1行で必須。業務ルール不明時は `title` 等に `（要確認）` を付ける。

---

## §5 設計判断ディベート — design-decision / design-architect

**生成元**：[`design-decision`](../skills/design-decision/SKILL.md)、[`design-architect`](../agents/design-architect.md)（複数候補のある判断ごと）
**出力先**：`deliverables/02_design/{decision_id}.debate.md`
**目的**：複数候補のある設計判断を、推進者A・推進者B（・C・D）と中立な審判のディベート形式で並べる。**AIは結論を出さず、人が判断する**ための材料を均等に提示する。

```markdown
# 設計判断ディベート: {decision_id}

## 論点
[何を決めるのか。1〜2文]

## 前提条件
- 規模: [例: 月間注文1万件]
- チームスキル: [例: TypeScript中心、SQL中級]
- 制約: [例: オンプレ、外部SaaS不可]
- 将来計画: [例: 1年後に多テナント化]
（不足している前提は「（要確認）」と明記し、推測で埋めない）

## 選択肢
- 案A: [名称]
- 案B: [名称]

## 推進者A（案A推し）
1. [主張1]
2. [主張2]
3. [主張3]

## 推進者B（案B推し）
1. [主張1]
2. [主張2]
3. [主張3]

## 中立な審判
- 案Aが有利になる条件: [...]
- 案Bが有利になる条件: [...]
- 判断に必要だが不足している情報: [...]

## 人が決めること
[ここはAIが結論を書かない。人が選んで追記する欄]
```

- 各推進者の主張は**3点ずつ均等**に出す（片方が薄くならない）。
- 「中立な審判」セクションでも**どちらが良いと断言しない**。条件と不足情報の提示に留める。
- 選択肢は最大4つ。3つ以上なら推進者セクションを案の数だけ用意する。

---

## §6 セッション引き継ぎ — handoff-writer / handoff

**生成元**：[`handoff-writer`](../agents/handoff-writer.md)、[`handoff`](../skills/handoff/SKILL.md)
**出力先**：`deliverables/handoff/handoff-{YYYY-MM-DD}-{seq}.md`
**目的**：次セッションが同じ状態から再開できるよう、現状・重要な事実・次の作業・注意事項を構造化する。**4セクションを必ずすべて含める**（空でも見出しを残す）。

```markdown
# 引き継ぎ: {YYYY-MM-DD}-{seq}

## 現在の状態
- 完了: [...]
- 未完了: [...]
- 進行中: [...]

## このセッションで確認した重要な事実
- [仕様の解釈・業務ルールの確認]
- [**AIが最初に誤解していたが訂正された点**を必ず書く ← 誤解の再発防止]

## 次のセッションで最初にやること
1. [具体的に。番号付き]
2. [...]

## 注意事項
- [このセッションで発生した問題と対処]
- [踏みやすい落とし穴]
```

- 「重要な事実」には**ユーザに訂正された箇所**を必ず起点として書く。
- 推測・要約は最小限。再開に必要な情報を網羅する。
- **機密情報（パスワード・トークン等）は書かない。**

---

## §7 パイプライン改善提案（Before/After） — pipeline-improve

**生成元**：[`pipeline-improve`](../skills/pipeline-improve/SKILL.md)
**出力先**：`deliverables/reviews/pipeline-improve-{YYYY-MM}.md`
**目的**：「人が修正した箇所と理由」を分析し、ルール・パイプラインの改善案を**具体的な文言**の Before/After で出す。追加ばかりでルールが肥大化しないよう、**廃止できるルールも必ず探す**。

```markdown
# パイプライン改善レポート: {YYYY-MM}

## 分析対象
- reviews/*.json の `verdict: 問題あり`: [N件]
- *.report.json の `assumptions(risk: high)`: [N件]
- 人が訂正した git diff: [対象範囲]

## 繰り返し発生したパターン
| # | 症状 | 発生回数 | 根本原因（推定） |
|---|---|---|---|
| 1 | [例: 数値の丸め方向ミス] | 4 | risk-categories に丸め観点が無い |

## 改善案（Before / After）
### 改善1: [タイトル]
- 対象ファイル: `.claude/rules/risk-categories.md`
- Before:
  > [現状の文言、または「該当記述なし」]
- After:
  > [追加・変更する具体的な文言。「気を付ける」等の抽象表現は禁止]
- 根拠: [上の表の#何番に対応するか]

## 廃止・統合の候補
- [使われていない／重複しているルールを必ず1つ以上検討する。無ければ「検討したが無し」と明記]

## 過去レポートとの重複チェック
- [前回までと同じ改善案を繰り返していないかの確認結果]
```

- ルール変更案は必ず**そのまま貼れる具体文言**で書く。
- 本レポートの内容を**直接 `.claude/agents/*.md` や `rules/*.md` に書き込まない**（人の承認が前提）。

---

## §8 既存コード解析レポート（1領域・1run） — legacy-analyzer

**生成元**：[`legacy-analyzer`](../agents/legacy-analyzer.md)
**出力先**：`deliverables/00_onboarding/{region}/analysis-{runN}.json`（`runN` = `run1` / `run2`）
**目的**：指定1領域のコードを固定6観点で解析する。同一領域を別runでもう一度解析し、§8b で突き合わせる前提。観点の順番も固定。

```json
{
  "region": "order",
  "run": "run1",
  "paths_analyzed": ["src/order/**"],
  "responsibilities": [
    { "module": "src/order/create.ts", "responsibility": "注文の作成と検証" }
  ],
  "dependencies": [
    { "from": "src/order/create.ts", "to": "src/stock/index.ts", "direction": "calls" }
  ],
  "implicit_preconditions": [
    "create() 呼び出し前にユーザ認証済みであることが暗黙の前提"
  ],
  "dead_code": [
    { "location": "src/order/legacy.ts:10-40", "note": "コメントアウト。参照なし" }
  ],
  "business_rule_evidence": [
    { "location": "src/order/create.ts:88", "magic": "0.08", "meaning": "（推測）消費税率8%" }
  ],
  "high_risk_changes": [
    { "location": "src/order/create.ts:120", "why": "在庫減算と密結合。変更で不整合の恐れ" }
  ],
  "assumptions": ["（推測）税率はハードコードだが設定化されている可能性あり"],
  "interpretations": [
    { "location": "src/order/create.ts:88", "options": ["税率固定", "地域別税率"] }
  ],
  "uncertainty": ["税率の根拠資料を確認できていない"]
}
```

- 6観点（責務 / 依存 / 暗黙の前提 / デッドコード / 業務ルールの根拠 / 高リスク箇所）をこの順で必ず埋める。
- 推測は `（推測）` を付けて `assumptions` に記録。複数解釈は `interpretations` に**両方**列挙し自分で選ばない。
- 断言しない。確証のない点は `uncertainty` に積む。読み取り専用（コード変更禁止）。

---

## §8b 解析突き合わせレポート — analysis-aggregator

**生成元**：[`analysis-aggregator`](../agents/analysis-aggregator.md)
**出力先**：`deliverables/00_onboarding/{region}/aggregation.json`
**目的**：同一領域の `analysis-run1.json` と `analysis-run2.json` を突き合わせ、一致（confirmed）/ 不一致（divergent）/ 片側のみ（partial）に分類し、人レビュー対象を絞る。解析自体はやり直さない。

```json
{
  "region": "order",
  "sources": [
    "deliverables/00_onboarding/order/analysis-run1.json",
    "deliverables/00_onboarding/order/analysis-run2.json"
  ],
  "confirmed": [
    { "topic": "create.ts の責務", "statement": "注文の作成と検証" }
  ],
  "divergent": [
    {
      "topic": "税率の意味",
      "run1": "消費税率8%（推測）",
      "run2": "地域別税率（断定）",
      "note": "片方推測・片方断定のため要人ゲート"
    }
  ],
  "partial": [
    { "topic": "legacy.ts のデッドコード", "mentioned_in": "run1", "statement": "参照なし" }
  ],
  "uncomparable": [
    { "topic": "...", "reason": "観点の粒度が両runで異なり比較不能" }
  ],
  "confidence_rate": 0.62
}
```

- 分類は `confirmed` / `divergent` / `partial` の3値に必ずマッピング。**完全に同じ場合のみ confirmed**（「ほぼ同じ」は不可）。
- `divergent` は**両方の主張を保存**（一方を選ばない）。一方が `（推測）`・他方が断定なら `divergent` 扱い。
- `confidence_rate` = `confirmed 項目数 / 総項目数`。
- 突き合わせ不能な項目は `uncomparable` に退避し理由を明記。

---

## §9 SIer受領設計書 読み取りレポート — sier-spec-reader

**生成元**：[`sier-spec-reader`](../agents/sier-spec-reader.md)
**出力先**：`deliverables/01_requirements/{feature}.sier-readout.json`
**目的**：外部受領設計書から、矛盾・未定義・暗黙前提を抽出して `issues` に積む。これらは**派生仕様（`{feature}.derived-spec.md`）には含めず**、人ゲート①' を必ず通すための材料。

```json
{
  "feature": "order-create",
  "source_documents": [
    { "file": "inputs/sier-design/基本設計書_v2.docx", "version": "v2" }
  ],
  "extracted_points": {
    "io": ["リクエスト: 商品ID・数量", "レスポンス: 注文ID・合計金額"],
    "business_rules": ["合計 = 単価 × 数量 × (1 + 税率)"],
    "error_handling": ["在庫不足時の挙動が（未記載）"],
    "transaction_idempotency": ["二重送信時のべき等性は未記載"]
  },
  "issues": {
    "conflicts": [
      {
        "id": "C1",
        "documents": ["基本設計書_v2 §3", "画面設計書 §5"],
        "description": "数量上限が一方は1000、他方は9999",
        "both_statements": ["基本設計: 1000", "画面設計: 9999"]
      }
    ],
    "undefined": [
      { "id": "U1", "topic": "在庫不足時のエラー応答", "need": "コードとメッセージの指定が必要" }
    ],
    "implicit_assumptions": [
      { "id": "I1", "description": "業界慣行として注文確定前に与信チェックがある前提と思われる" }
    ]
  },
  "version_diff": [
    { "from": "v1", "to": "v2", "change": "税率の記述が固定→設定参照に変更" }
  ]
}
```

- 受領設計書を**要約・翻案しない**。実装に必要な情報のみ `extracted_points` に抽出。
- 矛盾は `issues.conflicts` に**両方の記述を保存**。未定義は `issues.undefined`、暗黙前提は `issues.implicit_assumptions`。
- 複数バージョンがある場合は最新を優先しつつ差分を `version_diff` に記録。
- ここで挙げた `issues` は派生仕様に混ぜず、人ゲート①' で解消する。

---

## 参照される側のクイックマップ

| §  | 成果物 | 生成元 |
|----|--------|--------|
| §1  | `03_implementation/{task_id}.report.json` | implementer / implement |
| §2  | `reviews/{impl,design,test}-*.json` | implementation-reviewer / design-reviewer / test-reviewer / focused-review |
| §3  | `{phase}/{target}.uncertainty.json` | uncertainty-auditor / uncertainty-report |
| §4  | `04_test/scenarios-{feature}.{unit,e2e}.json` | test-scenario-designer / test-scenario |
| §5  | `02_design/{decision_id}.debate.md` | design-decision / design-architect |
| §6  | `handoff/handoff-{YYYY-MM-DD}-{seq}.md` | handoff-writer / handoff |
| §7  | `reviews/pipeline-improve-{YYYY-MM}.md` | pipeline-improve |
| §8  | `00_onboarding/{region}/analysis-{runN}.json` | legacy-analyzer |
| §8b | `00_onboarding/{region}/aggregation.json` | analysis-aggregator |
| §9  | `01_requirements/{feature}.sier-readout.json` | sier-spec-reader |
