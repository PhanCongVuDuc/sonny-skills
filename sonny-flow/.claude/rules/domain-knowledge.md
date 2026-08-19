---
paths:
  - "Arent3d.Architecture.Routing*/**"
  - "Tests/**"
---

# ドメイン知識参照ルール

このルールは C# プロジェクト（`Arent3d.Architecture.Routing*` — Core / AppBase / Electrical.App / Presentation / Auth / RevitTest）と `Tests/` 配下のファイルを読み書きするときに自動的に適用されます。

## 実装・設計前に必ず参照するドキュメント

コードを新規作成・修正する前に、以下のドキュメントが存在する場合は必ず読むこと:

1. **`docs/domain/business_rules.md`** — 業務ルール・不変制約・計算式。実装の根拠になる。
2. **`docs/domain/glossary.md`** — 用語定義。変数名・コメント・API名に使う言葉を揃える。
3. **`docs/domain/known_patterns.md`** — 採用済みパターン。新規実装はここに倣う。
4. **`docs/domain/generated/code_map.md`** — モジュール地図。影響範囲の把握に使う。

ドキュメントが存在しない場合はスキップして構わないが、存在する場合はスキップしてはならない。

## 実装後に更新を検討するドキュメント

- `docs/domain/generated/` 配下は `docs-keeper` エージェントが自動更新する（`arent-workflow` Plugin 有効時）。
- 新しい業務ルールを発見した場合は、実装後に `docs/domain/business_rules.md` への追記を提案する。
- 新しい設計パターンを採用した場合は、`docs/domain/known_patterns.md` への追記を提案する。

## ドキュメントと実装が矛盾している場合

1. ドキュメント（`business_rules.md`）を正として扱い、コードの修正方向を検討する
2. どちらが正しいか判断できない場合は、ユーザーに確認してから進める
3. ドキュメントが明らかに古い場合は、更新を提案する（自動で書き換えない）
