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

    public func monsterEatPlayer() {
        state.attempsRemaining -= 1
    }

}

// MARK: - Memento

typealias GameMemento = Data

// MAR: - Care Taker

public class GameSystem {

    public enum GameError: String, Error {
        case gameNotFound
    }

    // MARK: - Properties

    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let userDefaults = UserDefaults.standard

    // MARK: - Instance Methods

    public func save(_ game: Game, title: String) throws {
        let data = try encoder.encode(game)

        userDefaults.set(data, forKey: title)
    }

    public func load(title: String) throws -> Game {
        guard let data = userDefaults.data(forKey: title),
            let game = try? decoder.decode(Game.self, from: data)
        else {
            throw GameError.gameNotFound
        }

        return game
    }

}

var game = Game()

game.monsterEatPlayer()
game.rackUpMassivePoints()

let gameSystem = GameSystem()

try gameSystem.save(game, title: "Best Game Ever")

game = Game()

print("New Game Score: ", game.state.score)

game = try gameSystem.load(title: "Best Game Ever")

print("Loaded Game Score: ", game.state.score)
