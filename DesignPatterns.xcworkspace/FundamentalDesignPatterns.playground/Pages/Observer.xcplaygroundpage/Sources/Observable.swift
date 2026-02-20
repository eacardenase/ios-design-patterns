// MARK: - Observable

public class Observable<T> {

    fileprivate class Callback {

        fileprivate weak var observer: AnyObject?
        fileprivate let options: [ObservingOptions]
        fileprivate let closure: (T, ObservingOptions) -> Void

        fileprivate init(
            observer: AnyObject,
            options: [ObservingOptions],
            closure: @escaping (T, ObservingOptions) -> Void
        ) {
            self.observer = observer
            self.options = options
            self.closure = closure
        }

    }

    // MARK: - Properties

    public var value: T {
        didSet {
            removeNilObserverCallbacks()
            notifyCallbacks(value: oldValue, option: .old)
            notifyCallbacks(value: value, option: .new)
        }
    }

    // MARK: - Object Lifecycle

    public init(_ value: T) {
        self.value = value
    }

    // MARK: - Managing Observers

    private var callbacks = [Callback]()

    public func addObserver(
        _ observer: AnyObject,
        removeIfExists: Bool = true,
        options: [ObservingOptions] = [.new],
        closure: @escaping (T, ObservingOptions) -> Void
    ) {
        if removeIfExists {
            removeObserver(observer)
        }

        let callback = Callback(
            observer: observer,
            options: options,
            closure: closure
        )

        callbacks.append(callback)

        if options.contains(.initial) {
            closure(value, .initial)
        }
    }

    public func removeObserver(_ observer: AnyObject) {
        callbacks = callbacks.filter { $0.observer !== observer }
    }

    private func removeNilObserverCallbacks() {
        callbacks = callbacks.filter { $0.observer != nil }
    }

    private func notifyCallbacks(value: T, option: ObservingOptions) {
        let callbacksToNotify = callbacks.filter { $0.options.contains(option) }

        callbacksToNotify.forEach { $0.closure(value, option) }
    }

}

// MARK: - Observing Options

public struct ObservingOptions: OptionSet {

    public var rawValue: Int

    public static let initial = ObservingOptions(rawValue: 1 << 0)
    public static let old = ObservingOptions(rawValue: 1 << 1)
    public static let new = ObservingOptions(rawValue: 1 << 2)

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

}
