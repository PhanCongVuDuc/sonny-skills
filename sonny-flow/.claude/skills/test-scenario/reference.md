# test-scenario ─ 詳細手順

## 手順
1. **レベルを決める**：`unit`（単体）or `e2e`（エンドツーエンド）。両方必要ならSkillを2回回す
2. 対象機能の仕様書を読む（`{feature}.spec.md` or `.derived-spec.md`）
3. `docs/domain/business_rules.md` を読み、業務ルールの境界を把握
4. レベルごとのカテゴリでシナリオを生成
5. 各シナリオに必須フィールドを付ける（下記）
6. 出力JSONに書き出す

## レベル別カテゴリ

### unit（単体テスト）
- `boundary-value`（0件・最大件数・NULL・空・最大桁数・負数）
- `business-rule-boundary`（端数・閾値ちょうど・期末・月末）
- `processing-order`（前提処理スキップ）
- `partial-failure`（複数ステップの途中エラー）
- `concurrency`（同時実行・競合）

### e2e（エンドツーエンドテスト）
- `user-flow-error`（ユーザ動線の異常：途中で戻る・閉じる・タイムアウト）
- `cross-module-state`（モジュール跨ぎの状態整合：注文→在庫→請求の連鎖）
- `integration-failure`（外部連携失敗：決済・通知・認証）
- `auth-boundary`（認可境界：他ユーザのデータが見えない）
- `data-leak`（権限外データ表示の有無）

## 各シナリオの必須フィールド

- 共通：`id`, `category`, `name`, `preconditions`, `steps`, `expected`, **`miss_impact`**
- e2e追加：`entry_point`（画面/URL/API）, `actors`（誰が操作するか）

## 守るべき詳細ルール
- **正常系（happy-path）シナリオを出さない**（AIが最も得意な領域なので人が追加する）
- `miss_impact`（見落とした場合の影響）を1行で必ず付ける
- 業務ルールが不明なシナリオには `（要確認）` を付ける
- 仕様書ベースで生成する（実装コードを見て「あるべき動作」を逆算しない）
- 単体とe2eを**1ファイルに混ぜない**（テスト実装が混乱する）
