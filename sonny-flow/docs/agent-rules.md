# エージェント設計ルール（agent-rules）

`.claude/agents/` のサブエージェント定義と、それを呼ぶスキル・コマンドが守る設計ルール。
新しいエージェントを追加・分割するとき、および定期レビュー（`pipeline-improve`）の判断基準にする。

---

## 基本原則

1. **1エージェント＝1責務・1観点**。レビュー系は「1呼び出し1観点」を厳守し、観点外の問題に気づいても黙殺する（別呼び出しで扱う）。
2. **出力は構造化**。各エージェントの成果物フォーマットは [`.claude/rules/output-formats.md`](../.claude/rules/output-formats.md)（§1〜§9）に従う。自然言語の「できました」を進行根拠にしない。
3. **観点キー・リスクカテゴリは共通定義を使う**。独自カテゴリを発明せず [`.claude/rules/risk-categories.md`](../.claude/rules/risk-categories.md) のキーを使う。
4. **推測は隠さない**。確証のない点は `（推測）` / `uncertainty` / ABCD分類で必ず申告する（[`output-formats.md`](../.claude/rules/output-formats.md) §3）。
5. **フェーズ移行は人ゲート**。エージェントは「人が確認すべき項目」を絞り込むところまで。承認の判断は人が行う（[`.claude/rules/gates.md`](../.claude/rules/gates.md)）。

---

## エージェント分割の基準

| 分割すべきとき | 例 |
|---|---|
| 観点が増えて1エージェントの責務が肥大化 | 実装レビューを観点別（trans境界 / 数値精度 / 性能…）に並列化 |
| 「生成」と「検証」が混ざっている | `implementer`（生成）と `implementation-reviewer`（検証）を分ける |
| 「解析」と「集約」が混ざっている | `legacy-analyzer`（1領域解析）と `analysis-aggregator`（突き合わせ）を分ける |
| 独立した別セッションで多重実行したい | 並列解析（同一領域を2回）→ 突き合わせ |

エージェントを増やしすぎたら `pipeline-improve` で**廃止・統合候補**を検討する（肥大化防止）。

---

## frontmatter 規約

```yaml
---
name: <kebab-case。ファイル名と一致させる>
description: いつ起動すべきかを第三者が判断できる三人称記述
model: sonnet | opus | haiku    # 慎重さが要るレビュー系は opus も可
tools: Read, Grep, Glob, ...    # 必要最小限。解析系は読み取り専用に絞る
---
```

- `name` は必ずファイル名（拡張子なし）と一致させる。
- 解析・レビュー系はコード変更を伴わないので `Write`/`Edit` を付けない（読み取り専用）。

---

## 定期レビューのサイクル

- **3ヶ月に1度**、`pipeline-improve` スキルで「人が修正した箇所と理由」を分析し、ルール／エージェント／パイプラインの改善案を Before/After で出す（[`output-formats.md`](../.claude/rules/output-formats.md) §7）。
- 改善案は**そのまま貼れる具体文言**で出し、`.claude/rules/*.md` や `.claude/agents/*.md` への反映は**人の承認後**に行う（エージェントが直接書き込まない）。
- 追加ばかりでルールが肥大化しないよう、**廃止できるルール・エージェントも必ず探す**。
