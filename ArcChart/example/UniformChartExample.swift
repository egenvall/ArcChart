import SwiftUI
struct UniformChartExample: View {
    @State var segmentLineCount: Int = 10
    @State var overflowPolicy: ArcSegmentOverflowPolicy = .equalize
    @State var chart = UniformArcChart([
        0: UniformWedge(fill: .color(.red)),
        1: UniformWedge(fill: .color(.blue)),
        2: UniformWedge(fill: .color(.green)),
        3: UniformWedge(fill: .color(.yellow)),
        4: UniformWedge(fill: .color(.orange)),
        5: UniformWedge(fill: .color(.purple)),
        6: UniformWedge(fill: .color(.pink)),
        7: UniformWedge(fill: .color(.black))
    ])
    var body: some View {
        VStack {
            VStack {
                Text("Overflow Policy")
                Picker(selection: $overflowPolicy, label: Text("Paging Sensitivity")) {
                    Text("Equalize").tag(ArcSegmentOverflowPolicy.equalize)
                    Text("Shrink Spacing").tag(ArcSegmentOverflowPolicy.shrinkLineSpacing)
                    Text("Shrink Thickness").tag(ArcSegmentOverflowPolicy.shrinkLineThickness)
                }
                .pickerStyle(SegmentedPickerStyle()).padding([.horizontal])
                HStack {
                    Stepper("Segment LineCount", value: $segmentLineCount, in: 1...100)
                    Text("\(segmentLineCount)")
                }.padding([.horizontal])
            }
            
            
            ArcChartView(chart, desiredLineThickness: 16, desiredLineSpacing: 16, overflowPolicy: overflowPolicy, fillPolicy: .expandLineThickness, segmentLineCount: segmentLineCount).transition(.scaleAndFade)
            
            Button("Add Wedge") {
                chart.addWedge()
            }
        }
    }
    
}
