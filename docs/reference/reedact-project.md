# reedACT Project Documentation

## Vision
**"Reactive Templates in Action = reedACT"**

Eine moderne Web-Template-Engine, die die bewährte Tera-Syntax um reaktive Komponenten erweitert. reedACT folgt dem **RTR-Pattern (Request → Template → Response)** statt traditionellem MVC und macht Frontend-Developer wieder zu den Product Ownern der User Interface.

### The Ultimate Proof: reedCMS

**reedCMS** wird die erste Production-Application auf reedACT sein - ein revolutionäres CMS das zeigt, was passiert wenn Templates die Kontrolle übernehmen. "The CMS that speaks Frontend" beweist jeden einzelnen Aspekt von reedACT in einer real-world Anwendung:

- **Template-Defined Content Types**: Frontend definiert Schema, Backend muss liefern
- **Connection-Adaptive Admin**: Verschiedene Interfaces für Phone/Desktop/Slow/Fast
- **Polyglot Plugin System**: PHP für WordPress-Integration, Python für SEO-Analysis, JS für Rich Editors
- **Frontend-First Database**: Templates generieren Database-Schemas basierend auf UI-Needs
- **Live Demonstration**: Wenn reedCMS läuft, ist reedACT production-ready für alles

reedCMS ist nicht nur ein CMS - es ist der lebende Beweis dass reedACT das überlegene Paradigma ist. Ein CMS das sich an jeden Client anpasst, jede Sprache für ihren optimalen Use-Case nutzt, und Frontend-Developer zu den wahren Architekten macht.

## Core Philosophy

### RTR Pattern: Request → Template → Response
reedACT eliminiert MVC-Overhead und folgt einem ehrlichen, direkten Pattern:

1. **Request** kommt herein
2. **Template** holt was es braucht und rendert  
3. **Response** geht raus

**Das war's. Keine 13 Abstraction-Layer für simple CRUD.**

### Design Principles
- **Frontend-First**: Templates definieren was Backend liefern muss
- **HTML-First**: Semantische Templates, nicht JSX-Chaos
- **Progressive Enhancement**: Funktioniert ohne JavaScript, wird mit Rust/WASM besser
- **Right Tool for the Job**: Python für ML, JS für JSON, SQL für Queries
- **Convention over Configuration**: Zero-config per default, Power-User-Optionen verfügbar
- **KISS**: Nur 2 Core-Primitives, erweitert durch Filter-System

## Template Syntax

### Basic Reactive Blocks
```html
<!-- Auto-Component-Name vom Block-Namen abgeleitet -->
{% block content as reedACT via auto %}
  <p {% bind "message" %}>{{ status.message }}</p>
  <button {% on "click" call "save" %}>Save</button>
{% endblock content %}
```

### Explicit Configuration
```html
<!-- Expliziter Component-Name und Transport -->
{% block dashboard as reedACT DashboardWidget via socket act aggressive oldfashioned %}
  <div {% bind "stats" %}>{{ dashboard.stats }}</div>
  <button {% on "click" call="refresh" | debounce(1s) %}>Refresh</button>
{% endblock dashboard %}
```

### Server-Side Code Execution
```html
<!-- Execute code on server and return results to template -->
{% reedACT Calculator via map | python %}
  import pandas as pd
  
  df = pd.DataFrame({{ user_data | json }})
  result = df.groupby('category').sum().to_dict()
  return result
{% endreedACT %}

<div class="analytics">
  {% for category, total in calculated_data %}
    <span>{{ category }}: {{ total }}</span>
  {% endfor %}
</div>
```

## Core Primitives

reedACT hat nur **2 Core-Primitives** um Feature-Creep zu vermeiden:

### 1. Auswertung (bind)
Synchronisiert Server-State mit DOM-Elementen:
```html
<span {% bind "stock" %}>{{ product.stock }}</span>
<div {% bind "total" | format(currency) %}>${{ cart.total }}</div>
<h1 {% bind "title" | transform(uppercase) %}>{{ page.title }}</h1>
```

### 2. Handlung (on)  
Konvertiert User-Input zu State-Changes:
```html
<button {% on "click" call="save" %}>Save</button>
<input {% on "input" call="update_name" | debounce(300ms) %}>
<form {% on "submit" call="checkout" | prevent | validate %}>
```

### Filter-System
Nutzt Tera's existierende Filter-Syntax für Event-Modifiers und Data-Transforms:

```html
<!-- Event-Modifiers -->
<button {% on "click" call="submit" | prevent | once | loading %}>Submit</button>
<input {% on "input" call="search" | debounce(500ms) | transform(lowercase) %}>

<!-- Data-Transforms -->
<div {% bind "status" | transform(uppercase) | highlight %}>{{ status }}</div>
<span {% bind "price" | format(currency) | animate(pulse) %}>{{ product.price }}</span>
```

## Transport Methods

### Automatic (Recommended)
```html
{% block content as reedACT via auto %}
```
reedACT entscheidet intelligent basierend auf Heuristiken:
- Seltene Updates → HTTP  
- Häufige Updates + Multi-User → WebSocket
- UI-only State → Client-only

### Explicit Transport
```html
{% block chat as reedACT via socket %}                     <!-- WebSocket für real-time -->
{% block settings as reedACT via http %}                   <!-- HTTP REST für CRUD -->
{% block analytics as reedACT via map | python %}          <!-- Python backend map -->
{% block effects as reedACT via map | node %}              <!-- Node.js backend map -->
```

**Note:** Frontend JavaScript/TypeScript files (`.js.tera`, `.ts.tera`) are automatically injected into the document head as functions with unique component IDs. No transport specification needed - they run in the browser by default.

## Global Template Variables

### Unified Global Configuration

reedACT uses server-side request analysis to automatically set global template variables, providing zero-JavaScript client detection and environment awareness.

```toml
# config/globals.toml - Alle Template-Globals zentral konfiguriert

[globals]

# Client detection rules
[globals.client.phone]
max_width = 480
user_agent_contains = ["Mobile", "iPhone", "Android"]
performance_tier = "low"
css_strategy = "minimal"

[globals.client.tablet]
min_width = 481
max_width = 1024
user_agent_contains = ["Tablet", "iPad"]
performance_tier = "mid"

[globals.client.desktop]
min_width = 1025
performance_tier = "high"

[globals.client.low_end]
max_memory_gb = 4
css_strategy = "minimal"
js_strategy = "basic"

[globals.client.high_end]
min_memory_gb = 8
css_strategy = "full_features"
js_strategy = "advanced"

[globals.client.slow_connection]
connection_types = ["2g", "3g"]
image_format = "webp_compressed"

# Environment-based globals  
[globals.env.development]
debug_mode = true
hot_reload = true
verbose_errors = true

[globals.env.production]
debug_mode = false
minify_assets = true
enable_caching = true

# Feature flags
[globals.features.experimental_ui]
enabled = false
rollout_percentage = 5

[globals.features.new_checkout]
enabled = true
rollout_percentage = 100

# Theme globals
[globals.theme.dark]
css_variables = { primary = "#2d3748", background = "#1a202c" }

[globals.theme.light] 
css_variables = { primary = "#3182ce", background = "#ffffff" }

# User role globals
[globals.user.admin]
user_roles = ["admin", "super_admin"]
features = ["admin_panel", "user_management"]

[globals.user.premium]
subscription_tiers = ["premium", "enterprise"]
features = ["advanced_analytics", "priority_support"]
```

### Template Usage with Unified Globals

```html
<!-- dashboard.tera - Alle globals verfügbar -->
{% block dashboard as reedACT DashboardWidget via auto %}
  {% if globals.client.phone %}
    <!-- Phone-optimized layout -->
    <div class="dashboard-mobile">
      {% for widget in dashboard.widgets %}
        <div class="widget-minimal">{{ widget.value }}</div>
      {% endfor %}
    </div>
    
  {% elif globals.client.desktop and globals.user.admin %}
    <!-- Admin desktop layout -->
    <div class="dashboard-admin">
      {% for widget in dashboard.widgets %}
        <div class="widget-admin">
          <h3>{{ widget.title }}</h3>
          <span>{{ widget.value }}</span>
          {% if globals.env.development %}
            <small class="debug">ID: {{ widget.id }}</small>
          {% endif %}
        </div>
      {% endfor %}
    </div>
  {% endif %}
  
  {% if globals.features.experimental_ui %}
    <!-- Experimental features nur für A/B-Test-Users -->
    <div class="experimental-widget">
      <button {% on "click" call="try_new_feature" %}>Try New Feature</button>
    </div>
  {% endif %}
  
  {% if globals.client.high_end and globals.client.fast_connection %}
    <!-- Rich experience für High-End-Users -->
    <video autoplay muted loop>
      <source src="dashboard-bg-4k.mp4" type="video/mp4">
    </video>
  {% endif %}
{% endblock %}
```

