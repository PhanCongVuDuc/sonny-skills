# Skills Catalog

Danh mục toàn bộ skill đang cài, tra theo tên gọi. **Cách gọi:** `plugin:skill`
(vd `revit-ui:revit-ribbon`, `mattpocock-skills:grilling`).

- Cập nhật: 2026-08-12
- Tổng: **71 skill** — revit-skills (34) · mattpocock (35) · my-skills (1) · vercel-skills (1)
- Tổng quan nhà cung cấp: xem [README.md](README.md).

---

## revit-skills
> Nguồn: github `Nice3point/revit-skills` · autoUpdate ✅ · 7 plugin · 34 skill

### `dotnet` — C#/.NET nền tảng
| Gọi | Mô tả |
|---|---|
| `dotnet:csharp-style` | Viết/review code C# theo chuẩn. |
| `dotnet:technical-writing` | Viết/review văn bản kỹ thuật (markdown, README, wiki). |
| `dotnet:writing-xml-doc-comments` | Viết/review XML doc comment cho public API C#. |

### `dotnet-advanced` — Kiến trúc & runtime .NET
| Gọi | Mô tả |
|---|---|
| `dotnet-advanced:binding-and-validating-options` | Bind config section vào options class + validate lúc startup. |
| `dotnet-advanced:configuring-dotnet-dependency-injection` | Đăng ký service & chọn lifetime trên `IServiceCollection`. |
| `dotnet-advanced:configuring-dotnet-hosting` | Cấu hình host .NET (`IHostApplicationBuilder`) + extension feature. |
| `dotnet-advanced:designing-dotnet-types` | Chọn loại type phù hợp (static class, extension, service, record...). |
| `dotnet-advanced:dotnet-source-generated-logging` | Viết log bằng `LoggerMessage` source generator. |

### `revit-api` — Tự động hóa model Revit
| Gọi | Mô tả |
|---|---|
| `revit-api:revit-api-option-handlers` | Dùng handler sẵn của Toolkit cho callback nhỏ (`IFamilyLoadOptions`...). |
| `revit-api:revit-code-style` | Cấu trúc code Revit API (ranh giới API, transaction, thread affinity). |
| `revit-api:revit-element-and-parameter-access` | Đọc/ghi element & parameter bằng fluent accessor. |
| `revit-api:revit-element-collector` | Query model bằng `FilteredElementCollector` fluent. |
| `revit-api:revit-failure-handling` | Chặn/tự xử warning & failure trong thao tác API. |
| `revit-api:revit-utils-extensions` | Thay `*Utils` static bằng extension fluent của Nice3point. |

### `revit-ui` — Giao diện add-in Revit
| Gọi | Mô tả |
|---|---|
| `revit-ui:revit-command-and-application` | Tạo entry point add-in bằng base class Toolkit. |
| `revit-ui:revit-context-access` | Truy cập Application/UiApplication/ActiveDocument, suppress dialog. |
| `revit-ui:revit-context-menu` | Thêm menu chuột phải bằng fluent API. |
| `revit-ui:revit-dockable-pane` | Đăng ký dockable pane WPF. |
| `revit-ui:revit-external-events` | Chạy API work từ code ngoài Revit API context. |
| `revit-ui:revit-ribbon` | Dựng ribbon (panel, button) bằng fluent API. |
| `revit-ui:revit-selection-filter` | Lọc element user được phép pick khi selection. |

### `revit-solution` — Cấu hình & đóng gói project
| Gọi | Mô tả |
|---|---|
| `revit-solution:revit-addin-bundle` | Đóng gói add-in thành bundle App Store có version. |
| `revit-solution:revit-addin-debugging` | Cấu hình launch Revit + attach debugger từ IDE. |
| `revit-solution:revit-addin-publishing` | Copy add-in + `.addin` manifest sang Revit / `bin/publish`. |
| `revit-solution:revit-api-references` | Tham chiếu assembly Revit API qua NuGet Nice3point. |
| `revit-solution:revit-assembly-resolution` | Định tuyến assembly resolution về thư mục plugin (fix FileNotFound). |
| `revit-solution:revit-dependency-isolation` | Cô lập dependency tránh xung đột giữa các add-in. |
| `revit-solution:revit-multi-version-configuration` | Hỗ trợ nhiều version Revit trong 1 project (`#if REVIT####`). |
| `revit-solution:revit-sdk-project-configuration` | Cấu hình `.csproj` với `Nice3point.Revit.Sdk`. |
| `revit-solution:revit-template-migration` | Nâng cấp project scaffold lên template/SDK mới. |
| `revit-solution:scaffolding-revit-projects` | Scaffold project add-in/benchmark/test từ template. |

### `revit-testing` — Test Revit API
| Gọi | Mô tả |
|---|---|
| `revit-testing:revit-test-fixtures` | Cấp document/service/data case cho test Revit API. |
| `revit-testing:revit-testing` | Viết/chạy test Revit API chạy trong Revit (TUnit.Revit). |

### `revit-benchmarking` — Đo hiệu năng
| Gọi | Mô tả |
|---|---|
| `revit-benchmarking:revit-benchmarking` | Viết/chạy BenchmarkDotNet đo hiệu năng chạy trong Revit. |

---

