import Foundation

class Cell {
    var visibility: Visibility = .hidden
    var solved: Bool = false
    let type: CellType
    
    init(_ content: CellType) {
        self.type = content
    }
}

enum Visibility {
    case hidden
    case visible
    case marked
}

enum CellType {
    case mine
    case empty(Int)
}
