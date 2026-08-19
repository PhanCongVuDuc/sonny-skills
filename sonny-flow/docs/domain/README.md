# docs/domain — ドメイン知識ドキュメント

このディレクトリは `/arent-workflow:setup` がプロジェクトへ注入したドメイン知識の置き場です。
**AI が実装・設計の根拠として参照する正典**であり、コードからは読み取れない業務知識・技術選定の背景・用語をここに集約します。

> 旧来の `docs/domain-template/` を手動コピー（`cp -r`）する運用は廃止しました。
> Plugin の `/arent-workflow:setup` が雛形を注入し、`/arent-workflow:onboarding` が初期内容を提案します。

## 3層構造（所有モデル）

```
docs/domain/
├── business_rules.md   ← 【不変層】業務有識者が管理。AI は読む専用（提案は人間承認後のみ）
├── tech_stack.md       ← 【不変層】技術選定の根拠。AI は読む専用
├── glossary.md         ← 【不変層】用語の定義。AI は読む専用
├── known_patterns.md   ← 【半固定層】パターン集。AI が提案し、人間が承認して記録
└── generated/          ← 【自動生成層】docs-keeper エージェントが自動更新
    ├── code_map.md
    ├── dependencies.md
    └── module_index.md
```

| ファイル | 用途 | 管理者 |
|---|---|---|
| `business_rules.md` | 業務ルール（不変制約・計算式・ステータス遷移・例外・法規制・承認フロー） | 人間（業務有識者） |
| `tech_stack.md` | 採用技術・バージョン・選択理由 | 人間（技術有識者） |
| `glossary.md` | 用語集（業界用語・社内略語・コード語彙との対応） | 人間（有識者＋開発者） |
| `known_patterns.md` | 設計パターン・コーディング規約の実例 | AI 提案 → 人間承認 |
| `generated/*.md` | コード地図・依存関係・公開API一覧 | `docs-keeper` エージェント（自動） |

## arent-workflow Plugin との連携

- `docs-keeper` エージェントがコード変更を検知して `generated/` の3ファイルを自動更新する（業務ルールは扱わない＝人間管理）。
- `.claude/rules/domain-knowledge.md` が `src/**` 等の編集時に `business_rules.md` 参照を Claude に促す。コードとドキュメントが矛盾する場合は**ドキュメントを正**とし、差分は人間に提案する。
- `/arent-workflow:onboarding existing` が初回セットアップ時に既存コードを解析し、`generated/` を生成 ＋ `business_rules.md`／`known_patterns.md` への追記を**提案**する（自動反映はしない）。
- CI/手動で再生成したい場合は `scripts/update-ai-docs.sh force`（または `.ps1 force`）を実行する。

## 編集ルール

- 不変層（business_rules / tech_stack / glossary）は**人間が書く**。AI は読むだけで、勝手に上書きしない。
- 半固定層（known_patterns）は AI が候補を提案し、人間が承認したものだけを記録する。
- 自動生成層（generated/）は**手で編集しない**（次回の自動更新で上書きされる）。
