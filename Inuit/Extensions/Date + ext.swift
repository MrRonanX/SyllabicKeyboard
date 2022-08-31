//
//  Date + ext.swift
//  Inuit
//
//  Created by Roman Kavinskyi on 8/30/22.
//

import Foundation

extension Date {
    
    var isDoubleTap: Bool {
        let then = self.timeIntervalSince1970
        let now = Date().timeIntervalSince1970
        print(now - then )
        return now - then <= 0.2
    }
}
