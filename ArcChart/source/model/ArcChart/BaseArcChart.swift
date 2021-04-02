import SwiftUI
import Combine
protocol ArcChart: ObservableObject {
    associatedtype T: BasicWedge
    func getWedges() -> [Int : T]
    func setWedges(_ wedges: [Int : T])
    func getWedgeIds() -> [Int]
}

class BaseArcChart<T : BasicWedge>: ArcChart {
    private var _wedgesNeedsUpdate = false
    private var _wedges = [Int : T]()
    
    private(set) var wedgeIds = [Int]() {
        willSet {
            notifyChange()
        }
    }
    init(_ wedges: [Int : T]) {
        setWedges(wedges)
        setWedgeIds(Array(wedges.keys).sorted(by: { $0 < $1}))
    }
    private func setWedgeIds(_ ids: [Int]) {
        self.wedgeIds = ids
    }
    func wedgesNeedsUpdate() -> Bool {
        return _wedgesNeedsUpdate
    }
    func setNeedsUpdate(to value: Bool) {
        _wedgesNeedsUpdate = value
    }
    func notifyChange() {
        objectWillChange.send()
    }
    
    // MARK: - ArcChart Conformance
    func getWedges() -> [Int : T] {
        return _wedges
    }
    func setWedges(_ wedges: [Int : T]) {
        self._wedges = wedges
    }
    func getWedgeIds() -> [Int] {
        return wedgeIds
    }
    
    // MARK: - Add Wedge
    func addWedge(_ wedge: T) {
        let id = wedgeIds.count
        _wedges[id] = wedge
        wedgeIds.append(id)
    }
}
