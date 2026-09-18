# Jewellery Customer App

Multi-tenant Flutter customer app for the jewellery ERP. One binary serves N
shops: brand, palette, fonts, currency, languages and contact details all come
from a `TenantConfig` (bundled JSON today, `GET /api/v1/public/tenant/{key}`
later). Nothing brand-specific is hard-coded outside `assets/demo/tenant.json`.

Plan and progress live in `../docs/CUSTOMER-APP-PLAN.md` and
`../docs/CUSTOMER-APP-STATUS.md`.

## Requirements

Flutter 3.44 / Dart 3.12, Xcode 16 with CocoaPods for iOS, Android SDK with
minSdk 26. Same toolchain as the staff app (`../jwellery-mobile-app`).

## Running

Three flavours exist on both platforms, matching the staff app's wiring.

| Flavour | Android id | iOS bundle id | Name |
|---|---|---|---|
| dev | `com.finotechsoftware.jewelleryapp.customer.dev` | same | Fino Dev |
| staging | `com.finotechsoftware.jewelleryapp.customer.staging` | same | Fino STG |
| prod | `com.finotechsoftware.jewelleryapp.customer` | same | Fino Jewellery |

```sh
flutter pub get
flutter run --flavor dev                                     # demo data, tenant "fino"
flutter run --flavor staging --dart-define=ENV=staging
flutter run --flavor prod --dart-define=ENV=prod --release
flutter build ios --release --flavor dev --no-codesign       # what CI checks
flutter build apk --flavor prod --dart-define=ENV=prod
```

### Dart-defines

| Define | Values | Default | Effect |
|---|---|---|---|
| `ENV` | `dev` / `staging` / `prod` | `dev` | Base URL default, developer tools (shop-code screen, request logging). `prod` hides them. |
| `API_BASE_URL` | URL | `http://localhost:8081` (`10.0.2.2` on Android) | Backend root; `/api/v1` is appended. |
| `TENANT_KEY` | shop code | `fino` | Which company this build belongs to (white-label builds bake it in). |
| `DATA_MODE` | `demo` / `api` | `demo` | `demo` reads bundled JSON with 420 ms simulated latency; `api` talks to the ERP backend's storefront API (see "Api mode" in `docs/CUSTOMER-APP-STATUS.md`; `tool/seed_storefront.sh` publishes the demo branding and content to a backend). |

Example: `flutter run --flavor dev --dart-define=DATA_MODE=api --dart-define=API_BASE_URL=http://192.168.1.20:8081`

### Demo sign-in

Phone + OTP only. In demo mode any 6-digit code verifies. `+856 20 5555 0142`
signs in as the seeded customer (orders, addresses and payment methods come from
`assets/demo/commerce.json`); any other number creates a fresh account and asks
for a name. "Continue as guest" skips sign-in; checkout, orders, addresses and
payment methods prompt guests to sign in when reached.

### Tenant key at runtime

In `dev`/`staging` builds, Settings → Developer → *Shop code* changes the tenant
key at runtime (persisted) and reloads the tenant config behind the branded
splash. The demo tenant repository ignores the key and always returns the
bundled Fino config; the API repository requests `/public/tenant/{key}` and
falls back to the bundled config on any failure.

## Layout

