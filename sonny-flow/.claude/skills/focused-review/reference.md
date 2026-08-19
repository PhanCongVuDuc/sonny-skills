# focused-review ─ 詳細手順

## 標準手順
1. レビュー対象（設計書 or コード）と**1つの観点**を決める
2. 観点キーは [`.claude/rules/risk-categories.md`](../../rules/risk-categories.md) から選ぶ
3. その観点の具体的な確認ポイントを3〜5項目に展開して渡す
4. 対象外を明示する（命名規則・正常系・パフォーマンス等）
5. レビュー結果を3値で出力：

```json
{
  "items": [
    {"verdict": "問題あり", "location": "...", "issue": "...", "risk_level": "high"},
    {"verdict": "問題なし", "scope": "確認した観点"},
    {"verdict": "確認不能", "reason": "業務ルール未確認", "needed_info": "..."}
  ]
}
```

## 観点ごとの確認ポイントテンプレート

### transaction-boundary
- 複数のDB操作が1トランザクションで処理されるべき箇所が分割されていないか
- 部分失敗時のリカバリ処理が定義されているか
- ネストトランザクションの必要性

### numeric-precision
- int/float と decimal の混在
- 整数除算による意図しない切り捨て
- 丸め方式が業務ルールと合っているか

### error-business-logic
- catchブロック内に「単純なログ・例外の再スロー」以外があるか
- エラー種別による業務処理分岐
- エラー時の別テーブル書き込み・通知・補正

### performance
- ループ内DBクエリ（N+1）
- 全件取得後のアプリ側フィルタ
- 大量データの一括メモリ展開

その他の観点は [`.claude/rules/risk-categories.md`](../../rules/risk-categories.md) を直接参照。

## 守るべき詳細ルール
- **1呼び出し1観点**を厳守
- 「良い点」は出さない（指摘のみ）
- 「問題なし」も観点を明示して出す
- 観点に該当しない問題に気づいたら黙殺し、別呼び出しで対応する
- `risk_level: high/medium/low` を必ず付ける
- 「確認不能」のときは確認に必要な情報を明示する
