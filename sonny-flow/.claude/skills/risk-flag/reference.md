# risk-flag ─ 詳細手順

## 手順
1. 実装コードを読む（差分でも可）
2. 以下のリスクカテゴリに該当する箇所を抽出
3. 各箇所に `risk_level: high/medium/low` を付ける
4. JSON構造で出力（`human_review_required` フィールド）

## リスクカテゴリ（抽出対象）

- `numeric-precision`：丸め・型変換・整数除算
- `transaction-boundary`：複数DB操作・部分失敗
- `error-business-logic`：catch内のビジネスロジック
- `business-rule`：暗黙の業務ルールへの依存
- `concurrency`：非同期・スレッド安全性
- `security`：認証・認可・入力検証・情報漏洩

詳細な観点は [`.claude/rules/risk-categories.md`](../../rules/risk-categories.md) を参照。

## 出力フォーマット

```json
{
  "human_review_required": [
    {
      "location": "src/foo.ts:42",
      "category": "numeric-precision",
      "description": "金額計算で float を使用。decimal への置き換えが必要か確認",
      "risk_level": "high",
      "question_for_human": "金額計算の精度要件は？（最小単位は？）"
    }
  ]
}
```

## 守るべき詳細ルール
- フラグを立てる基準は [`.claude/rules/risk-categories.md`](../../rules/risk-categories.md) と一致させる
- `question_for_human` を必ず付ける（人が見たときに何を確認すればよいかを明示）
- 「フラグなし」を返す場合は、確認したカテゴリを明示する（`confirmed_categories: [...]`）
- 高頻度に重複するパターン（例：同じファイル内の同種の問題）は1つにまとめてよい
- `risk_level: high` の判定基準：業務影響・データ破損・セキュリティのいずれかに該当
