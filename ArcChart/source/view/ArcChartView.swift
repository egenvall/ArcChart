import SwiftUI

struct ArcChartView<T: ArcChart>: View {
    @ObservedObject var chart: T
    @ObservedObject var viewModel: ArcChartViewModel
    private var helper: ArcSizeHelper
   
    init(_ chart: T, viewModel: ArcChartViewModel) {
        self.chart = chart
        self.viewModel = viewModel
        self.helper = ArcSizeHelper(viewModel.options)
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                let availableWidth = min(geometry.size.height, geometry.size.width)
                let arcProperties = helper.buildArcProperties(availableWidth)
                let wedges = chart.getWedges()
                
                ZStack {
                    // Draw the arcs
                    ForEach(chart.getWedgeIds(), id: \.self) { wedgeId in
                        if let wedge = wedges[wedgeId] {
                            ArcSegment(ArcSegmentProperty(lineProperties: arcProperties.lineProperties, segmentLineCount: viewModel.options.segmentLineCount), startAngle: wedge.start, endAngle: wedge.end, segmentLines: arcProperties.segmentLines, color: wedge.fill)
                        }
                    }
                    // Draw the illusion of segment spacers
                    ForEach(chart.getWedgeIds(), id: \.self) { wedgeId in
                        if let wedge = wedges[wedgeId] {
                            ArcSegmentSpacer(angle: wedge.start, radius: (availableWidth / 2) + 4)
                                .stroke(Color.white, style: StrokeStyle(lineWidth: arcProperties.lineProperties.lineSpacing))
                        }
                    }
                }
            }.drawingGroup().animation(.spring())
        }
    }
}








