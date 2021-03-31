import SwiftUI
struct ArcSegment: View {
    let startAngle: Double
    let endAngle: Double
    let fill: WedgeFillStyle
    let segmentProperty: ArcSegmentProperty
    let segmentLines: IndexedSegmentLines
    
    init(_ segmentProperty: ArcSegmentProperty, startAngle: Double, endAngle: Double, segmentLines: IndexedSegmentLines, color: WedgeFillStyle) {
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.fill = color
        self.segmentProperty = segmentProperty
        self.segmentLines = segmentLines
    }
    
    var body: some View {
        ForEach(Array(segmentLines.keys), id: \.self) { index in
            Arc(
                radius: segmentLines[index]!,
                startAngle: startAngle,
                endAngle: endAngle,
                thickness: segmentProperty.lineProperties.lineThickness
            )
            .fill(fill, start: startAngle, end: endAngle)
        }
    }
    
}
extension Shape {
    @ViewBuilder func fill(_ style: WedgeFillStyle, start: Double = 0, end: Double = 0) -> some View {
        switch style {
        case .color(let color):
            self.fill(color)
        case .gradient(let gradient):
            self.fill(AngularGradient(gradient: gradient, center: .center, startAngle: .radians(start), endAngle: .radians(end)))
        }
    }
}

