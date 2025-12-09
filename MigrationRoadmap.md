# Glyanec API Migration TODO Roadmap

Structured checklist of remaining work to fully align the iOS app with `https://shop.glyanec.net/`.

## 1) API Surface Migration
- [ ] Favorites API: replace local-only storage in `MainItemCell`, `ItemDetailsViewController`, and related view models with server-backed endpoints (create/list/delete) on the new host; align payload/ID types (likely string IDs) and headers.
- [ ] Basket sync: add read/write endpoints so the basket reflects server state (not just `UserDefaults`); reconcile request body shape with authoritative API spec (e.g., `list` wrapper, qty/price types).
- [ ] Purchases: confirm `NetworkPurchases` uses the correct endpoint and response model; add success/error handling for server validation failures.
- [ ] Search: validate the search endpoint and result model mapping; ensure pagination and empty results are handled without crashes.
- [ ] Categories & home modules: confirm all calls use `Glyanec.apiEndpoint` and the new response schema (including banners/promos if present).
- [ ] Item details: verify characteristics/additional fields against the new API and map any missing properties.

## 2) Decoding & Model Parity
- [ ] Audit all decoders for string/number polymorphism (price, price_old, count, id); extend custom inits where needed beyond `ResultItemsListModel`.
- [ ] Normalize `image` vs `images` handling across models and UI helpers; ensure first-image fallback is consistent.
- [ ] Validate basket request/response models (`RequestBasketModel`, `ItemBasketModel`, `BasketModel`, `ResultPurchaiseModel`) against current server schema.
- [ ] Ensure category/product models include any newly exposed fields (e.g., vendor, stock flags, pagination metadata) and default safely when missing.

## 3) UI Dependencies on Old Schema
- [ ] Identify cells/controllers that still expect legacy fields (e.g., fixed `images` array, integer IDs) and update bindings to new optional fields.
- [ ] Replace placeholder text/images where nil leads to empty UI; standardize placeholder assets for missing product/category images.
- [ ] Add empty-state views for home, categories, search results, favorites, and basket when the API returns no data.

## 4) Safety & Crash Hardening
- [ ] Remove remaining force unwraps/unsafe indexing across the project (search for `!` and unchecked `indexPath.row`).
- [ ] Guard all array indexing in collection/table view delegates; bail out gracefully when data is missing.
- [ ] Expand error handling paths to surface API errors to users instead of silent failures; integrate `NetworkErrorHandler` outputs.
- [ ] Add decoding error logging to help detect schema mismatches in production.

## 5) Networking & Token Handling
- [ ] Verify every network client builds URLs from `Glyanec.apiEndpoint`; remove any hard-coded legacy hosts.
- [ ] Standardize required headers (e.g., `X-TOKEN`, `accept-language`, JSON content type) across all sessions.
- [ ] Decide on token refresh/reauth: either re-enable adapter retrier on 401 or add explicit refresh flow; ensure failures degrade gracefully.
- [ ] Confirm SSL/timeout policies meet new host expectations.

## 6) UX & Data Consistency
- [ ] Implement server-backed favorites sync and ensure UI reflects server truth on load.
- [ ] Reconcile basket totals with server-calculated prices to avoid client-side drift; handle currency/locale formatting.
- [ ] Add loading/error/empty states to reduce perceived crashes when responses are slow or empty.
- [ ] Ensure notification scheduling or local badges stay consistent with server updates (basket/favorites counts).

## 7) Testing & Verification
- [ ] Add integration tests (or manual checklist) hitting the new endpoints for home, categories, search, item detail, favorites, basket add/remove, and purchase submission.
- [ ] Smoke-test image loading for both `image` and `images` payloads and verify placeholders appear when URLs are invalid.
- [ ] Validate persistence flows (basket/favorites) across app restarts with server sync enabled.

## 8) Known TODO Mentions from Migration
- [ ] Favorites API integration remains TODO (currently local only).
- [ ] Basket refresh from server (not just local cache) needs implementation.
- [ ] Token refresh logic commented out in `AuthAdapter`/`Glyanec.swift`—decision pending.
- [ ] Error handler may need expansion for structured error codes.
- [ ] Placeholder assets should be verified/added for missing images.

## 9) Prioritized Next Actions
1. Wire favorites and basket to server endpoints (read/write) using string IDs and required headers.
2. Audit and remove remaining force unwraps/unsafe indexing; add empty states for all list/detail screens.
3. Validate/extend decoding for polymorphic fields (price/count/id/image vs images) across all models.
4. Decide and implement token refresh or failure UX for expired tokens.
5. Add loading/error handling and placeholder imagery to stabilize UI when data is missing.
6. Create an end-to-end test pass against `https://shop.glyanec.net/` for home, categories, search, item detail, favorites, basket, and purchases.
