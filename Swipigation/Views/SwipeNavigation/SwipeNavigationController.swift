//
//  SwipeNavigationController.swift
//  Swipigation
//
//  Created by Alek Sai on 3/28/24.
//

import UIKit

// MARK: SwipeNavigationController

class SwipeNavigationController: UIPageViewController {
    
    private var menuController: SwipeNavigationMenuController
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Init
    
    init(menuItems: [MenuItem], initialItemIndex: Int = 0) {
        menuController = SwipeNavigationMenuController(menuItems: menuItems, initialItemIndex: initialItemIndex)
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        // Set initial page:
        if initialItemIndex < menuItems.count {
            setViewControllers([menuItems[initialItemIndex].getViewController()], direction: .forward, animated: false)
        }
        
        // We've got to locate supporting UIScrollView inside UIPageViewController to handle scroll event:
        for subview in view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
            }
        }
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

}

// MARK: Private API

extension SwipeNavigationController {
    
    private func setup() {
        dataSource = self
        delegate = self
        
        menuController.delegate = self
        
        menuController.view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(menuController.view)
        
        NSLayoutConstraint.activate([
            menuController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: kSwipeNavigationMenuVerticalPadding),
            menuController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            menuController.view.heightAnchor.constraint(equalToConstant: kSwipeNavigationMenuHeight)
        ])
    }
    
}

// MARK: UIPageViewController protocols

extension SwipeNavigationController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = menuController.currentItemIndex - 1
        
        if index >= 0 && index < menuController.menuItems.count {
            return menuController.menuItems[index].getViewController()
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = menuController.currentItemIndex + 1
        
        if index < menuController.menuItems.count {
            return menuController.menuItems[index].getViewController()
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard
            let viewController = (pageViewController.viewControllers as? [ContentViewController])?.first,
            let index = menuController.menuItems.firstIndex(of: viewController.item)
        else { return }
        
        menuController.setCurrentItemIndex(index)
    }
    
}

// MARK: UIScrollView protocol

extension SwipeNavigationController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let normalizedOffset = (scrollView.contentOffset.x - view.frame.width) / view.frame.width
        let fullNormalizedOffset = (normalizedOffset + CGFloat(menuController.currentItemIndex)) / CGFloat(menuController.menuItems.count - 1)
        
        menuController.setMenuOffset(withFullNormalizedOffset: fullNormalizedOffset)
        menuController.setActiveIndicatorConstraints(withNormalizedOffset: normalizedOffset)
    }
    
}

// MARK: SwipeNavigationMenuController protocol

extension SwipeNavigationController: SwipeNavigationMenuControllerDelegate {
    
    func selectItemIndex(_ index: Int) {
        setViewControllers([menuController.menuItems[index].getViewController()], direction: .forward, animated: false, completion: { [weak self] _ in
            guard let self else { return }
            
            self.menuController.selectItemIndex(index)
        })
    }
    
}
