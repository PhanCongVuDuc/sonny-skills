---
description: 音声書き起こし（vtt/srt/txt）からユースケース・ユーザストーリーを抽出する。/setup の Q4 で「書き起こしあり」なら Phase 1 入口として使う。長文は章分割で処理。
---

`/setup` の Q4 で「書き起こしあり」と回答した場合に Phase 1 の入口として使う。書き起こしファイルを起点に Phase 1 を開始する。

進め方：

1. **入力確認**：CLAUDE.md の Input 配置で「書き起こしファイル」の場所を確認
2. [`transcript-extractor`](../agents/transcript-extractor.md) エージェントを起動（[`transcript-to-usecase`](../skills/transcript-to-usecase/SKILL.md) Skillを使う）
   - 大きいファイルは章/トピックで分割して処理
   - 出力：
     - `deliverables/01_requirements/{feature}.from-transcript.md`
     - `deliverables/01_requirements/{feature}.transcript-refs.json`（元ファイル行番号への参照）
3. [`uncertainty-auditor`](../agents/uncertainty-auditor.md) を続けて起動
4. **人レビュー**：書き起こしだけでは要件が確定しないことが多い。`/req` で `requirements-organizer` のインタビューに続けて、不足分を埋める
5. その後 `/spec` で仕様書ドラフトに進む

**重要：** 書き起こしには発言者の言い間違い・記憶違い・前提省略が含まれる。**書き起こしの内容だけで要件確定しないこと。** 必ず人インタビューで補強する。

引数（任意）：`$ARGUMENTS` に対象機能名を渡す。
