// Offline execution of the delivered script in a minimal DOM. No browser,
// filesystem writes, network, packages or analysis; this is not a visual render.
const fs = require('fs');
const vm = require('vm');
const assert = require('assert').strict;
const path = require('path');
const filename = path.resolve(__dirname, '../../docs/index.html');
const html = fs.readFileSync(filename, 'utf8');
class Element {
  constructor(tag = 'div', attrs = {}) {
    this.tag = tag; this.attrs = attrs; this.children = []; this.events = {};
    this.dataset = {}; this.value = ''; this.textContent = ''; this.markup = '';
  }
  setAttribute(k, v) { this.attrs[k] = String(v); }
  appendChild(e) { this.children.push(e); return e; }
  addEventListener(k, f) { this.events[k] = f; }
  set innerHTML(v) { this.markup = v; this.children = []; }
  get innerHTML() { return this.markup; }
}
const ids = {};
for (const m of html.matchAll(/<([a-z0-9]+)\b[^>]*\bid="([^"]+)"[^>]*>/g)) ids[m[2]] = new Element(m[1]);
const chips = ['all', 'Main text', 'Online Appendix'].map(f => {
  const e = new Element('button'); e.dataset.f = f; return e;
});
const copies = ['cmd', 'bib'].map(f => {
  const e = new Element('button'); e.dataset.copy = f; return e;
});
const document = {
  documentElement: new Element('html'),
  getElementById: id => { assert(ids[id], id); return ids[id]; },
  createElementNS: (ns, tag) => new Element(tag),
  createElement: tag => new Element(tag),
  querySelectorAll: q => { assert(['.chip', '.copy'].includes(q)); return q === '.chip' ? chips : copies; }
};
const context = { document, navigator: {}, getComputedStyle: () => ({ getPropertyValue: n => n }),
  window: { matchMedia: () => ({ addEventListener() {} }) },
  MutationObserver: class { observe() {} }, setTimeout() {}, Promise };
vm.createContext(context);
const scripts = [...html.matchAll(/<script>([\s\S]*?)<\/script>/g)];
assert.equal(scripts.length, 1);
vm.runInContext(scripts[0][1], context, { timeout: 10000 });
const data = JSON.parse(vm.runInContext('JSON.stringify(DATA)', context));
assert.equal(ids.count.textContent, '89 of 89');
function rowCount() { return (ids.rows.innerHTML.match(/<tr>/g) || []).length; }
assert.equal(rowCount(), 89);
const allLinks = [...ids.rows.innerHTML.matchAll(/href="([^"]+)"/g)].map(m => m[1]);
for (const target of allLinks) {
  assert(!target.includes(';'), target);
  const prefix = 'https://github.com/AW0908/three-red-lines-replication/blob/main/';
  assert(target.startsWith(prefix), target);
  assert(fs.statSync(path.resolve(__dirname, '../..', target.slice(prefix.length))).isFile(), target);
}
for (const group of ['Main text', 'Online Appendix']) {
  chips.find(c => c.dataset.f === group).events.click();
  const expected = data.map.filter(r => r.section === group).length;
  assert.equal(rowCount(), expected);
  assert.equal(ids.count.textContent, expected+' of 89');
}
chips[0].events.click();
ids.q.value = 'tab:ai_use'; ids.q.events.input();
assert.equal(rowCount(), 1);
for (const name of ['process/AI_USAGE_LOG.md', 'process/state/runs.log', 'process/state/approvals.log'])
  assert(ids.rows.innerHTML.includes('/blob/main/'+name+'"'), name);
ids.q.value = 'no_such_result_093'; ids.q.events.input();
assert.equal(rowCount(), 0);
ids.q.value = ''; ids.q.events.input();
assert.equal(rowCount(), 89);
assert.equal(ids.rules.children.length, 3);
function inspect(e) {
  for (const [k, v] of Object.entries(e.attrs)) {
    assert(!/NaN|Infinity|undefined/.test(v), k+': '+v);
    if (['width', 'height'].includes(k)) assert(Number(v) >= 0, k+': '+v);
  }
  return 1+e.children.reduce((n, c) => n+inspect(c), 0);
}
const chartNodes = Object.fromEntries(['hero-chart', 'f1', 'f2', 'f3'].map(id => {
  const n = inspect(ids[id]); assert(id === 'f3' ? n === 20 : n > 20, id); return [id, n];
}));
function textNodes(e) {
  return (e.tag === 'text' ? [e.textContent] : []).concat(e.children.flatMap(textNodes));
}
const expectedContracts = ['Fixed or guaranteed return', '1', 'Exit at market value', '2',
  'Buyback, terms unspecified', '1', 'Equity from own group', '5',
  'Plain outside equity', '1', 'Terms unknown', '239'];
assert.deepEqual(textNodes(ids.f3), expectedContracts);
const periodLabels = textNodes(ids.f1).filter(t => /^(Before|After)/.test(t));
assert.deepEqual(periodLabels, ['Before: 2017H1–2019H2', 'After: 2020H2–2022H2']);
assert(html.includes('compliant share of developer half-years'));
assert(html.includes('(602 firm-half-years, 129 developers)'));
assert(!html.includes('share of compliant developers'));
assert(!html.includes('fewer compliant developers'));
assert(!/70(?:&nbsp;| )%|95(?:&nbsp;| )%/.test(html));
assert(html.includes('95% confidence interval'));
assert(ids.files);
assert(html.includes('href="#files"'));
for (const folder of ['code', 'data', 'outputs', 'docs', 'process', 'release']) {
  assert(html.includes('class="folder" href="https://github.com/AW0908/three-red-lines-replication/tree/main/'+folder+'"'));
  assert(fs.statSync(path.resolve(__dirname, '../..', folder)).isDirectory());
}
assert(html.includes('href="https://github.com/AW0908/three-red-lines-replication/archive/refs/heads/main.zip"'));
assert(html.includes('ZIP; about 0.5 GB unpacked'));
copies.forEach(c => c.events.click());
setImmediate(() => {
  copies.forEach(c => assert.equal(c.textContent, 'Select and copy the text above'));
  process.stdout.write(JSON.stringify({ result: 'PASS', mode: 'Node VM with minimal DOM; no visual render',
    file: 'docs/index.html', rows: 89, rendered_links: allLinks.length,
    filter_and_search: 'PASS', multi_source_links: 'PASS', finite_svg_geometry: chartNodes,
    contract_chart_labels_and_counts: expectedContracts, estimator_period_labels: periodLabels,
    compliance_observation_unit: '602 firm-half-years, 129 developers',
    folder_tiles_and_repository_download: 'PASS; six local directories; HTTP availability not checked',
    clipboard_unavailable_fallback: 'PASS' }, null, 2)+'\n');
});
