//
//  LayoutConstants.swift
//  Inuit
//
//  Created by Roman Kavinskyi on 8/25/22.
//

import UIKit

struct LayoutConstants {
    var sideEdgesPortraitArray: [CGFloat]               = [3, 4]
    var sideEdgesPortraitWidthThreshholds: [CGFloat]    = [400]
    var sideEdgesLandscape: CGFloat                     = 3
    
    
    var keyboardShrunkSizeArray: [CGFloat]              = [522, 524]
    var keyboardShrunkSizeWidthThreshholds: [CGFloat]   = [700]
    var keyboardShrunkSizeBaseWidthThreshhold: CGFloat  = 600
    
 
    func sideEdgesPortrait(_ width: CGFloat) -> CGFloat {
        findThreshhold(sideEdgesPortraitArray, threshholds: sideEdgesPortraitWidthThreshholds, measurement: width)
    }
   
    func keyboardShrunkSize(_ width: CGFloat) -> CGFloat {
        let isPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
        if isPad { return width }
        
        if width >= self.keyboardShrunkSizeBaseWidthThreshhold {
            return findThreshhold(keyboardShrunkSizeArray, threshholds: keyboardShrunkSizeWidthThreshholds, measurement: width)
        }
        else {
            return width
        }
    }
    
    func findThreshhold(_ elements: [CGFloat], threshholds: [CGFloat], measurement: CGFloat) -> CGFloat {
        assert(elements.count == threshholds.count + 1, "elements and threshholds do not match")
        return elements[findThreshholdIndex(threshholds, measurement: measurement)]
    }
    func findThreshholdIndex(_ threshholds: [CGFloat], measurement: CGFloat) -> Int {
        for (i, threshhold) in Array(threshholds.reversed()).enumerated() {
            if measurement >= threshhold {
                let actualIndex = threshholds.count - i
                return actualIndex
            }
        }
        return 0
    }
}
