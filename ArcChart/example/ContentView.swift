//
//  ContentView.swift
//  ArcChart
//
//  Created by Kim Egenvall on 2021-03-26.
//

import SwiftUI
enum Example: String {
    case relational, uniform
}
struct ExampleRow: View {
    var testCase: Example
    var body: some View {
        HStack {
            Text(testCase.rawValue)
        }
    }
}
struct ExampleDetailView: View {
    var example: Example
    var body: some View {
        if example == .relational {
            RelationalChartExample(viewModel: ArcChartViewModel(ArcChartOptions(desiredLineSpacing: 1, segmentLineCount: 1)))
        }
        else {
            UniformChartExample(viewModel: ArcChartViewModel())
        }
    }
}
struct ContentView: View {
    let cases: [Example] = [.uniform, .relational]
    
    var body: some View {
        NavigationView {
            List(cases, id: \.self) { testCase in
                NavigationLink(destination: ExampleDetailView(example: testCase)) {
                    ExampleRow(testCase: testCase)
                }
            }.navigationTitle("Examples")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Rectangle()
    }
}
