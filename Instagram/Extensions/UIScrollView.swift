//
//  UIScrollView.swift
//  github
//
//  Created by Chung Tran on 27/03/2019.
//  Copyright © 2019 Chung Tran. All rights reserved.
//

import UIKit

extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}