### CSS Templates with Global Access

```scss
// dashboard.scss.tera
.dashboard-{{ component.id }} {
  {% if globals.theme.dark %}
    background: {{ globals.theme.dark.css_variables.background }};
    color: white;
  {% else %}
    background: {{ globals.theme.light.css_variables.background }};
    color: black;
  {% endif %}
  
  {% if globals.client.phone %}
    // Mobile styles
    display: flex;
    flex-direction: column;
    padding: 8px;
    
  {% elif globals.client.desktop %}
    // Desktop styles
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 24px;
    padding: 24px;
  {% endif %}
  
  {% if globals.client.low_end %}
    // Performance optimization für low-end
    .animation { display: none; }
    .complex-gradients { background: solid; }
  {% endif %}
}

{% if globals.env.development %}
  // Development-only styles
  .debug-border {
    border: 2px dashed red;
  }
  
  .debug-info:after {
    content: "Component: {{ component.id }}";
    position: absolute;
    background: yellow;
    font-size: 10px;
  }
{% endif %}
```

### Server-Side Implementation

```rust
impl GlobalsManager {
    fn load_globals_config() -> GlobalsConfig {
        let config_content = fs::read_to_string("config/globals.toml")?;
        toml::from_str(&config_content)?
    }
    
    fn build_template_globals(&self, req: &Request, user: &User) -> TemplateGlobals {
        let client_info = self.analyze_request(req);
        
        TemplateGlobals {
            client: self.detect_client_matches(&client_info),
            env: self.get_environment_globals(),
            features: self.get_feature_flags(&user),
            theme: self.get_theme_globals(&user),
            user: self.get_user_role_globals(&user),
        }
    }
}
```

**Benefits of Global Template Variables:**
- ✅ **Zero-JavaScript Detection**: All client info derived from HTTP headers
- ✅ **Unified Configuration**: One TOML file for all global template state
- ✅ **Semantic Namespacing**: `globals.client.phone`, `globals.env.development` 
- ✅ **Easy Deployment**: Simple config changes, no complex setup
- ✅ **Debug-Friendly**: Clear global state inspection in templates

## Named Endpoint Configuration

### Unified API Management

reedACT provides centralized endpoint configuration with automatic credential management, making API integration clean and secure across all languages.

```toml
# config/endpoints.toml - Zentrale API-Endpoint-Verwaltung

[endpoints]

# Payment APIs
[endpoints.stripe]
url = "https://api.stripe.com/v1"
api_key = "${STRIPE_SECRET_KEY}"
timeout = 30
retry_attempts = 3

[endpoints.paypal] 
url = "https://api.paypal.com/v2"
client_id = "${PAYPAL_CLIENT_ID}"
client_secret = "${PAYPAL_CLIENT_SECRET}"
sandbox = false

# External Services
[endpoints.sendgrid]
url = "https://api.sendgrid.com/v3"
api_key = "${SENDGRID_API_KEY}"
from_email = "noreply@company.com"

[endpoints.analytics]
url = "https://analytics-api.company.com/v2"
bearer_token = "${ANALYTICS_TOKEN}"
rate_limit = 100

# Internal Services  
[endpoints.userservice]
url = "https://internal.company.com/users"
auth_header = "X-Internal-Token"
auth_value = "${INTERNAL_USER_TOKEN}"

[endpoints.inventory]
url = "https://warehouse-api.company.com/v3"
basic_auth = { username = "${WAREHOUSE_USER}", password = "${WAREHOUSE_PASS}" }

# Database connections
[endpoints.analytics_db]
url = "postgresql://analytics:${DB_PASS}@analytics-db:5432/analytics"
pool_size = 10
timeout = 15

[endpoints.redis_cache]
url = "redis://:${REDIS_PASS}@cache-cluster:6379/0"
ttl = 3600
```

### Template Usage with Named Endpoints

```html
<!-- checkout.tera -->
{% block checkout as reedACT CheckoutForm via auto %}
  {% reedACT PaymentProcessor via enclave | php %}
    // Use named endpoint instead of hardcoded URLs
    $stripe = new StripeClient(endpoint('stripe'));
    $paypal = new PayPalClient(endpoint('paypal'));
    
    // Credentials automatisch aus endpoints.toml geladen
    $payment_options = [
        'stripe' => $stripe->getAvailableMethods(),
        'paypal' => $paypal->getAvailableMethods()
    ];
    
    return $payment_options;
  {% endreedACT %}
  
  <!-- Template uses clean endpoint names -->
  <form {% on "submit" call="process_payment" | prevent %}>
    <div class="payment-methods">
      {% for method in stripe_methods %}
        <label>
          <input type="radio" name="payment" value="stripe_{{ method.id }}">
          {{ method.display_name }}
        </label>
      {% endfor %}
      
      {% for method in paypal_methods %}
        <label>
          <input type="radio" name="payment" value="paypal_{{ method.id }}">
          {{ method.display_name }}
        </label>
      {% endfor %}
    </div>
    
    <button type="submit">Pay Now</button>
  </form>
{% endblock %}
```

### Multi-Language Endpoint Integration

```html
<!-- user-dashboard.tera -->
{% block dashboard as reedACT UserDashboard via auto %}
  {% reedACT UserStats via map | python %}
    # Named endpoints in Python
    import requests
    
    # Analytics API mit automatic credentials
    analytics = endpoint('analytics')
    user_data = analytics.get(f'/users/{user_id}/stats')
    
    # Redis cache mit automatic connection
    cache = endpoint('redis_cache')
    cached_stats = cache.get(f'user_stats:{user_id}')
    
    return {
        'total_orders': user_data['total_orders'],
        'lifetime_value': user_data['lifetime_value'],
        'cached_at': cached_stats['timestamp'] if cached_stats else 'live'
    }
  {% endreedACT %}
  
  {% reedACT NotificationSender via map | php %}
    // SendGrid integration mit named endpoint
    $sendgrid = endpoint('sendgrid');
    
    $welcome_email = $sendgrid->send([
        'to' => {{ user.email }},
        'subject' => 'Welcome to Dashboard',
        'template' => 'dashboard_welcome'
    ]);
    
    return ['email_sent' => $welcome_email->success];
  {% endreedACT %}
  
  <div class="dashboard">
    <h1>Welcome {{ user.name }}!</h1>
    <p>{{ total_orders }} orders, ${{ lifetime_value }} lifetime value</p>
    
    {% if email_sent %}
      <div class="success">Welcome email sent!</div>
    {% endif %}
  </div>
{% endblock %}
```

### Server-Side Implementation

```rust
// Helper function in map context
impl MapContext {
    fn endpoint(&self, name: &str) -> EndpointClient {
        let config = self.get_endpoint_config(name);
        
        EndpointClient::new(config)
            .with_credentials(&config.credentials)
            .with_timeout(config.timeout)
            .with_retry_policy(config.retry_attempts)
    }
}
```

**Benefits of Named Endpoints:**
- ✅ **Named endpoints** instead of hardcoded URLs
- ✅ **Central credential management** with environment variable resolution
- ✅ **Polyglot support** - same endpoint names across PHP/Python/Node
- ✅ **Zero template config** - `endpoint('stripe')` and done
- ✅ **Environment-aware** - automatic dev/staging/prod endpoint switching

## Dynamic CSS Generation

### Component-Scoped CSS with Auto-Naming

reedACT generates dynamic, component-scoped CSS based on client detection, delivering only the styles each client actually needs while providing crystal-clear debugging experience.

