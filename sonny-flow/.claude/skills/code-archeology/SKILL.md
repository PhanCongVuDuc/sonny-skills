---
name: code-archeology
description: 既存コードから「開発者の意図」「業務上の理由」「暗黙の前提」を抽出する。/setup の既存解析パスで業務ルール候補を出す主力Skill。
---

# code-archeology

## いつ使うか
- /setup の既存解析パスで業務ルール候補を抽出するとき
- ドキュメントがないレガシーコードの「なぜそう書いたか」を知りたいとき
- 変更前に「動いている理由」を理解したいとき

## 入出力
- 入力：対象コード（ファイル単位 or 領域単位）
- 出力：
  - Phase 0：`deliverables/00_onboarding/business-rules-candidates.json`
  - 単発調査：`deliverables/00_onboarding/archeology-{target}.md`

## 最低限の守るルール
- 「コードを読めば分かる機能の再説明」をしない（**なぜ**にフォーカス）
- 推測と確証を必ず区別する（`（推測）` `（確証）` `（不明）`）
- コードを変更しない（読み取り専用）
- 抽出結果は**直接 `docs/domain/business_rules.md` に上書きしない**（必ず人ゲートを通る）

抽出観点・出力構造は [`reference.md`](reference.md) を参照。
