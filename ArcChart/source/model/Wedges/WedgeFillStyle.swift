import SwiftUI
enum WedgeFillStyle: Equatable {
    static func == (lhs: WedgeFillStyle, rhs: WedgeFillStyle) -> Bool {
        switch (lhs, rhs) {
        case (.color(let first), .color(let second)):
            return first == second
        case (.gradient(let first), .gradient(let second)):
            return first == second
        default: return false
        }
    }
    
    case color(_ color: Color), gradient(_ gradient: Gradient)
}
