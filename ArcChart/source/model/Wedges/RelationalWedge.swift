import SwiftUI
protocol RelationalWedgeConforming {
    var value: Double { get }
}
struct RelationalWedge: BasicWedge, RelationalWedgeConforming {
    var fill: WedgeFillStyle
    var start: Double = 0.0
    var end: Double = 0.0
    var value: Double
}
