# Glyanec API Migration – File-by-File Notes

The notes below document the code that was modified in the prior migration to `https://shop.glyanec.net/`. Each section explains what changed, why it improves compatibility with the new API, safety/crash considerations, and any remaining follow-ups.

## Glyanec/Infrastructure/Constant.swift
- **Purpose of change:** Point the shared base URL constant to `https://shop.glyanec.net/` so every request builds off the new host.
- **Compatibility:** Ensures no legacy domains are used when constructing endpoints.
- **Logic replaced/removed:** Old base URL removed; no functional behavior besides host swap.
- **Crash/safety fixes:** None needed.
- **New decoding rules/fields:** None.
- **UI updates:** Not applicable.
- **Networking updates:** Centralizes the new host for all callers.
- **Potential TODOs:** Confirm every manual URL builder now relies on this constant.

## Glyanec/Network/ApiManager/AuthAdapter.swift
- **Purpose:** Keep the `RequestAdapter` aligned with the new host and header requirements; token pulled from `UserAuth` and attached as `X-TOKEN` only for Glyanec requests.
- **Compatibility:** Uses `Glyanec.apiEndpoint` (now the new host) to scope header injection to `https://shop.glyanec.net/` calls.
- **Logic removed:** Legacy refresh-token scaffolding remains commented out; no automatic refresh is attempted.
- **Crash fixes:** Avoids force-unwrapping token; gracefully exits when URL is missing.
- **New decoding rules:** None.
- **UI updates:** Not applicable.
- **Networking updates:** Adds `X-TOKEN` header when available.
- **Potential TODOs:** Decide whether refresh logic should be reinstated for 401 handling; currently just logs and stops retries.

## Glyanec/Network/ApiManager/NetworkPurchases.swift
- **Purpose:** Point basket purchase calls to the new `basket/api/v1.0/add_items` endpoint under `https://shop.glyanec.net/` and persist locally cached basket payloads.
- **Compatibility:** Base URL now composes from `Glyanec.apiEndpoint`, matching the new domain.
- **Logic changes:** Reads basket data from `UserDefaults` safely before POSTing; no force unwraps on decode. Error handler invoked before decoding response.
- **Crash fixes:** Guards against missing `response.data` and decoding failures with explicit rejection.
- **New decoding rules:** Uses updated `ResultPurchaiseModel` (see below).
- **UI updates:** Not applicable.
- **Networking updates:** Uses JSON encoding with the new host; headers resolved by `NetworkSessionManager`.
- **Potential TODOs:** Verify server expects `list` wrapper as currently posted; align with any future API schema updates.

## Glyanec/Network/Glyanec.swift
- **Purpose:** Tie `apiEndpoint` to the new base URL and ensure every `SessionManager` instance sends required headers.
- **Compatibility:** All Alamofire sessions now default to `https://shop.glyanec.net/` and include `X-TOKEN` when present.
- **Logic removed:** Old commented adapter wiring retained but inactive; defaults simplified to a single configured session.
- **Crash fixes:** None, but optional token guarded before header insertion.
- **New fields/rules:** Language header (`accept-language`) and JSON content type explicitly set.
- **UI updates:** Not applicable.
- **Networking updates:** Session configuration adds `X-TOKEN` from Keychain without force unwrap.
- **Potential TODOs:** Consider re-enabling adapter/retrier if automatic token refresh is required; confirm timeout is acceptable for new API.

## Glyanec/Network/ModelRequest/RequestBasketModel.swift
- **Purpose:** Normalize basket/favorite payload models to the new API using string identifiers and safe Codable structs.
- **Compatibility:** `id` values are strings (API can return string identifiers); image retained as a string URL per new payloads.
- **Logic changes:** Removed integer IDs/force unwraps in favor of optionals handled upstream.
- **Crash fixes:** Codable decoding relies on safe types; no implicit unwraps remain.
- **New fields/rules:** Supports lists of `ItemBasketModel` and `BasketModel` for new basket schema.
- **UI updates:** Not applicable directly, but cells rely on these safer models.
- **Networking updates:** Models align with purchase requests posted in `NetworkPurchases`.
- **Potential TODOs:** Confirm quantity and price types exactly match server expectations (currently `Int` qty, `Double` price).

