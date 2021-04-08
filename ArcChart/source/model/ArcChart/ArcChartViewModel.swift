import Combine
class ArcChartViewModel: ObservableObject {
    @Published var options: ArcChartOptions
    init(_ options: ArcChartOptions = ArcChartOptions()) {
        self.options = options
    }
}
