---
name: parallel-analysis
description: 同じ対象を独立した複数エージェントで並列解析し、結果を突き合わせて信頼度の高い解析を作る。/setup の既存解析パスで精度を担保する主力Skill。
---

# parallel-analysis

## いつ使うか
- 既存コード解析で**初回の精度**が重要なとき
- AIの非決定性を逆手に取って「複数runで一致する部分」を信頼度=高として採用したいとき
- レビュー対象を「不一致箇所だけ」に絞り込みたいとき

## 入出力
- 入力：領域定義（`deliverables/00_onboarding/regions.json` の1領域）
- 出力：
  - `deliverables/00_onboarding/{region}/analysis-run1.json`
  - `deliverables/00_onboarding/{region}/analysis-run2.json`
  - `deliverables/00_onboarding/{region}/aggregation.json`

## 最低限の守るルール
- runごとに**必ず別セッション**で実行する（コンテキスト汚染の防止）
- run間で**プロンプトを変えない**（同一条件での比較が成立しなくなる）
- `confidence_rate` が 70% 未満なら、領域分割が粗すぎる可能性。再分割を検討
- 領域を跨ぐ問題は当該領域のレポートに書かない

並列実行の具体手順は [`reference.md`](reference.md) を参照。
