//
//  SwipeNavigationMenuController.swift
//  Swipigation
//
//  Created by Alek Sai on 3/28/24.
//

import UIKit

// MARK: Protocol

protocol SwipeNavigationMenuControllerDelegate {
    func selectItemIndex(_ index: Int)
}

// MARK: SwipeNavigationMenuController

class SwipeNavigationMenuController: UICollectionViewController {
    
    private(set) var menuItems: [MenuItem]
    private(set) var currentItemIndex: Int
    
    public var delegate: SwipeNavigationMenuControllerDelegate?
    
    private var activeIndicator: UIView?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Init
    
    init(menuItems: [MenuItem], initialItemIndex: Int) {
        self.menuItems = menuItems
        self.currentItemIndex = initialItemIndex
        
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset.left = kSwipeNavigationMenuHorizontalPadding
        layout.sectionInset.right = kSwipeNavigationMenuHorizontalPadding
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        
        super.init(collectionViewLayout: layout)
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setActiveIndicatorConstraints()
    }
    
}

// MARK: Public API

extension SwipeNavigationMenuController {
    
    public func setCurrentItemIndex(_ index: Int) {
        currentItemIndex = index
    }
    
    public func selectItemIndex(_ index: Int) {
        setCurrentItemIndex(index)
        
        let calculatedOffset = CGFloat(currentItemIndex) / CGFloat(menuItems.count - 1)
        setMenuOffset(withFullNormalizedOffset: calculatedOffset, withAnimation: true)
        
        setActiveIndicatorConstraints(withAnimation: true)
    }
    
    public func setMenuOffset(withFullNormalizedOffset fullNormalizedOffset: CGFloat, withAnimation: Bool = false) {
        guard collectionView.contentSize.width > view.frame.width else { return }
        
        let menuOffset = (collectionView.contentSize.width - view.frame.width) * fullNormalizedOffset
        
        collectionView.setContentOffset(CGPoint(x: menuOffset, y: 0), animated: withAnimation)
    }
    
    public func setActiveIndicatorConstraints(withNormalizedOffset normalizedOffset: CGFloat? = nil, withAnimation: Bool = false) {
        if withAnimation && normalizedOffset == nil {
            UIView.animate(withDuration: 0.1, animations: {
                self.setIndicatorWidth()
                self.setIndicatorLeading()
            })
        } else {
            setIndicatorWidth(normalizedOffset: normalizedOffset)
            setIndicatorLeading(normalizedOffset: normalizedOffset)
        }
    }
    
}

// MARK: Private API

extension SwipeNavigationMenuController {
    
    private func setup() {
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(SwipeNavigationMenuItemCell.self, forCellWithReuseIdentifier: "item")
        
        activeIndicator = UIView(frame: CGRect(x: 0, y: kSwipeNavigationMenuVerticalPadding - 1, width: 100, height: kSwipeNavigationMenuItemHeight))
        
        activeIndicator?.translatesAutoresizingMaskIntoConstraints = false
        activeIndicator?.backgroundColor = .gray.withAlphaComponent(0.1)
        activeIndicator?.layer.cornerRadius = kSwipeNavigationMenuItemCornerRadius
        
        guard let activeIndicator else { return }
        
        view.addSubview(activeIndicator)
        view.sendSubviewToBack(activeIndicator)
    }
    
    private func setIndicatorWidth(normalizedOffset: CGFloat? = nil) {
        var offset: CGFloat = 0
        
        if let normalizedOffset {
            let index = normalizedOffset > 0 ? (currentItemIndex + 1) : (currentItemIndex - 1)
            
            if index >= 0 && index < menuItems.count {
                let currentWidth = menuItems[currentItemIndex].getTitleWidth() + kSwipeNavigationMenuItemWidthExceptTitle
                let morphWidth = menuItems[index].getTitleWidth() + kSwipeNavigationMenuItemWidthExceptTitle
                
                offset = (morphWidth - currentWidth) * abs(normalizedOffset)
            }
        }
        
        activeIndicator?.frame.size.width = menuItems[currentItemIndex].getTitleWidth() + kSwipeNavigationMenuItemWidthExceptTitle + offset
    }
    
    private func setIndicatorLeading(normalizedOffset: CGFloat? = nil) {
        guard let activeCell = collectionView.cellForItem(at: IndexPath(item: currentItemIndex, section: 0)) else { return }
        
        var leadingOffset = activeCell.frame.origin.x
        
        if let normalizedOffset {
            let index = normalizedOffset > 0 ? (currentItemIndex + 1) : (currentItemIndex - 1)
            
            if index >= 0 && index < menuItems.count {
                if let morphCell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) {
                    let morphOffset = (morphCell.frame.origin.x - activeCell.frame.origin.x) * normalizedOffset
                    
                    if normalizedOffset > 0 {
                        leadingOffset += morphOffset
                    } else {
                        leadingOffset -= morphOffset
                    }
                }
            }
        }
        
        activeIndicator?.frame.origin.x = leadingOffset - collectionView.contentOffset.x
    }
    
}

// MARK: UICollectionView protocol

extension SwipeNavigationMenuController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        menuItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as? SwipeNavigationMenuItemCell
        
        cell?.layout()
        cell?.setItem(menuItems[indexPath.item])
        
        return cell ?? UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectItemIndex(indexPath.item)
    }
    
}

// MARK: UIScrollView protocol

extension SwipeNavigationMenuController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setIndicatorLeading()
    }
    
}
