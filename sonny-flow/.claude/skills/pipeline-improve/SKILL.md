---
name: pipeline-improve
description: 直近のAI駆動開発サイクルで記録した「人が修正した箇所と理由」ログを分析し、ルール・パイプラインの改善案をBefore/After形式で出力する。
---

# pipeline-improve

## いつ使うか
- 3ヶ月に1度の定期レビュー（[`docs/agent-rules.md`](../../../docs/agent-rules.md) のサイクル）
- AIの同種ミスが繰り返し発生していると感じたとき
- ルールファイルが肥大化してきたとき

## 入出力
- 入力：`deliverables/reviews/*.json` の `verdict: 問題あり`、`deliverables/03_implementation/*.report.json` の `assumptions(risk: high)`、人が訂正したgit diff
- 出力：`deliverables/reviews/pipeline-improve-{YYYY-MM}.md`（[`.claude/rules/output-formats.md`](../../rules/output-formats.md) §7 形式）

## 最低限の守るルール
- 「廃止できるルール」も必ず探す（追加ばかりだとルールが肥大化する）
- ルール変更案は**具体的な文言**で出す（「気を付ける」のような抽象表現は禁止）
- 過去のレポートを読んで、同じ改善案を繰り返し出していないか確認する
- このSkillの結果を **直接 `.claude/agents/*.md` に書き込まない**（必ず人の承認を得る）

分析の進め方は [`reference.md`](reference.md) を参照。
