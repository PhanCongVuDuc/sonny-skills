---
name: design-decision
description: 複数候補のある設計判断をディベート形式（推進者A・推進者B・中立な審判）で並べる。AIに結論を出させずに人が判断する。
---

# design-decision

## いつ使うか
- アーキテクチャ・技術選定の選択肢を比較したいとき
- 複数の設計案を中立的に整理したいとき
- 1つに見える設計に「他に選択肢はないか」を問いたいとき

## 入出力
- 入力：選択肢（最大4つ）、前提条件（規模・チームスキル・制約・将来計画）
- 出力：`deliverables/02_design/{decision_id}.debate.md`（[`.claude/rules/output-formats.md`](../../rules/output-formats.md) §5 形式）

## 最低限の守るルール
- AIが「どちらが良い」と結論を述べることは禁止
- 各推進者の主張は3点ずつ均等に出す（片方が薄くならないように）
- 前提条件が不足していたら、推測で埋めずに「（要確認）」で報告

詳細な3ステップ進行は [`reference.md`](reference.md) を参照。