#### Auto-Component CSS Templates
```css
/* product-card.scss.tera */
.{{ component.name }} {
  /* Automatically becomes: .product-card */
  background: white;
  border-radius: 8px;
  
  {% if globals.client.phone %}
    padding: 12px;
    margin-bottom: 8px;
  {% else %}
    padding: 20px;
    margin-bottom: 16px;
  {% endif %}
  
  {% if globals.client.slow_connection %}
    /* Minimal for slow connections */
    box-shadow: none;
    background: #f8f9fa;
  {% else %}
    /* Rich for fast connections */
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    background: linear-gradient(to bottom, #ffffff, #f8f9fa);
  {% endif %}
}

.{{ component.name }} h3 {
  /* Automatically becomes: .product-card h3 */
  margin: 0 0 8px 0;
  font-size: {{ globals.client.phone ? '16px' : '20px' }};
  color: #1f2937;
}

.{{ component.name }} .price {
  /* Automatically becomes: .product-card .price */
  font-weight: 700;
  color: #059669;
  
  {% if globals.client.phone %}
    font-size: 14px;
  {% else %}
    font-size: 18px;
  {% endif %}
}

.{{ component.name }} button {
  {% if globals.client.phone %}
    padding: 8px 16px;
    font-size: 14px;
    width: 100%;
  {% else %}
    padding: 12px 24px;
    font-size: 16px;
    width: auto;
  {% endif %}
  
  {% if globals.client.slow_connection %}
    background: #3182ce;
    border: none;
  {% else %}
    background: linear-gradient(135deg, #3182ce, #805ad5);
    border: none;
    transition: all 0.2s ease;
  {% endif %}
}

{% if not globals.client.slow_connection %}
.{{ component.name }} button:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(49, 130, 206, 0.4);
}
{% endif %}
```

#### Template with Auto-Generated Classes
```html
<!-- product-card.tera -->
{% block card as reedACT ProductCard via auto %}
  <article class="{{ component.name }}">        <!-- .product-card -->
    <img src="{{ optimized_image(product.image) }}" alt="{{ product.name }}">
    
    <h3>{{ product.name }}</h3>
    
    <div class="price">${{ product.price }}</div>
    
    <button {% on "click" call="add_to_cart" %}>
      Add to Cart
    </button>
  </article>
{% endblock %}
```

### Generated CSS File Structure
```
public/generated/
├── dashboard/
│   ├── reedact-phone.css           # 8KB - only dashboard components for phone
│   ├── reedact-phone.slow.css      # 6KB - dashboard minimal for slow connections
│   ├── reedact-tablet.css          # 18KB - dashboard tablet layout
│   └── reedact-desktop.css         # 25KB - dashboard full desktop experience
├── product/  
│   ├── reedact-phone.css           # 12KB - only product components for phone
│   ├── reedact-tablet.css          # 22KB - product tablet layout
│   └── reedact-desktop.css         # 35KB - product full desktop experience
└── checkout/
    ├── reedact-phone.css           # 15KB - only checkout components for phone
    └── reedact-desktop.css         # 30KB - checkout desktop experience
```

### CSS Bundle Size Comparison

| Framework | Bundle Strategy | Phone User Gets | Desktop User Gets | Total Files on Server |
|-----------|----------------|-----------------|-------------------|----------------------|
| **Traditional** | One superbundle | 847KB (99% unused) | 847KB (60% unused) | 1 file |
| **reedACT** | Dynamic per-page | 8KB (100% used) | 35KB (100% used) | 12 files |

**Benefits of Dynamic CSS Generation:**
- ✅ **18x smaller downloads** - phone users get 8KB instead of 847KB
- ✅ **Page-specific optimization** - only components actually used on current page
- ✅ **Client-specific optimization** - phone vs desktop vs slow connection variants
- ✅ **Component-scoped naming** - automatic `.{{ component.name }}` prevents conflicts
- ✅ **Perfect debugging** - clear source mapping to `.scss.tera:line`
- ✅ **HTTP/2 optimized** - multiple small files load in parallel with zero latency penalty
- ✅ **Superior caching** - granular invalidation, static files cache forever

## Microsecond Connection Quality Detection

### Real-Time Bandwidth Measurement

reedACT leverages standard TCP socket APIs for instant, robust connection quality detection without any client-side JavaScript or additional round-trips.

```rust
impl ConnectionDetector {
    fn measure_connection_quality(&self, req: &Request) -> ConnectionQuality {
        // 1. HTTP-Headers analysieren (< 1 microsecond)
        let connection_hint = req.headers().get("connection");
        let accept_encoding = req.headers().get("accept-encoding");
        
        // 2. TCP-Socket Info direkt abfragen (< 10 microseconds)
        let socket_info = req.connection_info();
        let rtt = socket_info.round_trip_time();      // TCP Round-trip time
        let bandwidth = socket_info.estimated_bandwidth();
        
        // 3. Sofortige Klassifikation
        match (rtt.as_micros(), bandwidth) {
            (0..=50_000, _) if bandwidth > 10_000_000 => ConnectionQuality::Fiber,    // <50ms, >10MB/s
            (0..=100_000, _) if bandwidth > 5_000_000 => ConnectionQuality::Fast4G,   // <100ms, >5MB/s  
            (0..=200_000, _) if bandwidth > 1_000_000 => ConnectionQuality::Good4G,   // <200ms, >1MB/s
            (0..=500_000, _) => ConnectionQuality::Slow3G,                           // <500ms
            _ => ConnectionQuality::VeryShow2G,
        }
    }
}

// Real-Time Bandwidth Estimation using standard TCP APIs
impl BandwidthEstimator {
    fn estimate_from_socket(&self, socket: &TcpSocket) -> u64 {
        // TCP Congestion Window Size - kernel-level info
        let cwnd = socket.congestion_window_size();
        
        // Round-Trip Time from TCP stack - microsecond precision  
        let rtt = socket.smoothed_rtt();
        
        // Bandwidth = CWND / RTT (classic TCP formula)
        let estimated_bps = (cwnd as f64 / rtt.as_secs_f64()) as u64;
        
        estimated_bps
    }
}
```

### Connection-Adaptive Media Delivery

```html
<!-- Smart media selection based on real connection speed -->
{% block media as reedACT MediaPlayer via auto %}
  {% if globals.client.slow_connection %}
    <!-- Audio-only for slow connections -->
    <audio controls>
      <source src="{{ media('podcast', 'compressed') }}">  <!-- 240KB/min vs 15MB -->
    </audio>
    <div class="transcript">{{ media.transcript }}</div>
    
  {% elif globals.client.fast_connection %}
    <!-- Standard video -->
    <video controls>
      <source src="{{ media('video', 'hd') }}">           <!-- 5MB/min -->
    </video>
    
  {% elif globals.client.fiber %}
    <!-- 4K with preloading -->
    <video controls preload="auto">
      <source src="{{ media('video', '4k_av1') }}">       <!-- 25MB/min, instant start -->
    </video>
  {% endif %}
{% endblock %}
```

### Image Optimization by Connection

```html
{% block gallery as reedACT PhotoGallery via auto %}
  {% if globals.client.slow_connection %}
    <!-- Thumbnail placeholders with lazy loading -->
    {% for photo in photos %}
      <div class="photo-placeholder" data-full="{{ image(photo, 'compressed') }}">
        <div class="placeholder-content">
          <h4>{{ photo.title }}</h4>
          <button {% on "click" call="load_image" %}>Load Image ({{ photo.size_compressed }})</button>
        </div>
      </div>
    {% endfor %}
    
  {% elif globals.client.fiber %}
    <!-- Full resolution with preloading -->
    {% for photo in photos %}
      <img src="{{ image(photo, '4k') }}" loading="lazy" alt="{{ photo.title }}">
    {% endfor %}
    
    <!-- Preload next batch -->
    {% for photo in photos[10:20] %}
      <link rel="preload" as="image" href="{{ image(photo, '4k') }}">
    {% endfor %}
  {% endif %}
{% endblock %}
```

**Connection-Adaptive Benefits:**
- ✅ **Microsecond detection** using standard TCP socket APIs
- ✅ **56x bandwidth savings** for slow connections (8KB vs 450KB images)  
- ✅ **Zero client-side JavaScript** for detection
- ✅ **Instant optimization** on first request
- ✅ **Perfect UX** for every connection type - no buffering on slow, no quality loss on fast

## Server-Side Code Execution (Map System)

reedACT ermöglicht server-side execution verschiedener Sprachen in sicheren "reedACT Maps". Jede Map gibt einen expliziten **Record** zurück, der nur die für das Frontend bestimmten Variables enthält.

### Map API Contract Pattern

