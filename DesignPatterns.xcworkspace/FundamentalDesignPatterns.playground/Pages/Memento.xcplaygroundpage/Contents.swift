/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)

 # Memento
 - - - - - - - - - -
 ![Memento Diagram](Memento_Diagram.png)

 The memento pattern allows an object to be saved and restored. It involves three parts:

 (1) The **originator** is the object to be saved or restored.

 (2) The **memento** is a stored state.

 (3) The **caretaker** requests a save from the originator, and it receives a memento in response. The care taker is responsible for persisting the memento, so later on, the care taker can provide the memento back to the originator to request the originator restore its state.

 ## Code Example
 */
import Foundation

// MARK: - Originator

public class Game: Codable {

    public class State: Codable {
        public var attempsRemaining = 3
        public var level = 1
        public var score = 0
    }

    public var state = State()

    public func rackUpMassivePoints() {
        state.score += 9002
    }

    public func monsterEatsPlayer() {
        state.attempsRemaining -= 1
    }

}

// MARK: - Memento

typealias GameMemento = Data

// MARK: - CareTaker

public class GameSystem {

    public enum GameError: String, Error {
        case gameNotFound
    }

    // MARK: - Properties

    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let userDefaults = UserDefaults.standard

    // MARK: - Instance Methods

    public func save<T: Codable>(_ object: T, title: String) throws {
        let data: GameMemento = try encoder.encode(object)

        userDefaults.set(data, forKey: title)
    }

    public func load<T: Codable>(_ type: T.Type, title: String) throws -> T {
        guard let data = userDefaults.data(forKey: title) as? GameMemento,
            let game = try? decoder.decode(T.self, from: data)
        else {
            throw GameError.gameNotFound
        }

        return game
    }

}

// First Game

var game = Game()

game.monsterEatsPlayer()
game.rackUpMassivePoints()

// Save Game

let gameSystem = GameSystem()

print("First Game Score: ", game.state.score)

try gameSystem.save(game, title: "Best Game Ever")

// Second Game

game = Game()

print("Second Game Score: ", game.state.score)

// Load Game

game = try gameSystem.load(Game.self, title: "Best Game Ever")

print("Loaded Game Score: ", game.state.score)
