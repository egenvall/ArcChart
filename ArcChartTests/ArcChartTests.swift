import XCTest
@testable import ArcChart

class ArcChartTests: XCTestCase {
    func testEqualizedOverflowPolicy() throws {
        let availableWidth: CGFloat = 375
        let helper = ArcSizeHelper(segmentLineCount: 10, desiredLineThickness: 16, desiredLineSpacing: 8, fillPolicy: .expandLineThickness, overflowPolicy: .equalize, centerSpacing: 32)
        let arcProperties = helper.buildArcProperties(availableWidth)
        
        /*
         2 * (segmentLineCount + segmentLineCount - 1) * equalizedLineSize = availableWidth - centerSpacing
         equalizedLineSize = (availableWidth - centerSpacing - padding) / 2 * (segmentLineCount + segmentLineCount - 1)
         
         (375 - 32 - 8) / 38
         **/
        let assertionResult: CGFloat = 335 / 38

        XCTAssertTrue(arcProperties.lineProperties.lineSpacing == assertionResult)
        XCTAssertTrue(arcProperties.lineProperties.lineThickness == assertionResult)
        XCTAssertTrue(arcProperties.lineProperties.lineThickness == arcProperties.lineProperties.lineSpacing)
    }
    func testShrunkLineSpacingOverflowPolicyWithoutReducingLineThickness() throws {
        let availableWidth: CGFloat = 375
        let helper = ArcSizeHelper(segmentLineCount: 10, desiredLineThickness: 16, desiredLineSpacing: 16, fillPolicy: .expandLineThickness, overflowPolicy: .shrinkLineSpacing, centerSpacing: 32)
        let arcProperties = helper.buildArcProperties(availableWidth)
        
        /**
         ArcSizeHelper: minimumLineSpacing = 0.5
         (2 * segmentLineCount * `desiredLineThickness`) + ( 2 * segmentLineCount - 1 * `lineSpacing`) = availableWidth - centerSpacing
         lineSpacing = (availableWidth - centerSpacing - padding - (2 * segmentLineCount * desiredLineThickness)) / (2 * segmentLineCount - 1)
         lineSpacing = (375 - 32 - 8 - (20 * 16)) / 18
         */
        let assertionResult: CGFloat = (375 - 32 - 8 - (20*16)) / 18
        print("\(arcProperties) - \(assertionResult)")
        XCTAssertTrue(arcProperties.lineProperties.lineSpacing == assertionResult)
        XCTAssertTrue(arcProperties.lineProperties.lineThickness == 16)
    }
    func testShrunkLineSpacingOverflowPolicyWithReducingLineThickness() throws {
        let availableWidth: CGFloat = 375
        let helper = ArcSizeHelper(segmentLineCount: 50, desiredLineThickness: 16, desiredLineSpacing: 16, fillPolicy: .expandLineThickness, overflowPolicy: .shrinkLineSpacing, centerSpacing: 32)
        let arcProperties = helper.buildArcProperties(availableWidth)
        
        /**
         ArcSizeHelper: minimumLineSpacing = 0.5
         If the chart won't fit with lineSpacing = minimumLinespacing, start to reduce the lineThickness
         */
        XCTAssertTrue(arcProperties.lineProperties.lineSpacing == helper.minimumLineSpacing)
        XCTAssertTrue(arcProperties.lineProperties.lineThickness < 16)
    }
    func testInevitableOverflow() throws {
        let availableWidth: CGFloat = 375
        let helper = ArcSizeHelper(segmentLineCount: 5000, desiredLineThickness: 16, desiredLineSpacing: 16, fillPolicy: .expandLineThickness, overflowPolicy: .shrinkLineSpacing, centerSpacing: 32)
        let arcProperties = helper.buildArcProperties(availableWidth)

        XCTAssertTrue(arcProperties.lineProperties.lineSpacing == helper.minimumLineSpacing)
        XCTAssertTrue(arcProperties.lineProperties.lineThickness == helper.minimumLineThickness)
    }
    func testShrunkLineThicknessOverflowPolicyWithoutReducingLineSpacing() throws {
        let availableWidth: CGFloat = 375
        let helper = ArcSizeHelper(segmentLineCount: 10, desiredLineThickness: 16, desiredLineSpacing: 16, fillPolicy: .expandLineThickness, overflowPolicy: .shrinkLineThickness, centerSpacing: 32)
        let arcProperties = helper.buildArcProperties(availableWidth)
        
        /**
         (2 * segmentLineCount * lineThickness) + ( 2 * segmentLineCount - 1 * desiredLineSpacing) = availableWidth - centerSpacing
         lineThickness = (availableWidth - centerSpacing - padding -  (2 * segmentLineCount - 1) * spacing ) / ( 2 * segmentLineCount )
         lineThickness = (375 - 32 - 8 - (18 * 16)) / 20
         (2.35 * 20) + 40 + 288
         */
        let assertionResult: CGFloat = (375 - 32 - 8 - (18 * 16)) / 20
        XCTAssertTrue(arcProperties.lineProperties.lineThickness == assertionResult)
        XCTAssertTrue(arcProperties.lineProperties.lineSpacing == 16)
    }
    func testShrunkLineThicknessOverflowPolicyWithReducingLineSpacing() throws {
        let availableWidth: CGFloat = 375
        let helper = ArcSizeHelper(segmentLineCount: 50, desiredLineThickness: 16, desiredLineSpacing: 16, fillPolicy: .expandLineThickness, overflowPolicy: .shrinkLineThickness, centerSpacing: 32)
        let arcProperties = helper.buildArcProperties(availableWidth)
        
        /**
         ArcSizeHelper: minimumLineThickness = 0.5
         If the chart can't fit with that lineThickness, reduce the spacing
         
         */
        XCTAssertTrue(arcProperties.lineProperties.lineThickness == helper.minimumLineThickness)
        XCTAssertTrue(arcProperties.lineProperties.lineSpacing < 16)
    }
}
