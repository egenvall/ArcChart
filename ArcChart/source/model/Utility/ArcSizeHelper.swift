import SwiftUI
class ArcSizeHelper: ArcPropertyCalculator {
    let options: ArcChartOptions
    /*
    let segmentLineCount: Int
    let desiredLineThickness: CGFloat
    let desiredLineSpacing: CGFloat
    let fillPolicy: ArcSegmentFillPolicy
    let overflowPolicy: ArcSegmentOverflowPolicy
    let centerSpacing: CGFloat
    */
    let padding: CGFloat = 8
    let minimumLineSpacing: CGFloat = 0.5
    let minimumLineThickness: CGFloat = 0.5
    
    init(_ options: ArcChartOptions) {
        self.options = options
    }
    func buildArcProperties(_ availableWidth: CGFloat) -> ArcProperties {
        let lineProperties = calculateFinalLineProperties(availableWidth)
        let segmentLines = buildSegmentLines(lineProperties.lineThickness, lineSpacing: lineProperties.lineSpacing, availableWidth: availableWidth)
        return ArcProperties(lineProperties: lineProperties, segmentLines: segmentLines)
    }
    
    private func getRadius(_ index: Int, spacing: CGFloat, thickness: CGFloat, availableWidth: CGFloat) -> CGFloat {
        return calculateDiameterForConfiguration(index, availableWidth: availableWidth, withLineSpacing: spacing, withLineThickness: thickness) / 2
    }
    private func buildSegmentLines(_ lineThickness: CGFloat, lineSpacing: CGFloat, availableWidth: CGFloat) -> IndexedSegmentLines {
        let indexes = Array(0...options.segmentLineCount - 1)
        return Dictionary(uniqueKeysWithValues: indexes.map { index in (index, getRadius(index, spacing: lineSpacing, thickness: lineThickness, availableWidth: availableWidth)) })
    }
    
   private func calculateDiameterForConfiguration(_ index: Int, availableWidth: CGFloat, withLineSpacing spacing: CGFloat, withLineThickness thickness: CGFloat) -> CGFloat {
        let centerX = availableWidth / 2
        let indexedLineSpace = (thickness + spacing) * CGFloat(index)
        let startX = centerX - ((indexedLineSpace + (thickness / 2)) + (options.centerSpacing / 2))
        let endX = centerX + ((indexedLineSpace + (thickness / 2)) + (options.centerSpacing / 2))
        let diameter = endX - startX
        return diameter
    }
    
