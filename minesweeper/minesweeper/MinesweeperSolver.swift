import Foundation

class MinesweeperSolver {

    typealias Neighbours = [Visibility:[Point]]
    
    let game: MinesweeperGame
    
    init(game: MinesweeperGame) {
        self.game = game
    }
    
    func move(previous: Point) -> Move? {
        var possibleMoves: [Move] = []
        for (point, cell) in game.grid {
            guard !cell.solved else {
                continue
            }

            switch cell.visibility {
            case .hidden:
                continue
            case .marked:
                cell.solved = true
                continue
            case .visible:
                switch cell.type {
                case .mine:
                    cell.solved = true
                    continue
                case .empty(let count):
                    if count == 0 {
                        cell.solved = true
                        continue
                    }
                    let neighbours = neighboursByVisibility(point: point)
                    let hidden = neighbours[.hidden]!
                    let marked = neighbours[.marked]!
                    
                    if hidden.count == 0 {
                        cell.solved = true
                        continue
                    }
                    
                    if marked.count == count {
                        possibleMoves.append(Move(click: .reveal, point: hidden.first!))
                    } else if hidden.count + marked.count == count {
                        possibleMoves.append(Move(click: .mark, point: hidden.first!))
                    }
                }
            }
        }
        
        if let closestMove = possibleMoves.min(by: { a, b in
            abs(a.point.row - previous.row) + abs(a.point.col - previous.col) < abs(b.point.row - previous.row) + abs(b.point.col - previous.col)
        }) {
            return closestMove
        }

        if let randomPoint = game.randomEmpty() {
            return Move(click: .reveal, point: randomPoint)
        }
        
        return nil
    }
    
    func neighboursByVisibility(point: Point) -> Neighbours {
        var result: Neighbours = [
            .hidden: [],
            .marked: [],
            .visible: []
        ]

        for neigbourPoint in neighbourIndices(point: point, rows: game.rows, cols: game.cols) {
            let cell = game.grid[neigbourPoint]
            if case .visible = cell.visibility {
                continue
            }
            result[cell.visibility]!.append(neigbourPoint)
        }
        
        return result
    }
 
}