```
lib/
  app.dart, main.dart             root widget; tenant resolved before first frame
  core/
    config/     AppConfig from dart-defines, Environment, DataMode
    tenant/     TenantConfig, TenantPalette, Demo/Api repositories, tenantProvider
    theme/      tokens (spacing, radius, type, shadows), 6 fallback palettes,
                buildTheme(palette, brightness), AppColors extension, themeMode
    motion/     durations, curves, reduced-motion, AppPage transition
    l10n/       localeProvider (persisted; falls back to tenant default)
    media/      ImageRef (asset:// key:// https://) + AppImage
    format/     MoneyFormatter (tenant currency), DateFormatter
    layout/     Breakpoints, ContentWidth (max 1180), ResponsiveGrid (2→3→4)
    network/    Dio client + ApiClient envelope unwrapping
    router/     go_router with StatefulShellRoute (4 tabs) + stacked pages
  data/
    session/    sessionProvider (guest / customer), seenTourProvider
    models/     CatalogueItem (ERP shape) + RetailAttributes, Category, Banner, Review,
                commerce (Cart, Wishlist, Order, Address, PaymentMethod, Account, Session)
    models/     content (GoldRate, PolicyDoc, Store, Offer, Brand, TrendingCard,
                AppNotification, Story, AboutContent)
    repositories/ interfaces for catalogue, categories, banners, reviews, auth, cart,
                wishlist, orders, addresses, payment methods, gold rates, policies,
                stores, offers, content, feedback, notifications
    demo/       DemoStore (assets/demo/*.json) + Demo* repositories (customer data
                persisted in LocalStore)
    api/        Api* repositories over the backend storefront API
    repository_providers.dart  the single Demo/Api switch + read-side providers
  features/     splash, onboarding (tour, welcome), auth (phone, OTP, profile setup,
                ensureSignedIn), shell (header, drawer, tabs), home, search,
                collections, catalogue (category, filter sheet, size guide, lookbook),
                product, wishlist, cart (+ coupon panel), checkout, orders, account
                (addresses, payment methods, profile), settings (theme picker, shop
                code), policies, gold_rates (live drift), content (about, contact,
                stories), feedback (feedback, rate us), support (scripted chat),
                notifications, stores, offers, catalogue/commission_sheet (camera)
  shared/widgets/ SectionHead, Eyebrow, GoldRule, Skeleton, EmptyState, ErrorState,
                PressScale, AppChip, AppBadge, StaggeredReveal, AppArt, ProductCard,
                product skeletons/rail, RatingStars, PriceText, HeartButton,
                QuantityStepper, StatusPill, SegmentedControl, AnimatedTick,
                AppTextField, AppPanel, AppSheet, BadgeCount, Scrim, showToast,
                BannerGround (themed ground + animated gold sheen)
  core/platform/ Launch (tel / mailto / WhatsApp / maps via url_launcher)
  l10n/         app_en.arb, app_lo.arb (generated AppL10n)
assets/
  demo/         tenant.json, catalogue.json (75 items, 9 categories incl. Coins & Bars,
                5 banners), commerce.json (demo account, addresses, payment methods,
                orders), content.json (gold rates, 6 policies, 5 stores, 5 offers,
                4 brands, trending cards, notifications, stories, about)
  images/       banners, catalogue photos, category icons, ui
  art/          filigree-corner.svg, facets.svg, flourish.svg, menu/*.svg (10 drawer
                icons) — all single-ink, tinted per tenant
  fonts/        Playfair Display, Inter, Noto Sans Lao
```

## Tests

`flutter test` covers tenant JSON parsing, palette → ThemeData, MoneyFormatter,
ImageRef parsing, the demo catalogue (75 items, all metals/purities/stones,
metal / tag / brand scopes), the demo content repositories (rates, policies,
stores, offers, notifications, feedback), coupon totals, the scripted support
flow (fake_async), a settings & content widget flow (theme swatch → policy →
gold rates → offers → coupon in bag → stores → notifications → support → about),
the demo commerce repositories (auth, cart/wishlist persistence, orders and
placement, addresses, payment methods), cart totals, ARB completeness (every
English key exists in Lao and is translated), a shell smoke test (first-run
tour → welcome → guest → home; tabs → dark mode → language → FAB → drawer) and
an end-to-end commerce flow (category → product → bag → OTP sign-in → checkout
→ confirmation → order detail). `flutter analyze` must stay clean.

## Fonts and licences

Fonts are vendored, never fetched at runtime.

- **Playfair Display** — SIL Open Font License 1.1, see
  `assets/fonts/PlayfairDisplay-OFL.txt`. Shipped as the two variable files
  from Google Fonts (`PlayfairDisplay-Variable.ttf`, `-ItalicVariable.ttf`);
  weights are selected through `FontVariation('wght', …)` in the theme.
- **Inter** — SIL OFL 1.1 (copied from the staff app).
- **Noto Sans Lao** — SIL OFL 1.1 (copied from the staff app), the fallback
  for Lao script.

Photographs under `assets/images` are the reference Ionic app's demo assets and
are placeholders until the tenant's file server supplies real ones.