    /**
     Calculates the final lineSpacing & lineSpacing that allows the whole Arc to fit within the CGRect
     based on the supplied `overflowPolicy` and `fillPolicy`
     */
    private func calculateFinalLineProperties(_ availableWidth: CGFloat) -> FinalLineProperties {
        let target = (availableWidth  - (options.desiredLineThickness) / 2)
        let initialResult = calculateDiameterForConfiguration(options.segmentLineCount - 1, availableWidth: availableWidth, withLineSpacing: options.desiredLineSpacing, withLineThickness: options.desiredLineThickness)
        
        guard initialResult >= target else {
            if options.fillPolicy == .none {
                return FinalLineProperties(lineSpacing: options.desiredLineSpacing, lineThickness: options.desiredLineThickness)
            }
            else {
                return linePropertiesWhenExpandedLineThickness(initialResult, availableWidth: availableWidth)
                
            }
        }
        switch options.overflowPolicy {
        case .equalize:
            return linePropertiesWhenEqualized(initialResult, availableWidth: availableWidth)
        case .shrinkLineSpacing:
            return linePropertiesWhenShrunkLineSpacing(withLineThickness: options.desiredLineThickness, availableWidth: availableWidth)
        case .shrinkLineThickness:
            return linePropertiesWhenShrunkLineThickness(withLineSpacing: options.desiredLineSpacing, availableWidth: availableWidth)
        }
    }
    private func linePropertiesWhenEqualized(_ initialResult: CGFloat, availableWidth: CGFloat) -> FinalLineProperties {
        /*
         2 * (segmentLineCount + segmentLineCount - 1) * equalizedLineSize = availableWidth - centerSpacing
         equalizedLineSize = (availableWidth - centerSpacing) / 2 * (segmentLineCount + segmentLineCount - 1)
         **/
        let totalLines: CGFloat = CGFloat(options.segmentLineCount) + CGFloat(options.segmentLineCount - 1)
        let equalizedLineSize = (availableWidth - options.centerSpacing - padding) / (2 * totalLines)
        return FinalLineProperties(lineSpacing: equalizedLineSize, lineThickness: equalizedLineSize)

    }
    private func linePropertiesWhenShrunkLineSpacing(withLineThickness thickness: CGFloat, availableWidth: CGFloat) -> FinalLineProperties {
        /**
         (2 * segmentLineCount * `desiredLineThickness`) + ( 2 * segmentLineCount - 1 * `lineSpacing`) = availableWidth - centerSpacing
         lineSpacing = (availableWidth - centerSpacing - (2 * segmentLineCount * desiredLineThickness)) / (2 * segmentLineCount - 1)
         */
        
        let lineSpacing = (availableWidth - options.centerSpacing - (thickness / 2) - CGFloat(CGFloat(2 * options.segmentLineCount) * thickness)) / CGFloat(2 * (options.segmentLineCount - 1))
        guard lineSpacing >= minimumLineSpacing else {
            // Fall out if we came here with a minimum lineSpacing, nothing more we can do.
            guard thickness != minimumLineThickness else {
                return FinalLineProperties(lineSpacing: minimumLineSpacing, lineThickness: thickness)
            }
            let result = linePropertiesWhenShrunkLineThickness(withLineSpacing: minimumLineSpacing, availableWidth: availableWidth)
            return FinalLineProperties(lineSpacing: minimumLineSpacing, lineThickness: result.lineThickness)
        }
        return FinalLineProperties(lineSpacing: lineSpacing, lineThickness: options.desiredLineThickness)
    }
    private func linePropertiesWhenShrunkLineThickness(withLineSpacing spacing: CGFloat, availableWidth: CGFloat) -> FinalLineProperties {
        /**
         (2 * segmentLineCount * lineThickness) + ( 2 * segmentLineCount - 1 * desiredLineSpacing) = availableWidth - centerSpacing
         lineThickness = (availableWidth - centerSpacing - padding -  (2 * segmentLineCount - 1) * spacing ) / ( 2 * segmentLineCount )
         */
        let lineThickness = (availableWidth - options.centerSpacing - padding - (CGFloat(2 * (options.segmentLineCount - 1)) * spacing)) / CGFloat(2 * options.segmentLineCount)
        guard lineThickness >= minimumLineThickness else {
            // Fall out if we came here with a minimum lineSpacing, nothing more we can do.
            guard spacing != minimumLineSpacing else {
                return FinalLineProperties(lineSpacing: spacing, lineThickness: minimumLineThickness)
            }
            let result = linePropertiesWhenShrunkLineSpacing(withLineThickness: minimumLineThickness, availableWidth: availableWidth)
            return FinalLineProperties(lineSpacing: result.lineSpacing, lineThickness: minimumLineThickness)
        }
        return FinalLineProperties(lineSpacing: options.desiredLineSpacing, lineThickness: lineThickness)
    }
    
    private func linePropertiesWhenExpandedLineThickness(_ initialResult: CGFloat, availableWidth: CGFloat) -> FinalLineProperties {
        let availableDrawingSpace = (availableWidth - initialResult - options.centerSpacing / 2)
        let finalAdditionalThickness = CGFloat(availableDrawingSpace / CGFloat(2 * options.segmentLineCount))
        return FinalLineProperties(lineSpacing: options.desiredLineSpacing, lineThickness: options.desiredLineThickness + finalAdditionalThickness)
    }
}
