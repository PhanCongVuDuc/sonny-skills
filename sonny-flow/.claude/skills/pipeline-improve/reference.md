# pipeline-improve ─ 詳細手順

## 手順
1. 入力ログを集める：
   - `deliverables/reviews/*.json` 内の `verdict: 問題あり` 項目
   - `deliverables/03_implementation/*.report.json` の `assumptions` で `risk: high` のもの
   - 人が訂正した箇所（git diff で実装後に直された差分があれば収集）
2. 失敗をカテゴリ分類（[`.claude/rules/risk-categories.md`](../../rules/risk-categories.md) のキーを使う）
3. 上位3カテゴリを抽出し、それぞれについて分析：
   - なぜそのカテゴリが多いか
   - どのエージェントのルールが原因か
   - ルール変更案（Before → After）
4. **このルール変更でカバーできない失敗**を明示
5. **廃止・統合候補ルール**を提案

## 出力フォーマット

```markdown
# パイプライン改善分析（{年月}）

## 最多失敗カテゴリ（上位3つ）
1. カテゴリ名 - 件数 - 主な原因
2. ...

## 変更すべきルール
| 対象 | Before | After |
|---|---|---|
| .claude/agents/implementer.md | ... | ... |

## このルール変更でカバーできない失敗
-（人レビューで継続対応が必要なもの）

## 廃止・統合候補ルール
-（増えすぎているルールの整理案）
```

## 守るべき詳細ルール
- 「廃止できるルール」も必ず探す（追加ばかりだとルールが肥大化する）
- ルール変更案は**具体的な文言**で出す（「気を付ける」のような抽象表現は禁止）
- このSkillの結果をもとに `.claude/agents/*.md` を**直接編集する前に**、必ず人の承認を得る
- 過去のレポート（`pipeline-improve-{YYYY-MM}.md`）を読んで、同じ改善案を繰り返し出していないか確認する
- 失敗件数だけでなく **影響の重さ** も考慮する（5件のlow-impactより1件のhigh-impactを優先）
