import SwiftUI
class NumbersOnly: ObservableObject {
    @Published var value = "" {
        didSet {
            let filtered = value.filter { $0.isNumber }
            
            if value != filtered {
                value = filtered
            }
        }
    }
}
struct RelationalChartExample: View {
    @ObservedObject var viewModel: ArcChartViewModel
    @ObservedObject var rent = NumbersOnly()
    @ObservedObject var savings = NumbersOnly()
    @ObservedObject var groceries = NumbersOnly()
    @ObservedObject var utilities = NumbersOnly()
    var body: some View {
        VStack() {
            VStack {
                HStack {
                    Circle().foregroundColor(.red).frame(width: 20, height: 20)
                    TextField("Rent", text: $rent.value)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack {
                    Circle().foregroundColor(.purple).frame(width: 20, height: 20)
                    TextField("Savings", text: $savings.value)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                }
                HStack {
                    Circle().foregroundColor(.blue).frame(width: 20, height: 20)
                    TextField("Groceries", text: $groceries.value)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack {
                    Circle().foregroundColor(.yellow).frame(width: 20, height: 20)
                    TextField("Utilities", text: $utilities.value)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }.padding([.horizontal])
            ArcChartView(relationalChart(), viewModel: viewModel).transition(.scaleAndFade).padding()
        }.navigationTitle("Household")
        
    }
    
    private func relationalChart() -> RelationalArcChart<RelationalWedge> {
        let rentValue = Double(rent.value) ?? 1.0
        let savingsValue = Double(savings.value) ?? 1.0
        let groceriesValue = Double(groceries.value) ?? 1.0
        let utilitiesValue = Double(utilities.value) ?? 1.0
        
            return RelationalArcChart([
                0 : RelationalWedge(fill: .color(.red), value: rentValue),
                1 : RelationalWedge(fill: .color(.purple), value: savingsValue),
                2 : RelationalWedge(fill: .color(.blue), value: groceriesValue),
                3 : RelationalWedge(fill: .color(.yellow), value: utilitiesValue)
            ])
        }
    }
