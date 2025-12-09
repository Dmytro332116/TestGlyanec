import Foundation
import PromiseKit

final class FavoritesStore {
    static let shared = FavoritesStore()

    private(set) var favoriteIDs: Set<String> = []
    private var isLoading = false

    private init() {}

    func preloadFavorites() {
        guard !isLoading else { return }
        isLoading = true
        NetworkFavorites.listFavorites()
            .done { [weak self] response in
                self?.favoriteIDs = Set(response.products.compactMap { $0.id })
            }
            .catch { error in
                print("Failed to preload favorites: \(error)")
            }
            .finally { [weak self] in
                self?.isLoading = false
            }
    }

    func isFavorite(id: String?) -> Bool {
        guard let id else { return false }
        return favoriteIDs.contains(id)
    }

    func toggleFavorite(id: String, completion: ((Bool) -> Void)? = nil) {
        if favoriteIDs.contains(id) {
            remove(id: id, completion: completion)
        } else {
            add(id: id, completion: completion)
        }
    }

    private func add(id: String, completion: ((Bool) -> Void)?) {
        NetworkFavorites.addFavorite(id: id)
            .done { [weak self] _ in
                self?.favoriteIDs.insert(id)
                completion?(true)
            }
            .catch { error in
                print("Add favorite failed: \(error)")
                completion?(false)
            }
    }

    private func remove(id: String, completion: ((Bool) -> Void)?) {
        NetworkFavorites.removeFavorite(id: id)
            .done { [weak self] _ in
                self?.favoriteIDs.remove(id)
                completion?(true)
            }
            .catch { error in
                print("Remove favorite failed: \(error)")
                completion?(false)
            }
    }
}
