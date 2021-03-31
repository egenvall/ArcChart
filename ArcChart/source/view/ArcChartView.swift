import SwiftUI

struct ArcChartView<T: BasicWedge>: View {
    @ObservedObject var chart: BaseArcChart<T>
    private var helper: ArcSizeHelper
    // Clear circle in center of ArcChart
    let centerSpacing: CGFloat
    
    /**
     The desired thickness of each invididual line in a segment
     This is NOT promised to be maintained depending on `overflowPolicy` and `fillPolicy`
     */
    let desiredLineThickness: CGFloat
    
    /**
     The desired clear space between individual lines in a segment
     This is NOT promised to be maintained depending on `overflowPolicy` and `fillPolicy`
     */
    let desiredLineSpacing: CGFloat
    
    /**
     Policy on how to manage conflicts when the `desiredLineThickness` and the `desiredLineSpacing` will not
     fit within the target CGRect
     */
    let overflowPolicy: ArcSegmentOverflowPolicy
    /**
     Policy on how to manage the segments when `desiredLineThickness` and `desiredLineSpacing` will result
     in an Arc Chart that is smaller than the target CGRect
     */
    let fillPolicy: ArcSegmentFillPolicy
    
    // The number of individual lines inside a segment
    let segmentLineCount: Int
    
    init(_ chart: BaseArcChart<T>, desiredLineThickness: CGFloat, desiredLineSpacing: CGFloat, centerSpacing: CGFloat = 32, overflowPolicy: ArcSegmentOverflowPolicy = .equalize, fillPolicy: ArcSegmentFillPolicy, segmentLineCount: Int = 10) {
        self.chart = chart
        self.desiredLineThickness = desiredLineThickness
        self.desiredLineSpacing = desiredLineSpacing
        self.overflowPolicy = overflowPolicy
        self.fillPolicy = fillPolicy
        self.segmentLineCount = segmentLineCount
        self.helper = ArcSizeHelper(segmentLineCount: segmentLineCount, desiredLineThickness: desiredLineThickness, desiredLineSpacing: desiredLineSpacing, fillPolicy: fillPolicy, overflowPolicy: overflowPolicy, centerSpacing: centerSpacing)
        self.centerSpacing = centerSpacing
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                let availableWidth = min(geometry.size.height, geometry.size.width)
                let arcProperties = helper.buildArcProperties(availableWidth)
                
                ZStack {
                    // Draw the arcs
                    ForEach(chart.wedgeIds, id: \.self) { wedgeId in
                        if let wedge = chart.wedges[wedgeId] {
                            ArcSegment(ArcSegmentProperty(lineProperties: arcProperties.lineProperties, segmentLineCount: segmentLineCount), startAngle: wedge.start, endAngle: wedge.end, segmentLines: arcProperties.segmentLines, color: wedge.fill)
                        }
                    }
                    // Draw the illusion of segment spacers
                    ForEach(chart.wedgeIds, id: \.self) { wedgeId in
                        if let wedge = chart.wedges[wedgeId] {
                            ArcSegmentSpacer(angle: wedge.start, radius: (availableWidth / 2) + 4)
                                .stroke(Color.white, style: StrokeStyle(lineWidth: arcProperties.lineProperties.lineSpacing))
                        }
                    }
                }
            }.drawingGroup().animation(.spring())
        }
    }
}








