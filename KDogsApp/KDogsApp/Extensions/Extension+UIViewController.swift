//
//  Extension+UIViewController.swift
//  KDogsApp
//
//  Created by Pablo Ramirez on 18/06/25.
//

import UIKit

extension UIViewController {
    public func showLoadingView() {
        view.endEditing(true)
        
        let loadingView = LoadingView()
        loadingView.tag = 500
        
        guard let keyWindow = (UIApplication.shared.delegate as? AppDelegate)?.window else { return }
        
        loadingView.frame = CGRect.init(x: keyWindow.bounds.origin.x,
                                        y: keyWindow.bounds.origin.y,
                                        width: keyWindow.bounds.size.width,
                                        height: keyWindow.bounds.size.height)
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                keyWindow.rootViewController?.view.isUserInteractionEnabled = false
                keyWindow.addSubview(loadingView)
            }
        }
    }
    
    public func dismissLoadingView(){
        DispatchQueue.main.async {
            if let keyWindow = (UIApplication.shared.delegate as? AppDelegate)?.window,
               let viewWithTag = keyWindow.viewWithTag(500) {
                
                keyWindow.rootViewController?.view.isUserInteractionEnabled = true
                viewWithTag.removeFromSuperview()
            }
        }
    }
}
