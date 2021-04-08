import SwiftUI
struct ArcChartOptions {
    let desiredLineThickness: CGFloat
    let desiredLineSpacing: CGFloat
    let centerSpacing: CGFloat
    let overflowPolicy: ArcSegmentOverflowPolicy
    let fillPolicy: ArcSegmentFillPolicy
    let segmentLineCount: Int
    
    init(desiredLineThickness: CGFloat = 16, desiredLineSpacing: CGFloat = 8, centerSpacing: CGFloat = 32, overflowPolicy: ArcSegmentOverflowPolicy = .equalize, fillPolicy: ArcSegmentFillPolicy = .expandLineThickness, segmentLineCount: Int = 10) {
        self.desiredLineThickness = desiredLineThickness
        self.desiredLineSpacing = desiredLineSpacing
        self.centerSpacing = centerSpacing
        self.overflowPolicy = overflowPolicy
        self.fillPolicy = fillPolicy
        self.segmentLineCount = segmentLineCount
    }
}
