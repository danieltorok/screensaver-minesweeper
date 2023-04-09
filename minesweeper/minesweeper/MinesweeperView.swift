import Foundation
import ScreenSaver

class MinesweeperView: ScreenSaverView {
    
    lazy var configureSheetController = ConfigureSheetController()

    let game: MinesweeperGame
    let solver: MinesweeperSolver
    let cursor: Cursor
    var theme: Theme
    
    var nextMove: Move?
    var currentPoint: Point = Point(row: 0, col: 0)
    
    var initRenderCount = 0
    
    static func createTheme(game: MinesweeperGame) -> Theme {
        let theme = Preferences.theme
        switch theme {
        case "Classic": return ClassicTheme(game: game)
        case "Green Field": return GreenTheme(game: game)
        case "Random": return Int.random(in: 0...100) < 50 ? ClassicTheme(game: game) : GreenTheme(game: game)
        default: return ClassicTheme(game: game)
        }
    }
    
    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init?(coder decoder: NSCoder) not implemented")
    }

    override init(frame: NSRect, isPreview: Bool) {
        game = MinesweeperGame(screenSize: frame.size)
        solver = MinesweeperSolver(game: game)
        cursor = Cursor(boxSize: Double(game.boxSize))
        theme = MinesweeperView.createTheme(game: game)
        
        super.init(frame: frame, isPreview: isPreview)!
        animationTimeInterval = 1.0 / 30.0
    }
    
    override var hasConfigureSheet: Bool {
        true
    }
    
    override var configureSheet: NSWindow? {
        return configureSheetController.window
    }

    override func draw(_ rect: NSRect) {
        // On some machines the initial frame is erased for some reason,
        // so here I render it a few times.
        if initRenderCount < 10 {
            initRenderCount += 1
            game.grid.forEach { (point, cell) in
                theme.drawCell(point: point, cell: cell)
            }
        }
        
        game.invalidPoints.union(cursor.invalidPoints).forEach { point in
            theme.drawCell(point: point, cell: game.grid[point])
        }
        
        cursor.draw()
    }

    override func animateOneFrame() {
        if nextMove == nil {
            let move = solver.move(previous: currentPoint)
            if move == nil {
                reset()
                setNeedsDisplay(bounds)
                return
            }

            nextMove = move
            currentPoint = move!.point
            cursor.moveTo(point: NSPoint(
                x: move!.point.col * game.boxSize,
                y: move!.point.row * game.boxSize
            ))
        }
        
        let isCursorOverNextCell = cursor.step()
        setNeedsDisplay(cursor.invalidRect)

        if isCursorOverNextCell {
            switch nextMove!.click {
            case .reveal:
                game.reveal(point: nextMove!.point)
            case .mark:
                game.mark(point: nextMove!.point)
            }
            nextMove = nil
            setNeedsDisplay(game.invalidRect)
        }
    }
    
    func reset() {
        game.reset()
        theme = MinesweeperView.createTheme(game: game)
        initRenderCount = 0
    }

}
