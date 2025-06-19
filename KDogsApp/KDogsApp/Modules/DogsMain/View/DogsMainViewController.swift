//
//  DogsMainViewController.swift
//  KonfioAppChallenge
//
//  Created by Pablo Ramirez on 18/06/25.
//

import UIKit

final class DogsMainViewController: UIViewController {
    
    @IBOutlet private weak var dogsCollectionView: UICollectionView!
    
    private let input: DogsMainViewInput
    private let output: DogsMainViewOutput

    init(input: DogsMainViewInput, output: DogsMainViewOutput) {
        self.input = input
        self.output = output
        
        super.init(
            nibName: String(describing: DogsMainViewController.self),
            bundle: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        input.didLoad()
    }
}

private extension DogsMainViewController {
    func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.tintColor = UIColor.customBlack
        backButton.sizeToFit()

        let backBarItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarItem
        
        if let arialFont = UIFont(name: "Arial-BoldMT", size: 20) {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: arialFont,
                .foregroundColor: UIColor.customBlack
            ]
            
            navigationController?.navigationBar.titleTextAttributes = attributes
        }
        
        title = input.navTitle
    }
}
