import Foundation

class Grid: Sequence {
    var grid: [[Cell]]
    
    var rows: Int { grid.count }
    var cols: Int { grid[0].count }
    
    init(grid: [[Cell]]) {
        self.grid = grid
    }
    
    subscript(index: Point) -> Cell {
        grid[index.row][index.col]
    }
    
    func makeIterator() -> GridIterator {
        GridIterator(self)
    }
}

struct GridIterator: IteratorProtocol {
    
    typealias Element = (Point, Cell)
    
    let grid: Grid
    var current: Point = Point(row: 0, col: 0)
    
    init(_ grid: Grid) {
        self.grid = grid
    }
    
    mutating func next() -> Element? {
        guard current.row < grid.rows else {
            return nil
        }
        
        let point = current
        let cell = grid[point]
        let col = (current.col + 1) % grid.cols
        let row = col == 0 ? current.row + 1 : current.row
        current = Point(row: row, col: col)
        
        return (point, cell)
    }
    
}