## mattpocock
> Nguồn: github `mattpocock/skills` · autoUpdate ✅ · 1 plugin `mattpocock-skills` · 35 skill

### Engineering
| Gọi | Mô tả |
|---|---|
| `mattpocock-skills:ask-matt` | Router — hỏi skill/flow nào hợp tình huống. |
| `mattpocock-skills:code-review` | Review thay đổi từ 1 mốc theo 2 trục Standards & Spec (2 sub-agent song song). |
| `mattpocock-skills:codebase-design` | Từ vựng chung để thiết kế "deep module". |
| `mattpocock-skills:diagnosing-bugs` | Vòng lặp chẩn đoán bug khó & hồi quy hiệu năng. |
| `mattpocock-skills:domain-modeling` | Dựng & mài domain model, ghi ADR. |
| `mattpocock-skills:grill-with-docs` | Phỏng vấn truy vấn để mài plan + tạo ADR/glossary song song. |
| `mattpocock-skills:implement` | Triển khai công việc theo spec/tickets. |
| `mattpocock-skills:improve-codebase-architecture` | Quét cơ hội "deepening", báo cáo HTML, rồi grill cái được chọn. |
| `mattpocock-skills:prototype` | Dựng prototype vứt đi để trả lời câu hỏi thiết kế. |
| `mattpocock-skills:research` | Nghiên cứu từ nguồn tin cậy, lưu findings ra file markdown. |
| `mattpocock-skills:resolving-merge-conflicts` | Xử lý merge/rebase conflict đang dở. |
| `mattpocock-skills:setup-matt-pocock-skills` | Cấu hình repo cho bộ engineering skills (issue tracker, triage label...). |
| `mattpocock-skills:tdd` | Phát triển hướng test (red-green-refactor). |
| `mattpocock-skills:to-spec` | Biến hội thoại hiện tại thành spec, đẩy lên issue tracker. |
| `mattpocock-skills:to-tickets` | Chẻ plan/spec thành ticket tracer-bullet có edge phụ thuộc. |
| `mattpocock-skills:triage` | Đưa issue/PR qua state machine triage, viết brief cho agent. |
| `mattpocock-skills:wayfinder` | Lập bản đồ khối việc lớn thành ticket quyết định, giải từng cái. |
| `mattpocock-skills:wizard` | Sinh wizard bash tương tác hướng dẫn người làm bước thủ công. |

### Productivity
| Gọi | Mô tả |
|---|---|
| `mattpocock-skills:grill-me` | Phỏng vấn truy vấn để mài plan/design (gọi `/grilling`). |
| `mattpocock-skills:grilling` | Grill người dùng liên tục để stress-test suy nghĩ. |
| `mattpocock-skills:handoff` | Nén hội thoại thành tài liệu handoff cho agent khác. |
| `mattpocock-skills:teach` | Dạy người dùng 1 kỹ năng/khái niệm mới. |
| `mattpocock-skills:to-questionnaire` | Biến quyết định chưa trả lời được thành bảng câu hỏi cho người khác. |
| `mattpocock-skills:wait-what` | Dừng — tin nhắn vừa rồi chưa "vào", pitch lại. |
| `mattpocock-skills:writing-for-agents` | Viết tài liệu cho agent (skill, AGENTS.md, CLAUDE.md). |

### In-progress (đang phát triển)
| Gọi | Mô tả |
|---|---|
| `mattpocock-skills:claude-handoff` | Bàn giao hội thoại cho 1 background agent làm tiếp ngay. |
| `mattpocock-skills:loop-me` | Grill về spec cho workflow muốn xây, trong workspace. |
| `mattpocock-skills:setup-ts-deep-modules` | Gắn dependency-cruiser vào repo TS để mỗi package là deep module. |
| `mattpocock-skills:writing-beats` | Viết (exploit) — ráp nguyên liệu thành chuỗi "beats". |
| `mattpocock-skills:writing-fragments` | Viết (explore) — đào fragment thô, chưa cấu trúc. |
| `mattpocock-skills:writing-shape` | Viết (exploit) — nắn nguyên liệu thành bài, từng đoạn. |

### Misc
| Gọi | Mô tả |
|---|---|
| `mattpocock-skills:git-guardrails-claude-code` | Cài hook chặn lệnh git nguy hiểm trong Claude Code. |
| `mattpocock-skills:migrate-to-shoehorn` | Chuyển test từ `as` assertion sang `@total-typescript/shoehorn`. |
| `mattpocock-skills:scaffold-exercises` | Tạo cấu trúc thư mục bài tập (section/problem/solution). |
| `mattpocock-skills:setup-pre-commit` | Cài Husky pre-commit + lint-staged (Prettier), typecheck, test. |

---

## my-skills
> Nguồn: local `my-skills/` · skill tự viết · 1 skill

| Gọi | Mô tả |
|---|---|
| `my-skills:hello-skill` | Skill mẫu kiểm tra local marketplace hoạt động. |

---

## vercel-skills
> Nguồn: vendored `vendored/vercel-skills/` (clone `vercel-labs/skills` + manifest tự thêm) · cập nhật `git pull` tay · 1 skill

| Gọi | Mô tả |
|---|---|
| `vercel-skills:find-skills` | Giúp tìm & cài agent skill từ hệ sinh thái. |
