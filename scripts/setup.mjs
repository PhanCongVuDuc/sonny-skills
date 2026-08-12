#!/usr/bin/env node
// Reads skills.json and brings this machine's skills up to date.
// Idempotent: safe to run on an empty machine or one that is already set up.
//
//   node scripts/setup.mjs             apply
//   node scripts/setup.mjs --dry-run   show what would run, change nothing
//   node scripts/setup.mjs --dev       mark this machine as an authoring machine
//   node scripts/setup.mjs --no-dev    unmark it

import { spawnSync } from 'node:child_process';
import { existsSync, mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { homedir } from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const REPO_ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const CLAUDE_DIR = path.join(homedir(), '.claude');
const SETTINGS = path.join(CLAUDE_DIR, 'settings.json');
const KNOWN_MARKETPLACES = path.join(CLAUDE_DIR, 'plugins', 'known_marketplaces.json');
const INSTALLED_PLUGINS = path.join(CLAUDE_DIR, 'plugins', 'installed_plugins.json');
const SKILLS_DIR = path.join(CLAUDE_DIR, 'skills');
const REFERENCE_DIR = path.join(CLAUDE_DIR, 'reference');
const DEV_MARKER = path.join(REPO_ROOT, '.sonny-dev');

const argv = new Set(process.argv.slice(2));
const DRY_RUN = argv.has('--dry-run') || argv.has('-n');

const problems = [];
let changes = 0;

// ── helpers ──────────────────────────────────────────────────────────────────

const readJson = (file, fallback) => {
  if (!existsSync(file)) return fallback;
  try {
    const raw = readFileSync(file, 'utf8').trim();
    return raw ? JSON.parse(raw) : fallback;
  } catch (err) {
    problems.push(`Không đọc được ${file}: ${err.message}`);
    return fallback;
  }
};

const writeJson = (file, value) => {
  mkdirSync(path.dirname(file), { recursive: true });
  writeFileSync(file, `${JSON.stringify(value, null, 2)}\n`, 'utf8');
};

/** Quote a shell argument. NOT JSON.stringify — that escapes Windows backslashes. */
const q = (s) => (/[\s"&|<>^]/.test(s) ? `"${s.replace(/"/g, '\\"')}"` : s);

const say = (msg) => console.log(msg);
const step = (msg) => console.log(`\n\x1b[1m${msg}\x1b[0m`);
const ok = (msg) => console.log(`  \x1b[32m✓\x1b[0m ${msg}`);
const skip = (msg) => console.log(`  \x1b[90m·\x1b[0m ${msg}`);
const bad = (msg) => console.log(`  \x1b[31m✗\x1b[0m ${msg}`);

/** Run a command. Returns { ok, stdout, stderr }. Never throws. */
const run = (cmd, args, { label, allowFail = false } = {}) => {
  const pretty = `${cmd} ${args.join(' ')}`;
  if (DRY_RUN) {
    skip(`(dry-run) ${pretty}`);
    return { ok: true, stdout: '', stderr: '' };
  }
  const res = spawnSync(cmd, args, {
    shell: true, // needed on Windows for .cmd shims (claude, npx)
    encoding: 'utf8',
    windowsHide: true,
  });
  const stdout = res.stdout ?? '';
  const stderr = res.stderr ?? '';
  if (res.status === 0) {
    changes += 1;
    ok(label ?? pretty);
    return { ok: true, stdout, stderr };
  }
  const detail = (stderr || stdout || res.error?.message || 'không rõ nguyên nhân').trim().split('\n')[0];
  if (allowFail) {
    skip(`${label ?? pretty} — bỏ qua (${detail})`);
  } else {
    bad(`${label ?? pretty} — ${detail}`);
    problems.push(`${pretty}\n    ${detail}`);
  }
  return { ok: false, stdout, stderr };
};

// ── dev-marker ───────────────────────────────────────────────────────────────

if (argv.has('--dev') && !DRY_RUN) writeFileSync(DEV_MARKER, 'Máy này là máy viết skill.\n', 'utf8');
if (argv.has('--no-dev') && !DRY_RUN && existsSync(DEV_MARKER)) rmSync(DEV_MARKER);
const IS_DEV = existsSync(DEV_MARKER) || argv.has('--dev');

// ── load manifest & current state ────────────────────────────────────────────

const manifest = readJson(path.join(REPO_ROOT, 'skills.json'), null);
if (!manifest) {
  console.error('Không tìm thấy skills.json ở gốc repo. Dừng.');
  process.exit(1);
}

const known = readJson(KNOWN_MARKETPLACES, {});
const installed = readJson(INSTALLED_PLUGINS, { plugins: {} }).plugins ?? {};

say(`\x1b[1msonny-skills setup\x1b[0m — ${IS_DEV ? 'máy VIẾT skill (marketplace trỏ vào thư mục local)' : 'máy DÙNG skill (marketplace trỏ vào GitHub)'}${DRY_RUN ? ' · dry-run' : ''}`);
say(`Repo: ${REPO_ROOT}`);

// ── 1. settings.json ─────────────────────────────────────────────────────────

step('1. Cập nhật ~/.claude/settings.json (merge, không ghi đè)');

const settings = readJson(SETTINGS, {});
const extra = { ...(settings.extraKnownMarketplaces ?? {}) };
const enabled = { ...(settings.enabledPlugins ?? {}) };

for (const [name, entry] of Object.entries(manifest.marketplaces ?? {})) {
  const isLocal = Boolean(entry.self) && IS_DEV;
  if (isLocal) {
    // A local-directory marketplace is registered by `claude plugin marketplace add <path>`.
    // Declaring it in settings too would fight that registration, so leave it out.
    delete extra[name];
  } else {
    // Keep whatever source Claude Code already recorded; only carry autoUpdate across.
    const currentSource = known[name]?.source ?? extra[name]?.source ?? entry.source;
    extra[name] = { source: currentSource, autoUpdate: entry.autoUpdate === true };
  }
  for (const plugin of entry.plugins ?? []) enabled[`${plugin}@${name}`] = true;
}

const nextSettings = { ...settings };
if (Object.keys(extra).length) nextSettings.extraKnownMarketplaces = extra;
else delete nextSettings.extraKnownMarketplaces;
nextSettings.enabledPlugins = enabled;

if (JSON.stringify(nextSettings) === JSON.stringify(settings)) {
  skip('đã đúng, không đổi gì');
} else if (DRY_RUN) {
  skip('(dry-run) sẽ ghi extraKnownMarketplaces + enabledPlugins');
} else {
  writeJson(SETTINGS, nextSettings);
  changes += 1;
  ok(`ghi ${Object.keys(extra).length} marketplace + ${Object.keys(enabled).length} plugin`);
}

// ── 2. marketplaces ──────────────────────────────────────────────────────────

step('2. Marketplace');

for (const [name, entry] of Object.entries(manifest.marketplaces ?? {})) {
  const isLocal = Boolean(entry.self) && IS_DEV;
  const target = isLocal ? REPO_ROOT : entry.source?.repo ?? entry.source?.url;
  if (!target) {
    bad(`${name}: skills.json thiếu source.repo hoặc source.url`);
    problems.push(`Marketplace "${name}" trong skills.json không có source hợp lệ.`);
    continue;
  }

  if (known[name]) {
    const registeredAgainst = JSON.stringify(known[name].source ?? {});
    const registeredLocal = registeredAgainst.includes(REPO_ROOT.replace(/\\/g, '\\\\')) || registeredAgainst.includes(REPO_ROOT);
    if (isLocal !== registeredLocal) {
      // Mode flipped between dev and use — re-register against the right source.
      // Removing a marketplace uninstalls its plugins; step 3 reinstalls them.
      run('claude', ['plugin', 'marketplace', 'remove', name], { label: `${name}: gỡ đăng ký cũ`, allowFail: true });
      run('claude', ['plugin', 'marketplace', 'add', q(target)], { label: `${name}: đăng ký lại → ${target}` });
    } else {
      run('claude', ['plugin', 'marketplace', 'update', name], { label: `${name}: cập nhật`, allowFail: true });
    }
  } else {
    run('claude', ['plugin', 'marketplace', 'add', q(target)], { label: `${name}: thêm mới → ${target}` });
  }
}

// ── 3. plugins ───────────────────────────────────────────────────────────────

step('3. Plugin');

// Re-read: step 2 may have removed a marketplace, which uninstalls its plugins.
const installedNow = readJson(INSTALLED_PLUGINS, { plugins: {} }).plugins ?? {};

for (const [name, entry] of Object.entries(manifest.marketplaces ?? {})) {
  for (const plugin of entry.plugins ?? []) {
    const id = `${plugin}@${name}`;
    if (installedNow[id]?.length) {
      run('claude', ['plugin', 'update', id], { label: `${id}: cập nhật`, allowFail: true });
    } else {
      run('claude', ['plugin', 'install', id, '--scope', 'user'], { label: `${id}: cài mới` });
    }
  }
}

// ── 4. tầng Vercel (repo không có marketplace) ───────────────────────────────

const vercel = manifest.vercel ?? [];
step(`4. Skill qua npx skills${vercel.length ? '' : ' — không có mục nào'}`);

let touchedVercel = false;
for (const entry of vercel) {
  for (const skill of entry.skills ?? []) {
    if (existsSync(path.join(SKILLS_DIR, skill, 'SKILL.md'))) {
      skip(`${skill}: đã có, để bước update lo`);
      touchedVercel = true;
      continue;
    }
    // --copy because symlinks need Developer Mode / admin on Windows.
    const res = run(
      'npx',
      ['-y', 'skills@latest', 'add', entry.repo, '--skill', skill, '-g', '-a', 'claude-code', '-y', '--copy'],
      { label: `${skill}: cài từ ${entry.repo}` },
    );
    if (res.ok) touchedVercel = true;
  }
}
if (touchedVercel) {
  run('npx', ['-y', 'skills@latest', 'update', '-g', '-y'], { label: 'cập nhật toàn bộ skill global lên mới nhất', allowFail: true });
}

// ── 5. repo tham khảo (chỉ để đọc, không cài) ────────────────────────────────

const reference = manifest.reference ?? [];
if (reference.length) {
  step('5. Repo tham khảo (chỉ clone để đọc)');
  mkdirSync(REFERENCE_DIR, { recursive: true });
  for (const repo of reference) {
    const dir = path.join(REFERENCE_DIR, repo.replace('/', '__'));
    if (existsSync(path.join(dir, '.git'))) {
      run('git', ['-C', q(dir), 'pull', '--ff-only', '--quiet'], { label: `${repo}: pull`, allowFail: true });
    } else {
      run('git', ['clone', '--depth', '1', '--quiet', `https://github.com/${repo}.git`, q(dir)], { label: `${repo}: clone → ${dir}` });
    }
  }
}

// ── 6. SKILLS.md ─────────────────────────────────────────────────────────────

step(`${reference.length ? 6 : 5}. Sinh lại SKILLS.md`);
run('node', [q(path.join(REPO_ROOT, 'scripts', 'gen-skills.mjs'))], { label: 'SKILLS.md', allowFail: true });

// ── kết ──────────────────────────────────────────────────────────────────────

console.log('');
if (problems.length) {
  console.log(`\x1b[31m${problems.length} việc chưa xong:\x1b[0m`);
  for (const p of problems) console.log(`  - ${p}`);
  console.log('');
  process.exitCode = 1;
} else if (DRY_RUN) {
  console.log('\x1b[90mDry-run xong — chưa thay đổi gì.\x1b[0m');
} else {
  console.log('\x1b[32mXong.\x1b[0m Chạy \x1b[1m/reload-plugins\x1b[0m trong Claude Code, hoặc khởi động lại, để skill mới có hiệu lực.');
}
