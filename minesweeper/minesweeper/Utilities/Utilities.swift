import Foundation

func isEmpty(_ data: CellType) -> Bool {
    if case .empty(let count) = data {
        return count == 0
    } else {
        return false
    }
}

func isNotEmpty(_ data: CellType) -> Bool {
    if case .empty(let count) = data {
        return count > 0
    } else {
        return false
    }
}

func isNotMine(_ data: CellType) -> Bool {
    if case .mine = data {
        return false
    } else {
        return true
    }
}

func isHidden(_ data: Cell) -> Bool {
    if case .hidden = data.visibility {
        return true
    } else {
        return false
    }
}

let deltas = [(0, -1), (1, -1), (1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1)]
func neighbourIndices(point: Point, rows: Int, cols: Int) -> [Point] {
    return deltas
        .map({ (colDelta, rowDelta) in Point(row: point.row + rowDelta, col: point.col + colDelta) })
        .filter({ point in 0..<cols ~= point.col && 0..<rows ~= point.row })
}

func commonDivisors(_ a: Int, _ b: Int) -> [Int] {
    var divisors: [Int] = []
    for num in 2...max(a, b) {
        if (a % num == 0 && b % num == 0) {
            divisors.append(num)
        }
    }
    return divisors
}
