# ArcChart
Animated Dynamic Relational & Uniform ArcChart in SwiftUI

**Work in Progress - Feature requests appreciated**.  
 

You can create your own custom chart implementation by subclassing  
```
class BaseArcChart<T : BasicWedge> {
  ...
  init(_ wedges: [Int : T])
  ...
```

Provided examples are  
`RelationalArcChart<T : BasicWedge & RelationalWedgeConforming>: BaseArcChart<T>`  
`UniformArcChart<T: BasicWedge>: BaseArcChart<T>`

**BasicWedge**  
To draw any Wedge, you must at minimum specify a `WedgeFillStyle`  
```
protocol BasicWedge: Equatable {  
    var fill: WedgeFillStyle { get }  
    var start: Double { get set }  
    var end: Double { get set}
}
```

```
enum WedgeFillStyle: Equatable {
    ...
    case color(_ color: Color), gradient(_ gradient: Gradient)
}
```

**RelationalWedge**  
```
protocol RelationalWedgeConforming {
    var value: Double { get }
}
struct RelationalWedge: BasicWedge, RelationalWedgeConforming {
    var fill: WedgeFillStyle
    var start: Double = 0.0
    var end: Double = 0.0
    var value: Double
}
```

**`ArcChartView<T : ArcChart> : View`**  
The view that holds the chart and is responsible for drawing the chart based on the supplied parameters

```
init(_ chart: T, viewModel: ArcChartViewModel)
```

`_ chart: T` - 

```
protocol ArcChart: ObservableObject {
    associatedtype T: BasicWedge
    func getWedges() -> [Int : T]
    func setWedges(_ wedges: [Int : T])
    func getWedgeIds() -> [Int]
}
``` 
 Examples are `UniformArcChart<UniformWedge>` and `RelationalArcChart<RelationalWedge>`  
  
  
```
struct ArcChartOptions {
    let desiredLineThickness: CGFloat
    let desiredLineSpacing: CGFloat
    let centerSpacing: CGFloat
    let overflowPolicy: ArcSegmentOverflowPolicy
    let fillPolicy: ArcSegmentFillPolicy
    let segmentLineCount: Int
}
```  


`desiredLineThickness: CGFloat` - The desired lineThickness (depth) of each line in a segment.  
This value of this property is **not** guaranteed to be used when drawing the chart, depending on [Overflow Policy](https://github.com/egenvall/ArcChart/blob/main/ArcChart/source/model/Utility/ArcSegmentOverflowPolicy.swift) and [Fill Policy](https://github.com/egenvall/ArcChart/blob/main/ArcChart/source/model/Utility/ArcSegmentFillPolicy.swift)  
The chart will automatically resize `desiredLineThickness` and `desiredLineSpacing` based on policies to fit within its bounds. 

`desiredLineSpacing: CGFloat` - The desired lineSpacing (depth) between each line in a segment.  
This value of this property is **not** guaranteed to be used when drawing the chart, depending on [Overflow Policy](https://github.com/egenvall/ArcChart/blob/main/ArcChart/source/model/Utility/ArcSegmentOverflowPolicy.swift) and [Fill Policy](https://github.com/egenvall/ArcChart/blob/main/ArcChart/source/model/Utility/ArcSegmentFillPolicy.swift)  
The chart will automatically resize `desiredLineThickness` and `desiredLineSpacing` based on policies to fit within its bounds.  
The final value of `desiredLineSpacing` is also used as spacing between segments.  

`centerSpacing: CGFloat` - The radius of the clear space in the center of the chart

`overflowPolicy: ArcSegmentOverflowPolicy` - [Overflow Policy](https://github.com/egenvall/ArcChart/blob/main/ArcChart/source/model/Utility/ArcSegmentOverflowPolicy.swift)  
```
/**
 If the chart can't fit within the available rect with the `desiredLineSpacing` and `desiredLineThickness`, one of these policies are applied.
 - `shrinkLineSpacing`: Shrink the `desiredLineSpacing` until the chart fits, or until it reaches the `minimumLineSpacing`.
    If that happens, `desiredLineThickness` is reduced until the chart fits, or `desiredLineSpacing`== `minimumLineSpacing` and `desiredLineThickness` == `minimumLineThickness`
 
 - `shrinkLineThickness`: Shrink the `desiredLineThickness` until the chart fits, or until it reaches the `minimumLineThickness`.
    If that happens, `desiredLineSpacing` is reduced until the chart fits, or `desiredLineSpacing`== `minimumLineSpacing` and `desiredLineThickness` == `minimumLineThickness`
 
 - `equalize` : Equalize so that the actual `lineThickness` and `lineSpacing` are equal. This setting has no minimum limit, but will eventually reach close to 0.
 */
enum ArcSegmentOverflowPolicy {
    case shrinkLineSpacing, shrinkLineThickness, equalize
}
```

`fillPolicy: ArcSegmentFillPolicy` : Should the size of the resulting ArcChart be smaller than the container, `.fill` will expand `desiredLineThickness` to fill the available space properly while `.none` will keep the size as is.

`segmentLineCount: Int` - The number of individual lines within each segment.  
The `RelationalArcChart` example uses `segmentLineCount: 1`  
The `UniformArcChart` example uses `segmentLineCount: 10`  

This value can be anything, the `UniformArcChart` example provides a Stepper up to 100.  
Keep in mind, excessive values may reduce performance.  
Example:  
`segmentLineCount: 100`
`segments: 17`
Shapes to draw: 100 * 17 => 1700  

Even though it's all flattened using `.drawingGroup()`, it's not magic.  


  
**UniformArcChart** [Example](https://github.com/egenvall/ArcChart/blob/main/ArcChart/example/UniformChartExample.swift)  
![uniformgif](https://github.com/egenvall/ArcChart/blob/main/ArcChart/uniform_example.gif)  


**RelationalArcChart** [Example](https://github.com/egenvall/ArcChart/blob/main/ArcChart/example/RelationalChartExample.swift)  
![relationalgif](https://github.com/egenvall/ArcChart/blob/main/ArcChart/relational_example.gif)
