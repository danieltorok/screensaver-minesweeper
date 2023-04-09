import Foundation
import AppKit

class GreenTheme: Theme {
    
    let game: MinesweeperGame
    let cellSize: NSSize
    
    let borderGreen = NSColor(red: 134.0 / 255.0, green: 174.0 / 255.0, blue: 59.0 / 255.0, alpha: 1)
    
    let lightGreen = NSColor(red: 169.0 / 255.0, green: 215.0 / 255.0, blue: 81.0 / 255.0, alpha: 1)
    let darkGreen = NSColor(red: 162.0 / 255.0, green: 209.0 / 255.0, blue: 72.0 / 255.0, alpha: 1)
    
    let lightBrown = NSColor(red: 229.0 / 255.0, green: 194.0 / 255.0, blue: 159.0 / 255.0, alpha: 1)
    let darkBrown = NSColor(red: 215.0 / 255.0, green: 184.0 / 255.0, blue: 153.0 / 255.0, alpha: 1)
    
    let colors = [
        NSColor(red: 25.0 / 255.0, green: 118.0 / 255.0, blue: 210.0 / 255.0, alpha: 1),
        NSColor(red: 56.0 / 255.0, green: 142.0 / 255.0, blue: 60.0 / 255.0, alpha: 1),
        NSColor(red: 211.0 / 255.0, green: 46.0 / 255.0, blue: 47.0 / 255.0, alpha: 1),
        NSColor(red: 123.0 / 255.0, green: 31.0 / 255.0, blue: 162.0 / 255.0, alpha: 1),
        NSColor(red: 255.0 / 255.0, green: 144.0 / 255.0, blue: 0.0 / 255.0, alpha: 1),
        NSColor(red: 0.0 / 255.0, green: 156.0 / 255.0, blue: 169.0 / 255.0, alpha: 1),
        NSColor(red: 43.0 / 255.0, green: 40.0 / 255.0, blue: 41.0 / 255.0, alpha: 1),
        NSColor(red: 234.0 / 255.0, green: 78.0 / 255.0, blue: 226.0 / 255.0, alpha: 1)
    ]
    
    let textLeftPadding: Double
    let textTopPadding: Double
    
    init(game: MinesweeperGame) {
        self.game = game
        self.cellSize = NSSize(width: game.boxSize, height: game.boxSize)
        self.textLeftPadding = game.d_boxSize * 0.21
        self.textTopPadding = game.d_boxSize * -0.05
    }
    
    func drawCell(point: Point, cell: Cell) {
        let pos = NSPoint(x: point.col * game.boxSize, y: point.row * game.boxSize)
        let even = (point.col + point.row) % 2 == 0
        
        drawBackground(pos: pos, even: even, visibility: cell.visibility)
        if case .visible = cell.visibility {
            drawBorder(pos: pos, point: point)
        }
        drawContent(pos: pos, cell: cell)
    }
    
    private func drawContent(pos: NSPoint, cell: Cell) {
        switch cell.visibility {
        case .marked:
            drawFlag(pos: pos)
        case .visible:
            drawVisible(pos: pos, content: cell.type)
        default:
            return
        }
    }
    
    private func drawBackground(pos: NSPoint, even: Bool, visibility: Visibility) {
        let color = backgroundColor(even: even, visibility: visibility)
        color.setFill()

        let box = NSBezierPath(rect: NSRect(origin: pos, size: cellSize))
        box.fill()
    }
    
