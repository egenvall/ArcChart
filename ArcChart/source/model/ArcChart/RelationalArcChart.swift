import SwiftUI
import Combine

class RelationalArcChart<T : BasicWedge & RelationalWedgeConforming>: BaseArcChart<T> {
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
                let total = wedgeIds.reduce(0.0) { $0 + _wedges[$1]!.value }
                var location = 0.0
                for id in wedgeIds {
                    var wedge = _wedges[id]!
                    let relativeWidth = wedge.value / total
                    wedge.start = location
                    location += relativeWidth * (.pi * 2)
                    wedge.end = location
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
}

