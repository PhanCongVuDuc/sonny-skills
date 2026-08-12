# SKILLS.md

> Sinh tự động bằng `node scripts/gen-skills.mjs`. **Đừng sửa tay.**

Tổng **71 skill** từ **10 plugin**.

| Plugin | Marketplace | Provenance | Version | Skills |
|---|---|---|---|---|
| `duc` | duc-skills | **own** | `f72348f5d7e7` | 1 |
| `dotnet-advanced` | revit-skills | third-party | `0.1.2` | 5 |
| `dotnet` | revit-skills | third-party | `0.1.2` | 3 |
| `find-skills` | duc-skills | third-party | `c6f69c631292-ed96bd46` | 1 |
| `mattpocock-skills` | mattpocock | third-party | `1.2.3` | 35 |
| `revit-api` | revit-skills | third-party | `0.1.2` | 6 |
| `revit-benchmarking` | revit-skills | third-party | `0.1.2` | 1 |
| `revit-solution` | revit-skills | third-party | `0.1.2` | 10 |
| `revit-testing` | revit-skills | third-party | `0.1.2` | 2 |
| `revit-ui` | revit-skills | third-party | `0.1.2` | 7 |

## `duc` — skill tự viết

| Skill | Mô tả |
|---|---|
| `duc:hello-skill` | Verify the duc-skills marketplace is wired up and loading. Use when the user says "hello-skill", "test skill", or asks whether their own skills marketplace is working. |

## `dotnet-advanced` — bên thứ 3

| Skill | Mô tả |
|---|---|
| `dotnet-advanced:binding-and-validating-options` | > Bind a configuration section to a typed options class and validate it at startup with the .NET options pattern. USE FOR: adding an options type, binding it from configuration, applying DataAnnotations or custom validation, and failing fast on invalid configuration with ValidateOnStart. DO NOT USE FOR: general host composition and the order of builder extensions (use configuring-dotnet-hosting). |
| `dotnet-advanced:configuring-dotnet-dependency-injection` | > Register and review .NET dependency-injection services and lifetimes on IServiceCollection. USE FOR: adding a registration, choosing singleton/scoped/transient, grouping registrations behind a feature extension, assembly scanning with Scrutor, or validating a service graph. DO NOT USE FOR: choosing which kind of type to declare (use designing-dotnet-types), or wiring the host builder and its lifecycle (use configuring-dotnet-hosting). |
| `dotnet-advanced:configuring-dotnet-hosting` | > Configure a .NET application host and its feature-registration extensions on IHostApplicationBuilder. USE FOR: composing HostApplicationBuilder/WebApplicationBuilder, writing IHostApplicationBuilder extension methods, wiring shared service defaults, and host startup and lifecycle. DO NOT USE FOR: choosing a service lifetime or a single registration (use configuring-dotnet-dependency-injection), or binding and validating an options section (use binding-and-validating-options). |
| `dotnet-advanced:designing-dotnet-types` | > Choose the right kind of .NET type for new behavior — static class, extension method, injected service, hosted service, options type, record, or interface. USE FOR: deciding how to shape a new unit of behavior or data before writing it, or reviewing that an existing type has the right shape for its dependencies and lifecycle. DO NOT USE FOR: registering a type or choosing its DI lifetime (use configuring-dotnet-dependency-injection). |
| `dotnet-advanced:dotnet-source-generated-logging` | > Write .NET logs with the LoggerMessage source generator for ILogger calls. USE FOR: adding or reviewing log statements built from [LoggerMessage] partial methods — message templates, log levels, event ids, exception logging, and logging scopes. |

## `dotnet` — bên thứ 3

| Skill | Mô tả |
|---|---|
| `dotnet:csharp-style` | > Write or review C# code. USE FOR: any C# you write or review. DO NOT USE FOR: prose, markdown, or wiki text (use technical-writing), or XML doc comment content (use writing-xml-doc-comments). |
| `dotnet:technical-writing` | > Write or review technical prose — markdown documentation, wiki pages, README or config comments. USE FOR: explaining a contract, behavior, decision, or API in human-readable text, and reviewing that prose says something a reader cannot already infer. DO NOT USE FOR: C# code comments (use csharp-style), or C# XML documentation comments (use writing-xml-doc-comments). |
| `dotnet:writing-xml-doc-comments` | > Write or review C# XML documentation comments on public API surface. USE FOR: adding XML documentation elements to public types and members. DO NOT USE FOR: prose, markdown, README, or wiki text (use technical-writing). |

## `find-skills` — bên thứ 3

