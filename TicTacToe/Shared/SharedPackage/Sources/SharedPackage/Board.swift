import Foundation
import Combine

final class Board: ObservableObject {
    @Published private(set) var isGameover: Bool
    @Published private(set) var isStarted: Bool
    @Published private(set) var winner: Square.OccupiedBy
    
    private let squares: [[Square]]
    private let flatSquares: [Square]
    
    /// This matrix is used to find indexes to check all
    /// possible wining combinations
    private let wins: [[Int]] = [
        [0, 1, 2], // 0 Check first row.
        [3, 4, 5], // 1 Check second Row
        [6, 7, 8], // 2 Check third Row
        [0, 3, 6], // 3 Check first column
        [1, 4, 7], // 4 Check second Column
        [2, 5, 8], // 5 Check third Column
        [0, 4, 8], // 6 Check first Diagonal
        [2, 4, 6]  // 7 Check second Diagonal
    ]
    
    init() {
        self.squares = [
            [.init(.nobody), .init(.nobody), .init(.nobody)],
            [.init(.nobody), .init(.nobody), .init(.nobody)],
            [.init(.nobody), .init(.nobody), .init(.nobody)],
        ]
        self.isGameover = false
        self.isStarted = false
        self.winner = .nobody
        self.flatSquares = squares.flatMap { $0 }
    }
    
    func occupy(at indexPath: IndexPath, with player: Square.OccupiedBy) throws {
        guard indexPath.item < 3, indexPath.section < 3 else {
            throw Error.invalid(indexPath: indexPath, function: #function, filePath: #filePath)
        }
        let occupation = squares[indexPath.section][indexPath.item].occupiedBy
        guard occupation == .nobody else {
            throw Error.cannotChangeOccupiedSquare(function: #function, filePath: #filePath)
        }
        squares[indexPath.section][indexPath.item].occupiedBy = player
        checkGameStatus()
    }
    
    func isOccupied(at indexPath: IndexPath) -> Bool {
        return squares[indexPath.section][indexPath.item].occupiedBy != .nobody
    }
    
    func resetGame() throws {
        for section in 0...2 {
            for item  in 0...2 {
                squares[section][item].occupiedBy = .nobody
                checkGameStatus()
            }
        }
        checkGameStatus()
    }
    
    // MARK: - Error
    
    enum Error: Swift.Error, CustomStringConvertible, Equatable {
        case invalid(indexPath: IndexPath, function: String, filePath: String)
        case cannotChangeOccupiedSquare(function: String, filePath: String)
        
        var description: String {
            switch self {
                case .invalid(indexPath: let indexPath, function: let function, filePath: let filePath):
                    return """
                        ❌ Invalid indexPath: (\(indexPath.section), \(indexPath.item))
                            function: \(function)
                            filePath: \(filePath)

                        \(Board.self) is only 3x3 big!
                        """
                case .cannotChangeOccupiedSquare(function: let function, filePath: let filePath):
                    return """
                        ❌ Tried to change an occupied square.
                            function: \(function)
                            filePath: \(filePath)
                        """
            }
        }
    }
    
    // MARK: - Private
    
    
    private func checkForWinner() -> Square.OccupiedBy {
        let candidates: [Square.OccupiedBy] = [.home, .visitor]
        for candidate in candidates {
            for i in 0..<8 {
                if flatSquares[wins[i][0]].occupiedBy == candidate,
                   flatSquares[wins[i][1]].occupiedBy == candidate,
                   flatSquares[wins[i][2]].occupiedBy == candidate {
                   return candidate
                }
            }
        }
        return .nobody
    }
    
    private func checkGameStatus() {
        let flatSquares: [Square] = squares.flatMap { $0 }
        isGameover = flatSquares.filter { $0.occupiedBy != .nobody }.count != 0
        isStarted = flatSquares.contains(.init(.home)) || flatSquares.contains(.init(.visitor))
        winner = checkForWinner()
    }
    

}
