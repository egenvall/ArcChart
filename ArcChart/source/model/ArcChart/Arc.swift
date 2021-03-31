import SwiftUI


struct Arc: Shape, Animatable {
    typealias AnimatableData = AnimatablePair<AnimatablePair<CGFloat, CGFloat>, AnimatablePair<Double, Double>>

    var radius: CGFloat
    /// The start angle in radians
    var startAngle: Double
    // The end angle in radians
    var endAngle: Double
    // The thickness, eg depth of an arc
    var thickness: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: innerRadius(), startAngle: .radians(startAngle), endAngle: .radians(endAngle), clockwise: false)
        path.addLine(to: getPoint(CGPoint(x: rect.midX, y: rect.midY), .radians(endAngle), outerRadius())) // end Outer
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: outerRadius(), startAngle: .radians(endAngle), endAngle: .radians(startAngle), clockwise: true) // outer arc
        path.addLine(to: getPoint(CGPoint(x: rect.midX, y: rect.midY), .radians(startAngle), innerRadius())) // bottomleft
        path.closeSubpath()
        return path
    }
    
    /**
    The inner radius of an arc with the supplied `radius` and `thickness`
     */
    private func innerRadius() -> CGFloat {
        return radius - (thickness / 2)
    }
    /**
    The outer radius of an arc with the supplied `radius` and `thickness`
     */
    private func outerRadius() -> CGFloat {
        return radius + (thickness / 2)
    }
    /**
     Calculates a point on the Arc given the specified `center`, `angle` and `radius`
     */
    func getPoint(_ center: CGPoint, _ angle: Angle, _ radius: CGFloat) -> CGPoint {
        let x = center.x + (CGFloat(cos(angle.radians)) * radius)
        let y = center.y + (CGFloat(sin(angle.radians)) * radius)
        return CGPoint(x: x, y: y)
    }
    
    var animatableData: AnimatableData {
        get {
            AnimatableData(.init(radius, thickness), .init(startAngle, endAngle))
        }
        set {
            radius = newValue.first.first
            thickness = newValue.first.second
            startAngle = newValue.second.first
            endAngle = newValue.second.second
        }
    }
}
