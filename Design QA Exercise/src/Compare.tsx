import { useEffect, useRef, useState } from 'react';
import issues from './practice-issues.json';
import './compare.css';

export default function Compare() {
  const [selected, setSelected] = useState('practice');
  const [linked, setLinked] = useState(true);
  const [ready, setReady] = useState(0);
  const original = useRef<HTMLIFrameElement>(null);
  const practice = useRef<HTMLIFrameElement>(null);
  useEffect(() => {
    if (!linked) return;
    const a = original.current?.contentWindow;
    const b = practice.current?.contentWindow;
    if (!a || !b) return;
    let busy = false;
    let frame = 0;
    const sync = (from: Window, to: Window) => {
      if (busy || !a.frameElement?.getClientRects().length || !b.frameElement?.getClientRects().length) return;
      busy = true;
      to.scrollTo({ top: from.scrollY, behavior: 'instant' });
      frame = requestAnimationFrame(() => { busy = false; });
    };
    const left = () => sync(a, b);
    const right = () => sync(b, a);
    a.addEventListener('scroll', left, { passive: true });
    b.addEventListener('scroll', right, { passive: true });
    return () => { a.removeEventListener('scroll', left); b.removeEventListener('scroll', right); cancelAnimationFrame(frame); };
  }, [linked, ready]);
  const reset = () => {
    original.current?.contentWindow?.scrollTo({ top: 0 });
    practice.current?.contentWindow?.scrollTo({ top: 0 });
  };
  return <main className="comparison">
    <header className="comparison-header">
      <div><h1>Spot the details.</h1><p>The same screen, with intentional differences. Explore both versions.</p></div>
      <div className="comparison-controls"><label><input type="checkbox" checked={linked} onChange={e => setLinked(e.target.checked)} /> Link scrolling</label><button onClick={reset}>Back to top</button></div>
    </header>
    <div className="comparison-tabs" role="group" aria-label="Visible version">
      <button aria-pressed={selected === 'original'} onClick={() => setSelected('original')}>Original</button>
      <button aria-pressed={selected === 'practice'} onClick={() => setSelected('practice')}>Practice copy</button>
    </div>
    <div className="comparison-panes" data-selected={selected}>
      <section className="comparison-pane original-pane"><header><h2>Original</h2><a href="/" target="_blank" rel="noreferrer">Open full screen ↗</a></header><iframe ref={original} src="/" title="Original discovery app" onLoad={() => setReady(n => n + 1)} /></section>
      <section className="comparison-pane practice-pane"><header><h2>Practice copy</h2><a href="/practice" target="_blank" rel="noreferrer">Open full screen ↗</a></header><iframe ref={practice} src="/practice" title="Practice discovery app with intentional issues" onLoad={() => setReady(n => n + 1)} /></section>
    </div>
    <details className="answer-key"><summary>Facilitator answer key · {issues.length} intentional issues</summary><p>Keep this closed during the exercise. Some issues appear when using the keyboard, saving a restaurant, or adding a dish to the cart.</p><ol>{issues.map(issue => <li key={issue.id}><span>{issue.id} · {issue.area}</span><h3>{issue.issue}</h3><p>{issue.expected}</p></li>)}</ol></details>
  </main>;
}