| Skill | Mô tả |
|---|---|
| `find-skills:find-skills` | Helps users discover and install agent skills when they ask questions like "how do I do X", "find a skill for X", "is there a skill that can...", or express interest in extending capabilities. This skill should be used when the user is looking for functionality that might exist as an installable skill. |

## `mattpocock-skills` — bên thứ 3

| Skill | Mô tả |
|---|---|
| `mattpocock-skills:ask-matt` | Ask which skill or flow fits your situation. A router over the skills in this repo. |
| `mattpocock-skills:claude-handoff` | Hand the current conversation off to a fresh background agent that picks up the work immediately. |
| `mattpocock-skills:code-review` | Review the changes since a fixed point (commit, branch, tag, or merge-base) along two axes — Standards (does the code follow this repo's documented coding standards?) and Spec (does the code match what the originating issue/spec asked for?). Runs both reviews in parallel sub-agents and reports them side by side. Use when the user wants to review a branch, a PR, work-in-progress changes, or asks to "review since X". |
| `mattpocock-skills:codebase-design` | Shared vocabulary for designing deep modules. Use when the user wants to design or improve a module's interface, find deepening opportunities, decide where a seam goes, make code more testable or AI-navigable, or when another skill needs the deep-module vocabulary. |
| `mattpocock-skills:diagnosing-bugs` | Diagnosis loop for hard bugs and performance regressions. Use when the user says "diagnose"/"debug this", or reports something broken/throwing/failing/slow. |
| `mattpocock-skills:domain-modeling` | Build and sharpen a project's domain model. Use when the user wants to pin down domain terminology or a ubiquitous language, record an architectural decision, or when another skill needs to maintain the domain model. |
| `mattpocock-skills:git-guardrails-claude-code` | Set up Claude Code hooks to block dangerous git commands (push, reset --hard, clean, branch -D, etc.) before they execute. Use when user wants to prevent destructive git operations, add git safety hooks, or block git push/reset in Claude Code. |
| `mattpocock-skills:grill-me` | A relentless interview to sharpen a plan or design. |
| `mattpocock-skills:grill-with-docs` | A relentless interview to sharpen a plan or design, which also creates docs (ADR's and glossary) as we go. |
| `mattpocock-skills:grilling` | Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases. |
| `mattpocock-skills:handoff` | Compact the current conversation into a handoff document for another agent to pick up. |
| `mattpocock-skills:implement` | Implement a piece of work based on a spec or set of tickets. |
| `mattpocock-skills:improve-codebase-architecture` | Scan a codebase for deepening opportunities, present them as a visual HTML report, then grill through whichever one you pick. |
| `mattpocock-skills:loop-me` | Grill me about specs for the workflows I want to build, within this workspace. |
| `mattpocock-skills:migrate-to-shoehorn` | Migrate test files from `as` type assertions to @total-typescript/shoehorn. Use when user mentions shoehorn, wants to replace `as` in tests, or needs partial test data. |
| `mattpocock-skills:prototype` | Build a throwaway prototype to answer a design question. Use when the user wants to sanity-check whether a state model or logic feels right, or explore what a UI should look like. |
| `mattpocock-skills:research` | Investigate a question against high-trust primary sources and capture the findings as a Markdown file in the repo. Use when the user wants a topic researched, docs or API facts gathered, or reading legwork delegated to a background agent. |
| `mattpocock-skills:resolving-merge-conflicts` | Use when you need to resolve an in-progress git merge/rebase conflict. |
| `mattpocock-skills:scaffold-exercises` | Create exercise directory structures with sections, problems, solutions, and explainers that pass linting. Use when user wants to scaffold exercises, create exercise stubs, or set up a new course section. |
| `mattpocock-skills:setup-matt-pocock-skills` | Configure this repo for the engineering skills — set up its issue tracker, triage label vocabulary, and domain doc layout. Run once before first use of the other engineering skills. |
| `mattpocock-skills:setup-pre-commit` | Set up Husky pre-commit hooks with lint-staged (Prettier), type checking, and tests in the current repo. Use when user wants to add pre-commit hooks, set up Husky, configure lint-staged, or add commit-time formatting/typechecking/testing. |
| `mattpocock-skills:setup-ts-deep-modules` | Wire dependency-cruiser into a TypeScript repo so each package is a deep module — implementation hidden in subfolders, reachable only through its entry-point files. User-invoked. |
| `mattpocock-skills:tdd` | Test-driven development. Use when the user wants to build features or fix bugs test-first, mentions "red-green-refactor", or wants integration tests. |
| `mattpocock-skills:teach` | Teach the user a new skill or concept, within this workspace. |
| `mattpocock-skills:to-questionnaire` | Turn a decision you can't fully answer into a questionnaire for someone else to fill in. |
| `mattpocock-skills:to-spec` | Turn the current conversation into a spec and publish it to the project issue tracker — no interview, just synthesis of what you've already discussed. |
| `mattpocock-skills:to-tickets` | Break a plan, spec, or the current conversation into a set of tracer-bullet tickets, each declaring its blocking edges, published to the configured tracker — edges as text in one file per ticket locally, or native blocking links on a real tracker. |
| `mattpocock-skills:triage` | Move issues and external PRs through a state machine of triage roles — categorise, verify, grill if needed, and write agent-ready briefs. |
| `mattpocock-skills:wait-what` | Stop. That last message did not land — re-pitch it. |
| `mattpocock-skills:wayfinder` | Plan a huge chunk of work — more than one agent session can hold — as a shared map of decision tickets on your issue tracker, and resolve them one at a time until the way to the destination is clear. |
| `mattpocock-skills:wizard` | Generate an interactive bash wizard that walks a human through steps only they can perform. Use when provisioning infrastructure, setting up credentials or CI secrets, walking an unfamiliar third-party dashboard, or running a one-off migration or cutover. Don't invoke this for steps the agent can perform itself. |
| `mattpocock-skills:writing-beats` | Writing, exploit — assemble raw material into a journey of beats, grounding each term before a beat leans on it. |
| `mattpocock-skills:writing-for-agents` | Writing documents for agents. Use when creating or editing skills, or modifying AGENTS.md or CLAUDE.md. |
| `mattpocock-skills:writing-fragments` | Writing, explore — mine raw fragments, no structure yet. |
| `mattpocock-skills:writing-shape` | Writing, exploit — shape raw material into an article, paragraph by paragraph. |

## `revit-api` — bên thứ 3

| Skill | Mô tả |
|---|---|
| `revit-api:revit-api-option-handlers` | > Supply small Autodesk Revit API callback interfaces with Nice3point.Revit.Toolkit ready-made handlers, not hand-rolled classes. USE FOR: passing IFamilyLoadOptions, IDuplicateTypeNamesHandler, or ISaveSharedCoordinatesCallback to a Revit API call. DO NOT USE FOR: constraining what a user can pick in an interactive selection, or building a dockable pane's UI element. |
| `revit-api:revit-code-style` | > Structure Autodesk Revit API code — API boundaries, document and transaction ownership, thread affinity, and converting Revit objects to plain models. USE FOR: structuring Revit API code — where Revit types may live, who opens and closes a document, how to scope a transaction, thread affinity, and converting Revit objects before they cross a service or process boundary. DO NOT USE FOR: the mechanics of individual model operations (querying, parameter read/write, *Utils wrappers), which have their own focused skills — apply this to the structure around them. |
| `revit-api:revit-element-and-parameter-access` | > Read and write Autodesk Revit elements and parameters with the Nice3point.Revit.Extensions fluent accessors. USE FOR: finding an Element by ElementId, finding a parameter by BuiltInParameter/ParameterTypeId/Guid/name, reading its typed value, setting it, and converting internal units. DO NOT USE FOR: querying the model for a set of elements (use revit-element-collector). |
| `revit-api:revit-element-collector` | > Query the Revit model with the Nice3point.Revit.Extensions fluent FilteredElementCollector wrappers; filter with Revit's parameter filters, not by loading elements and filtering with LINQ. USE FOR: writing or reviewing element queries that filter by class, category, or parameter value and return the first match, a count, or the full set. DO NOT USE FOR: reading or setting parameters on an element you already hold (use revit-element-and-parameter-access). |
| `revit-api:revit-failure-handling` | > Suppress expected Autodesk Revit warnings and failures during a bounded API operation with Nice3point.Revit.Toolkit RevitApiContext. USE FOR: auto-resolving or auto-cancelling a known failure that would otherwise block opening a document, loading a family, or committing a transaction. DO NOT USE FOR: suppressing UI dialogs that are not failures (use RevitContext.BeginDialogSuppressionScope), or running API work from outside the Revit API context (use a Toolkit external event). |
| `revit-api:revit-utils-extensions` | > Replace verbose Autodesk Revit *Utils static calls, static managers, and hand-written enum/id conversions with Nice3point.Revit.Extensions fluent extensions. USE FOR: any time you need to call a SomeUtils.Operation(…) or any other static Revit API helper, and any time you convert or format a Revit value. DO NOT USE FOR: querying the model for elements (use revit-element-collector), or reading and writing element parameters (use revit-element-and-parameter-access). |

## `revit-benchmarking` — bên thứ 3

| Skill | Mô tả |
|---|---|
| `revit-benchmarking:revit-benchmarking` | > Design, write, run, or review BenchmarkDotNet measurements that run inside Autodesk Revit with Nice3point.BenchmarkDotNet.Revit. USE FOR: comparing viable Revit API implementations or measuring a Revit hot path, including the runner's WithCurrentConfiguration requirement and the OnGlobalSetup/OnGlobalCleanup document lifecycle. DO NOT USE FOR: benchmarking .NET code that does not call the Revit API. |

## `revit-solution` — bên thứ 3

| Skill | Mô tả |
|---|---|
| `revit-solution:revit-addin-bundle` | > Package a versioned Autodesk Revit add-in as an Autodesk App Store bundle with the Nice3point.Revit.Templates ModularPipelines build. USE FOR: setting the bundle vendor metadata and version, and running the build to produce a versioned .bundle with per-Revit-year contents for App Store distribution. DO NOT USE FOR: per-build deploy or publish to a local Revit (use revit-addin-publishing), or launching and debugging (use revit-addin-debugging). |
| `revit-solution:revit-addin-debugging` | > Configure an Autodesk Revit add-in project's IDE launch of the matching Revit with the debugger attached, using the Nice3point.Revit.Sdk launch properties. USE FOR: setting up a project where a debug session launches the matching Revit and breaks in the add-in, overriding the Revit path or start arguments, and keeping Hot Reload responsive while debugging. DO NOT USE FOR: copying built files to the Revit add-ins folder (use revit-addin-publishing), dependency isolation or repacking (use revit-dependency-isolation). |
| `revit-solution:revit-addin-publishing` | > Configure an Autodesk Revit add-in project to copy the add-in, .addin manifest to the local Revit or a `bin/publish` folder, using the Nice3point.Revit.Sdk publish targets. USE FOR: setting up a project for publishing, bundling extra content into the output, and relying on per-version manifest patching. DO NOT USE FOR: launching and debugging the add-in from the IDE (use revit-addin-debugging), dependency isolation or repacking (use revit-dependency-isolation), or packaging a versioned App Store bundle (use revit-addin-bundle). |
| `revit-solution:revit-api-references` | > Reference the Autodesk Revit API assemblies using the Nice3point.Revit.Api.* or Nice3point toolkit, extensions or other NuGet packages. USE FOR: adding a Revit API assembly reference. DO NOT USE FOR: the version matrix and conditional compilation (use revit-multi-version-configuration). |
| `revit-solution:revit-assembly-resolution` | > Redirect Autodesk Revit add-in assembly resolution to a plugin folder with Nice3point.Revit.Toolkit. USE FOR: fixing a FileNotFoundException when loading a WPF window or third-party dependency Revit cannot resolve, or pinning which folder a bounded load resolves from. DO NOT USE FOR: entry points derived from the Toolkit base classes (ExternalCommand, ExternalApplication, ExternalDBApplication), or preventing two add-ins' dependency versions from colliding process-wide (use revit-dependency-isolation). |
| `revit-solution:revit-dependency-isolation` | > Prevent Autodesk Revit add-in dependency conflicts with AssemblyLoadContext isolation (Revit 2027+) or ILRepack repacking (legacy). USE FOR: resolving crashes caused by two add-ins loading different versions of the same dependency, by isolating your add-in's assemblies. DO NOT USE FOR: resolving a missing dependency at load time (use revit-assembly-resolution). |
| `revit-solution:revit-multi-version-configuration` | > Support multiple Autodesk Revit versions in one project with Debug.RNN/Release.RNN configurations and REVIT#### conditional compilation. USE FOR: declaring the supported-version matrix, adding or removing a version, and writing #if REVIT####_OR_GREATER branches for genuine API differences. DO NOT USE FOR: what the SDK derives per version (use revit-sdk-project-configuration), or referencing the Revit API packages (use revit-api-references). |
| `revit-solution:revit-sdk-project-configuration` | > Configure the Revit project .csproj with the MSBuild Nice3point.Revit.Sdk. USE FOR: setting the project SDK, or configuring the target framework, implicit usings, language version, or add-in defaults. DO NOT USE FOR: adding or removing a supported Revit version (use revit-multi-version-configuration), referencing the Revit API assemblies (use revit-api-references), or publishing the add-in (use revit-addin-publishing). |
| `revit-solution:revit-template-migration` | > Upgrade a Nice3point.Revit.Templates project or solution to the latest template or SDK version. USE FOR: moving a scaffolded add-in, module, benchmark, test project, or solution to a newer template or SDK version, or adding template options to an existing scaffold. DO NOT USE FOR: creating a brand-new project (use scaffolding-revit-projects), or changing only the supported Revit-year matrix (use revit-multi-version-configuration). |
| `revit-solution:scaffolding-revit-projects` | > Scaffold an Autodesk Revit add-in, benchmark, or test project from the Nice3point.Revit.Templates. USE FOR: installing the templates and creating a new project or solution with dotnet new. DO NOT USE FOR: configuring an existing project's SDK, versions, or references (use revit-sdk-project-configuration), or upgrading a scaffolded project to a newer template version (use revit-template-migration). |

## `revit-testing` — bên thứ 3

| Skill | Mô tả |
|---|---|
| `revit-testing:revit-test-fixtures` | > Supply Autodesk Revit API tests with the documents, services, and data cases they run against, and pick the right data source for each situation. USE FOR: seeding a fresh in-memory model per test, opening installed sample .rvt/.rfa files as fixtures, choosing between [MethodDataSource] and [InstanceMethodDataSource], running one test body across several file kinds, injecting services under test through a dependency-injection data source, and test skipping. DO NOT USE FOR: writing the test itself or the Revit-thread executor model (use revit-testing), or measuring performance (that is a benchmark, not a fixture). |
| `revit-testing:revit-testing` | > Write, run, or review Autodesk Revit API tests that execute inside Revit with Nice3point.TUnit.Revit. USE FOR: writing RevitApiTest classes whose bodies run on Revit's single thread via the RevitThreadExecutor. DO NOT USE FOR: supplying the documents, services, or data cases a test runs against (use revit-test-fixtures), scaffolding the test project (create it from the revit-tunit template), or tests that never call the Revit API. |

## `revit-ui` — bên thứ 3

| Skill | Mô tả |
|---|---|
| `revit-ui:revit-command-and-application` | > Build Autodesk Revit add-in entry points with Nice3point.Revit.Toolkit base classes, not raw IExternalCommand/IExternalApplication interfaces. USE FOR: authoring an external command or application with a simplified Execute()/OnStartup() override, optional OnShutdown() override, ready context properties, and automatic dependency resolution. DO NOT USE FOR: dispatching API work from code that runs outside the Revit API context (use revit-external-events). |
| `revit-ui:revit-context-access` | > Access the Autodesk Revit database application through RevitApiContext or an active UI session through RevitContext from Nice3point.Revit.Toolkit, and suppress dialogs. USE FOR: reading Application, the current UiApplication/ActiveDocument/ActiveView without a commandData, or suppressing TaskDialog and message boxes with BeginDialogSuppressionScope. DO NOT USE FOR: suppressing expected Revit warnings and failures during a transaction. |
| `revit-ui:revit-context-menu` | > Add Autodesk Revit right-click context menu entries with the Nice3point.Revit.Extensions fluent API. USE FOR: registering context menu items, submenus, and separators bound to command classes during application startup. DO NOT USE FOR: ribbon panels and buttons (use revit-ribbon). |
| `revit-ui:revit-dockable-pane` | > Register a WPF dockable pane in the Autodesk Revit UI with Nice3point.Revit.Toolkit DockablePaneProvider. USE FOR: registering a dockable pane and its initial dock state during application startup with the fluent API. |
| `revit-ui:revit-external-events` | > Run Autodesk Revit API work from code that executes outside the Revit API context, using Nice3point.Revit.Toolkit external events. USE FOR: raising API work from a modeless window, background thread, or other non-API-context callback via the toolkit's external events or the [ExternalEvent] source generator. DO NOT USE FOR: code that already runs in the Revit API context — call the API directly. |
| `revit-ui:revit-ribbon` | > Build an Autodesk Revit ribbon with the Nice3point.Revit.Extensions fluent panel and button API, not raw RibbonPanel and PushButtonData calls. USE FOR: creating ribbon panels, push/pulldown/split buttons, stacked rows, icons, tooltips, shortcuts, and availability controllers in an application's OnStartup. DO NOT USE FOR: right-click context menu entries (use revit-context-menu). |
| `revit-ui:revit-selection-filter` | > Filter which elements and references a user can pick in Autodesk Revit UI with the Nice3point.Revit.Toolkit SelectionConfiguration, not a hand-rolled ISelectionFilter. USE FOR: constraining an interactive Selection.PickObject/PickObjects with a fluent Allow.Element / Allow.Reference filter. DO NOT USE FOR: headless API callbacks such as family load or duplicate-type options (use Toolkit option handlers like FamilyLoadOptions). |
