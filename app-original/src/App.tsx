import { useEffect, useRef, useState } from 'react';
import type { ReactNode } from 'react';
import { assets } from './assets';

type Item = { name: string; image: string; price?: number; restaurant?: string; rating?: string; reviews?: string; time?: string; fee?: string };
type CartItem = Item & { quantity: number };
type Panel = { kind: 'detail'; item: Item } | { kind: 'cart' | 'profile' | 'address' } | { kind: 'info'; title: string; text: string };
const restaurants: Item[] = [
  { name: 'Gonzalez & Co.', image: 'gonzalez-logo', rating: '98%', reviews: '550', time: '20-30min', fee: '2,49€' },
  { name: 'Healthy Poke', image: 'healthy-logo', rating: '96%', reviews: '413', time: '20-30min', fee: '2,49€' },
  { name: 'Red Ant', image: 'redant-logo', rating: '97%', reviews: '413', time: '25-35min', fee: '1,99€' },
  { name: 'Enlagloria Salad house', image: 'elg-logo', rating: '98%', reviews: '413', time: '15-25min', fee: '2,49€' },
  { name: 'Honest Greens', image: 'honest-logo', rating: '98%', reviews: '413', time: '20-30min', fee: '2,49€' },
  { name: 'Goiko Grill', image: 'goiko-logo', rating: '95%', reviews: '413', time: '30-45min', fee: '2,49€' },
];
const products: Item[] = [
  { name: 'Burrito vegetariano', restaurant: 'Gonzalez & Co', image: 'burrito', price: 8, fee: '0,99€' },
  { name: 'La Caraqueña', restaurant: 'Healthy Poke', image: 'caraquena', price: 7.99, fee: 'Free' },
  { name: 'Pita Pollo', restaurant: 'Incheon Korean', image: 'pita', price: 7.62, fee: '0,99€' },
  { name: 'Bacon cheese burger', restaurant: 'Goiko Grill', image: 'burger', price: 8.99, fee: '0,99€' },
];
const stores: Item[] = [
  { name: 'Grosso Napoletano', image: 'grosso' }, { name: 'Mayura', image: 'mayura' },
  { name: 'Kiena', image: 'kiena' }, { name: 'Kemako', image: 'kemako' },
  { name: 'Nudes', image: 'nudes' }, { name: 'Baby Jalebi', image: 'jalebi', rating: '97%', reviews: '245', time: '25-35min', fee: '2,99€' },
  { name: 'Goiko', image: 'goiko' }, { name: 'Popeyes', image: 'popeyes' },
];
const groceries = ['Condis', 'Dia', 'Caprabo', 'Ametller Origen', 'Manolo Bakes', 'Supermercado', 'Super Glovo', 'Carrefour'];
const groceryImages = ['condis-logo', 'dia-logo', 'caprabo-logo', 'ametller-logo', 'manolo-logo', 'super-logo', 'glovo-logo', 'carrefour-logo'];
const euro = (value: number) => `${value.toFixed(2).replace('.', ',')}€`;
function stored<T,>(key: string, fallback: T): T { try { return JSON.parse(localStorage.getItem(key) || 'null') ?? fallback; } catch { return fallback; } }
function Picture({ name, className = '', alt = '', ...rest }: { name: string; className?: string; alt?: string } & React.ImgHTMLAttributes<HTMLImageElement>) {
  return <img src={assets[name]} alt={alt} className={className} draggable="false" {...rest} />;
}
function Rating({ item = {}, compact = false, delivery = true }: { item?: Partial<Item>; compact?: boolean; delivery?: boolean }) {
  return <div className={`rating ${compact ? 'compact' : ''}`}>
    <span className="thumb"><Picture name="thumb-blob" /><Picture name="thumb" /></span>
    <strong>{item.rating || '98%'}</strong><span className="review-count">({item.reviews || '413'})</span>
    <span className="rating-dot">·</span><span>{item.time || '20-30min'}</span>
    {delivery && <><span className="rating-dot">·</span><Picture name="delivery" className="inline-icon" /><span className="rating-delivery-fee">{item.fee || '2,49€'}</span></>}
  </div>;
}
function Section({ title, subtitle, info, id, children, className = '', onInfo, onMore }: {
  title: string; subtitle?: string; info?: string; id: string; children: ReactNode; className?: string;
  onInfo?: (title: string, text: string) => void; onMore?: () => void;
}) {
  const ref = useRef<HTMLElement>(null);
  const advance = () => {
    if (onMore) { onMore(); return; }
    const rail = ref.current?.querySelector<HTMLElement>('.rail');
    if (rail) rail.scrollTo({ left: rail.scrollLeft >= rail.scrollWidth - rail.clientWidth - 2 ? 0 : rail.scrollLeft + 276, behavior: 'smooth' });
  };
  return <section className={`section ${className}`} id={id} ref={ref} aria-labelledby={`${id}-title`}>
    <header className="section-heading">
      <div className="heading-row"><div className="title-with-info"><h2 id={`${id}-title`}>{title}</h2>
        {info && <button className="info-button" aria-label={`About ${title}`} onClick={() => onInfo?.(title, info)}><Picture name="info" /></button>}
      </div><button className="arrow-button" aria-label={`See more ${title.toLowerCase()}`} onClick={advance}><Picture name="arrow" /></button></div>
      {subtitle && <p className="section-subtitle">{subtitle}</p>}
    </header>
    {children}
  </section>;
}

