import SwiftUI
import Combine

class UniformArcChart<T: BasicWedge>: BaseArcChart<T>{
    override func getWedges() -> [Int : T] {
        var wedges = super.getWedges()
        guard super.wedgesNeedsUpdate() else {
            return wedges
        }
        let wedgeWidth: Double = (.pi * 2) / Double(wedges.count)
        var location = 0.0
        for id in wedgeIds {
            var wedge = wedges[id]!
            wedge.start = location - (.pi / 2)
            location += wedgeWidth
            wedge.end = location - (.pi / 2)
            wedges[id] = wedge
        }
        super.setWedges(wedges)
        super.setNeedsUpdate(to: false)
        return wedges
    }
    
    override func notifyChange() {
        self.objectWillChange.send()
    }
    override func setWedges(_ wedges: [Int : T]) {
        notifyChange()
        super.setWedges(wedges)
        super.setNeedsUpdate(to: true)
    }
  
    func addWedge() {
        let wedge = UniformWedge(fill: .color(Color.random()))
        guard let genericWedge = wedge as? T else {
            return
        }
        super.setNeedsUpdate(to: true)
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
