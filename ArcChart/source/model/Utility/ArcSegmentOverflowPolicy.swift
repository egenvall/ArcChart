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