## Glyanec/Network/ModelResult/ResultItemsListModel.swift
- **Purpose:** Expand decoding resilience for categories and products according to the new API payloads.
- **Compatibility:** Handles string or numeric representations for `price`, `price_old`, and `count`; supports both `images` arrays and single `image` strings.
- **Logic changes:** Custom `init(from:)` normalizes differing field types and fallback behavior; categories/characteristics default to empty arrays when missing.
- **Crash fixes:** Removes force unwraps by using `decodeIfPresent` with optionals and defaults; safely builds image list even when absent.
- **New fields/rules:** Adds dual image handling, string-to-double conversions, and optional numeric parsing for counts/prices.
- **UI updates:** Enables callers to choose a first image or placeholder without crashing on missing data.
- **Networking updates:** Decoding aligns responses consumed by home/product/basket flows.
- **Potential TODOs:** Validate additional fields (e.g., vendor info, pagination) against latest API docs; ensure `total` and `pages` types are correct.

## Glyanec/Network/NetworkErrorHandler.swift
- **Purpose:** Provide friendly fallback messaging when API errors are returned in new formats.
- **Compatibility:** Aggregates string arrays or single message/error fields returned by the new host.
- **Logic changes:** Adds array-to-string flattening for `message` fields.
- **Crash fixes:** Wrapped JSON parsing in `do/catch` with graceful nil returns; no force unwraps.
- **New fields/rules:** Supports `[String]` message handling.
- **UI updates:** Enables better error notifications surfaced to users.
- **Networking updates:** Shared across all network calls to interpret new API error bodies.
- **Potential TODOs:** Extend to map any structured error codes the new API might expose.

## Glyanec/app/Basket/View/BasketViewController.swift
- **Purpose:** Keep basket UI in sync with safer models and updated persistence.
- **Compatibility:** Uses `ItemBasketModel`/`BasketModel` string IDs and reloads basket contents safely from `UserDefaults` for the new API flow.
- **Logic changes:** Removes force unwraps when mutating lists; re-encodes after deletions.
- **Crash fixes:** Guarded removes based on array bounds; handles missing persisted data without crashing.
- **New fields/rules:** None beyond safer model usage.
- **UI updates:** Maintains tab bar visibility logic; updates checkout button text via delegate callback.
- **Networking updates:** Triggers `purchasesList` aligned with new API endpoint.
- **Potential TODOs:** Validate that basket refresh (`getBasketList`) is also updated from server rather than local cache only.

## Glyanec/app/Basket/View/Cell/BasketItemCell.swift
- **Purpose:** Display basket items with safe pricing and imagery.
- **Compatibility:** Accepts `ItemBasketModel` using string IDs and image URLs from new API.
- **Logic changes:** Eliminates force unwraps; relies on cached or remote images with graceful fallback when URL is invalid.
- **Crash fixes:** Guards delegate callbacks with optional row; avoids forced image conversion.
- **New fields/rules:** None.
- **UI updates:** Price/quantity labels derive from decoded doubles and integers; uses SDWebImage cache lookup first.
- **Networking updates:** None directly.
- **Potential TODOs:** Add placeholder imagery for missing URLs to match UX expectations.

## Glyanec/app/Basket/View/Cell/BasketPriceCell.swift
- **Purpose:** Compute and display basket totals using new model shapes.
- **Compatibility:** Works over `[ItemBasketModel]` with double price and integer qty from new API responses.
- **Logic changes:** Consolidated calculation via `reduce` without force unwraps or intermediate vars.
- **Crash fixes:** No optional crashes; pure functional calculation.
- **New fields/rules:** None.
- **UI updates:** Updates labels and notifies delegate with computed price.
- **Networking updates:** None.
- **Potential TODOs:** None noted; consider currency formatting/localization.

## Glyanec/app/Basket/ViewModel/BasketViewModel.swift
- **Purpose:** Drive basket screens using safe persistence and network calls targeting the new API.
- **Compatibility:** Loads basket lists from `UserDefaults` as arrays of the new Codable models; posts them via `NetworkPurchases`.
- **Logic changes:** Adds guards for missing lists; clears storage on successful purchase; surfaces new API error messages.
- **Crash fixes:** Removes force unwraps on optional lists; handles nil gracefully with defaults and guards.
- **New fields/rules:** Leverages `ResultPurchaiseModel` decoding that matches new endpoint response.
- **UI updates:** Invokes `view.updateItems()` after state changes.
- **Networking updates:** Hooks into `NetworkPurchases.purchasesList` which targets `https://shop.glyanec.net/`.
- **Potential TODOs:** Consider syncing basket with server rather than local-only state; expand error handling for multi-error arrays.

