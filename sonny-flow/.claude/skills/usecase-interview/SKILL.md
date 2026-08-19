---
name: usecase-interview
description: ユースケース・ユーザストーリーと暗黙の業務ルールをインタビュー形式で引き出す。質問は1つずつ。最後にMarkdownへ整理。
---

# usecase-interview

## いつ使うか
- 新規機能の要件整理を始めるとき
- 既存仕様書の暗黙の前提を可視化したいとき
- ドメイン知識（[`docs/domain/business_rules.md`](../../../docs/domain/business_rules.md)）を埋めるとき

## 入出力
- 入力：プロジェクトの業界・システム種別・対象機能、既存ドキュメント（あれば）
- 出力：`deliverables/01_requirements/{feature}.requirements.md`

## 最低限の守るルール
- 一度に複数質問しない（1問1答）
- ユーザ回答を勝手に解釈・補完しない
- 自分で答えを推測して質問をスキップしない

詳細な質問観点・進め方は [`reference.md`](reference.md) を参照。
