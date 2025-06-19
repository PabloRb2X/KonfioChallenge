//
//  DogsMainViewController.swift
//  KonfioAppChallenge
//
//  Created by Pablo Ramirez on 18/06/25.
//

import UIKit

final class DogsMainViewController: UIViewController {
    
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

        input.didLoad()
    }
}
