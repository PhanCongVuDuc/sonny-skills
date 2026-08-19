---
name: spec-draft
description: 要件・ユーザストーリーから仕様書ドラフトを生成する。正常系・異常系・トランザクション境界・未決定事項を必ず含める構造。
---

# spec-draft

## いつ使うか
- ユーザストーリー・要件メモ・口頭説明を仕様書に変換するとき
- 仕様書の構造を統一したいとき

## 入出力
- 入力：要件、[`docs/domain/business_rules.md`](../../../docs/domain/business_rules.md) の関連セクション
- 出力：`deliverables/01_requirements/{feature}.spec.md`

## 最低限の守るルール
- 「未決定事項」セクションは**必ず存在させる**（空でも見出しは残す）
- 異常系・エラーフローは正常系と同等以上の分量を確保
- 業務ルールは推測で埋めない。不明なら未決定事項に
- コードは書かない

仕様書の構成・詳細な作成手順は [`reference.md`](reference.md) を参照。
