//
//  CustomPublished.swift
//
//
//  Created by Edwin Cardenas on 2/15/26.
//

import Foundation

@propertyWrapper public class CustomPublished<T> {

    public class Publisher {

        fileprivate var callbacks = [((T) -> Void)]()

        public func sink(
            receiveCompletion completion: @escaping (T) -> Void
        ) {
            callbacks.append(completion)
        }

    }

    private var publisher = Publisher()

    public var value: T {
        didSet {
            publisher.callbacks.forEach { closure in
                closure(value)
            }
        }
    }

    public var wrappedValue: T {
        get { value }
        set { value = newValue }
    }

    public var projectedValue: CustomPublished<T>.Publisher {
        return publisher
    }

    public init(wrappedValue: T) {
        value = wrappedValue
    }

}