**Information Hiding durch explizite Records:**
```html
<!-- user-stats.py.tera - Map mit privatem Scope -->
{% macro execute() %}
  # Private implementation details (nicht für Frontend sichtbar)
  raw_user_data = User.objects.get(id={{ user_id }})
  temp_calculations = []
  debug_counter = 0
  intermediate_results = {}
  complex_business_logic_vars = process_user_metrics(raw_user_data)
  
  # Nur explizit returned Variables werden für Frontend verfügbar
  return {
      'user_name': raw_user_data.first_name + ' ' + raw_user_data.last_name,
      'total_orders': raw_user_data.orders.count(),
      'lifetime_value': complex_business_logic_vars.final_calculation,
      'loyalty_tier': raw_user_data.calculate_tier(),
      'display_status': format_user_status(raw_user_data)
  }
  
  # raw_user_data, temp_calculations, debug_counter etc. 
  # bleiben in der Map und sind NICHT im Frontend verfügbar
{% endmacro %}
```

**Template-Usage mit Namespace-Access:**
```html
<!-- dashboard.tera - Clean interface ohne pollution -->
{% import "user-stats.py.tera" as userStats %}
{% import "pricing.php.tera" as pricing %}

{% block dashboard as reedACT UserDashboard via auto %}
  <!-- Nur explizit exported variables verfügbar -->
  <div class="welcome">
    <h1>Welcome {{ userStats.user_name }}!</h1>
    <div class="stats">
      <span {% bind "total_orders" %}>{{ userStats.total_orders }} orders</span>
      <span class="tier">{{ userStats.loyalty_tier }} member</span>
      <span>${{ userStats.lifetime_value }} lifetime value</span>
    </div>
    <p class="status">{{ userStats.display_status }}</p>
  </div>
  
  <div class="pricing">
    <span>${{ pricing.final_price }}</span>
    <small>{{ pricing.discount_message }}</small>
  </div>
  
  <!-- Fehler: Diese Variables existieren nicht im Template-Scope -->
  <!-- {{ userStats.raw_user_data }} = COMPILATION ERROR -->
  <!-- {{ userStats.debug_counter }} = COMPILATION ERROR -->
  <!-- {{ userStats.temp_calculations }} = NOT EXPORTED -->
{% endblock %}
```

### Multi-Language Record Examples

#### PHP Map Record
```html
<!-- pricing.php.tera -->
{% macro execute() %}
  // Private business logic variables
  $product = Product::with(['discounts', 'category'])->find({{ product_id }});
  $temp_discount_calc = 0;
  $internal_pricing_rules = $this->loadPricingMatrix();
  $debug_info = ['step' => 1, 'calculations' => []];
  
  // Complex discount calculation logic
  foreach ($product->discounts as $discount) {
      $temp_discount_calc += $this->calculateDiscount($discount);
      $debug_info['calculations'][] = $discount->type;
  }
  
  // Only return clean interface for frontend
  return [
      'base_price' => $product->base_price,
      'final_price' => $product->base_price - $temp_discount_calc,
      'discount_amount' => $temp_discount_calc,
      'discount_message' => $temp_discount_calc > 0 ? "You save $temp_discount_calc!" : "Regular price",
      'currency_symbol' => $this->getCurrencyFor({{ user.country }})
  ];
  
  // $product, $temp_discount_calc, $internal_pricing_rules, $debug_info 
  // bleiben privat in der PHP-Map
{% endmacro %}
```

#### Python Map Record
```html
<!-- analytics.py.tera -->
{% macro execute() %}
  import pandas as pd
  import numpy as np
  from datetime import datetime
  
  # Private data processing variables
  raw_data = fetch_analytics_data({{ user_id }})
  temp_dataframe = pd.DataFrame(raw_data)
  processing_steps = []
  intermediate_calculations = {}
  debug_metrics = {"rows_processed": 0, "errors": []}
  
  # Complex data science processing
  cleaned_data = temp_dataframe.dropna()
  aggregated_results = cleaned_data.groupby('category').agg({
      'revenue': 'sum',
      'orders': 'count'  
  }).to_dict()
  
  # Only return frontend-ready variables
  return {
      'top_category': max(aggregated_results['revenue'], key=aggregated_results['revenue'].get),
      'total_revenue': sum(aggregated_results['revenue'].values()),
      'growth_trend': calculate_trend(cleaned_data),
      'summary_message': f"Best performing category: {top_category}",
      'last_updated': datetime.now().strftime('%Y-%m-%d %H:%M')
  }
  
  # raw_data, temp_dataframe, processing_steps, debug_metrics etc.
  # bleiben privat in der Python-Map
{% endmacro %}
```

### Bundle Installation (Admin-Controlled)
```bash
# Server-Admin installiert gewünschte Language-Bundles
apt install reedact-map-python    # Python 3.11 + common packages (pandas, numpy, sqlalchemy)
apt install reedact-map-node      # Node.js 18+ + popular modules (axios, prisma, lodash)
apt install reedact-map-php       # PHP 8.3 + Composer packages (laravel, doctrine, guzzle)
apt install reedact-map-ruby      # Ruby 3.2 + gems (rails, activerecord, sequel)
```

### Multi-Language Macros
```
components/
├── product-card/
│   ├── product-card.tera          # Main template
│   ├── product-card.py.tera       # Python macros
│   ├── product-card.js.tera       # JavaScript macros  
│   ├── product-card.php.tera      # PHP macros
│   └── product-card.scss          # Component styles
```

**Example Usage:**
```html
<!-- product-card.tera -->
{% from "product-card.py.tera" import calculate_discount %}
{% from "product-card.php.tera" import format_price %}

{% block product as reedACT via auto %}
  {% reedACT PricingEngine via map | python %}
    {% call calculate_discount(product.price, user.tier) %}
  {% endreedACT %}
  
  {% reedACT PriceFormatter via map | php %}  
    {% call format_price(discounted_price, user.currency) %}
  {% endreedACT %}
  
  <div class="product">
    <h3>{{ product.name }}</h3>
    <span class="price">{{ formatted_price }}</span>
  </div>
{% endblock %}
```

## Behavior Flags

Semantic naming für Performance-Trade-offs:

```html
act aggressive     <!-- Speed über alles, hoher Resource-Verbrauch -->
act oldfashioned   <!-- Kompatibilität mit Web-Features älter als 3 Jahre -->
act paranoid       <!-- Security-first, Performance-second -->
act wasteful       <!-- RAM/Bandwidth egal, nur Performance -->
act experimental   <!-- Bleeding-edge Features -->
act patient        <!-- Langsam aber stabil -->
act reckless       <!-- Performance-first, alles andere egal -->
act minimalist     <!-- Kleine Bundle-Size über alles -->
```

## Technology Stack

### Frontend
- **Templates**: Tera mit reedACT-Extensions (.tera files)
- **Client Logic**: Rust/WASM für Reaktivität
- **Styling**: Standard CSS (co-located mit Components)

### Backend  
- **Server Framework**: Axum (memory-efficient, Tower-ecosystem)
- **Template Engine**: Extended Tera
- **Code Execution**: Secure language jails (FreeBSD-jail-inspired)
- **Transport**: WebSocket + HTTP REST + Server-side execution

### Security Architecture
```rust
// FreeBSD-Jail-inspired isolation
struct ExecutionJail {
    language: Language,           // php-8.3, python-3.11, node-18
    chroot_path: PathBuf,         // /jail/php83/root  
    resource_limits: ResourceLimits, // Memory, CPU, timeout
    allowed_syscalls: Vec<Syscall>,  // Whitelist system calls
    network_policy: NetworkPolicy,   // Isolated networking
}
```

### Development Workflow

#### Server Installation (One-time setup)
```bash
# Install reedACT server system-wide
apt install reedact-server
apt install reedact-map-php        # PHP 8.3 execution environment
apt install reedact-map-python     # Python 3.11 execution environment
apt install reedact-map-node       # Node.js 18 execution environment

# Start server service
systemctl enable reedact
systemctl start reedact
```

#### Project Development (Daily workflow)
```bash
# Create new project
reedact new my-project
cd my-project

# Development server with hot reload
reedact serve --dev --port 8080

# Deploy to production
reedact deploy --target production
```