## Glyanec/app/ItemDetails/View/ItemDetailsViewController.swift
- **Purpose:** Adapt item detail display and add-to-basket/favorites actions to the new product model and image handling.
- **Compatibility:** Reads pricing, optional old price, and dual image fields (`images` array or `image` string) from `ResultProductModel` decoding.
- **Logic changes:** Removes force unwraps; guards IDs and optional fields when adding to basket or favorites. Uses defaults when prices or images are missing.
- **Crash fixes:** Prevents nil ID crashes by guarding `productId`; hides old-price UI when absent; safe defaults for stored lists.
- **New fields/rules:** Uses `images?.first ?? image` resolution consistent with new decoder behavior.
- **UI updates:** Shows/hides discount labels based on `price_old`; updates preview with first available image.
- **Networking updates:** Relies on previously updated view model responses; no direct calls changed here.
- **Potential TODOs:** Favorites still stored locally; server-side favorite API migration may be pending.

## Glyanec/app/Main/View/Cell/CategoriesCVCell.swift
- **Purpose:** Render categories from new API payload safely.
- **Compatibility:** Uses optional category `name` and `image` strings; loads images directly from provided URLs.
- **Logic changes:** Adds placeholder image fallback when `image` is nil.
- **Crash fixes:** Avoids force unwraps on strings and URLs.
- **New fields/rules:** None beyond matching `ResultCategorysListModel`.
- **UI updates:** Displays category name text; uses SDWebImage caching.
- **Networking updates:** None directly.
- **Potential TODOs:** Verify placeholder asset exists and matches design; consider handling empty names.

## Glyanec/app/Main/View/Cell/MainItemCell.swift
- **Purpose:** Display products on the home grid using the new product model and safe basket writes.
- **Compatibility:** Supports images from either `images` array or `image` string, and prices parsed as doubles from new API decoder.
- **Logic changes:** Removes force unwraps; guards product ID before persisting to basket; sets discount visibility based on `price_old`.
- **Crash fixes:** Safe optional handling prevents crashes when product fields are missing; image loading guarded with URL creation checks.
- **New fields/rules:** Leverages updated `ResultProductModel` decoding that handles string/array images.
- **UI updates:** Displays prices with currency suffix; hides discount UI when absent.
- **Networking updates:** None directly; interacts with locally stored basket and notification scheduling.
- **Potential TODOs:** Favorites action remains stubbed/commented; needs integration with new favorite API.

## Glyanec/app/Main/View/MainViewController+Extension.swift
- **Purpose:** Stabilize collection view data source/delegate behaviors for new API outputs.
- **Compatibility:** Safely indexes products array from `ResultProductsListModel` to avoid out-of-range access when API returns fewer items.
- **Logic changes:** Adds guard on product array before configuring cells and selecting items.
- **Crash fixes:** Prevents crashes on selection/configuration when products are nil or count mismatched.
- **New fields/rules:** None.
- **UI updates:** Layout sizing unchanged; ensures reloads complete even with partial data.
- **Networking updates:** None directly; relies on refreshed view model data.
- **Potential TODOs:** Consider dynamic section counts if API changes category/top-action layout needs.

## Glyanec/app/Main/View/MainViewController.swift
- **Purpose:** Wire home screen to trigger new product fetches and handle search without unsafe assumptions.
- **Compatibility:** Refresh control triggers `getCategoryProducts` which now pulls from the new API; search uses the updated view model.
- **Logic changes:** Adds guards around search text, hides search close button appropriately.
- **Crash fixes:** Avoids force unwraps for search text and refresh controls.
- **New fields/rules:** None.
- **UI updates:** Maintains rounded headers/search views; safe refresh behavior.
- **Networking updates:** Indirect—relies on view model fetching from `https://shop.glyanec.net/`.
- **Potential TODOs:** Confirm search endpoint fully migrated; may need debounce or cancellation support for larger datasets.

---

## Remaining Gaps and Recommendations
- **Favorites:** UI writes favorites to local `UserDefaults`; integration with the new favorites API is still TODO.
- **Purchases/Basket Sync:** Basket is persisted locally and posted en masse; consider fetching live basket state from the server to stay in sync with web or other clients.
- **Token Refresh:** Adapter currently only attaches `X-TOKEN`; automatic refresh for expired tokens is commented out. Verify whether the new API requires refresh handling.
- **Error Handling:** Network error handler flattens simple messages but may miss structured error formats; inspect real error payloads from the new API and extend parsing accordingly.
- **Placeholder/Empty States:** Some views assume text/image presence; consider additional placeholders and user feedback for empty data returned by the new API.
- **Schema Validation:** Validate price/count types and basket request body (`list` and quantity fields) against the authoritative API spec to ensure long-term compatibility.
