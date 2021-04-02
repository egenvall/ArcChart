import SwiftUI
import Combine

class RelationalArcChart<T : BasicWedge & RelationalWedgeConforming>: BaseArcChart<T> {
    override func getWedges() -> [Int : T] {
        var wedges = super.getWedges()
        guard super.wedgesNeedsUpdate() else {
            return wedges
        }
        let total = wedgeIds.reduce(0.0) { $0 + wedges[$1]!.value }
        var location = 0.0
        for id in wedgeIds {
            var wedge = wedges[id]!
            let relativeWidth = wedge.value / total
            wedge.start = location
            location += relativeWidth * (.pi * 2)
            wedge.end = location
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
}