### 1. Template-First Development  
```html
<!-- Designer/Frontend-Dev erstellt UI-Requirements mit automatic processing -->
{% from "dashboard-stats.py.tera" import "calculate_metrics" %}     <!-- Backend enclave -->  
{% from "dashboard-ui.js.tera" import "animate_counter" %}          <!-- Frontend head injection -->

{% block dashboard as reedACT UserDashboard via auto %}
  <div class="welcome">
    <h1>Welcome {{ user.name }}!</h1>
    <div class="stats">
      <span 
        {% get "order_count" %}
        {% on "update" call "animate_counter" %}
      >{{ calculate_metrics.total_orders }} orders</span>
      
      <span {% get "points" %}>{{ calculate_metrics.loyalty_points }} points</span>
    </div>
    
    <button {% send "refresh_action" %} {% on "click" call="refresh_stats" %}>
      Refresh Stats
    </button>
  </div>
{% endblock %}
```

### 2. Backend Implementation  
```php
<!-- Backend-Dev MUSS liefern was Frontend fordert -->
<!-- user-dashboard.php.tera -->
{% macro get_user_stats(user_id) %}
  $user = User::find({{ user_id }});
  
  // Frontend will name, order_count, loyalty_points
  // Backend hat keine Wahl - muss genau das liefern
  return [
      'name' => $user->first_name . ' ' . $user->last_name,
      'order_count' => $user->orders()->count(), 
      'loyalty_points' => $user->loyalty_points
  ];
{% endmacro %}
```

### 3. Reactive Logic (Optional)
```rust  
// components/user_dashboard.rs
#[reedact::component]
pub struct UserDashboard {
    order_count: u32,
    loyalty_points: u32,
}

impl UserDashboard {
    pub async fn refresh_stats(&mut self) -> Result<()> {
        // Real-time stats update via WebSocket
        let fresh_data = self.fetch_fresh_stats().await?;
        self.order_count = fresh_data.order_count;
        self.loyalty_points = fresh_data.loyalty_points;
        
        // Automatic DOM update via bind
        Ok(())
    }
}
```

## Security Architecture & File Serving

### Template Security Model

**IMPORTANT**: reedACT follows the same security model as Twig, Blade, and other server-side template engines:

- **Templates (`*.tera`) are NEVER sent to the client** - they're server-side only
- **Components (`*.php.tera`, `*.py.tera`, etc.) are NEVER exposed** - they execute on the server
- **Only rendered HTML/JSON and public assets are sent to browsers**

This is exactly like PHP applications:
- `.php` files → executed on server → HTML sent to client
- `.tera` files → rendered on server → HTML sent to client

### Directory Security Boundaries

```
my-reedact-project/
├── templates/           ← SERVER ONLY (like views/ in Laravel)
│   └── *.tera          ← Never served directly, always rendered
├── components/         ← SERVER ONLY (like app/ in Laravel)  
│   └── *.{php,py,js}.tera ← Executed in secure jails, never exposed
└── public/             ← CLIENT ACCESSIBLE (the usual suspects)
    ├── css/           ← Static stylesheets
    ├── js/            ← Client-side JavaScript
    ├── images/        ← Images, icons, etc.
    └── favicon.ico    ← Standard web assets
```

**Security Rules:**
1. **NEVER serve** anything outside `/public/` directly
2. **ALL templates** go through the rendering engine
3. **ALL code execution** happens in secure language jails
4. **NO raw template files** are ever accessible via HTTP

## Project Structure

### reedACT Server Structure (Installation)

The reedACT server itself is distributed as a system service with the following structure:

```
/opt/reedact/                       # Server installation directory
├── bin/
│   ├── reedact-server             # Main server binary
│   └── reedact-cli                # CLI tool for project management
├── lib/
│   ├── template_engine.so         # Core template processor
│   ├── jails/                     # Language execution engines
│   │   ├── php_jail.so
│   │   ├── python_jail.so
│   │   └── node_jail.so
│   └── transports/                # Communication layers
│       ├── websocket.so
│       └── http_rest.so
├── config/
│   ├── server.toml                # Server-wide configuration
│   ├── security.toml              # Jail security policies
│   └── performance.toml           # Resource limits and optimization
└── templates/
    └── system/                    # Built-in system templates
        ├── error.tera
        └── debug.tera
```

### Web Project Structure (Development)

Individual web projects built with reedACT have a clean, focused structure:

```
my-reedact-project/
├── config/                        # Project-specific configuration
│   ├── globals.toml              # Client detection, environment, features
│   ├── endpoints.toml            # API endpoints and credentials
│   └── project.toml              # Project settings
├── templates/                     # Frontend templates and logic
│   ├── base.tera                 # Base template
│   ├── pages/
│   │   ├── dashboard.tera
│   │   ├── product.tera
│   │   └── checkout.tera
│   └── components/
│       ├── user-dashboard/
│       │   ├── user-dashboard.tera
│       │   ├── user-dashboard.php.tera    # PHP business logic
│       │   ├── user-dashboard.py.tera     # Python analytics
│       │   ├── user-dashboard.js.tera     # JavaScript interactions
│       │   └── user-dashboard.scss        # Component styles
│       └── product-card/
│           ├── product-card.tera
│           ├── product-card.php.tera
│           └── product-card.scss
└── public/                        # Public web assets (the usual suspects)
    ├── css/                      # Compiled stylesheets
    ├── js/                       # Client-side JavaScript
    ├── images/
    │   ├── hero-4k.avif
    │   ├── hero-mobile.webp
    │   └── hero-compressed.webp
    ├── fonts/
    └── media/
        ├── video-4k.mp4
        ├── video-720p.mp4
        └── audio-compressed.mp3
```

## reedACT vs React: The Right Way to Build Reactive UIs

### React's Problems → reedACT's Solutions

#### **Problem 1: JSX Destroys Semantic HTML**
```jsx
// React: HTML structure lost in JavaScript
const ProductCard = ({product, onAddCart}) => {
  const [stock, setStock] = useState(product.stock);
  
  return (
    <div className="product-card">
      <h3>{product.name}</h3>
      <span className={stock > 0 ? "in-stock" : "out-of-stock"}>
        {stock} left
      </span>
      <button onClick={() => onAddCart(product.id)}>Add</button>
    </div>
  );
};
```

**reedACT Solution: HTML-First Templates**
```html
<!-- Clean, semantic HTML with reactive powers -->
{% from "stock-tracker.py.tera" import "get_live_stock" %}
{% from "cart-animation.js.tera" import "animate_add" %}

{% block product_card as reedACT ProductCard via auto %}
  <article class="product-card">
    <h3>{{ product.name }}</h3>
    <span class="{{ get_live_stock.css_class }}">
      {{ get_live_stock.count }} left
    </span>
    <button 
      {% on "click" call="add_to_cart" %}
      {% on "success" call="animate_add" %}
    >Add to Cart</button>
  </article>
{% endblock %}
```

#### **Problem 2: Complex State Management**  
```jsx
// React: Manual state synchronization hell
const [stock, setStock] = useState(product.stock);
const [loading, setLoading] = useState(false);
const [error, setError] = useState(null);

useEffect(() => {
  const ws = new WebSocket('/stock-updates');
  ws.onmessage = (e) => {
    const data = JSON.parse(e.data);
    if (data.productId === product.id) {
      setStock(data.stock);
    }
  };
  
  return () => ws.close();
}, [product.id]);

const handleAddToCart = async () => {
  setLoading(true);
  try {
    await addToCart(product.id);
    setStock(prev => prev - 1);
  } catch (err) {
    setError(err.message);
  } finally {
    setLoading(false);
  }
};
```

**reedACT Solution: Automatic State Synchronization**
```html
<!-- Server-authoritative state with automatic sync -->
{% from "inventory.php.tera" import "get_current_stock" %}

{% block product as reedACT ProductCard via auto %}
  <!-- State sync happens automatically -->
  <span {% get "stock" %}>{{ get_current_stock.available }} left</span>
  
  <!-- Error handling, loading states handled by reedACT -->
  <button {% on "click" call "add_to_cart" %}>Add to Cart</button>
{% endblock %}
```

#### **Problem 3: Server-Client Data-Fetching Complexity**
```jsx
// React: Manual API orchestration
const ProductPage = () => {
  const [product, setProduct] = useState(null);
  const [pricing, setPricing] = useState(null);
  const [recommendations, setRecommendations] = useState([]);
  
  useEffect(() => {
    Promise.all([
      fetch(`/api/products/${productId}`),
      fetch(`/api/pricing/${productId}`),  
      fetch(`/api/recommendations/${productId}`)
    ]).then(([productRes, pricingRes, recRes]) => {
      setProduct(productRes.json());
      setPricing(pricingRes.json());
      setRecommendations(recRes.json());
    });
  }, [productId]);
  
  if (!product) return <div>Loading...</div>;
  
  return (
    <div>
      <h1>{product.name}</h1>
      <span>${pricing?.finalPrice}</span>
      {/* Complex rendering logic */}
    </div>
  );
};
```

