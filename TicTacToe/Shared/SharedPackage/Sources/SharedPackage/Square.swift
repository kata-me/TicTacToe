import Foundation
import Combine

final class Square: Equatable, CustomStringConvertible, ObservableObject {
    static let empty = "     "

    static func == (lhs: Square, rhs: Square) -> Bool {
        lhs.occupiedBy == rhs.occupiedBy
    }
    
    enum OccupiedBy: Equatable {
        case nobody, visitor, home
    }
    
    @Published var occupiedBy: OccupiedBy {
        didSet {
            switch occupiedBy {
                case .nobody:
                    text = Square.empty
                case .visitor:
                    text = "v"
                case .home:
                    text = "h"
            }
        }
    }
    @Published var text: String
    
    init(_ ownedBy: OccupiedBy) {
        self.occupiedBy = ownedBy
        self.text = Square.empty
    }
    
    var description: String {
        return """
        \(occupiedBy)
        """
    }
    
}

