//
//  LoadingView.swift
//  KonfioAppChallenge
//
//  Created by Pablo Ramírez on 18/06/25.
//

import UIKit

final class LoadingView: UIView {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
        setup()
    }
    
    private func setup() {
        guard let view = Bundle.main.loadNibNamed(String(describing: LoadingView.self), owner: self, options: nil)?[0] as? UIView else { return }
        
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        activityIndicator.startAnimating()
    }
}