**reedACT Solution: Integrated Server-Side Processing**
```html
<!-- All data processing happens server-side automatically -->
{% from "product-data.php.tera" import "get_full_product" %}
{% from "pricing-engine.py.tera" import "calculate_pricing" %}
{% from "ml-recommendations.py.tera" import "get_suggestions" %}

{% block product as reedACT ProductPage via auto %}
  <!-- All data available immediately, no loading states -->
  <article class="product">
    <h1>{{ get_full_product.name }}</h1>
    <span class="price">${{ calculate_pricing.final_amount }}</span>
    
    <section class="recommendations">
      {% for item in get_suggestions.products %}
        <a href="/products/{{ item.slug }}">{{ item.name }}</a>
      {% endfor %}
    </section>
  </article>
{% endblock %}
```

### React's Core Benefits - But Better

| Feature | React | reedACT |
|---------|--------|---------|
| **Components** | JavaScript classes/functions | Tera blocks with Rust logic |
| **State Management** | Manual useState/Redux | Server-authoritative with auto-sync |
| **Reactivity** | Virtual DOM + reconciliation | Direct DOM updates via WebSocket/WASM |
| **Data Fetching** | useEffect + fetch | Automatic server-side integration |
| **Event Handling** | onClick handlers | `{% on %}` with filter modifiers |
| **Performance** | Client-side rendering | Server-rendered + progressive enhancement |
| **SEO** | Complex SSR setup | Built-in server rendering |
| **Type Safety** | PropTypes/TypeScript overlay | Native Rust type system |

### The Ultimate React Alternative

**reedACT delivers everything React promised:**
- ✅ **Component-based development** (Tera blocks)
- ✅ **Reactive user interfaces** (automatic state sync)  
- ✅ **Declarative programming** (template-driven)
- ✅ **Efficient updates** (targeted DOM changes)
- ✅ **Developer experience** (hot reload, error handling)

**Plus everything React failed to deliver:**
- ✅ **Semantic HTML** (no JSX pollution)
- ✅ **Server-first architecture** (better performance & SEO)
- ✅ **Polyglot backend** (right language for the job)
- ✅ **Simple mental model** (RTR pattern vs complex lifecycle)
- ✅ **Production-ready security** (enclave isolation)
- ✅ **Microsecond client detection** (zero JavaScript overhead)
- ✅ **Adaptive media delivery** (56x bandwidth optimization)

**Result: "React, but actually good."** 🚀

#### 1. **Backend-Driven UI Design**
```php
// Backend-Dev designs API without understanding frontend needs
class ProductController {
    public function show() {
        return new ProductResource([
            'entity' => $this->productRepository->findWithAllRelationsAndMetadata($id),
            'computed_fields' => $this->computationService->getAllPossibleComputations(),
            'meta' => $this->metaDataProvider->getExtensiveMetadata()
        ]);
    }
}
```

**Frontend-Dev struggles:**
```javascript
// "I just want product.name and product.price!"
const name = response.entity.attributes.product_information.display_name;
const price = response.computed_fields.pricing.final_amount.formatted.currency_string;
```

#### 2. **Frontend Rebuilds Backend Logic**
```javascript
// Twig/React: Business logic duplicated in frontend
function calculateShipping(items) {
    // "Backend API doesn't give me calculated shipping, so I rebuild it here"
    let total = 0;
    items.forEach(item => {
        // Duplicating backend shipping rules
        if (item.weight > 500) total += 5.99;
        // ... complex business logic copy-pasted from backend
    });
    return total;
}
```

#### 3. **MVC Complexity Without Benefits**
```php
// 260 lines across 5 files just to show a product
app/Http/Controllers/ProductController.php      # 50 lines
app/Services/ProductService.php                # 80 lines
app/Repositories/ProductRepository.php         # 60 lines  
app/Models/Product.php                         # 40 lines
resources/views/product/show.blade.php        # 30 lines
```

### reedACT's Solutions

#### 1. **Frontend-Defines-Backend Pattern**
```html
<!-- Template declares exactly what it needs -->
{% block product as reedACT via auto %}
  <h1>{{ product.name }}</h1>         <!-- Backend MUST provide product.name -->
  <p>${{ product.price }}</p>         <!-- Backend MUST provide product.price -->
  <span {% bind "stock" %}>{{ stock }} left</span>  <!-- Backend MUST provide live stock -->
{% endblock %}
```

**Backend becomes a service provider:**
```php
{% reedACT ProductData via map | php %}
  // No choice - frontend demands name, price, stock
  $product = Product::find({{ id }});
  return [
      'name' => $product->name,
      'price' => $product->price, 
      'stock' => $product->current_stock
  ];
{% endreedACT %}
```

#### 2. **Business Logic Stays in Backend**
```html
<!-- PHP with database integration -->
{% reedACT UserData via map | php %}
  // Use Eloquent ORM naturally
  $user = User::with(['orders', 'preferences'])
      ->where('id', {{ user_id }})
      ->first();
      
  return [
      'name' => $user->full_name,
      'order_count' => $user->orders()->count(), 
      'loyalty_points' => $user->loyalty_points
  ];
{% endreedACT %}

<!-- Python with data processing -->  
{% reedACT SalesAnalytics via map | python %}
  import pandas as pd
  from sqlalchemy import create_engine
  
  # Use Python's data science ecosystem
  engine = create_engine(database_url)
  df = pd.read_sql("""
      SELECT category, SUM(revenue) as total
      FROM sales WHERE date >= %s
      GROUP BY category
  """, engine, params=[start_date])
  
  result = df.to_dict('records')
  return result
{% endreedACT %}

<div class="analytics">
  {% for category in sales_data %}
    <div class="metric">{{ category.category }}: ${{ category.total }}</div>
  {% endfor %}
</div>
```

#### 3. **RTR Eliminates Unnecessary Layers**  
```html
<!-- One template, one purpose, direct execution -->
{% block user_dashboard as reedACT via auto %}
  {% reedACT UserStats via map | php %}
    // Direct database access with ORM
    $user = User::find({{ id }});
    $orders = $user->orders()->where('status', 'completed')->count();
    
    return [
        'name' => $user->full_name,
        'orders' => $orders,
        'lifetime_value' => $user->orders()->sum('total')
    ];
  {% endreedACT %}
  
  <h1>Hi {{ user_name }}!</h1>
  <p>{{ order_count }} orders worth ${{ lifetime_value }}</p>
{% endblock %}
```

## Language Execution Jails

### Supported Languages
- **PHP**: `via map | php-8.3` (WordPress, Laravel, Symfony integration)
- **Python**: `via map | python-3.11` (Data Science, ML, Analytics)  
- **JavaScript/TypeScript**: `via map | node-18` (Modern JS, JSON processing)
- **Ruby**: `via map | ruby-3.2` (Rails-style string processing)
- **Rust**: `via map | rust` (Performance-critical calculations)
- **SQL**: `via map | sql` (Complex database queries)

### Security Model (reedACT Jails)

reedACT uses "reedACT Jails" - software-based isolation inspired by FreeBSD jails that provides jail-level security without OS-complexity.

```rust
// reedACT Jail = Rust-based isolation with jail-security principles  
struct ReedACTJail {
    language: String,               // "php-8.3", "python-3.11"
    execution_limits: JailLimits,   // Memory, CPU, timeout limits
    security_policy: SecurityPolicy, // Function whitelists, blocked calls
    isolation_level: IsolationLevel, // Process/network/filesystem isolation
}

struct JailLimits {
    memory_limit: usize,           // Maximum RAM usage
    cpu_quota: f32,               // CPU percentage limit  
    execution_timeout: Duration,   // Maximum execution time
    max_processes: u32,           // Process spawn limit
    disk_quota: usize,            // Temporary file space
}

struct SecurityPolicy {
    allowed_functions: HashSet<String>,  // Whitelisted language functions
    blocked_functions: HashSet<String>,  // Dangerous functions (exec, system, etc.)
    allowed_imports: HashSet<String>,    // Whitelisted modules/packages
    network_access: bool,               // Network isolation flag
    filesystem_access: Vec<PathBuf>,    // Allowed file paths only
}
```

