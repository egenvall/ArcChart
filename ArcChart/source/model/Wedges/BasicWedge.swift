import SwiftUI
protocol BasicWedge: Equatable {
    var fill: WedgeFillStyle { get }
    var start: Double { get set }
    var end: Double { get set}
}
