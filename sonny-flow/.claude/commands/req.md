---
description: Phase 1：要件・ユースケース・ユーザストーリーをインタビュー形式で整理し、推測箇所レポートも併せて出力する
---

[`requirements-organizer`](../agents/requirements-organizer.md) エージェントを起動し、[`usecase-interview`](../skills/usecase-interview/SKILL.md) Skillで暗黙の業務ルールも含めて整理する。

進め方：
1. 対象機能・業界・システム種別を確認
2. 質問を**1つずつ**出す（数値計算 → 例外処理 → データ制約 → 特例 → 暗黙の前提 → 法規制 → 処理順序）
3. 整理結果を `deliverables/01_requirements/{feature}.requirements.md` に書き出す
4. 続けて [`uncertainty-auditor`](../agents/uncertainty-auditor.md) を起動し `deliverables/01_requirements/{feature}.uncertainty.json` を生成（推測箇所レポート。形式は [`output-formats.md`](../rules/output-formats.md) §3）
5. 続けて [`spec-drafter`](../agents/spec-drafter.md) を呼ぶか確認する

引数（任意）：`$ARGUMENTS` に対象機能名を渡せる。