**Benefits of reedACT Jails:**
- **Jail-level security**: Complete process isolation with resource limits
- **Language-agnostic**: Same security model across PHP, Python, Node.js, etc.
- **Software-based**: No OS-level configuration required
- **Portable**: Works on Linux, macOS, Windows
- **Developer-friendly**: Standard Rust patterns, no complex setup

### Admin Configuration
```toml
# /etc/reedact/maps.toml
[php-8.3]
enabled = true
memory_limit = "256MB"
cpu_quota = 0.5
execution_timeout = 30
allowed_packages = ["laravel/framework", "guzzlehttp/guzzle"]
blocked_functions = ["exec", "system", "shell_exec"]
network_access = false

[python-3.11]
enabled = true  
memory_limit = "512MB"
packages = ["pandas", "numpy", "scikit-learn", "sqlalchemy", "psycopg2"]
blocked_modules = ["subprocess", "os", "sys"]
database_connections = ["postgresql://analytics_db"]
```

## Component Architecture

### Co-Located Component Files
```
components/shopping-cart/
├── shopping-cart.tera              # Main template
├── shopping-cart.php.tera          # PHP business logic macros
├── shopping-cart.py.tera           # Python analytics macros  
├── shopping-cart.js.tera           # JavaScript formatting macros
├── shopping-cart.scss              # Component styles
└── shopping-cart.rs                # Rust reactive logic (optional)
```

### Multi-Language Macro System
```html
<!-- shopping-cart.php.tera -->
{% macro get_user_orders(user_id, limit) %}
  // Use Laravel's Eloquent ORM  
  $orders = Order::with(['items.product'])
      ->where('user_id', {{ user_id }})
      ->orderBy('created_at', 'desc')
      ->limit({{ limit }})
      ->get();
      
  return $orders->map(function($order) {
      return [
          'id' => $order->id,
          'total' => $order->total,
          'item_count' => $order->items->count(),
          'status' => $order->status
      ];
  })->toArray();
{% endmacro %}

{% macro calculate_loyalty_points(user_id) %}
  // Complex business logic with database queries
  $user = User::find({{ user_id }});
  $totalSpent = $user->orders()->sum('total');
  $bonusMultiplier = $user->membership_tier === 'premium' ? 1.5 : 1.0;
  
  return floor($totalSpent * 0.01 * $bonusMultiplier);
{% endmacro %}
```

```html
<!-- shopping-cart.tera -->
{% from "shopping-cart.php.tera" import get_user_orders, calculate_loyalty_points %}

{% block cart as reedACT ShoppingCart via auto %}
  {% reedACT OrderHistory via map | php %}
    {% call get_user_orders(user.id, 5) %}
  {% endreedACT %}
  
  {% reedACT LoyaltyCalculator via map | php %}
    {% call calculate_loyalty_points(user.id) %}
  {% endreedACT %}
  
  <div class="cart-summary">
    <div class="loyalty">
      <span {% bind "points" %}>{{ loyalty_points }} points earned</span>
    </div>
    
    <div class="recent-orders">
      <h4>Recent Orders</h4>
      {% for order in recent_orders %}
        <div class="order">
          Order #{{ order.id }}: ${{ order.total }} ({{ order.item_count }} items)
        </div>
      {% endfor %}
    </div>
    
    <form {% on "submit" call="checkout" | prevent | validate %}>
      <button type="submit">Checkout</button>
    </form>
  </div>
{% endblock %}
```

## Technical Implementation

### Server Setup (Axum)
```rust
use axum::{routing::get, Router};
use reedact::axum::ReedACTLayer;

#[tokio::main]
async fn main() {
    let app = Router::new()
        .route("/*path", get(serve_templates))
        .layer(ReedACTLayer::new()
            .with_templates("templates/**/*.tera")
            .with_jail("php", reedact_map_php::PhpJail::new("8.3"))
            .with_jail("python", reedact_map_python::PythonJail::new("3.11"))
            .with_jail("node", reedact_map_node::NodeJail::new("18"))
        );
    
    let listener = tokio::net::TcpListener::bind("127.0.0.1:8080").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
```

### Request Processing Flow
1. **Request** hits Axum server
2. **Template** is identified and loaded
3. **Map executions** are processed in secure maps
4. **Template** is rendered with results
5. **Response** is sent with reactive client code injected

### Security Map Execution
```rust
impl LanguageMap for PythonMap {
    async fn execute_code(&self, code: &str, context: &Context) -> Result<Value> {
        // 1. Create isolated execution environment (map)
        let map = self.create_fresh_map().await?;
        
        // 2. Copy minimal Python runtime to map  
        map.copy_python_runtime("3.11").await?;
        
        // 3. Inject template context securely
        map.set_variables(context).await?;
        
        // 4. Execute with strict limits in secure map
        let result = map.execute_python(code, ExecutionLimits {
            memory: 256_000_000,      // 256MB
            timeout: Duration::from_secs(30),
            cpu_quota: 0.5,          // 50% CPU
        }).await?;
        
        // 5. Destroy map completely
        map.destroy().await?;
        
        Ok(result.exported_variables)
    }
}
```

## Example: E-Commerce Product Page

### Template (product.tera)
```html
{% extends "base.tera" %}
{% from "components/product-card/product-card.php.tera" import calculate_pricing, check_availability %}
{% from "components/product-card/product-card.py.tera" import get_recommendations %}

{% block main as reedACT ProductPage via auto act aggressive %}
  <!-- Server-side business logic in appropriate languages -->
  <!-- PHP business logic with Laravel ORM -->
  {% reedACT PricingEngine via map | php %}
    // Use Laravel's Eloquent for complex business rules
    $product = Product::with(['discounts', 'category'])->find({{ product.id }});
    $user = User::with('membership')->find({{ user.id }});
    
    $basePrice = $product->base_price;
    $categoryDiscount = $product->category->current_discount ?? 0;
    $membershipDiscount = $user->membership->discount_rate ?? 0;
    
    $finalPrice = $basePrice * (1 - max($categoryDiscount, $membershipDiscount));
    return round($finalPrice, 2);
  {% endreedACT %}
  
  {% reedACT InventoryChecker via map | php %}
    // Real-time inventory with business rules
    $product = Product::find({{ product.id }});
    $reservedCount = CartItem::where('product_id', {{ product.id }})
        ->where('created_at', '>', now()->subMinutes(15))
        ->sum('quantity');
        
    $availableStock = $product->stock - $reservedCount;
    return [
        'available' => $availableStock > 0,
        'stock_count' => max(0, $availableStock),
        'estimated_restock' => $product->estimated_restock_date
    ];
  {% endreedACT %}
  
  <!-- Python with database and ML integration -->  
  {% reedACT RecommendationEngine via map | python %}
    import pandas as pd
    from sqlalchemy import create_engine
    from sklearn.metrics.pairwise import cosine_similarity
    
    # Database integration with Python data science stack
    engine = create_engine(database_url)
    user_data = pd.read_sql("""
        SELECT product_id, rating FROM user_ratings 
        WHERE user_id = %s
    """, engine, params=[user_id])
    
    # ML processing  
    recommendations = ml_model.get_recommendations(user_data)
    return recommendations.to_dict('records')
  {% endreedACT %}
  
  <!-- Frontend focuses purely on UX -->
  <article class="product">
    <div class="hero">
      <img src="{{ product.image }}" alt="{{ product.name }}">
      <div class="details">
        <h1>{{ product.name }}</h1>
        <p class="price" {% bind "current_price" %}>{{ current_price }}</p>
        
        {% if inventory_available %}
          <p class="stock" {% bind "stock_count" %}>{{ stock_count }} available</p>
          
          <form {% on "submit" call="add_to_cart" | prevent | validate %}>
            <input type="number" {% bind "quantity" %} min="1" max="{{ stock_count }}">
            <button type="submit">Add to Cart</button>
          </form>
        {% else %}
          <p class="out-of-stock">Out of stock in your area</p>
        {% endif %}
      </div>
    </div>
    
    <!-- Real-time features via WebSocket -->
    {% reedACT LiveInventory via socket %}
      <div class="live-updates">
        <span {% bind "viewers" %}>{{ current_viewers }} people viewing this</span>
        <span {% bind "recent_purchases" %}>{{ recent_purchases }} sold today</span>
      </div>
    {% endreedACT %}
    
    <!-- AI-powered recommendations -->
    <section class="recommendations">
      <h3>Recommended for you</h3>
      {% for item in recommended_products %}
        <a href="/products/{{ item.slug }}" class="recommendation">
          <img src="{{ item.image }}" alt="{{ item.name }}">
          <span>{{ item.name }}</span>
          <span class="price">${{ item.price }}</span>
        </a>
      {% endfor %}
    </section>
  </article>
{% endblock %}
```

