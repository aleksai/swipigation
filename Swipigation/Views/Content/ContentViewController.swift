//
//  ContentViewController.swift
//  Swipigation
//
//  Created by Alek Sai on 3/28/24.
//

import UIKit

class ContentViewController: UIViewController {
    
    let item: MenuItem
    
    private var wrapperView: UIView?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(item: MenuItem) {
        self.item = item
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
}

extension ContentViewController {
    
    private func setup() {
        wrapperView = UIView()
        
        wrapperView?.translatesAutoresizingMaskIntoConstraints = false
        
        guard let wrapperView else { return }
        
        view.addSubview(wrapperView)
        
        let messageLabel = UILabel()
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .lightGray
        messageLabel.font = .boldSystemFont(ofSize: 32)
        messageLabel.textAlignment = .center
        messageLabel.text = item.title
        messageLabel.numberOfLines = 0
        
        wrapperView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            wrapperView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            wrapperView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            wrapperView.widthAnchor.constraint(equalTo: view.widthAnchor),
            messageLabel.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor),
            messageLabel.widthAnchor.constraint(equalTo: wrapperView.widthAnchor)
        ])
    }
    
}
