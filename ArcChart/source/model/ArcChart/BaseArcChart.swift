import SwiftUI
import Combine
class BaseArcChart<T : BasicWedge>: ObservableObject {
    var _wedgesNeedsUpdate = false
    var _wedges = [Int : T]()
    var wedges =  [Int : T]()
    
    private(set) var wedgeIds = [Int]() {
        willSet {
            objectWillChange.send()
        }
    }
    init(_ wedges: [Int : T]) {
        setWedges(wedges)
        setWedgeIds(Array(wedges.keys).sorted(by: { $0 < $1}))
    }
    func setWedgeIds(_ ids: [Int]) {
        self.wedgeIds = ids
    }
    func setWedges(_ wedges: [Int : T]) {
        self._wedges = wedges
        self.wedges = wedges
    }
    func addWedge(_ wedge: T) {
        let id = wedgeIds.count
        wedges[id] = wedge
        wedgeIds.append(id)
    }
}
