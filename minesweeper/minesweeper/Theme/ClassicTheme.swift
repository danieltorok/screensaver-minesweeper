import Foundation
import AppKit

class ClassicTheme: Theme {
    
    let game: MinesweeperGame
    let cellSize: NSSize

    let background = NSColor(red: 198.0 / 255.0, green: 198.0 / 255.0, blue: 198.0 / 255.0, alpha: 1)
    let light = NSColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
    let dark = NSColor(red: 128.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 1)
    
    let paths: [() -> NSBezierPath] = [
        ClassicTheme.createOnePath,
        ClassicTheme.createTwoPath,
        ClassicTheme.createThreePath,
        ClassicTheme.createFourPath,
        ClassicTheme.createFivePath,
        ClassicTheme.createSixPath,
        ClassicTheme.createSevenPath,
        ClassicTheme.createEightPath
    ]
    
    let colors = [
        NSColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 255.0 / 255.0, alpha: 1),
        NSColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 0.0 / 255.0, alpha: 1),
        NSColor(red: 255.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 1),
        NSColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 128.0 / 255.0, alpha: 1),
        NSColor(red: 128.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 1),
        NSColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 1),
        NSColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 1),
        NSColor(red: 128.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 1)
    ]
    
    init(game: MinesweeperGame) {
        self.game = game
        self.cellSize = NSSize(width: game.boxSize, height: game.boxSize)
    }
    
    func drawCell(point: Point, cell: Cell) {
        let pos = NSPoint(x: point.col * game.boxSize, y: point.row * game.boxSize)
        let even = (point.col + point.row) % 2 == 0
        
        drawBackground(pos: pos, even: even, visibility: cell.visibility)
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
    
    func drawVisible(pos: NSPoint, content: CellType) {
        switch content {
        case .empty(let count) where count > 0:
            let path = self.paths[count - 1]()
            path.transform(using: AffineTransform(scale: (game.d_boxSize/64.0) * 0.7))
            path.transform(using: AffineTransform(
                translationByX: pos.x + game.d_boxSize * 0.13,
                byY: pos.y + game.d_boxSize * 0.17
            ))
            
            colors[count - 1].setFill()
            path.fill()

        default:
            return
        }
    }
    
    private func drawBackground(pos: NSPoint, even: Bool, visibility: Visibility) {
        switch visibility {
        case .hidden, .marked:
            let upper = NSBezierPath(rect: NSRect(origin: pos, size: cellSize))
            light.setFill()
            upper.fill()
            
            let lower = NSBezierPath()
            lower.move(to: pos)
            lower.relativeLine(to: NSPoint(x: game.d_boxSize, y: game.d_boxSize))
            lower.relativeLine(to: NSPoint(x: 0, y: -game.d_boxSize))
            lower.close()
            dark.setFill()
            lower.fill()
            
            let mid = NSBezierPath(rect: NSRect(
                origin: NSPoint(x: pos.x + game.d_boxSize * 0.1, y: pos.y + game.d_boxSize * 0.1),
                size: NSSize(width: game.d_boxSize - game.d_boxSize * 0.2, height: game.d_boxSize - game.d_boxSize * 0.2)
            ))
            background.setFill()
            mid.fill()
        case .visible:
            let upper = NSBezierPath(rect: NSRect(origin: pos, size: cellSize))
            background.setFill()
            upper.fill()
            
            let lower = NSBezierPath(rect: NSRect(
                origin: pos,
                size: NSSize(width: game.d_boxSize, height: game.d_boxSize*0.05)
            ))
            dark.setFill()
            lower.fill()
            
            let right = NSBezierPath(rect: NSRect(
                origin: NSPoint(x: pos.x + game.d_boxSize * 0.95, y: pos.y),
                size: NSSize(width: game.d_boxSize * 0.05, height: game.d_boxSize)
            ))
            dark.setFill()
            right.fill()
        }
    }
    
    let fillColor2 = NSColor(red: 0, green: 0, blue: 0, alpha: 1)
    let strokeColor = NSColor(red: 0, green: 0, blue: 0, alpha: 1)
    let id0 = NSGradient(colors: [
        NSColor(red: 0.906, green: 0, blue: 0.188, alpha: 1),
        NSColor(red: 1, green: 0.282, blue: 0.282, alpha: 1),
        NSColor(red: 1, green: 0.184, blue: 0.184, alpha: 1),
        NSColor(red: 1, green: 0.11, blue: 0.11, alpha: 1),
        NSColor(red: 0.753, green: 0.082, blue: 0.082, alpha: 1),
        NSColor(red: 0.631, green: 0.051, blue: 0.051, alpha: 1)
    ], atLocations: [0.0, 0.39, 0.62, 0.79, 0.97, 1.0], colorSpace: NSColorSpace.sRGB)!

    
    func drawFlag(pos: NSPoint) {
        let polePath = NSBezierPath(rect: NSRect(x: 34.25, y: 16.2, width: 5.52, height: 19.88))
        fillColor2.setFill()
        polePath.transform(using: AffineTransform(scale: (game.d_boxSize/64.0) * 0.7))
        polePath.transform(using: AffineTransform(
            translationByX: pos.x + game.d_boxSize * 0.13,
            byY: pos.y + game.d_boxSize * 0.17
        ))
        polePath.fill()
        strokeColor.setStroke()
        polePath.lineWidth = 0.5
        polePath.stroke()

        let base_2Path = NSBezierPath(roundedRect: NSRect(x: 20.37, y: 10.05, width: 24.84, height: 9.08), xRadius: 3.17, yRadius: 3.17)
        fillColor2.setFill()
        base_2Path.transform(using: AffineTransform(scale: (game.d_boxSize/64.0) * 0.7))
        base_2Path.transform(using: AffineTransform(
            translationByX: pos.x + game.d_boxSize * 0.13,
            byY: pos.y + game.d_boxSize * 0.17
        ))
        base_2Path.fill()

        let base_1Path = NSBezierPath(roundedRect: NSRect(x: 9.5, y: 0.58, width: 47.87, height: 13.06), xRadius: 3.36, yRadius: 3.36)
        base_1Path.transform(using: AffineTransform(scale: (game.d_boxSize/64.0) * 0.7))
        base_1Path.transform(using: AffineTransform(
            translationByX: pos.x + game.d_boxSize * 0.13,
            byY: pos.y + game.d_boxSize * 0.17
        ))
        fillColor2.setFill()
        base_1Path.fill()

        let redFlagPath = NSBezierPath()
        redFlagPath.move(to: NSPoint(x: 39.9, y: 63.38))
        redFlagPath.line(to: NSPoint(x: 39.9, y: 30.3))
        redFlagPath.curve(to: NSPoint(x: 5.51, y: 56.42), controlPoint1: NSPoint(x: 34.35, y: 43.36), controlPoint2: NSPoint(x: 11.89, y: 31.1))
        redFlagPath.curve(to: NSPoint(x: 21.05, y: 58.22), controlPoint1: NSPoint(x: 5.51, y: 56.42), controlPoint2: NSPoint(x: 12.83, y: 54.24))
        redFlagPath.curve(to: NSPoint(x: 39.9, y: 63.38), controlPoint1: NSPoint(x: 29.27, y: 62.2), controlPoint2: NSPoint(x: 35.35, y: 61.07))
        redFlagPath.close()
        redFlagPath.transform(using: AffineTransform(scale: (game.d_boxSize/64.0) * 0.7))
        redFlagPath.transform(using: AffineTransform(
            translationByX: pos.x + game.d_boxSize * 0.13,
            byY: pos.y + game.d_boxSize * 0.17
        ))
        
        redFlagPath.windingRule = .evenOdd
        NSGraphicsContext.saveGraphicsState()
        redFlagPath.addClip()
        id0.draw(from: NSPoint(x: 10.62 + pos.x, y: 49.02 + pos.y),
                 to: NSPoint(x: 34.79 + pos.x, y: 44.65 + pos.y),
            options: [.drawsBeforeStartingLocation, .drawsAfterEndingLocation])
        NSGraphicsContext.restoreGraphicsState()
    }
    
    static func createOnePath() -> NSBezierPath {
        let onePath = NSBezierPath()
        onePath.move(to: NSPoint(x: 9.47, y: -0.41))
        onePath.line(to: NSPoint(x: 54, y: -0.4))
        onePath.line(to: NSPoint(x: 53.99, y: 12.22))
        onePath.line(to: NSPoint(x: 41.17, y: 12.22))
        onePath.line(to: NSPoint(x: 41.17, y: 63.98))
        onePath.curve(to: NSPoint(x: 28.55, y: 64), controlPoint1: NSPoint(x: 36.97, y: 63.99), controlPoint2: NSPoint(x: 32.76, y: 63.99))
        onePath.curve(to: NSPoint(x: 9.49, y: 44.64), controlPoint1: NSPoint(x: 25.66, y: 53.61), controlPoint2: NSPoint(x: 18.53, y: 48.03))
        onePath.line(to: NSPoint(x: 9.44, y: 38.43))
        onePath.line(to: NSPoint(x: 22.27, y: 38.43))
        onePath.line(to: NSPoint(x: 22.22, y: 12.26))
        onePath.line(to: NSPoint(x: 9.33, y: 12.32))
        onePath.line(to: NSPoint(x: 9.47, y: -0.41))
        onePath.close()

        return onePath
    }
    
    static func createTwoPath() -> NSBezierPath {
        let twoPath = NSBezierPath()
        twoPath.move(to: NSPoint(x: -0.3, y: 44.69))
        twoPath.line(to: NSPoint(x: 18.31, y: 44.69))
        twoPath.line(to: NSPoint(x: 18.31, y: 50.88))
        twoPath.curve(to: NSPoint(x: 40.49, y: 50.93), controlPoint1: NSPoint(x: 26.08, y: 50.84), controlPoint2: NSPoint(x: 32.71, y: 50.96))
        twoPath.curve(to: NSPoint(x: 46.52, y: 46.76), controlPoint1: NSPoint(x: 41.87, y: 50.86), controlPoint2: NSPoint(x: 46.71, y: 51.73))
        twoPath.line(to: NSPoint(x: 46.54, y: 44.33))
        twoPath.curve(to: NSPoint(x: 38.09, y: 38.62), controlPoint1: NSPoint(x: 46.38, y: 40.37), controlPoint2: NSPoint(x: 41.54, y: 40.18))
        twoPath.curve(to: NSPoint(x: -0.09, y: 21.82), controlPoint1: NSPoint(x: 12.59, y: 30.79), controlPoint2: NSPoint(x: -0.07, y: 26.89))
        twoPath.curve(to: NSPoint(x: -0.23, y: 13.14), controlPoint1: NSPoint(x: -0.24, y: 19.26), controlPoint2: NSPoint(x: -0.19, y: 15.81))
        twoPath.line(to: NSPoint(x: -0.22, y: 0.35))
        twoPath.line(to: NSPoint(x: 63.01, y: -0.06))
        twoPath.line(to: NSPoint(x: 62.81, y: 12.52))
        twoPath.line(to: NSPoint(x: 18.43, y: 12.61))
        twoPath.line(to: NSPoint(x: 18.41, y: 14.47))
        twoPath.curve(to: NSPoint(x: 19.83, y: 18.28), controlPoint1: NSPoint(x: 18.54, y: 15.81), controlPoint2: NSPoint(x: 18.06, y: 17.49))
        twoPath.curve(to: NSPoint(x: 57.73, y: 31.16), controlPoint1: NSPoint(x: 27.34, y: 21.06), controlPoint2: NSPoint(x: 43.14, y: 26.29))
        twoPath.curve(to: NSPoint(x: 63.3, y: 44.3), controlPoint1: NSPoint(x: 62.52, y: 33.25), controlPoint2: NSPoint(x: 63.33, y: 38.77))
        twoPath.line(to: NSPoint(x: 63.36, y: 55.55))
        twoPath.curve(to: NSPoint(x: 55.47, y: 63.98), controlPoint1: NSPoint(x: 63.33, y: 60.78), controlPoint2: NSPoint(x: 60.5, y: 64.19))
        twoPath.line(to: NSPoint(x: 6.84, y: 63.9))
        twoPath.curve(to: NSPoint(x: -0.3, y: 54.33), controlPoint1: NSPoint(x: 0.39, y: 63.67), controlPoint2: NSPoint(x: -0.29, y: 57.68))
        twoPath.line(to: NSPoint(x: -0.3, y: 44.69))
        twoPath.close()
        
        return twoPath
    }
    
    static func createThreePath() -> NSBezierPath {
        let threePath = NSBezierPath()
        threePath.move(to: NSPoint(x: 62.98, y: 19.92))
        threePath.line(to: NSPoint(x: 62.98, y: 7))
        threePath.curve(to: NSPoint(x: 50.93, y: -0.37), controlPoint1: NSPoint(x: 62.98, y: 2.95), controlPoint2: NSPoint(x: 57.55, y: -0.37))
        threePath.line(to: NSPoint(x: 5.85, y: -0.37))
        threePath.curve(to: NSPoint(x: 0.18, y: 7), controlPoint1: NSPoint(x: -0.76, y: -0.37), controlPoint2: NSPoint(x: 0.18, y: 2.95))
        threePath.line(to: NSPoint(x: 0.18, y: 12.24))
        threePath.line(to: NSPoint(x: 40.59, y: 12.24))
        threePath.curve(to: NSPoint(x: 44.73, y: 14.77), controlPoint1: NSPoint(x: 42.87, y: 12.24), controlPoint2: NSPoint(x: 44.73, y: 13.38))
        threePath.line(to: NSPoint(x: 44.73, y: 22.91))
        threePath.curve(to: NSPoint(x: 40.59, y: 25.44), controlPoint1: NSPoint(x: 44.73, y: 24.3), controlPoint2: NSPoint(x: 42.87, y: 25.44))
        threePath.line(to: NSPoint(x: 18.97, y: 25.44))
        threePath.line(to: NSPoint(x: 18.97, y: 38.05))
        threePath.line(to: NSPoint(x: 18.97, y: 38.19))
        threePath.line(to: NSPoint(x: 40.59, y: 38.19))
        threePath.curve(to: NSPoint(x: 44.73, y: 40.72), controlPoint1: NSPoint(x: 42.87, y: 38.19), controlPoint2: NSPoint(x: 44.73, y: 39.33))
        threePath.line(to: NSPoint(x: 44.73, y: 48.86))
        threePath.curve(to: NSPoint(x: 40.59, y: 51.39), controlPoint1: NSPoint(x: 44.73, y: 50.25), controlPoint2: NSPoint(x: 42.87, y: 51.39))
        threePath.line(to: NSPoint(x: 0.18, y: 51.39))
        threePath.line(to: NSPoint(x: 0.18, y: 56.63))
        threePath.curve(to: NSPoint(x: 5.36, y: 64), controlPoint1: NSPoint(x: 0.18, y: 60.69), controlPoint2: NSPoint(x: -1.25, y: 64))
        threePath.line(to: NSPoint(x: 50.93, y: 64))
        threePath.curve(to: NSPoint(x: 62.98, y: 56.63), controlPoint1: NSPoint(x: 57.55, y: 64), controlPoint2: NSPoint(x: 62.98, y: 60.69))
        threePath.line(to: NSPoint(x: 62.98, y: 43.95))
        threePath.curve(to: NSPoint(x: 60.36, y: 38.1), controlPoint1: NSPoint(x: 63.14, y: 40.58), controlPoint2: NSPoint(x: 62.37, y: 38.96))
        threePath.curve(to: NSPoint(x: 56.76, y: 33.64), controlPoint1: NSPoint(x: 57.65, y: 36.93), controlPoint2: NSPoint(x: 56.76, y: 35.03))
        threePath.line(to: NSPoint(x: 56.76, y: 29.87))
        threePath.curve(to: NSPoint(x: 60.29, y: 25.09), controlPoint1: NSPoint(x: 56.76, y: 27.24), controlPoint2: NSPoint(x: 57.97, y: 26.21))
        threePath.curve(to: NSPoint(x: 62.98, y: 19.92), controlPoint1: NSPoint(x: 62.57, y: 24), controlPoint2: NSPoint(x: 62.98, y: 22.31))
        threePath.close()
        
        return threePath
    }
    
    static func createFourPath() -> NSBezierPath {
        let fourPath = NSBezierPath()
        fourPath.move(to: NSPoint(x: 38.97, y: 64))
        fourPath.line(to: NSPoint(x: 57.42, y: 64))
        fourPath.line(to: NSPoint(x: 57.42, y: 38.33))
        fourPath.line(to: NSPoint(x: 61.44, y: 38.33))
        fourPath.curve(to: NSPoint(x: 63.97, y: 35.84), controlPoint1: NSPoint(x: 62.46, y: 38.33), controlPoint2: NSPoint(x: 63.97, y: 37.89))
        fourPath.curve(to: NSPoint(x: 63.97, y: 28.63), controlPoint1: NSPoint(x: 63.97, y: 33.78), controlPoint2: NSPoint(x: 63.97, y: 29.24))
        fourPath.curve(to: NSPoint(x: 61.74, y: 25.64), controlPoint1: NSPoint(x: 63.97, y: 28.02), controlPoint2: NSPoint(x: 64.42, y: 25.73))
        fourPath.curve(to: NSPoint(x: 57.42, y: 25.49), controlPoint1: NSPoint(x: 59.06, y: 25.56), controlPoint2: NSPoint(x: 57.42, y: 25.49))
        fourPath.line(to: NSPoint(x: 57.42, y: 0.27))
        fourPath.line(to: NSPoint(x: 38.52, y: 0.27))
        fourPath.line(to: NSPoint(x: 38.52, y: 25.79))
        fourPath.line(to: NSPoint(x: 9.42, y: 25.79))
        fourPath.curve(to: NSPoint(x: 1.66, y: 34.87), controlPoint1: NSPoint(x: 2.95, y: 25.79), controlPoint2: NSPoint(x: -3.65, y: 24.48))
        fourPath.line(to: NSPoint(x: 11.16, y: 57.82))
        fourPath.curve(to: NSPoint(x: 19.91, y: 64), controlPoint1: NSPoint(x: 12.33, y: 61.63), controlPoint2: NSPoint(x: 15.02, y: 63.92))
        fourPath.line(to: NSPoint(x: 31.67, y: 64))
        fourPath.line(to: NSPoint(x: 21.4, y: 38.33))
        fourPath.line(to: NSPoint(x: 38.37, y: 38.33))
        fourPath.line(to: NSPoint(x: 38.97, y: 64))
        fourPath.close()
        
        return fourPath

    }
    
    static func createFivePath() -> NSBezierPath {
        let fivePath = NSBezierPath()
        fivePath.move(to: NSPoint(x: 62.99, y: 20.33))
        fivePath.line(to: NSPoint(x: 62.99, y: 6.07))
        fivePath.curve(to: NSPoint(x: 50.87, y: 0.13), controlPoint1: NSPoint(x: 62.99, y: 0.58), controlPoint2: NSPoint(x: 57.8, y: 0.13))
        fivePath.line(to: NSPoint(x: 5.51, y: 0.13))
        fivePath.curve(to: NSPoint(x: -0.2, y: 7.47), controlPoint1: NSPoint(x: -1.15, y: 0.13), controlPoint2: NSPoint(x: -0.2, y: 3.43))
        fivePath.line(to: NSPoint(x: -0.2, y: 12.69))
        fivePath.line(to: NSPoint(x: 40.47, y: 12.69))
        fivePath.curve(to: NSPoint(x: 43.91, y: 15.21), controlPoint1: NSPoint(x: 42.76, y: 12.69), controlPoint2: NSPoint(x: 43.91, y: 13.82))
        fivePath.line(to: NSPoint(x: 43.91, y: 23.31))
        fivePath.curve(to: NSPoint(x: 40.47, y: 25.65), controlPoint1: NSPoint(x: 43.91, y: 24.69), controlPoint2: NSPoint(x: 42.76, y: 25.65))
        fivePath.line(to: NSPoint(x: -0.22, y: 25.59))
        fivePath.line(to: NSPoint(x: -0.23, y: 63.86))
        fivePath.line(to: NSPoint(x: 62.81, y: 64))
        fivePath.line(to: NSPoint(x: 62.82, y: 60.62))
        fivePath.curve(to: NSPoint(x: 55.17, y: 51.01), controlPoint1: NSPoint(x: 63.08, y: 52.89), controlPoint2: NSPoint(x: 61.04, y: 51.03))
        fivePath.line(to: NSPoint(x: 18.45, y: 51.01))
        fivePath.line(to: NSPoint(x: 18.42, y: 38.15))
        fivePath.line(to: NSPoint(x: 51, y: 38.28))
        fivePath.curve(to: NSPoint(x: 62.98, y: 32.36), controlPoint1: NSPoint(x: 56.35, y: 38.3), controlPoint2: NSPoint(x: 62.89, y: 38.55))
        fivePath.curve(to: NSPoint(x: 62.99, y: 20.33), controlPoint1: NSPoint(x: 63.02, y: 29.8), controlPoint2: NSPoint(x: 62.99, y: 22.71))
        fivePath.close()
        
        return fivePath
    }
    
    static func createSixPath() -> NSBezierPath {
        let sixPath = NSBezierPath()
        sixPath.move(to: NSPoint(x: 62.99, y: 20.24))
        sixPath.line(to: NSPoint(x: 62.99, y: 8.8))
        sixPath.curve(to: NSPoint(x: 50.87, y: -0), controlPoint1: NSPoint(x: 62.99, y: 1.96), controlPoint2: NSPoint(x: 57.79, y: -0))
        sixPath.line(to: NSPoint(x: 8.67, y: -0))
        sixPath.curve(to: NSPoint(x: -0.23, y: 8.11), controlPoint1: NSPoint(x: 2, y: -0), controlPoint2: NSPoint(x: -0.23, y: 4.06))
        sixPath.line(to: NSPoint(x: -0.23, y: 8.57))
        sixPath.line(to: NSPoint(x: -0.28, y: 8.57))
        sixPath.line(to: NSPoint(x: -0.28, y: 33.3))
        sixPath.line(to: NSPoint(x: -0.26, y: 33.3))
        sixPath.line(to: NSPoint(x: -0.26, y: 56.66))
        sixPath.curve(to: NSPoint(x: 7.9, y: 63.88), controlPoint1: NSPoint(x: -0.39, y: 60.3), controlPoint2: NSPoint(x: 2.33, y: 63.95))
        sixPath.line(to: NSPoint(x: 56.98, y: 64))
        sixPath.line(to: NSPoint(x: 56.99, y: 61.82))
        sixPath.curve(to: NSPoint(x: 49.78, y: 51.03), controlPoint1: NSPoint(x: 57.23, y: 53.63), controlPoint2: NSPoint(x: 56.24, y: 51.25))
        sixPath.line(to: NSPoint(x: 19.13, y: 51.17))
        sixPath.line(to: NSPoint(x: 19.09, y: 38.29))
        sixPath.line(to: NSPoint(x: 50.99, y: 38.23))
        sixPath.curve(to: NSPoint(x: 62.98, y: 30.39), controlPoint1: NSPoint(x: 57.66, y: 38.21), controlPoint2: NSPoint(x: 62.89, y: 36.6))
        sixPath.curve(to: NSPoint(x: 62.99, y: 20.24), controlPoint1: NSPoint(x: 63.02, y: 27.83), controlPoint2: NSPoint(x: 62.99, y: 22.62))
        sixPath.close()
        sixPath.move(to: NSPoint(x: 18.83, y: 12.58))
        sixPath.line(to: NSPoint(x: 19, y: 12.58))
        sixPath.line(to: NSPoint(x: 40.46, y: 12.58))
        sixPath.curve(to: NSPoint(x: 43.9, y: 15.1), controlPoint1: NSPoint(x: 42.75, y: 12.58), controlPoint2: NSPoint(x: 43.9, y: 13.71))
        sixPath.line(to: NSPoint(x: 43.9, y: 23.22))
        sixPath.curve(to: NSPoint(x: 40.46, y: 25.56), controlPoint1: NSPoint(x: 43.9, y: 24.61), controlPoint2: NSPoint(x: 42.75, y: 25.57))
        sixPath.line(to: NSPoint(x: 18.83, y: 25.53))
        sixPath.line(to: NSPoint(x: 18.83, y: 12.58))
        sixPath.close()
        
        return sixPath
    }
    
    static func createSevenPath() -> NSBezierPath {
        let sevenPath = NSBezierPath()
        sevenPath.move(to: NSPoint(x: 0.01, y: 64))
        sevenPath.line(to: NSPoint(x: 62.97, y: 64))
        sevenPath.line(to: NSPoint(x: 62.97, y: 48.23))
        sevenPath.curve(to: NSPoint(x: 60.09, y: 36.23), controlPoint1: NSPoint(x: 63.2, y: 43.03), controlPoint2: NSPoint(x: 61.97, y: 39.29))
        sevenPath.line(to: NSPoint(x: 40.79, y: 0.2))
        sevenPath.curve(to: NSPoint(x: 31.92, y: 0.2), controlPoint1: NSPoint(x: 37.84, y: 0.2), controlPoint2: NSPoint(x: 34.88, y: 0.2))
        sevenPath.curve(to: NSPoint(x: 25.72, y: 4.47), controlPoint1: NSPoint(x: 27.3, y: 0.28), controlPoint2: NSPoint(x: 25.76, y: 0.39))
        sevenPath.curve(to: NSPoint(x: 28.87, y: 14.79), controlPoint1: NSPoint(x: 25.54, y: 7.71), controlPoint2: NSPoint(x: 26.41, y: 10.8))
        sevenPath.line(to: NSPoint(x: 41.52, y: 37.14))
        sevenPath.curve(to: NSPoint(x: 44.1, y: 45.51), controlPoint1: NSPoint(x: 42.8, y: 39.08), controlPoint2: NSPoint(x: 44.26, y: 41.77))
        sevenPath.line(to: NSPoint(x: 44.1, y: 50.21))
        sevenPath.line(to: NSPoint(x: 7.16, y: 50.21))
        sevenPath.curve(to: NSPoint(x: -0, y: 57.84), controlPoint1: NSPoint(x: 3.63, y: 50.13), controlPoint2: NSPoint(x: -0.03, y: 51.27))
        sevenPath.line(to: NSPoint(x: 0.01, y: 64))
        sevenPath.close()

        return sevenPath
    }
    
    static func createEightPath() -> NSBezierPath {
        let eightPath = NSBezierPath()
        eightPath.move(to: NSPoint(x: 22.65, y: 12.9))
        eightPath.line(to: NSPoint(x: 40.4, y: 12.9))
        eightPath.curve(to: NSPoint(x: 43.86, y: 15.43), controlPoint1: NSPoint(x: 42.7, y: 12.9), controlPoint2: NSPoint(x: 43.86, y: 14.04))
        eightPath.line(to: NSPoint(x: 43.86, y: 23.36))
        eightPath.curve(to: NSPoint(x: 40.4, y: 25.71), controlPoint1: NSPoint(x: 43.86, y: 24.75), controlPoint2: NSPoint(x: 42.7, y: 25.71))
        eightPath.line(to: NSPoint(x: 22.65, y: 25.68))
        eightPath.curve(to: NSPoint(x: 18.72, y: 22.83), controlPoint1: NSPoint(x: 20.14, y: 25.8), controlPoint2: NSPoint(x: 18.49, y: 25.17))
        eightPath.line(to: NSPoint(x: 18.72, y: 15.7))
        eightPath.curve(to: NSPoint(x: 22.65, y: 12.9), controlPoint1: NSPoint(x: 18.62, y: 13.71), controlPoint2: NSPoint(x: 19.92, y: 12.77))
        eightPath.close()
        eightPath.move(to: NSPoint(x: 62.99, y: 20.23))
        eightPath.line(to: NSPoint(x: 62.99, y: 8.78))
        eightPath.curve(to: NSPoint(x: 50.84, y: -0.02), controlPoint1: NSPoint(x: 62.99, y: 1.95), controlPoint2: NSPoint(x: 57.78, y: -0.02))
        eightPath.line(to: NSPoint(x: 8.54, y: -0.02))
        eightPath.curve(to: NSPoint(x: -0.38, y: 8.09), controlPoint1: NSPoint(x: 1.86, y: -0.02), controlPoint2: NSPoint(x: -0.38, y: 4.04))
        eightPath.line(to: NSPoint(x: -0.38, y: 8.56))
        eightPath.line(to: NSPoint(x: -0.42, y: 8.56))
        eightPath.line(to: NSPoint(x: -0.3, y: 22.51))
        eightPath.curve(to: NSPoint(x: 5.65, y: 28.48), controlPoint1: NSPoint(x: -0.27, y: 26.95), controlPoint2: NSPoint(x: 0.66, y: 28.67))
        eightPath.curve(to: NSPoint(x: 5.84, y: 35.4), controlPoint1: NSPoint(x: 7.68, y: 28.84), controlPoint2: NSPoint(x: 8.32, y: 35.15))
        eightPath.curve(to: NSPoint(x: -0.4, y: 44.76), controlPoint1: NSPoint(x: -1.03, y: 35.74), controlPoint2: NSPoint(x: -0.41, y: 40.18))
        eightPath.line(to: NSPoint(x: -0.41, y: 56.66))
        eightPath.curve(to: NSPoint(x: 7.77, y: 63.88), controlPoint1: NSPoint(x: -0.53, y: 60.3), controlPoint2: NSPoint(x: 2.19, y: 63.95))
        eightPath.line(to: NSPoint(x: 44.13, y: 63.97))
        eightPath.line(to: NSPoint(x: 44.13, y: 64))
        eightPath.line(to: NSPoint(x: 56.97, y: 64))
        eightPath.curve(to: NSPoint(x: 63, y: 57.12), controlPoint1: NSPoint(x: 60.99, y: 63.74), controlPoint2: NSPoint(x: 63, y: 61.45))
        eightPath.line(to: NSPoint(x: 62.97, y: 42.75))
        eightPath.curve(to: NSPoint(x: 57.37, y: 35.44), controlPoint1: NSPoint(x: 63.03, y: 37.5), controlPoint2: NSPoint(x: 62.37, y: 35.63))
        eightPath.curve(to: NSPoint(x: 57.2, y: 28.44), controlPoint1: NSPoint(x: 55.06, y: 35.39), controlPoint2: NSPoint(x: 55.28, y: 28.41))
        eightPath.curve(to: NSPoint(x: 62.98, y: 23.28), controlPoint1: NSPoint(x: 63.27, y: 28.16), controlPoint2: NSPoint(x: 62.97, y: 23.66))
        eightPath.curve(to: NSPoint(x: 62.99, y: 20.23), controlPoint1: NSPoint(x: 62.98, y: 22.96), controlPoint2: NSPoint(x: 62.99, y: 22.31))
        eightPath.close()
        eightPath.move(to: NSPoint(x: 22.65, y: 38.64))
        eightPath.line(to: NSPoint(x: 40.4, y: 38.64))
        eightPath.curve(to: NSPoint(x: 43.86, y: 41.17), controlPoint1: NSPoint(x: 42.7, y: 38.64), controlPoint2: NSPoint(x: 43.86, y: 39.78))
        eightPath.line(to: NSPoint(x: 43.86, y: 49.1))
        eightPath.curve(to: NSPoint(x: 40.4, y: 51.45), controlPoint1: NSPoint(x: 43.86, y: 50.49), controlPoint2: NSPoint(x: 42.7, y: 51.45))
        eightPath.line(to: NSPoint(x: 22.65, y: 51.42))
        eightPath.curve(to: NSPoint(x: 18.72, y: 48.57), controlPoint1: NSPoint(x: 20.14, y: 51.54), controlPoint2: NSPoint(x: 18.49, y: 50.91))
        eightPath.line(to: NSPoint(x: 18.72, y: 41.44))
        eightPath.curve(to: NSPoint(x: 22.65, y: 38.64), controlPoint1: NSPoint(x: 18.62, y: 39.45), controlPoint2: NSPoint(x: 19.92, y: 38.51))
        eightPath.close()

        return eightPath
    }
    
}