    private func drawBorder(pos: NSPoint, point: Point) {
        borderGreen.setFill()
        for nPoint in neighbourIndices(point: point, rows: game.rows, cols: game.cols) {
            let nCell = game.grid[nPoint]
            if case .visible = nCell.visibility {
                continue
            }
            
            if nPoint.row > point.row && nPoint.col == point.col {
                let top = NSBezierPath(rect: NSRect(
                    x: pos.x,
                    y: pos.y + game.d_boxSize * 0.9, width: game.d_boxSize, height: game.d_boxSize*0.1
                ))
                top.fill()
            }
            if nPoint.row < point.row && nPoint.col == point.col {
                let botom = NSBezierPath(rect: NSRect(
                    x: pos.x,
                    y: pos.y, width: game.d_boxSize, height: game.d_boxSize*0.1
                ))
                botom.fill()
            }
            if nPoint.row == point.row && nPoint.col < point.col {
                let left = NSBezierPath(rect: NSRect(
                    x: pos.x,
                    y: pos.y, width: game.d_boxSize*0.1, height: game.d_boxSize
                ))
                left.fill()
            }
            if nPoint.row == point.row && nPoint.col > point.col {
                let right = NSBezierPath(rect: NSRect(
                    x: pos.x + game.d_boxSize * 0.9,
                    y: pos.y, width: game.d_boxSize*0.1, height: game.d_boxSize
                ))
                right.fill()
            }
            
            if nPoint.row > point.row && nPoint.col > point.col {
                let uRight = NSBezierPath(rect: NSRect(
                    x: pos.x + game.d_boxSize * 0.9,
                    y: pos.y + game.d_boxSize * 0.9, width: game.d_boxSize*0.1, height: game.d_boxSize*0.1
                ))
                uRight.fill()
            }
            if nPoint.row < point.row && nPoint.col > point.col {
                let lRight = NSBezierPath(rect: NSRect(
                    x: pos.x + game.d_boxSize * 0.9,
                    y: pos.y, width: game.d_boxSize*0.1, height: game.d_boxSize*0.1
                ))
                lRight.fill()
            }
            if nPoint.row < point.row && nPoint.col < point.col {
                let lLeft = NSBezierPath(rect: NSRect(
                    x: pos.x,
                    y: pos.y, width: game.d_boxSize*0.1, height: game.d_boxSize*0.1
                ))
                lLeft.fill()
            }
            if nPoint.row > point.row && nPoint.col < point.col {
                let uLeft = NSBezierPath(rect: NSRect(
                    x: pos.x,
                    y: pos.y + game.d_boxSize * 0.9, width: game.d_boxSize*0.1, height: game.d_boxSize*0.1
                ))
                uLeft.fill()
            }
        }
    }
    
    private func backgroundColor(even: Bool, visibility: Visibility) -> NSColor {
        switch visibility {
        case .hidden, .marked:
            return even ? lightGreen : darkGreen
        case .visible:
            return even ? lightBrown : darkBrown
        }
    }
    
    func drawVisible(pos: NSPoint, content: CellType) {
        switch content {
        case .empty(let count) where count > 0:
            let textCenter = NSPoint(x: pos.x + textLeftPadding, y: pos.y + textTopPadding)
            let s = NSAttributedString(
                string: "\(count)",
                attributes: [
                    .font: NSFont(name: "Courier", size: game.d_boxSize)!,
                    .foregroundColor: colors[count - 1]
                ]
            )
            s.draw(at: textCenter)
            break
        default:
            return
        }
    }
    
    func drawFlag(pos: NSPoint) {
        let base = NSBezierPath()
        base.move(to: NSPoint(
            x: pos.x + game.d_boxSize / 8.0,
            y: pos.y + game.d_boxSize / 10.0
        ))
        base.relativeLine(to: NSPoint(x: 0, y: game.d_boxSize / 10))
        base.relativeLine(to: NSPoint(x: game.d_boxSize / 4.0 + game.d_boxSize / 15, y: 0))
        base.relativeLine(to: NSPoint(x: 0, y: -(game.d_boxSize / 10)))
        base.close()
        NSColor.black.setFill()
        base.fill()
        
        let pole = NSBezierPath()
        pole.move(to: NSPoint(
            x: pos.x + game.d_boxSize / 4.0,
            y: pos.y + game.d_boxSize / 5.0
        ))
        pole.relativeLine(to: NSPoint(x: 0, y: game.d_boxSize / 1.5))
        pole.relativeLine(to: NSPoint(x: game.d_boxSize / 15, y: 0))
        pole.relativeLine(to: NSPoint(x: 0, y: -(game.d_boxSize / 1.5)))
        pole.close()
        NSColor.black.setFill()
        pole.fill()
        
        let flag = NSBezierPath()
        flag.move(to: NSPoint(
            x: pos.x + game.d_boxSize / 4.0,
            y: pos.y + game.d_boxSize / 5.0 + game.d_boxSize / 1.5
        ))
        flag.relativeLine(to: NSPoint(x: game.d_boxSize / 2.0, y: -(game.d_boxSize / 4.0)))
        flag.relativeLine(to: NSPoint(x: -(game.d_boxSize / 2.0), y: -(game.d_boxSize / 4.0)))
        flag.close()
        NSColor.black.setFill()
        flag.fill()
        
        let inner = NSBezierPath()
        inner.move(to: NSPoint(
            x: pos.x + game.d_boxSize / 3.5,
            y: pos.y + game.d_boxSize / 5.0 + game.d_boxSize / 1.6
        ))
        inner.relativeLine(to: NSPoint(x: game.d_boxSize / 2.5, y: -(game.d_boxSize / 5)))
        inner.relativeLine(to: NSPoint(x: -(game.d_boxSize / 2.5), y: -(game.d_boxSize / 5)))
        inner.close()
        NSColor.red.setFill()
        inner.fill()
    }
    
}
