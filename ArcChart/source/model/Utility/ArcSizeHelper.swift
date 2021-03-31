import SwiftUI
class ArcSizeHelper: ArcPropertyCalculator {
    let segmentLineCount: Int
    let desiredLineThickness: CGFloat
    let desiredLineSpacing: CGFloat
    let fillPolicy: ArcSegmentFillPolicy
    let overflowPolicy: ArcSegmentOverflowPolicy
    let centerSpacing: CGFloat
    
    let padding: CGFloat = 8
    let minimumLineSpacing: CGFloat = 0.5
    let minimumLineThickness: CGFloat = 0.5
    
    init(segmentLineCount: Int, desiredLineThickness: CGFloat, desiredLineSpacing: CGFloat, fillPolicy: ArcSegmentFillPolicy, overflowPolicy: ArcSegmentOverflowPolicy, centerSpacing: CGFloat) {
        self.segmentLineCount = segmentLineCount
        self.desiredLineThickness = desiredLineThickness
        self.desiredLineSpacing = desiredLineSpacing
        self.fillPolicy = fillPolicy
        self.overflowPolicy = overflowPolicy
        self.centerSpacing = centerSpacing
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
        let indexes = Array(0...segmentLineCount - 1)
        return Dictionary(uniqueKeysWithValues: indexes.map { index in (index, getRadius(index, spacing: lineSpacing, thickness: lineThickness, availableWidth: availableWidth)) })
    }
    
   private func calculateDiameterForConfiguration(_ index: Int, availableWidth: CGFloat, withLineSpacing spacing: CGFloat, withLineThickness thickness: CGFloat) -> CGFloat {
        let centerX = availableWidth / 2
        let indexedLineSpace = (thickness + spacing) * CGFloat(index)
        let startX = centerX - ((indexedLineSpace + (thickness / 2)) + (centerSpacing / 2))
        let endX = centerX + ((indexedLineSpace + (thickness / 2)) + (centerSpacing / 2))
        let diameter = endX - startX
        return diameter
    }
    
    /**
     Calculates the final lineSpacing & lineSpacing that allows the whole Arc to fit within the CGRect
     based on the supplied `overflowPolicy` and `fillPolicy`
     */
    private func calculateFinalLineProperties(_ availableWidth: CGFloat) -> FinalLineProperties {
        let target = (availableWidth  - (desiredLineThickness) / 2)
        let initialResult = calculateDiameterForConfiguration(segmentLineCount - 1, availableWidth: availableWidth, withLineSpacing: desiredLineSpacing, withLineThickness: desiredLineThickness)
        
        guard initialResult >= target else {
            if fillPolicy == .none {
                return FinalLineProperties(lineSpacing: desiredLineSpacing, lineThickness: desiredLineThickness)
            }
            else {
                return linePropertiesWhenExpandedLineThickness(initialResult, availableWidth: availableWidth)
                
            }
        }
        switch overflowPolicy {
        case .equalize:
            return linePropertiesWhenEqualized(initialResult, availableWidth: availableWidth)
        case .shrinkLineSpacing:
            return linePropertiesWhenShrunkLineSpacing(withLineThickness: desiredLineThickness, availableWidth: availableWidth)
        case .shrinkLineThickness:
            return linePropertiesWhenShrunkLineThickness(withLineSpacing: desiredLineSpacing, availableWidth: availableWidth)
        }
    }
    private func linePropertiesWhenEqualized(_ initialResult: CGFloat, availableWidth: CGFloat) -> FinalLineProperties {
        /*
         2 * (segmentLineCount + segmentLineCount - 1) * equalizedLineSize = availableWidth - centerSpacing
         equalizedLineSize = (availableWidth - centerSpacing) / 2 * (segmentLineCount + segmentLineCount - 1)
         **/
        let totalLines: CGFloat = CGFloat(segmentLineCount) + CGFloat(segmentLineCount - 1)
        let equalizedLineSize = (availableWidth - centerSpacing - padding) / (2 * totalLines)
        return FinalLineProperties(lineSpacing: equalizedLineSize, lineThickness: equalizedLineSize)

    }
    private func linePropertiesWhenShrunkLineSpacing(withLineThickness thickness: CGFloat, availableWidth: CGFloat) -> FinalLineProperties {
        /**
         (2 * segmentLineCount * `desiredLineThickness`) + ( 2 * segmentLineCount - 1 * `lineSpacing`) = availableWidth - centerSpacing
         lineSpacing = (availableWidth - centerSpacing - (2 * segmentLineCount * desiredLineThickness)) / (2 * segmentLineCount - 1)
         */
        
        let lineSpacing = (availableWidth - centerSpacing - (thickness / 2) - CGFloat(CGFloat(2 * segmentLineCount) * thickness)) / CGFloat(2 * (segmentLineCount - 1))
        guard lineSpacing >= minimumLineSpacing else {
            // Fall out if we came here with a minimum lineSpacing, nothing more we can do.
            guard thickness != minimumLineThickness else {
                return FinalLineProperties(lineSpacing: minimumLineSpacing, lineThickness: thickness)
            }
            let result = linePropertiesWhenShrunkLineThickness(withLineSpacing: minimumLineSpacing, availableWidth: availableWidth)
            return FinalLineProperties(lineSpacing: minimumLineSpacing, lineThickness: result.lineThickness)
        }
        return FinalLineProperties(lineSpacing: lineSpacing, lineThickness: desiredLineThickness)
    }
    private func linePropertiesWhenShrunkLineThickness(withLineSpacing spacing: CGFloat, availableWidth: CGFloat) -> FinalLineProperties {
        /**
         (2 * segmentLineCount * lineThickness) + ( 2 * segmentLineCount - 1 * desiredLineSpacing) = availableWidth - centerSpacing
         lineThickness = (availableWidth - centerSpacing - padding -  (2 * segmentLineCount - 1) * spacing ) / ( 2 * segmentLineCount )
         */
        let lineThickness = (availableWidth - centerSpacing - padding - (CGFloat(2 * (segmentLineCount - 1)) * spacing)) / CGFloat(2 * segmentLineCount)
        guard lineThickness >= minimumLineThickness else {
            // Fall out if we came here with a minimum lineSpacing, nothing more we can do.
            guard spacing != minimumLineSpacing else {
                return FinalLineProperties(lineSpacing: spacing, lineThickness: minimumLineThickness)
            }
            let result = linePropertiesWhenShrunkLineSpacing(withLineThickness: minimumLineThickness, availableWidth: availableWidth)
            return FinalLineProperties(lineSpacing: result.lineSpacing, lineThickness: minimumLineThickness)
        }
        return FinalLineProperties(lineSpacing: desiredLineSpacing, lineThickness: lineThickness)
    }
    
    private func linePropertiesWhenExpandedLineThickness(_ initialResult: CGFloat, availableWidth: CGFloat) -> FinalLineProperties {
        let availableDrawingSpace = (availableWidth - initialResult - centerSpacing / 2)
        let finalAdditionalThickness = CGFloat(availableDrawingSpace / CGFloat(2 * segmentLineCount))
        return FinalLineProperties(lineSpacing: desiredLineSpacing, lineThickness: desiredLineThickness + finalAdditionalThickness)
    }
}
