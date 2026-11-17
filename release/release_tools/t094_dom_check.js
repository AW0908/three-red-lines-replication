if (!process.argv[2]) {
 const cp=require('child_process');
 const modes=['motion','reduced','no-observer'].map(mode=>{
  const r=cp.spawnSync(process.execPath,[__filename,mode],{encoding:'utf8'});
  if(r.status!==0){process.stderr.write(r.stderr);process.exit(r.status||1);}return JSON.parse(r.stdout);
 });
 process.stdout.write(JSON.stringify({result:'PASS',modes},null,2)+'\n');
} else {
// Offline execution of the delivered script in a minimal DOM. No browser,
// filesystem writes, network, packages or analysis; this is not a visual render.
const fs = require('fs');
const vm = require('vm');
const assert = require('assert').strict;
const path = require('path');
const filename = path.resolve(__dirname, '../../docs/index.html');
const html = fs.readFileSync(filename, 'utf8');
const mode=process.argv[2] || 'motion';
const reduced=mode==='reduced';
const frames=[];const observers=[];const windowEvents={};
class Element {
  constructor(tag = 'div', attrs = {}) {
    this.tag = tag; this.attrs = attrs; this.children = []; this.events = {};
    this.style={setProperty(k,v){this[k]=v;}};this.className='';this.tagName=tag;
    this.classList={add:(c)=>{this.attrs.class=((this.attrs.class||'')+' '+c).trim();},remove:(c)=>{this.attrs.class=(this.attrs.class||'').split(' ').filter(x=>x!==c).join(' ');},contains:(c)=>(this.attrs.class||'').split(' ').includes(c),toggle:(c,on)=>{if(on)this.classList.add(c);else this.classList.remove(c);}};
    this.dataset = {}; this.value = ''; this.textContent = ''; this.markup = '';
  }
  getAttribute(k){return this.attrs[k];}
  getBoundingClientRect(){return {top:1000};}
  querySelectorAll(q){const cls=q.split(',').map(x=>x.replace('.',''));return this.children.flatMap(c=>[(cls.some(x=>(c.attrs.class||c.className||'').split(' ').includes(x))?c:null),...c.querySelectorAll(q)]).filter(Boolean);}
  querySelector(q){return this.querySelectorAll(q)[0];}
  get y1(){return {baseVal:{value:Number(this.attrs.y1)}};}
  get y2(){return {baseVal:{value:Number(this.attrs.y2)}};}
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
const counters=[...html.matchAll(/<[^>]+data-count="([^"]+)"[^>]*>([^<]+)</g)].map(m=>{const e=new Element('b');e.dataset.count=m[1];e.textContent=m[2];return e;});
const originalCounters=counters.map(e=>e.textContent);
const navlinks=[...html.matchAll(/<a class="l" href="([^"]+)"/g)].map(m=>new Element('a',{href:m[1]}));
const sections=Object.values(ids).filter(e=>e.tag==='section');
const document = {
  documentElement: new Element('html'),
  getElementById: id => { assert(ids[id], id); return ids[id]; },
  createElementNS: (ns, tag) => new Element(tag),
  createElement: tag => new Element(tag),
  querySelectorAll:q=>{if(q==='.chip')return chips;if(q==='.copy')return copies;if(q==='nav a.l')return navlinks;if(q==='main section[id]')return sections;if(q==='svg.chart')return ['hero-chart','f1','f2','f3'].map(id=>ids[id]);if(q==='[data-count]')return counters;if(q==='.card,.finding,.folder,.fact,.rule,.tier,.tablewrap,.formula')return [new Element(),...ids.rules.children];throw Error(q);}
};
class IO {constructor(callback){this.callback=callback;this.targets=[];observers.push(this);}observe(t){this.targets.push(t);}unobserve(){} }
const context = { document, navigator: {}, getComputedStyle: () => ({ getPropertyValue: n => n }),
  window:{innerHeight:800,addEventListener(k,f){windowEvents[k]=f;},matchMedia:q=>({matches:q.includes('reduced-motion')&&reduced,addEventListener(){}}),...(mode!=='no-observer'?{IntersectionObserver:IO}:{})},
  IntersectionObserver:IO,performance:{now:()=>0},requestAnimationFrame:cb=>frames.push(cb),
  MutationObserver: class { observe() {} }, setTimeout() {}, Promise };
vm.createContext(context);
const scripts = [...html.matchAll(/<script>([\s\S]*?)<\/script>/g)];
assert.equal(scripts.length, 1);
Object.assign(document.documentElement,{scrollTop:0,scrollHeight:2000,clientHeight:800});
vm.runInContext(scripts[0][1], context, { timeout: 10000 });
assert.deepEqual(counters.map(e=>e.textContent),originalCounters);
if(reduced){
 assert.equal(windowEvents.scroll,undefined);
 assert.equal(ids.progress.style.transform,undefined);
 assert.equal(observers.length,1); // Static active-section highlighting only.
 observers[0].callback(observers[0].targets.map(target=>({target,isIntersecting:true})));
 assert.equal(frames.length,0);
 assert.deepEqual(counters.map(e=>e.textContent),originalCounters);
 for(const id of ['hero-chart','f1','f2','f3'])
  assert.equal(ids[id].querySelectorAll('.g,.gx,.d,.f').length,0);
}else{assert.equal(typeof windowEvents.scroll,'function');}
const beforeMotionCharts=['hero-chart','f1','f2','f3'].map(id=>ids[id].children.length);
assert(beforeMotionCharts.every(n=>n>0));
assert.equal((ids.rows.innerHTML.match(/<tr>/g)||[]).length,89);
if(mode==='motion'){
 assert.equal(observers.length,2);
 observers.forEach(o=>o.callback(o.targets.map(target=>({target,isIntersecting:true}))));
 const midway=frames.splice(0);midway.forEach(cb=>cb(550));
 assert(counters.some((e,i)=>e.textContent!==originalCounters[i]));
 const end=frames.splice(0);end.forEach(cb=>cb(1200));
 assert.deepEqual(counters.map(e=>e.textContent),originalCounters);
 assert.equal(frames.length,0);
 assert(ids.f1.querySelectorAll('.g').length>0);
 assert(ids.f1.querySelectorAll('.d').length>0);
}else{assert.equal(frames.length,0);assert.equal(ids.f1.querySelectorAll('.g').length,0);}

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
assert(html.includes('compliant share of firm-half-years'));
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
  process.stdout.write(JSON.stringify({ result:'PASS',mode, runtime:'Node VM with minimal DOM; no visual render',counter_initial_text:originalCounters,counter_final_text:counters.map(e=>e.textContent),content_before_intersection:'PASS; four charts, rules and 89 table rows',
    scroll_listener_registered:!!windowEvents.scroll, reduced_motion_no_frames:reduced?frames.length===0:null, static_section_observer_only:reduced?observers.length===1:null, file: 'docs/index.html', rows: 89, rendered_links: allLinks.length,
    filter_and_search: 'PASS', multi_source_links: 'PASS', finite_svg_geometry: chartNodes,
    contract_chart_labels_and_counts: expectedContracts, estimator_period_labels: periodLabels,
    compliance_observation_unit: '602 firm-half-years, 129 developers',
    folder_tiles_and_repository_download: 'PASS; six local directories; HTTP availability not checked',
    clipboard_unavailable_fallback: 'PASS' }, null, 2)+'\n');
});

}
