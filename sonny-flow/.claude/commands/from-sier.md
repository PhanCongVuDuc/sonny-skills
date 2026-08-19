---
description: SIerなど外部から受領した設計書を読み解き、派生仕様を作って実装フェーズに進む。/setup の Q3 で「設計書あり」なら Phase 1 入口として使う。
---

`/setup` の Q3 で「SIer受領設計書あり」と回答した場合に Phase 1 の入口として使う。受領設計書を入力に、implementer に渡せる**派生仕様**を作る。

進め方：

1. **入力確認**：CLAUDE.md の Input 配置で「SIer設計書」の場所を確認。ファイルが揃っていることをユーザに確認してもらう
2. [`sier-spec-reader`](../agents/sier-spec-reader.md) エージェントを起動（[`sier-spec-mapping`](../skills/sier-spec-mapping/SKILL.md) Skillを使う）
   - 出力：
     - `deliverables/01_requirements/{feature}.derived-spec.md`（派生仕様）
     - `deliverables/01_requirements/{feature}.sier-readout.json`（矛盾・未定義リスト）
3. [`uncertainty-auditor`](../agents/uncertainty-auditor.md) を続けて起動
   - 出力：`deliverables/01_requirements/{feature}.uncertainty.json`
4. **人ゲート①'**：以下をユーザに確認してもらう
   - `sier-readout.json` の `issues`（矛盾・未定義）への対処方針
   - `uncertainty.json` の `impact: high` 項目の確認
5. 確認が済んだら `/implement` で Phase 3 へ進む

**重要：** 受領設計書を実装エージェントに直接渡さないこと。必ず `derived-spec.md` 経由で渡す（設計書間の矛盾や未定義箇所が implementer に伝わると、推測実装が増える）。

引数（任意）：`$ARGUMENTS` に対象機能名を渡す。
