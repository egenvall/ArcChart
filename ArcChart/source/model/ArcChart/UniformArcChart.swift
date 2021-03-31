import SwiftUI
import Combine

class UniformArcChart<T: BasicWedge>: BaseArcChart<T> {    
    override func setWedgeIds(_ ids: [Int]) {
        super.setWedgeIds(ids)
        self.objectWillChange.send()
    }
    override func setWedges(_ wedges: [Int : T]) {
        super.setWedges(wedges)
    }
    override var wedges: [Int : T] {
        get {
            if _wedgesNeedsUpdate {
                let wedgeWidth: Double = (.pi * 2) / Double(_wedges.count)
                var location = 0.0
                for id in wedgeIds {
                    var wedge = _wedges[id]!
                    wedge.start = location - (.pi / 2)
                    location += wedgeWidth
                    wedge.end = location - (.pi / 2)
                    _wedges[id] = wedge
                }
                
                _wedgesNeedsUpdate = false
            }
            return _wedges
        }
        set {
            self.objectWillChange.send()
            _wedges = newValue
            _wedgesNeedsUpdate = true
        }
    }
    func addWedge() {
        let wedge = UniformWedge(fill: .color(Color.random()))
        guard let genericWedge = wedge as? T else {
            return
        }
        super.addWedge(genericWedge)
    }
}

extension Color {
    static func random() -> Color {
        let r: Double = .random(in: 0...255)
        let g: Double = .random(in: 0...255)
        let b: Double = .random(in: 0...255)
        return Color(red: r / 255, green: g / 256, blue: b / 255, opacity: 1.0)
    }
}
