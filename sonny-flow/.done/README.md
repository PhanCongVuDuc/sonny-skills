# .done/

エージェントのべき等性を担保するための**完了フラグファイル**を置く場所。

## 仕組み

エージェントは処理開始前にここに `{task_id}.done` があるかを確認し、あればスキップする。
これにより：

- パイプライン途中で失敗してリトライしたときに同じ処理を2回実行しない
- Usage limit にヒットしたあと再開すると未処理分だけ進む
- 同じ機能の再生成を防ぐ

## ファイル名規約

- `{task_id}.done` ：タスク単位
- `{feature}-{phase}.done` ：フェーズ単位（例：`order-create-spec.done`）

## 中身

タイムスタンプ・完了したフェーズ・成果物パスをJSON1行で書く例：

```json
{"task_id": "form_001", "completed_at": "2026-05-19T10:30:00+09:00", "phase": "implementation", "artifact": "deliverables/03_implementation/form_001.report.json"}
```

## 削除

- 再実行したいときはこのフォルダ内の該当ファイルを削除する
- 全リセットしたいときはこのフォルダ配下を空にする（`.gitkeep` と `README.md` 以外）
