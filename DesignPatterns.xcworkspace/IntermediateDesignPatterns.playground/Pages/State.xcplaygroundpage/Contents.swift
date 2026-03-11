import PlaygroundSupport
/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)

 # State
 - - - - - - - - - -
 ![State Diagram](State_Diagram.png)

 The state pattern is a behavioral pattern that allows an object to change its behavior at runtime. It does so by changing an internal state. This pattern involves three types:

 1. The **context** is the object whose behavior changes and has an internal state.

 2. The **state protocol** defines a set of methods and properties required by concrete states. If you need stored properties, you can substitute a **base state class** instead of a protocol.

 3. The **concrete states** conform to the state protocol, or if a base class is used instead, they subclass the base. They implement required methods and properties to perform whatever behavior is desired when the context is in its state.

 ## Code Example
 */
import UIKit

// MARK: - Context

class TrafficLight: UIView {

    // MARK: - Properties

    public private(set) var canisterLayers = [CAShapeLayer]()
    public private(set) var currentState: TrafficLightState
    public private(set) var states: [TrafficLightState]

    // MARK: - Object Lifecycle

    public init(
        canisterCount: Int = 3,
        frame: CGRect = CGRect(x: 0, y: 0, width: 160, height: 420),
        states: [TrafficLightState]
    ) {
        guard !states.isEmpty else {
            fatalError("states should not be empty")
        }

        self.currentState = states.first!
        self.states = states

        super.init(frame: frame)

        backgroundColor = .black

        createCanisterLayers(count: canisterCount)
        transition(to: currentState)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers

    private func createCanisterLayers(count: Int) {
        let paddingPercentage: CGFloat = 0.2
        let yTotalPadding = paddingPercentage * bounds.height
        let yPadding = yTotalPadding / CGFloat(count + 1)

        let canisterHeight = (bounds.height - yTotalPadding) / CGFloat(count)
        let xPadding = (bounds.width - canisterHeight) / 2.0
        var canisterFrame = CGRect(
            x: xPadding,
            y: yPadding,
            width: canisterHeight,
            height: canisterHeight
        )

        for _ in 0..<count {
            let canisterShape = CAShapeLayer()

            canisterShape.path = UIBezierPath(ovalIn: canisterFrame).cgPath
            canisterShape.fillColor = UIColor.systemGray.cgColor

            layer.addSublayer(canisterShape)
            canisterLayers.append(canisterShape)

            canisterFrame.origin.y += (canisterFrame.height + yPadding)
        }
    }

    public func transition(to state: TrafficLightState) {
        removeCanisterSublayers()

        currentState = state
        currentState.apply(to: self)
        nextState.apply(to: self, after: currentState.delay)
    }

    public func removeCanisterSublayers() {
        canisterLayers.forEach {
            $0.sublayers?.forEach { $0.removeFromSuperlayer() }
        }
    }

    public var nextState: TrafficLightState {
        guard let index = states.firstIndex(where: { $0 === currentState }),
            index + 1 < states.count
        else {
            return states.first!
        }

        return states[index + 1]
    }

}

// MARK: - State

protocol TrafficLightState: AnyObject {
    var delay: TimeInterval { get }

    func apply(to context: TrafficLight)
}

// MARK: - Transitioning

extension TrafficLightState {
    public func apply(to context: TrafficLight, after delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            [weak self, weak context] in

            guard let self, let context else { return }

            context.transition(to: self)
        }
    }
}

// MARK: - Concrete States

class SolidTrafficLightState {

    // MARK: - Properties

    public let canisterIndex: Int
    public let color: UIColor
    public let delay: TimeInterval

    // MARK: - Object Lifecycle

    init(canisterIndex: Int, color: UIColor, delay: TimeInterval) {
        self.canisterIndex = canisterIndex
        self.color = color
        self.delay = delay
    }

}

// MARK: - TrafficLightState

extension SolidTrafficLightState: TrafficLightState {
    func apply(to context: TrafficLight) {
        let canisterLayer = context.canisterLayers[canisterIndex]
        let circleShape = CAShapeLayer()

        circleShape.path = canisterLayer.path!
        circleShape.fillColor = color.cgColor
        circleShape.strokeColor = color.cgColor

        canisterLayer.addSublayer(circleShape)
    }
}

// MARK: - Convenience Constructors

extension SolidTrafficLightState {

    public class func greenLight(
        canisterIndex: Int = 2,
        color: UIColor = .systemGreen,
        delay: TimeInterval = 1.0
    ) -> SolidTrafficLightState {
        return SolidTrafficLightState(
            canisterIndex: canisterIndex,
            color: color,
            delay: delay
        )
    }

    public class func yellowLight(
        canisterIndex: Int = 1,
        color: UIColor = .systemYellow,
        delay: TimeInterval = 0.5
    ) -> SolidTrafficLightState {
        return SolidTrafficLightState(
            canisterIndex: canisterIndex,
            color: color,
            delay: delay
        )
    }

    public class func redLight(
        canisterIndex: Int = 0,
        color: UIColor = .systemRed,
        delay: TimeInterval = 2.0
    ) -> SolidTrafficLightState {
        return SolidTrafficLightState(
            canisterIndex: canisterIndex,
            color: color,
            delay: delay
        )
    }

}

// MARK: - Example

let greenYellowRed: [SolidTrafficLightState] = [
    .greenLight(), .yellowLight(), .redLight(),
]

let trafficLight = TrafficLight(states: greenYellowRed)

PlaygroundPage.current.liveView = trafficLight
