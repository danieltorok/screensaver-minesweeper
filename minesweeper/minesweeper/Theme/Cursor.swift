import Foundation
import AppKit

class Cursor {
    
    let scale: Double
    let offset: Double
    let boxSize: Double
    
    var currentPosition: NSPoint
    var targetPosition: NSPoint
    var stepX: Double = 0
    var stepY: Double = 0
    
    var invalidRect: NSRect!
    var invalidPoints: Set<Point> = []
    
    init(boxSize: Double) {
        self.boxSize = boxSize
        self.scale = (boxSize / 18.22) * 0.7
        self.offset = boxSize / 4.0
        
        currentPosition = NSPoint(x: 0, y: 0)
        targetPosition = NSPoint(x: 0, y: 0)
    }
    
    func moveTo(point: NSPoint) {
        targetPosition = NSPoint(x: point.x, y: point.y)
        
        let dx = targetPosition.x - currentPosition.x
        let dy = targetPosition.y - currentPosition.y
        
        stepX = dx / 5.0
        stepY = dy / 5.0
    }
    
    func step() -> Bool {
        let from = NSPoint(x: currentPosition.x, y: currentPosition.y)
        currentPosition.x += stepX
        currentPosition.y += stepY
        
        if (
            (stepX > 0 && currentPosition.x > targetPosition.x) ||
            (stepX < 0 && currentPosition.x < targetPosition.x)
        ) {
            currentPosition.x = targetPosition.x
        }
        
        if (
            (stepY > 0 && currentPosition.y > targetPosition.y) ||
            (stepY < 0 && currentPosition.y < targetPosition.y)
        ) {
            currentPosition.y = targetPosition.y
        }
        
        let left = min(from.x, currentPosition.x) + offset
        let bottom = min(from.y, currentPosition.y)
        let width = abs(currentPosition.x - from.x) + 11.59 * scale
        let height = abs(currentPosition.y - from.y) + 18.22 * scale
        invalidRect = NSRect(
            x: left,
            y: bottom,
            width: width,
            height: height
        )
        
        let leftCol = Int(left / boxSize)
        let rightCol = Int((left + width) / boxSize)
        let leftRow = Int(bottom / boxSize)
        let rightRow = Int((bottom + height) / boxSize)
        
        invalidPoints = []
        for col in leftCol...rightCol {
            for row in leftRow...rightRow {
                invalidPoints.insert(Point(row: row, col: col))
            }
        }
        
        return currentPosition == targetPosition
    }
    
    func draw() {
        let u_outerPath = NSBezierPath()
        u_outerPath.move(to: NSPoint(x: 0, y: 2.58))
        u_outerPath.line(to: NSPoint(x: 0, y: 18.59))
        u_outerPath.line(to: NSPoint(x: 11.59, y: 6.97))
        u_outerPath.line(to: NSPoint(x: 4.81, y: 6.97))
        u_outerPath.line(to: NSPoint(x: 4.4, y: 6.85))
        u_outerPath.line(to: NSPoint(x: 0, y: 2.58))
        u_outerPath.close()
        u_outerPath.windingRule = .evenOdd
        NSColor.white.setFill()
        
        u_outerPath.transform(using: AffineTransform(scale: scale))
        u_outerPath.transform(using: AffineTransform(
            translationByX: currentPosition.x + offset,
            byY: currentPosition.y
        ))
        u_outerPath.fill()


        //// d_outer Drawing
        let d_outerPath = NSBezierPath()
        d_outerPath.move(to: NSPoint(x: 9.08, y: 1.9))
        d_outerPath.line(to: NSPoint(x: 5.48, y: 0.37))
        d_outerPath.line(to: NSPoint(x: 0.8, y: 11.46))
        d_outerPath.line(to: NSPoint(x: 4.48, y: 13.01))
        d_outerPath.line(to: NSPoint(x: 9.08, y: 1.9))
        d_outerPath.close()
        d_outerPath.windingRule = .evenOdd
        NSColor.white.setFill()
        
        d_outerPath.transform(using: AffineTransform(scale: scale))
        d_outerPath.transform(using: AffineTransform(
            translationByX: currentPosition.x + offset,
            byY: currentPosition.y
        ))
        d_outerPath.fill()


        //// cursor
        //// d_inner Drawing

        let d_innerPath = NSBezierPath()
        d_innerPath.move(to: NSPoint(x: 5.92, y: 1.97))
        d_innerPath.line(to: NSPoint(x: 7.77, y: 2.75))
        d_innerPath.line(to: NSPoint(x: 4.68, y: 10.12))
        d_innerPath.line(to: NSPoint(x: 2.83, y: 9.35))
        d_innerPath.line(to: NSPoint(x: 5.92, y: 1.97))
        NSColor.black.setFill()
        
        d_innerPath.transform(using: AffineTransform(scale: scale))
        d_innerPath.transform(using: AffineTransform(
            translationByX: currentPosition.x + offset,
            byY: currentPosition.y
        ))
        d_innerPath.fill()
        
        //// u_inner Drawing
        let u_innerPath = NSBezierPath()
        u_innerPath.move(to: NSPoint(x: 1, y: 16.19))
        u_innerPath.line(to: NSPoint(x: 1, y: 5))
        u_innerPath.line(to: NSPoint(x: 3.97, y: 7.86))
        u_innerPath.line(to: NSPoint(x: 4.4, y: 8))
        u_innerPath.line(to: NSPoint(x: 9.16, y: 8))
        u_innerPath.line(to: NSPoint(x: 1, y: 16.19))
        u_innerPath.close()
        u_innerPath.windingRule = .evenOdd
        NSColor.black.setFill()
        
        u_innerPath.transform(using: AffineTransform(scale: scale))
        u_innerPath.transform(using: AffineTransform(
            translationByX: currentPosition.x + offset,
            byY: currentPosition.y
        ))
        u_innerPath.fill()

    }
    
}
