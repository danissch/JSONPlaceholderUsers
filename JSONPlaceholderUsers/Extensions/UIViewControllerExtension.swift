//
//  UIViewControllerExtension.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 26/06/21.
//

import Foundation
import UIKit

extension UIViewController {

    internal class func instantiateFromXIB<T:UIViewController>() -> T{
        let xibName = T.stringRepresentation
        let vc = T(nibName: xibName, bundle: nil)
        return vc
    }
    
    func pushVc(_ uiViewController: UIViewController, animated:Bool = true, navigationBarIsHidden:Bool, presentStyle:UIModalPresentationStyle = .fullScreen, transitionStyle:UIModalTransitionStyle = .coverVertical){
        uiViewController.modalPresentationStyle = presentStyle
        self.navigationController?.modalPresentationStyle = presentStyle
        self.navigationController?.modalTransitionStyle = transitionStyle
        if navigationBarIsHidden{
            self.navigationController?.navigationBar.isHidden = true
        }
        self.navigationController?.pushViewController(uiViewController, animated: animated)
    }
    
    func presentWithStyle1(vcFrom:UIViewController, vcTo:UIViewController, animated:Bool = true, presentStyle:UIModalPresentationStyle = .fullScreen, transitionStyle:UIModalTransitionStyle = .coverVertical){
        vcTo.modalPresentationStyle = presentStyle
        vcTo.modalTransitionStyle = transitionStyle
        vcFrom.present(vcTo, animated: true, completion: nil)
    }
    
    @objc internal func backButton(image:String = "arrow_left"){
        let button = UIButton(type: .system)
        let image = UIImage(named: image)
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .systemBackground
        button.addTarget(self, action: #selector(navigateBack), for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.tintColor = .white
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        navigationItem.leftBarButtonItem = menuBarItem
    }
    
    @objc internal func navigateBack(){
        if isModal {
            dismiss(animated: true, completion: nil)
        }else{
            _ = navigationController?.popViewController(animated: true)
        }
    }
        
    var isModal:Bool {
        if presentingViewController != nil {
            return true
        }
        if presentingViewController?.presentedViewController == self {
            return true
        }
        if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        }
        if tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