## reedCMS: The First reedACT Application

### Vision: "The CMS that speaks Frontend"

reedCMS demonstrates the full power of reedACT by building a production-ready CMS where templates control everything:

#### Template-Defined Content Types
```html
<!-- content-types/blog-post.tera -->
{% macro define_schema() %}
  {
    "title": {
      "type": "text",
      "required": true,
      "ui": {
        "phone": "single_line",
        "desktop": "rich_text_inline"
      }
    },
    "content": {
      "type": "markdown",
      "ui": {
        "phone": "textarea",
        "desktop": "markdown_editor_split",
        "slow_connection": "plain_text_only"
      }
    }
  }
{% endmacro %}
```

#### Connection-Adaptive Admin Interface
```html
{% block admin as reedACT CMSAdmin via auto %}
  {% if globals.client.phone %}
    <!-- Minimal mobile admin -->
    <div class="cms-mobile">
      <button {% on "click" call="quick_publish" %}>Publish</button>
      <button {% on "click" call="view_stats" %}>Stats</button>
    </div>
    
  {% elif globals.client.slow_connection %}
    <!-- Text-only admin for 2G/3G -->
    <form method="POST" action="/admin/save">
      <textarea name="content"></textarea>
      <button type="submit">Save</button>
    </form>
    
  {% else %}
    <!-- Full rich admin with live preview -->
    {% reedACT RichEditor via socket %}
      <split-editor>
        <monaco-editor {% bind "content" %} />
        <live-preview {% bind "rendered" %} />
      </split-editor>
    {% endreedACT %}
  {% endif %}
{% endblock %}
```

#### Polyglot Plugin Architecture
```html
<!-- plugins/seo-optimizer/seo.py.tera -->
{% macro analyze(content) %}
  import nltk
  from textstat import flesch_reading_ease
  
  keywords = nltk.word_tokenize(content)
  readability = flesch_reading_ease(content)
  
  return {
    'seo_score': calculate_score(keywords, readability),
    'suggestions': generate_suggestions(content)
  }
{% endmacro %}

<!-- plugins/e-commerce/shop.php.tera -->
{% macro process_order(cart) %}
  $order = Order::create([
    'items' => $cart['items'],
    'total' => calculate_total($cart)
  ]);
  
  // Stripe integration
  $payment = \Stripe\Charge::create([
    'amount' => $order->total * 100,
    'currency' => 'usd'
  ]);
  
  return ['order_id' => $order->id];
{% endmacro %}
```

#### Why reedCMS Matters

reedCMS serves as:
1. **Proof of Concept**: Every reedACT feature in production
2. **Dogfooding**: Building a real product reveals real needs
3. **Showcase**: Demonstrates superiority over WordPress/Ghost/Strapi
4. **Migration Path**: Can import from existing CMS platforms
5. **Performance Benchmark**: Real-world metrics for optimization

### reedCMS Architecture
```
reedCMS/
├── templates/
│   ├── admin/           # Adaptive admin interfaces
│   ├── public/          # Public-facing templates
│   └── content-types/   # Schema definitions
├── plugins/
│   ├── seo/            # Python-powered SEO
│   ├── shop/           # PHP e-commerce
│   └── analytics/      # Python data science
└── config/
    └── cms.toml        # CMS configuration
```

## Key Advantages

### Development Experience
- **Frontend-First**: UI requirements drive backend implementation
- **Language-Appropriate Logic**: Python for ML, PHP for business rules, SQL for queries
- **No Framework Lock-in**: Standard HTML/CSS with progressive enhancement  
- **Immediate Feedback**: Templates show exactly what backend must provide
- **Real Product Development**: reedCMS proves the concept works

### Performance  
- **Server-Side Execution**: Complex logic runs where it belongs
- **Efficient Transport**: Intelligent WebSocket vs HTTP decisions
- **Rust Performance**: Memory-safe, concurrent server layer
- **Minimal Client Bundles**: No large JavaScript frameworks
- **Microsecond Connection Detection**: Real-time bandwidth optimization
- **Adaptive Media Delivery**: 56x bandwidth savings for slow connections
- **Dynamic CSS Generation**: 18x smaller stylesheets (8KB vs 847KB)

### Security
- **Jail Isolation**: Complete separation between language executions  
- **Resource Limits**: Memory, CPU, timeout controls per execution
- **No Persistent State**: Fresh environment for every execution
- **Admin Control**: Whitelist packages, functions, network access

### Maintainability
- **RTR Pattern**: Simple request→template→response flow
- **Co-Located Components**: Related files together but properly separated
- **Self-Documenting**: Semantic behavior flags and explicit transport methods
- **No Over-Engineering**: Frontend requirements prevent unnecessary backend complexity

## Project Strategy & Domains

### reedACT Framework - The Universal Solution

**Domain: reedact.io**

reedACT is positioned as a standalone, universal web framework - not just for CMS but for ANY web application:

```
reedACT (Universal Framework) at reedact.io
    ├── reedCMS (CMS Implementation) at reedcms.com
    ├── reedCommerce (E-Commerce Platform)
    ├── reedAnalytics (Dashboard System)
    ├── reedAPI (API Gateway)
    └── [Any Developer Application]
```

### Domain Structure

#### reedact.io - The Framework
```
reedact.io                  → Landing & Documentation
reedact.io/start            → Quick Start Guide
reedact.io/playground       → Live Demo Environment
reedact.io/showcase         → Built with reedACT

# Developer-Specific Entry Points
reedact.io/php              → PHP Developer Guide
reedact.io/python           → Python Developer Guide
reedact.io/javascript       → JavaScript Developer Guide
reedact.io/ruby             → Ruby Developer Guide
reedact.io/rust             → Rust Developer Guide

# Comparison Pages for SEO
reedact.io/vs/nextjs        → reedACT vs Next.js
reedact.io/vs/laravel       → reedACT vs Laravel
reedact.io/vs/django        → reedACT vs Django
reedact.io/vs/rails         → reedACT vs Rails

# Resources & Community
docs.reedact.io             → Full Documentation
api.reedact.io              → API Reference
discuss.reedact.io          → Community Forum
showcase.reedact.io         → Application Gallery
cloud.reedact.io            → Cloud Services
status.reedact.io           → System Status
```

#### reedcms.com - The Product Showcase
```
reedcms.com                 → CMS Product (powered by reedACT)
php.reedcms.com             → "The ultimate CMS for PHP developers"
python.reedcms.com          → "The ultimate CMS for Python developers"
js.reedcms.com              → "The ultimate CMS for JavaScript developers"
```

### Marketing Positioning

#### For reedACT (The Framework):
- **Tagline**: "The Post-MVC Web Framework"
- **Target**: ALL web developers regardless of language preference
- **Message**: "Write PHP, Python, and JavaScript in the same template. Ship 8KB instead of 800KB."

#### For reedCMS (The Product):
- **Tagline**: "The CMS that speaks Frontend"
- **Target**: Content teams, businesses, agencies
- **Message**: "The first CMS built with reedACT - proving templates should rule the web"

### Developer Adoption Strategy

```bash
# Quick Start Experience
npm install -g @reedact/cli
reedact new my-app

# Framework Integrations
# Laravel + reedACT
composer require reedact/laravel-bridge

# Django + reedACT  
pip install reedact-django

# Rails + reedACT
gem install reedact-rails

# Express + reedACT
npm install @reedact/express
```

### Why This Strategy Works

1. **reedACT as Framework**: Competes with Next.js, Laravel, Django - massive market
2. **reedCMS as Proof**: Shows real-world application, generates revenue
3. **Clear Separation**: Framework for developers, CMS for businesses
4. **Language Agnostic**: Every developer finds their language supported
5. **SEO Dominance**: Own keywords like "post-mvc", "polyglot framework", "adaptive rendering"

---

**reedACT: Post-MVC, Frontend-First, Polyglot Web Development**
**reedCMS: The CMS that proves Templates should rule the Web**

*Request → Template → Response. That's it.*