import SwiftUI
struct UniformChartExample: View {
    @ObservedObject var viewModel: ArcChartViewModel
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
            ArcChartView(chart, viewModel: viewModel).transition(.scaleAndFade)
            Button("Add Wedge") {
                chart.addWedge()
            }
        }
    }
    
}
