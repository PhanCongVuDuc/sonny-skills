# parallel-analysis ─ 詳細手順

## 手順
1. **対象を1領域に絞る**（コード全体を一度に渡さない）。領域定義は `deliverables/00_onboarding/regions.json`
2. **独立セッション**で `legacy-analyzer` を2回起動（run-1, run-2）。同じプロンプトを渡す
   - セッションを共有するとコンテキスト汚染で結果が似てしまう。**必ず別セッション**
   - 余裕があれば run-3 まで増やす（3-of-3 一致が confirmed の最強保証）
3. それぞれの結果を `analysis-run1.json`, `analysis-run2.json` として保存
4. `analysis-aggregator` を起動して突き合わせ：
   - `confirmed`：両方一致 → 信頼度=高
   - `divergent`：両方が違う結論 → 人レビュー必須
   - `partial`：片方しか触れていない → 人レビュー必須
5. 人ゲートで `divergent` と `partial` だけ確認する（`confirmed` は基本通す）

## 守るべき詳細ルール
- runごとに**必ず別セッション**で実行する（コンテキスト汚染の防止）
- run間で**プロンプトを変えない**（同一条件での比較が成立しなくなる）
- run結果を見てから「3run目はもう少しヒントを足そう」と思っても、それは別タスクの解析として残す（同一突き合わせには混ぜない）
- `confidence_rate` が 70% 未満なら、領域分割が粗すぎる可能性。領域を分割し直して再実行する
- 領域を跨ぐ問題に気づいても、当該領域のレポートには書かない（`legacy-analyzer` の責務外）

## confidence_rate の使い方

`aggregation.json` の `confidence_rate` は **(confirmed の項目数) / (総項目数)** で計算する。

| confidence_rate | 解釈 | 対応 |
|---|---|---|
| ≥ 0.90 | 解析の信頼度が非常に高い | 通常通り人ゲートへ |
| 0.70 〜 0.90 | 一定の信頼度。divergent/partialを人レビュー | 通常運用 |
| < 0.70 | 領域分割が粗い・対象コードが複雑すぎる | 領域を細かく分けて再実行を検討 |