export default function App() {
  const storagePrefix = 'hatch-reference';
  const [query, setQuery] = useState('');
  const [saved, setSaved] = useState<string[]>(() => stored(`${storagePrefix}-saved`, []));
  const [cart, setCart] = useState<CartItem[]>(() => stored(`${storagePrefix}-cart`, []));
  const [address, setAddress] = useState(() => stored(`${storagePrefix}-address`, "Carrer D’Avila 54"));
  const [addressDraft, setAddressDraft] = useState(address);
  const [panel, setPanel] = useState<Panel | null>(null);
  const [toast, setToast] = useState('');
  const [activeNav, setActiveNav] = useState('Discover');
  const dialog = useRef<HTMLDialogElement>(null);
  const search = useRef<HTMLInputElement>(null);
  useEffect(() => { localStorage.setItem(`${storagePrefix}-saved`, JSON.stringify(saved)); }, [saved, storagePrefix]);
  useEffect(() => { localStorage.setItem(`${storagePrefix}-cart`, JSON.stringify(cart)); }, [cart, storagePrefix]);
  useEffect(() => { localStorage.setItem(`${storagePrefix}-address`, JSON.stringify(address)); }, [address, storagePrefix]);
  useEffect(() => { if (panel) dialog.current?.showModal(); else dialog.current?.close(); }, [panel]);
  useEffect(() => { if (!toast) return; const timer = setTimeout(() => setToast(''), 2500); return () => clearTimeout(timer); }, [toast]);
  const open = (item: Item) => setPanel({ kind: 'detail', item });
  const info = (title: string, text: string) => setPanel({ kind: 'info', title, text });
  const close = () => { setPanel(null); setActiveNav('Discover'); };
  const toggleSaved = (name: string) => {
    setSaved(prev => prev.includes(name) ? prev.filter(x => x !== name) : [...prev, name]);
    setToast(saved.includes(name) ? `${name} removed from your picks` : `${name} saved to your picks`);
  };
  const add = (item: Item) => {
    setCart(prev => prev.some(x => x.name === item.name) ? prev.map(x => x.name === item.name ? { ...x, quantity: x.quantity + 1 } : x) : [...prev, { ...item, quantity: 1 }]);
    setToast(`${item.name} added to your cart`);
    close();
  };
  const count = cart.reduce((sum, item) => sum + item.quantity, 0);
  const results = [...restaurants, ...stores, ...products].filter(item => `${item.name} ${item.restaurant || ''}`.toLocaleLowerCase().includes(query.trim().toLocaleLowerCase()));
  const StoreCard = ({ item, exclusive = false, fast = false }: { item: Item; exclusive?: boolean; fast?: boolean }) => <article className="store-card">
    <button className="store-picture" onClick={() => open(item)} aria-label={`Explore ${item.name}`}><Picture name={item.image} alt={item.name} />{exclusive && <span className="exclusive">Only on Glovo</span>}</button>
    <div className="store-title"><button onClick={() => open(item)}>{item.name}</button><button className={`save-button ${saved.includes(item.name) ? 'is-saved' : ''}`} aria-label={`${saved.includes(item.name) ? 'Unsave' : 'Save'} ${item.name}`} aria-pressed={saved.includes(item.name)} onClick={() => toggleSaved(item.name)}><Picture name="heart" /></button></div>
    <Rating item={fast && item.name === 'Grosso Napoletano' ? { reviews: '678', time: '25-35min' } : item} />
  </article>;
  const TallCard = ({ item, review = false }: { item: Item; review?: boolean }) => <button className={`tall-card ${review ? 'review-card' : ''}`} onClick={() => open(item)} aria-label={`Explore ${item.name}`}>
    <Picture name={item.image} alt={item.name} className="tall-cover" /><Picture name="card-curve" className="card-curve" />
    <h3>{item.name}</h3><div className="tall-rating"><Rating item={item} /></div>
    {review ? <><span className="card-kicker">Featured review</span><p className="review-quote">“Super large portions and arrived hot. Do not skip the sweet potato fries”</p><span className="review-age">2 hours ago</span></> : <><span className="card-kicker">{item.name === 'Nudes' ? 'Products you looked at' : 'Highlights'}</span><div className="mini-products">{(item.name === 'Nudes' ? ['smoothie', 'juices', 'wrap'] : ['jalebi-cup', 'jalebi-bowl', 'jalebi-curry']).map((name, i) => <Picture key={name} name={name} className={`mini-product mini-${i}`} />)}</div></>}
  </button>;

  return <div className="app-shell">
    <div className="design-surface">
      <header className="hero">
        <div className="status-bar" aria-hidden="true"><span className="status-time">9:41</span><div className="status-icons"><Picture name="cellular" /><Picture name="wifi" /><Picture name="battery" /></div></div>
        <div className="address-row"><button className="address-button" onClick={() => { setAddressDraft(address); setPanel({ kind: 'address' }); }} aria-label={`Delivery address: ${address}`}><span>{address}</span><Picture name="chevron" /></button></div>
        <div className="greeting"><h1>Good evening,<br />Sebastian</h1><p>Ready to discover something new tonight?</p></div>
        <div className="hero-art" aria-hidden="true"><Picture name="header-blob-yellow" className="hero-blob yellow" /><Picture name="header-blob-cream" className="hero-blob cream" /><Picture name="magnifier" className="magnifying-glass" /></div>
        <Picture name="header-curve" className="hero-curve" />
      </header>
      <main>
        <div className="search-wrap"><Picture name="search" /><input ref={search} type="search" value={query} onChange={e => setQuery(e.target.value)} placeholder="Search" aria-label="Search restaurants and dishes" autoComplete="off" />{query && <button className="clear-search" onClick={() => { setQuery(''); search.current?.focus(); }}>Clear</button>}</div>
        {query.trim() ? <section className="search-results" aria-live="polite"><h2>Search results</h2><p>{results.length} {results.length === 1 ? 'match' : 'matches'} for “{query}”</p>{results.map((item, i) => <button className="result-row" key={`${item.name}-${i}`} onClick={() => open(item)}><Picture name={item.image} alt="" /><span><strong>{item.name}</strong><small>{item.price ? euro(item.price) : 'Explore restaurant'}</small></span><Picture name="arrow" className="inline-icon" /></button>)}{results.length === 0 && <div className="empty-state"><h3>No matches yet</h3><p>Try a restaurant name or a dish like “burrito”.</p><button className="primary-button" onClick={() => setQuery('')}>Back to Discover</button></div>}</section> : <div className="discovery-content">
          <Section id="top-restaurants" title="Top restaurants" subtitle="Most ordered in your city" className="top-section">
            <div className="rail ranked-rail" tabIndex={0} aria-label="Top restaurants carousel">
              {[0, 1].map(col => <div className="ranked-column" key={col}>{restaurants.slice(col * 3, col * 3 + 3).map((item, i) => <button className="ranked-card" key={item.name} onClick={() => open(item)}><span className="rank">{col * 3 + i + 1}</span><span className="ranked-logo"><Picture name={item.image} alt="" />{(i === 1 && col === 0 || i === 2 && col === 1) && <span className="promo-badge"><Picture name="promo-blob" /><Picture name="promo-icon" /></span>}</span><span className="ranked-body"><strong>{item.name}</strong><Rating item={item} compact delivery={false} /><span className="ranked-fee"><Picture name="delivery" />{item.fee}</span></span></button>)}</div>)}
            </div>
          </Section>
          <Section id="visited" title="You visited before" className="visited-section"><div className="rail tall-rail" tabIndex={0} aria-label="Previously visited restaurants"><TallCard item={stores[4]} /><TallCard item={stores[5]} /></div></Section>
          <Section id="friends" title="From your friends" subtitle="Hidden gems ordered by your friends" info="A selection of dishes your friends have ordered. The initials show which friends tried each dish." onInfo={info} onMore={() => info('From your friends', 'Your friends’ recent favourites, gathered in one place. Select a dish to see more.')} className="friends-section">
            <div className="friends-grid"><div className="friends-top"><FriendTile image="friend-curry" name="Chicken curry" friends={['J', 'F', 'G']} price="9,99€" onClick={() => open({ name: 'Chicken curry', image: 'friend-curry', price: 9.99 })} /><div className="friends-side"><FriendTile image="friend-burger" name="Double cheeseburger" friends={['A', 'B']} onClick={() => open({ name: 'Double cheeseburger', image: 'friend-burger', price: 9.99 })} /><FriendTile image="friend-chicken" name="Korean glazed chicken" friends={['H']} onClick={() => open({ name: 'Korean glazed chicken', image: 'friend-chicken', price: 9.99 })} /></div></div><div className="friends-bottom">{[['friend-wings', 'Sesame chicken wings', 'M', 'S'], ['friend-bowl', 'Chicken bowl', 'M'], ['friend-pizza', 'Margherita pizza', 'A', 'M']].map(([image, name, ...friends]) => <FriendTile key={image} image={image} name={name} friends={friends} onClick={() => open({ name, image, price: 9.99 })} />)}</div></div>
          </Section>
          <Section id="fast" title="Fast & well-rated" subtitle="Stores with typically fast delivery and high user ratings." className="fast-section"><div className="rail store-rail" tabIndex={0} aria-label="Fast and well-rated restaurants"><StoreCard item={stores[0]} fast /><StoreCard item={stores[1]} /></div></Section>
          <section className="grocery-section" aria-labelledby="grocery-title"><Picture name="grocery-curve-top" className="grocery-curve top" /><div className="grocery-content"><div className="heading-row"><h2 id="grocery-title">Top grocery stores</h2><button className="arrow-button" aria-label="See all grocery stores" onClick={() => info('Top grocery stores', 'Choose a store below to browse groceries. Delivery times are the estimates shown in the design.')}><Picture name="arrow" /></button></div><div className="grocery-grid">{groceries.map((name, i) => <button className="grocery-store" key={name} onClick={() => open({ name, image: groceryImages[i] })}><span className={`grocery-logo grocery-logo-${i}`}><Picture name={groceryImages[i]} alt={name} />{[0, 2, 3, 5].includes(i) && <span className="grocery-badge"><Picture name={i === 5 ? 'store-promo-blob' : 'store-badge-blob'} /><Picture name="store-badge" /></span>}</span><span>{i === 1 ? '20-30 min' : '10-20 min'}</span></button>)}</div><button className="in-store" onClick={() => info('In-store prices', 'Stores with this badge offer the same product prices as in their physical store. Delivery fees are shown separately.')}><span className="in-store-badge"><Picture name="store-badge-blob" /><Picture name="store-badge" /></span>In-store prices<Picture name="info" className="inline-icon" /></button></div><Picture name="grocery-curve-bottom" className="grocery-curve bottom" /></section>
          <Section id="saved" title="Saved for later" subtitle="Stores you've added to your picks but haven't tried" className="saved-section"><div className="rail store-rail" tabIndex={0} aria-label="Saved restaurants"><StoreCard item={stores[0]} exclusive /><StoreCard item={stores[1]} />{stores.filter(s => saved.includes(s.name) && !['Grosso Napoletano', 'Mayura'].includes(s.name)).map(item => <StoreCard item={item} key={item.name} />)}</div></Section>
          <Section id="local" title="Local favourites" subtitle="Most ordered by your neighbours over the last 3 hours" info="Popular nearby restaurants, based on orders placed over the last three hours." onInfo={info} className="local-section"><div className="rail tall-rail" tabIndex={0} aria-label="Local favourite restaurants"><TallCard item={stores[6]} review /><TallCard item={stores[7]} review /></div></Section>
          <Section id="lunch" title="Lunch for less than 9,99€" subtitle="No minimum spend. Deliver under 0,99€" info="The dishes in this selection cost less than 9,99€. Delivery fees are listed below each dish." onInfo={info} className="lunch-section"><div className="rail product-rail" tabIndex={0} aria-label="Lunch offers">{products.map((item, i) => <button key={item.name} className="product-card" onClick={() => open(item)}><div className="product-picture"><Picture name={item.image} alt={item.name} />{i === 0 && <span className="discount-badge">-20%</span>}{i < 2 && <Picture name={i === 0 ? 'gonzalez-logo' : 'healthy-product-logo'} className="product-logo" />}</div>{i < 2 && <span className="product-partner">{item.restaurant}</span>}<span className="product-name">{item.name}</span><span className="product-price">{euro(item.price!)}{i === 0 && <del>10,00€</del>}</span><span className={`delivery-tag ${i < 2 ? 'yellow-tag' : ''}`}><Picture name="delivery" />{item.fee}</span>{i === 2 && <span className="product-partner last-partner"><Picture name="incheon-logo" />Incheon<br />Korean</span>}<span className="ordered"><Picture name="ordered" /><span><strong>{i === 1 ? '100+' : '200+'}</strong> ordered</span></span></button>)}</div></Section>
          <Section id="newcomers" title="Highly-rated newcomers" subtitle="People are already loving these new stores on Glovo" className="new-section"><div className="rail store-rail" tabIndex={0} aria-label="Highly-rated newcomers"><StoreCard item={stores[2]} exclusive /><StoreCard item={stores[3]} /></div></Section>
        </div>}
      </main>
    </div>
    <nav className="bottom-nav" aria-label="Main navigation">{['Home', 'Discover', 'Cart', 'Profile'].map(label => <button key={label} className={activeNav === label ? 'active' : ''} aria-current={activeNav === label ? 'page' : undefined} onClick={() => { setActiveNav(label); if (label === 'Cart') setPanel({ kind: 'cart' }); else if (label === 'Profile') setPanel({ kind: 'profile' }); else { setQuery(''); window.scrollTo({ top: 0, behavior: 'smooth' }); } }}><span className="nav-icon"><Picture name={`nav-${label.toLowerCase()}`} />{label === 'Cart' && count > 0 && <span className="cart-count">{count}</span>}</span><span>{label}</span></button>)}</nav>
    <dialog ref={dialog} className="sheet" onCancel={close} onClick={e => { if (e.target === e.currentTarget) close(); }} onClose={() => { if (panel) close(); }}>
      {panel && <div className="sheet-content"><button className="close-sheet" onClick={close} aria-label="Close panel"><Picture name="chevron" /></button>
        {panel.kind === 'detail' && <><Picture name={panel.item.image} alt={panel.item.name} className="detail-image" /><h2>{panel.item.name}</h2>{panel.item.restaurant && <p className="muted">{panel.item.restaurant}</p>}{panel.item.price ? <><p className="detail-price">{euro(panel.item.price)}</p><p>Delivery: {panel.item.fee || '0,99€'}</p><button className="primary-button" onClick={() => add(panel.item)}>Add to cart · {euro(panel.item.price)}</button></> : <><Rating item={panel.item} /><button className="secondary-button" onClick={() => toggleSaved(panel.item.name)}>{saved.includes(panel.item.name) ? 'Remove from saved' : 'Save to your picks'}</button><h3>Discover something delicious</h3><div className="menu-list">{products.slice(0, 2).map(item => <button className="result-row" key={item.name} onClick={() => open(item)}><Picture name={item.image} /><span><strong>{item.name}</strong><small>{euro(item.price!)}</small></span><Picture name="arrow" className="inline-icon" /></button>)}</div><p className="demo-note">Preview menu for this local demo.</p></>}</>}
        {panel.kind === 'cart' && <><h2>Your cart</h2>{cart.length ? <><div className="cart-list">{cart.map(item => <div className="cart-row" key={item.name}><Picture name={item.image} /><div><strong>{item.name}</strong><span>{euro(item.price! * item.quantity)}</span><div className="quantity"><button aria-label={`Remove one ${item.name}`} onClick={() => setCart(prev => prev.flatMap(x => x.name !== item.name ? [x] : x.quantity > 1 ? [{ ...x, quantity: x.quantity - 1 }] : []))}>−</button><span>{item.quantity}</span><button aria-label={`Add one ${item.name}`} onClick={() => setCart(prev => prev.map(x => x.name === item.name ? { ...x, quantity: x.quantity + 1 } : x))}>+</button></div></div></div>)}</div><div className="cart-total"><strong>Subtotal</strong><strong>{euro(cart.reduce((sum, item) => sum + item.price! * item.quantity, 0))}</strong></div><p className="demo-note">This is a local demo cart. Orders and payments are not submitted.</p><button className="primary-button" onClick={close}>Keep exploring</button></> : <div className="empty-state"><Picture name="nav-cart" /><h3>Your next favourite is waiting</h3><p>Choose a dish to add it to your cart.</p><button className="primary-button" onClick={close}>Explore dishes</button></div>}</>}
        {panel.kind === 'profile' && <><h2>Hi, Sebastian</h2><p className="muted">Your discoveries, all in one place.</p><button className="secondary-button" onClick={() => { setAddressDraft(address); setPanel({ kind: 'address' }); }}>{address}<Picture name="chevron" className="inline-icon" /></button><h3>Your saved picks</h3>{saved.length ? saved.map(name => <div className="profile-pick" key={name}><span>{name}</span><button onClick={() => toggleSaved(name)}>Remove</button></div>) : <p>Tap the heart on a restaurant to save it here.</p>}</>}
        {panel.kind === 'address' && <form onSubmit={e => { e.preventDefault(); if (addressDraft.trim()) { setAddress(addressDraft.trim()); close(); setToast('Delivery address updated'); } }}><h2>Delivery address</h2><label className="form-label" htmlFor="address">Street and number</label><input className="address-input" id="address" value={addressDraft} onChange={e => setAddressDraft(e.target.value)} maxLength={80} required /><button className="primary-button" type="submit">Save address</button></form>}
        {panel.kind === 'info' && <><h2>{panel.title}</h2><p>{panel.text}</p><button className="primary-button" onClick={close}>Got it</button></>}
      </div>}
    </dialog>
    <div className={`toast ${toast ? 'visible' : ''}`} role="status">{toast}</div>
  </div>;
}

function FriendTile({ image, name, friends, price, onClick }: { image: string; name: string; friends: string[]; price?: string; onClick: () => void }) {
  return <button className={`friend-tile ${image} ${price ? 'featured' : ''}`} onClick={onClick} aria-label={`${name}, ordered by ${friends.length} ${friends.length === 1 ? 'friend' : 'friends'}`}><Picture name={image} alt={name} /><span className="friend-avatars">{friends.map((initial, i) => <span className={`friend-avatar friend-${initial.toLowerCase()} friend-position-${i}`} key={`${initial}-${i}`}>{initial}</span>)}</span>{price && <span className="friend-price">{price}</span>}</button>;
}
