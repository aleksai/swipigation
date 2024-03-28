//
//  MenuItem.swift
//  Swipigation
//
//  Created by Alek Sai on 3/28/24.
//

import UIKit

struct MenuItem: Equatable, Identifiable {
    
    let id: String
    let title: String
    let color: UIColor
    
    public func getViewController() -> UIViewController {
        ContentViewController(item: self)
    }
    
    public func getTitleWidth() -> CGFloat {
        let proxyLabel = UILabel()
        proxyLabel.font = .systemFont(ofSize: kSwipeNavigationMenuItemFontSize)
        proxyLabel.text = title
        
        return proxyLabel.sizeThatFits(CGSize(width: CGFLOAT_MAX, height: kSwipeNavigationMenuItemHeight)).width
    }
    
}
