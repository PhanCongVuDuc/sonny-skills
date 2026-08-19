# code-archeology ─ 詳細手順

## 手順
1. 対象コードを指定（ファイル単位 or 領域単位）
2. 以下の観点で抽出（「機能の説明」ではなく「なぜそう書いたか」が中心）
3. 推測には必ず `（推測）` を付ける
4. 結果を構造化出力

## 抽出する観点

1. このコードが存在する**業務上の理由**
2. 実装上の判断・工夫の跡（なぜこの構造か）
3. 後から追加された可能性がある箇所（コーディングスタイル不一致）
4. 依存している**暗黙の前提・事前条件**
5. マジックナンバー・特殊条件分岐の**業務的意味の推測**
6. 変更すると最もリスクが高い箇所と理由

## 出力構造

```json
{
  "target": "src/domain/Pricing.ts",
  "items": [
    {
      "type": "business_rule_hint",
      "location": "Pricing.ts:42",
      "code_excerpt": "if (amount > 1000000) return amount * 0.95;",
      "interpretation": "100万円超は5%値引き（理由は推測）",
      "confidence": "guess",
      "question_for_human": "100万円閾値と5%値引きの業務的根拠は？"
    },
    {
      "type": "implicit_assumption",
      "location": "Order.ts:78",
      "interpretation": "顧客IDは関数呼び出し前に検証済みと想定",
      "confidence": "high",
      "question_for_human": null
    }
  ]
}
```

## 守るべき詳細ルール
- 「コードを読めば分かる機能の再説明」をしない（**なぜ**にフォーカス）
- 推測と確証を必ず区別する（`（推測）` `（確証）` `（不明）`）
- コードを変更しない（読み取り専用）
- 業界慣行で説明できる箇所と、このプロジェクト固有の処理を区別する
- 抽出結果が**直接 `docs/domain/business_rules.md` に上書きされない**ことを意識（必ず人ゲートを通る）
- `confidence: guess` の項目は人ゲート⓪-3 で必ず確認される
