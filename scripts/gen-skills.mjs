#!/usr/bin/env node
// Regenerates SKILLS.md from what is actually installed on this machine,
// not from what skills.json claims. No timestamp, so an unchanged machine
// produces an empty diff.

import { existsSync, readFileSync, readdirSync, statSync, writeFileSync } from 'node:fs';
import { homedir } from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const REPO_ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const CLAUDE_DIR = path.join(homedir(), '.claude');
const OUT = path.join(REPO_ROOT, 'SKILLS.md');

const readJson = (file, fallback) => {
  if (!existsSync(file)) return fallback;
  try {
    return JSON.parse(readFileSync(file, 'utf8') || 'null') ?? fallback;
  } catch {
    return fallback;
  }
};

const dirs = (p) => {
  if (!existsSync(p)) return [];
  try {
    return readdirSync(p).filter((n) => !n.startsWith('.') && statSync(path.join(p, n)).isDirectory());
  } catch {
    return [];
  }
};

/** Pull `name` and `description` out of a SKILL.md YAML frontmatter block. */
const frontmatter = (file) => {
  let text;
  try {
    text = readFileSync(file, 'utf8');
  } catch {
    return null;
  }
  const match = /^---\r?\n([\s\S]*?)\r?\n---/.exec(text);
  if (!match) return null;
  const out = {};
  let key = null;
  for (const line of match[1].split(/\r?\n/)) {
    const kv = /^([A-Za-z][\w-]*):\s*(.*)$/.exec(line);
    if (kv) {
      key = kv[1];
      out[key] = kv[2].trim().replace(/^["']|["']$/g, '');
    } else if (key && /^\s+\S/.test(line)) {
      out[key] = `${out[key]} ${line.trim()}`.trim();
    }
  }
  return out;
};

/** Every skill a plugin ships: skills/<name>/SKILL.md, or a bare SKILL.md at root. */
const skillsOf = (root) => {
  const found = [];
  const collect = (file, fallbackName) => {
    const fm = frontmatter(file);
    if (!fm) return;
    found.push({ name: fm.name || fallbackName, description: fm.description || '—' });
  };
  for (const name of dirs(path.join(root, 'skills'))) {
    const file = path.join(root, 'skills', name, 'SKILL.md');
    if (existsSync(file)) collect(file, name);
  }
  if (!found.length && existsSync(path.join(root, 'SKILL.md'))) {
    collect(path.join(root, 'SKILL.md'), path.basename(root));
  }
  return found.sort((a, b) => a.name.localeCompare(b.name));
};

const esc = (s) => String(s).replace(/\|/g, '\\|').replace(/\s+/g, ' ').trim();

// ── plugins installed through marketplaces ───────────────────────────────────

const installed = readJson(path.join(CLAUDE_DIR, 'plugins', 'installed_plugins.json'), { plugins: {} }).plugins ?? {};
const manifest = readJson(path.join(REPO_ROOT, 'skills.json'), {});
const ownPlugins = new Set(
  Object.entries(manifest.marketplaces ?? {})
    .filter(([, e]) => e.self)
    .flatMap(([, e]) => e.plugins ?? []),
);

const plugins = [];
for (const [id, entries] of Object.entries(installed)) {
  const entry = Array.isArray(entries) ? entries[0] : entries;
  if (!entry?.installPath) continue;
  const [pluginName, marketplace] = id.split('@');
  plugins.push({
    id,
    pluginName,
    marketplace,
    version: entry.version || entry.gitCommitSha?.slice(0, 12) || 'unknown',
    own: ownPlugins.has(pluginName),
    skills: skillsOf(entry.installPath),
  });
}
plugins.sort((a, b) => Number(b.own) - Number(a.own) || a.id.localeCompare(b.id));

// ── standalone skills in ~/.claude/skills (npx skills, claude plugin init) ───

const standalone = [];
for (const name of dirs(path.join(CLAUDE_DIR, 'skills'))) {
  const root = path.join(CLAUDE_DIR, 'skills', name);
  const isPlugin = existsSync(path.join(root, '.claude-plugin', 'plugin.json'));
  for (const s of skillsOf(root)) standalone.push({ ...s, container: name, isPlugin });
}
standalone.sort((a, b) => a.name.localeCompare(b.name));

// ── render ───────────────────────────────────────────────────────────────────

const total = plugins.reduce((n, p) => n + p.skills.length, 0) + standalone.length;
const out = [];

out.push('# SKILLS.md');
out.push('');
out.push('> Sinh tự động bằng `node scripts/gen-skills.mjs` (hoặc `/setup-skills`). **Đừng sửa tay.**');
out.push('> Đây là ảnh chụp **máy này**, không phải danh sách mong muốn — cái đó nằm ở `skills.json`.');
out.push('');
out.push(`Tổng **${total} skill** từ **${plugins.length} plugin**${standalone.length ? ` và **${standalone.length} skill rời**` : ''}.`);
out.push('');

if (plugins.length) {
  out.push('| Plugin | Marketplace | Nguồn | Version | Skills |');
  out.push('|---|---|---|---|---|');
  for (const p of plugins) {
    out.push(`| \`${p.pluginName}\` | ${p.marketplace} | ${p.own ? '**own**' : 'bên thứ 3'} | \`${p.version}\` | ${p.skills.length} |`);
  }
  out.push('');
}

for (const p of plugins) {
  out.push(`## \`${p.pluginName}\` — ${p.own ? 'skill tự viết' : 'bên thứ 3'}`);
  out.push('');
  if (!p.skills.length) {
    out.push('_Chưa có skill nào._');
    out.push('');
    continue;
  }
  out.push('| Skill | Mô tả |');
  out.push('|---|---|');
  for (const s of p.skills) out.push(`| \`${p.pluginName}:${s.name}\` | ${esc(s.description)} |`);
  out.push('');
}

if (standalone.length) {
  out.push('## Skill rời trong `~/.claude/skills/`');
  out.push('');
  out.push('Cài bằng `npx skills` hoặc `claude plugin init`. Không thuộc marketplace nào.');
  out.push('');
  out.push('| Skill | Mô tả |');
  out.push('|---|---|');
  for (const s of standalone) {
    const id = s.isPlugin ? `${s.container}@skills-dir:${s.name}` : s.name;
    out.push(`| \`${id}\` | ${esc(s.description)} |`);
  }
  out.push('');
}

writeFileSync(OUT, `${out.join('\n')}`, 'utf8');
console.log(`SKILLS.md: ${total} skill · ${plugins.length} plugin · ${standalone.length} skill rời`);
