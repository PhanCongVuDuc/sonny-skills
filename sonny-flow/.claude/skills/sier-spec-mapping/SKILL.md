---
name: sier-spec-mapping
description: SIer受領設計書から「実装可能な派生仕様」へのマッピングを行う。/setup で「設計書あり」と回答した場合の Phase 1 入口で使う。
---

# sier-spec-mapping

## いつ使うか
- SIerなど外部受領設計書を起点に実装するとき（/setup の Q3 で「設計書あり」と回答した場合の Phase 1 入口）
- 受領設計書をそのまま implementer に渡せない（粒度・矛盾・未定義のため）

## 入出力
- 入力：受領設計書（場所はCLAUDE.mdの「Input配置」セクション参照）
- 出力：
  - `deliverables/01_requirements/{feature}.derived-spec.md`：派生仕様（implementer 入力）
  - `deliverables/01_requirements/{feature}.sier-readout.json`：矛盾・未定義リスト
  - `deliverables/01_requirements/{feature}.uncertainty.json`：推測箇所レポート

## 最低限の守るルール
- **受領設計書を要約・言い換えしない**。実装に必要な情報だけを抽出
- 設計書に書かれていない処理を「気を利かせて」追加しない
- 矛盾・未定義は派生仕様に含めない（`issues` に積む）
- 必ず**人ゲート①'**を通す。`issues` を解消してから implementer に進む
- 受領設計書のバージョンを `derived-spec.md` の冒頭に必ず明記する

抽出観点の詳細は [`reference.md`](reference.md) を参照。
