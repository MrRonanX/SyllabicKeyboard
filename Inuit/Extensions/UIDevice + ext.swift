//
//  UIDevice + ext.swift
//  Inuit
//
//  Created by Roman Kavinskyi on 12/25/22.
//

import UIKit

extension UIDevice {
    static var isLandscape: Bool {
        let size: CGSize = UIScreen.main.bounds.size
        return size.width / size.height > 1
    }
}
