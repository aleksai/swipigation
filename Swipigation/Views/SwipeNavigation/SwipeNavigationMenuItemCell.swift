//
//  SwipeNavigationMenuItemCell.swift
//  Swipigation
//
//  Created by Alek Sai on 3/28/24.
//

import UIKit

class SwipeNavigationMenuItemCell: UICollectionViewCell {
    
    private var dot: UIView?
    private var label: UILabel?
    
    public func layout() {
        if dot != nil { return }
        
        let wrapperView = UIView()
        
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(wrapperView)
        
        dot = UIView()
        
        dot?.translatesAutoresizingMaskIntoConstraints = false
        dot?.layer.cornerRadius = kSwipeNavigationMenuItemDotSize / 2
        
        
        label = UILabel()
        
        label?.translatesAutoresizingMaskIntoConstraints = false
        label?.font = .systemFont(ofSize: kSwipeNavigationMenuItemFontSize)
        label?.textColor = .black
        
        guard let dot, let label else { return }
        
        wrapperView.addSubview(dot)
        wrapperView.addSubview(label)
        
        NSLayoutConstraint.activate([
            wrapperView.leadingAnchor.constraint(equalTo: leadingAnchor),
            wrapperView.trailingAnchor.constraint(equalTo: trailingAnchor),
            wrapperView.topAnchor.constraint(equalTo: topAnchor),
            wrapperView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            dot.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: kSwipeNavigationMenuItemHorizontalPadding),
            dot.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor),
            dot.widthAnchor.constraint(equalToConstant: kSwipeNavigationMenuItemDotSize),
            dot.heightAnchor.constraint(equalToConstant: kSwipeNavigationMenuItemDotSize),
            
            label.leadingAnchor.constraint(equalTo: dot.trailingAnchor, constant: kSwipeNavigationMenuItemSpacing),
            label.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -kSwipeNavigationMenuItemHorizontalPadding),
            label.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: kSwipeNavigationMenuItemVerticalPadding),
            label.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -kSwipeNavigationMenuItemVerticalPadding)
        ])
    }
    
    public func setItem(_ item: MenuItem) {
        dot?.backgroundColor = item.color
        label?.text = item.title
    }
    
}
