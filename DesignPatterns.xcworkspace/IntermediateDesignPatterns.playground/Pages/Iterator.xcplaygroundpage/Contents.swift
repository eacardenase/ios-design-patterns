/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)

 # Iterator
 - - - - - - - - - -
 ![Iterator Diagram](Iterator_Diagram.png)

 The Iterator Pattern provides a standard way to loop through a collection. This pattern involves two types:

 1. The Swift `Iterable` protocol defines a type that can be iterated using a `for in` loop.

 2. A **custom object** you want to make iterable. Instead of conforming to `Iterable` directly, however, you can conform to `Sequence`, which itself conforms to `Iterable`. By doing so, you'll get many higher-order functions, including `map`, `filter` and more, implemented for free for you.

 ## Code Example
 */
import Foundation

// MARK: - Queue

public struct Queue<T> {
    private var array: [T?] = []
    private var head = 0

    public var count: Int {
        return array.count - head
    }

    public var isEmpty: Bool {
        return count == 0
    }

    public mutating func enqueue(_ element: T) {
        array.append(element)
    }

    public mutating func dequeue() -> T? {
        guard head < array.count, let element = array[head] else {
            return nil
        }

        array[head] = nil
        head += 1

        let percentage = Double(head) / Double(array.count)

        if array.count > 50, percentage > 0.25 {
            array.removeFirst(head)

            head = 0
        }

        return element
    }
}

extension Queue: Sequence {
    public func makeIterator() -> IndexingIterator<ArraySlice<T?>> {
        let nonEmptyValues = array[head..<array.count]

        return nonEmptyValues.makeIterator()
    }
}

public struct Ticket {
    enum PriorityType: Int {
        case low = 0
        case medium
        case high
    }

    var description: String
    var priority: PriorityType
}

extension Ticket {
    var sortIndex: Int {
        return priority.rawValue
    }
}

var queue = Queue<Ticket>()

queue.enqueue(
    Ticket(description: "Wireframe Tinder for dogs app", priority: .low)
)
queue.enqueue(
    Ticket(description: "Set up 4k monitor for Josh", priority: .medium)
)
queue.enqueue(
    Ticket(
        description: "There is smoke coming out of my laptop",
        priority: .high
    )
)
queue.enqueue(
    Ticket(description: "Put googly eyes on the Roomba", priority: .low)
)

queue.dequeue()

print("List of Tickets in queue:")

for ticket in queue {
    print(ticket?.description ?? "No Description")
}

let sortedTickets = queue.sorted { $0!.sortIndex > $1!.sortIndex }

var sortedQueue = Queue<Ticket>()

for ticket in sortedTickets {
    sortedQueue.enqueue(ticket!)
}

print()

print("Tickets sorted by priority:")

for ticket in sortedQueue {
    print(ticket?.description ?? "No Description")
}

// MARK: - Stack

struct Stack<Element> {
    var items = [Element]()

    mutating func push(_ element: Element) {
        items.append(element)
    }

    mutating func pop() -> Element? {
        return items.popLast()
    }

    func map<T>(_ transform: (Element) -> T) -> Stack<T> {
        var mappedItems = [T]()

        for item in items {
            mappedItems.append(transform(item))
        }

        return Stack<T>(items: mappedItems)
    }
}

// MARK: - IteratorProtocol

struct StackIterator<T>: IteratorProtocol {
    typealias Element = T

    var stack = Stack<T>()

    mutating func next() -> Element? {
        return stack.pop()
    }
}

// MARK: - Sequence

extension Stack: Sequence {
    typealias Iterator = StackIterator<Element>

    func makeIterator() -> Iterator {
        return StackIterator(stack: self)
    }
}

var intStack = Stack<Int>()
intStack.push(1)
intStack.push(2)

var doubleStack = intStack.map { $0 * 2 }

//print(String(describing: intStack.pop()))
//print(String(describing: intStack.pop()))
//print(String(describing: intStack.pop()))
//
//print(String(describing: doubleStack.pop()))
//print(String(describing: doubleStack.pop()))

var stringStack = Stack<String>()
stringStack.push("This is a string")
stringStack.push("Another string")

//print(String(describing: stringStack.pop()))

var myStack = Stack<Int>()
myStack.push(10)
myStack.push(20)
myStack.push(30)

var myStackIterator = StackIterator(stack: myStack)

while let value = myStackIterator.next() {
    print("got \(value)")
}

for value in myStack {
    print("got \(value)")
}
