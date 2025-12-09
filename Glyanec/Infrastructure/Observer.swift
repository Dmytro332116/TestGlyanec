import Foundation

class Observer {
    class ObservationUnit<T: NSObject, U, W> {
        var observer: Observer
        var path: KeyPath<T, U>
        var obj: T
        private var convertFunction: ((U) -> W)?

        init(observer: Observer, path: KeyPath<T, U>, obj: T) {
            self.observer = observer
            self.path = path
            self.obj = obj
        }

        func to<V>(_ root: V, _ destinationPath: ReferenceWritableKeyPath<V, W>, andThen: (() -> Void)? = nil) {
            _to(root, destinationPath, andThen: andThen)
        }

        func to<V>(_ root: V, _ destinationPath: ReferenceWritableKeyPath<V, W>, andThen: (() -> Void)? = nil) where U == W {
            if convertFunction == nil {
                convertFunction = { $0 }
            }

            _to(root, destinationPath, andThen: andThen)
        }

        func to(_ function: @escaping (U) -> Void) {
            let binding = obj.observe(path, options: [.initial]) { (obj: T, _: NSKeyValueObservedChange<U>) in
                guard self.convertFunction == nil else { preconditionFailure("Cannot use to with a mapping function") }
                function(obj[keyPath: self.path])
            }

            observer.observations.append(binding)
        }

        private func _to<V>(_ root: V, _ destinationPath: ReferenceWritableKeyPath<V, W>, andThen: (() -> Void)? = nil) {
            let binding = obj.observe(path, options: [.initial]) { (obj: T, _: NSKeyValueObservedChange<U>) in
                if let convertFunction = self.convertFunction {
                    DispatchQueue.main.async {
                        root[keyPath: destinationPath] = convertFunction(obj[keyPath: self.path])
                    }
                }

                andThen?()
            }

            observer.observations.append(binding)
        }

        func map<X>(_ function: @escaping ((U) -> X)) -> ObservationUnit<T, U, X> {
            let observationUnit = ObservationUnit<T, U, X>(observer: observer, path: path, obj: obj)
            observationUnit.convertFunction = function
            return observationUnit
        }

        func mapAsOptional() -> ObservationUnit<T, U, U?> {
            return map({ Optional.some($0) })
        }
    }

    struct NotifierUnit<T, U> {
        var observer: Observer
        var obj: T
        var name: NSNotification.Name
        var path: KeyPath<T, U>

        func to<V>(_ root: V, _ destinationPath: ReferenceWritableKeyPath<V, U>) {
            let binding = NotificationCenter.default.addObserver(forName: name, object: obj, queue: nil) { _ in
                root[keyPath: destinationPath] = self.obj[keyPath: self.path]
            }
            observer.notifications.append(binding)
        }
    }

    private var observations: [NSKeyValueObservation] = []
    private var notifications: [NSObjectProtocol] = []

    func invalidateAll() {
        observations.forEach {
            $0.invalidate()
        }
        notifications.forEach { NotificationCenter.default.removeObserver($0) }

        observations.removeAll()
        notifications.removeAll()
    }

    func from<T: NSObject, U>(_ obj: T, _ path: KeyPath<T, U>) -> ObservationUnit<T, U, U> {
        return ObservationUnit(observer: self, path: path, obj: obj)
    }

    func from<T, U>(_ obj: T, _ path: KeyPath<T, U>, forName name: NSNotification.Name) -> NotifierUnit<T, U> {
        return NotifierUnit(observer: self, obj: obj, name: name, path: path)
    }
}
