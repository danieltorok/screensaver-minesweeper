import Foundation

class MinesweeperGame {

    let screenWidth: Int
    let screenHeight: Int

    let boxSize: Int
    let d_boxSize: Double

    let cols: Int
    let rows: Int

    var grid: Grid
    var invalidRect: NSRect!
    var invalidPoints: Set<Point> = []

    static func mineScaler() -> Int {
        switch Preferences.mines {
        case 0:
            return Int.random(in: 11...15)
        case 1:
            return Int.random(in: 6...10)
        case 2:
            return Int.random(in: 3...6)
        default:
            return Int.random(in: 6...10)
        }
    }
    
    static func createMineGrid(_ rows: Int, _ cols: Int, _ count: Int) -> [[Int]] {
        let flatGrid = (0..<rows*cols).map({ $0 < count ? 1 : 0 }).shuffled()
        return stride(from: 0, to: rows*cols, by: cols).map {
            Array(flatGrid[$0..<$0+cols])
        }
    }
    
    static func createGrid(_ mineGrid: [[Int]]) -> Grid {
        let rows = mineGrid.count
        let cols = mineGrid[0].count
        var grid: [[Cell]] = []

        for (rowIndex, row) in mineGrid.enumerated() {
            grid.append([])
            for (colIndex, col) in row.enumerated() {
                let isMine = col == 1
                if (isMine) {
                    grid[rowIndex].append(Cell(.mine))
                } else {
                    let point = Point(row: rowIndex, col: colIndex)
                    let count = neighbourIndices(point: point, rows: rows, cols: cols)
                        .reduce(0, { count, index in count + mineGrid[index.row][index.col] })
                    grid[rowIndex].append(Cell(.empty(count)))
                }
            }
        }

        return Grid(grid: grid)
    }

    init(screenSize: CGSize) {
        screenWidth = Int(screenSize.width)
        screenHeight = Int(screenSize.height)
        
        let divisors = commonDivisors(screenWidth, screenHeight)
        boxSize = divisors.first(where: { 65 * $0 >= Int(screenSize.width) }) ?? 30
        d_boxSize = Double(boxSize)
        
        rows = screenHeight / boxSize
        cols = screenWidth / boxSize
        
        let mines = (rows*cols) / MinesweeperGame.mineScaler()
        let mineGrid = MinesweeperGame.createMineGrid(rows, cols, mines)
        grid = MinesweeperGame.createGrid(mineGrid)
    }

    func reset() {
        let mines = (rows*cols) / MinesweeperGame.mineScaler()
        let mineGrid = MinesweeperGame.createMineGrid(rows, cols, mines)
        grid = MinesweeperGame.createGrid(mineGrid)
        invalidPoints = []
    }

    func reveal(point: Point) {
        var queue: Set<Point> = [point]
        var visited: Set<Point> = []
        
        while !queue.isEmpty {
            let point = queue.popFirst()!
            visited.insert(point)
            
            let cell = grid[point]
            cell.visibility = .visible

            if isEmpty(cell.type) {
                neighbourIndices(point: point, rows: rows, cols: cols)
                    .filter({ !visited.contains($0) })
                    .forEach({ queue.insert($0) })
            }
        }
        
        calculateInvalidRect(points: visited)
    }
    
    func mark(point: Point) {
        grid[point].visibility = .marked
        calculateInvalidRect(points: [point])
    }
    
    func calculateInvalidRect(points: Set<Point>) {
        var leftCol = Int.max
        var leftRow = Int.max
        var rightCol = Int.min
        var rightRow = Int.min
        
        for point in points {
            leftCol = min(leftCol, point.col)
            leftRow = min(leftRow, point.row)
            rightCol = max(rightCol, point.col)
            rightRow = max(rightRow, point.row)
        }
        leftCol = max(0, leftCol - 1)
        leftRow = max(0, leftRow - 1)
        rightCol = min(cols - 1, rightCol + 1)
        rightRow = min(rows - 1, rightRow + 1)
        
        invalidPoints = []
        for col in leftCol...rightCol {
            for row in leftRow...rightRow {
                invalidPoints.insert(Point(row: row, col: col))
            }
        }
        
        let leftX = leftCol * boxSize
        let leftY = leftRow * boxSize
        let rightX = (rightCol + 1) * boxSize
        let rightY = (rightRow + 1) * boxSize
        invalidRect = NSRect(x: leftX, y: leftY, width: rightX - leftX, height: rightY - leftY)
    }
    
    func randomEmpty() -> Point? {
        let cells = grid.filter({ (_, cell) in isHidden(cell) && isNotMine(cell.type) }).shuffled()
        
        let empty = cells.first(where: { (_, cell) in isEmpty(cell.type) })
        return empty?.0 ?? cells.first?.0
    }

}
