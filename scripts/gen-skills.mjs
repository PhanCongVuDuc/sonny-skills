// Sinh SKILLS.md từ các plugin đang cài. Chạy: node scripts/gen-skills.mjs
//
// Nguồn sự thật là ~/.claude/plugins/installed_plugins.json (installPath của từng plugin) chứ
// không phải file này — nên SKILLS.md không thể trôi khỏi thực tế. Cố ý không in timestamp:
// chạy lại mà không có gì đổi thì diff phải rỗng.

import { readFile, writeFile, readdir } from "node:fs/promises";
import { homedir } from "node:os";
import path from "node:path";

const OWN_PLUGIN = "duc@duc-skills";
const installedPluginsPath = path.join(homedir(), ".claude", "plugins", "installed_plugins.json");
const outPath = path.join(import.meta.dirname, "..", "SKILLS.md");

/** Đọc frontmatter YAML tối giản — chỉ đủ cho `name` và `description` của SKILL.md. */
function parseFrontmatter(text) {
  const match = /^---\r?\n([\s\S]*?)\r?\n---/.exec(text);
  if (!match) return {};
  const fields = {};
  let currentKey = null;
  for (const line of match[1].split(/\r?\n/)) {
    const keyed = /^([A-Za-z][\w-]*):\s*(.*)$/.exec(line);
    if (keyed) {
      currentKey = keyed[1];
      fields[currentKey] = keyed[2].trim();
    } else if (currentKey && line.trim()) {
      fields[currentKey] += " " + line.trim();
    }
  }
  for (const key of Object.keys(fields)) {
    fields[key] = fields[key].replace(/^["']|["']$/g, "").trim();
  }
  return fields;
}

async function findSkillFiles(dir) {
  const found = [];
  let entries;
  try {
    entries = await readdir(dir, { withFileTypes: true });
  } catch {
    return found;
  }
  for (const entry of entries) {
    if (entry.name.startsWith(".")) continue;
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) found.push(...(await findSkillFiles(full)));
    else if (entry.name === "SKILL.md") found.push(full);
  }
  return found;
}

const installed = JSON.parse(await readFile(installedPluginsPath, "utf8"));
const plugins = [];

for (const [id, installs] of Object.entries(installed.plugins)) {
  const install = installs.find((entry) => entry.installPath);
  if (!install) continue;
  const [pluginName, marketplace] = id.split("@");
  const skills = [];
  for (const file of await findSkillFiles(install.installPath)) {
    const { name, description } = parseFrontmatter(await readFile(file, "utf8"));
    if (name) skills.push({ name, description: description ?? "" });
  }
  skills.sort((a, b) => a.name.localeCompare(b.name));
  plugins.push({ id, pluginName, marketplace, version: install.version, skills });
}

plugins.sort((a, b) => {
  if ((a.id === OWN_PLUGIN) !== (b.id === OWN_PLUGIN)) return a.id === OWN_PLUGIN ? -1 : 1;
  return a.id.localeCompare(b.id);
});

const total = plugins.reduce((sum, plugin) => sum + plugin.skills.length, 0);
const lines = [
  "# SKILLS.md",
  "",
  "> Sinh tự động bằng `node scripts/gen-skills.mjs`. **Đừng sửa tay.**",
  "",
  `Tổng **${total} skill** từ **${plugins.length} plugin**.`,
  "",
  "| Plugin | Marketplace | Provenance | Version | Skills |",
  "|---|---|---|---|---|",
  ...plugins.map(
    (p) =>
      `| \`${p.pluginName}\` | ${p.marketplace} | ${p.id === OWN_PLUGIN ? "**own**" : "third-party"} | \`${p.version}\` | ${p.skills.length} |`,
  ),
];

for (const plugin of plugins) {
  lines.push(
    "",
    `## \`${plugin.pluginName}\` — ${plugin.id === OWN_PLUGIN ? "skill tự viết" : "bên thứ 3"}`,
    "",
    "| Skill | Mô tả |",
    "|---|---|",
    ...plugin.skills.map(
      (skill) =>
        `| \`${plugin.pluginName}:${skill.name}\` | ${skill.description.replace(/\|/g, "\\|")} |`,
    ),
  );
}

await writeFile(outPath, lines.join("\n") + "\n", "utf8");
console.log(`SKILLS.md: ${total} skill / ${plugins.length} plugin`);
