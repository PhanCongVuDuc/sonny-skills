---
name: transcript-to-usecase
description: vtt等の音声書き起こしファイルから、ユースケース・ユーザストーリー・業務ルール候補を抽出する。長文は章単位に分割処理。
---

# transcript-to-usecase

## いつ使うか
- ヒアリング会議の録画書き起こし（vtt/srt/txt）から要件を起こすとき
- インタビューを `usecase-interview` Skillで実施できなかった代替

## 入出力
- 入力：書き起こしファイル（場所はCLAUDE.mdの「Input配置」セクション参照）
- 出力：
  - `deliverables/01_requirements/{feature}.from-transcript.md`
  - `deliverables/01_requirements/{feature}.transcript-refs.json`（行番号対応）
  - `deliverables/01_requirements/{feature}.uncertainty.json`

## 最低限の守るルール
- 5000行超 / 100KB超のファイルは**章/トピックで分割**してから処理（一度に全体を読み込まない）
- 発言の解釈を補完しない。発言ベースで残し、補完が必要な箇所は `(推測)` を付ける
- 話者名・個人名を含めない（役割名「PM」「業務担当者」等に置換）
- 抽出後は必ず `requirements-organizer` の人インタビューで補強する（書き起こしだけで要件確定しない）

抽出観点・章分割の方法は [`reference.md`](reference.md) を参照。
