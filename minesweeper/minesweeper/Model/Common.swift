import Foundation

enum Click {
    case reveal
    case mark
}

struct Move {
    let click: Click
    let point: Point
}

struct Point: Hashable {
    let row, col: Int
}
