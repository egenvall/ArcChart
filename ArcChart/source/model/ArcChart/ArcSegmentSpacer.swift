import SwiftUI
/**
 A line drawn at an angle to give the illusion of spacing between segments
 */
struct ArcSegmentSpacer: Shape, Animatable {
    typealias AnimatableData = AnimatablePair<Double, CGFloat>
    var angle: Double
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: center(rect))
        path.addLine(to: getPoint(center(rect), .radians(angle), radius))
        return path
    }
    func getPoint(_ center: CGPoint, _ angle: Angle, _ radius: CGFloat) -> CGPoint {
        let x = center.x + (CGFloat(cos(angle.radians)) * radius)
        let y = center.y + (CGFloat(sin(angle.radians)) * radius)
        return CGPoint(x: x, y: y)
    }
    func center(_ rect: CGRect) -> CGPoint {
        return CGPoint(x: rect.midX, y: rect.midY)
    }
    var animatableData: AnimatableData {
        get {
            .init(angle, radius)
        }
        set {
            angle = newValue.first
            radius = newValue.second
        }
    }
}
