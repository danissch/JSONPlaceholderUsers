//
//  CustomSearchBar.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 26/06/21.
//

import Foundation
import UIKit

class CustomSearchBar: UISearchBar {
    var searchTField: UITextField?
        
    override init(frame: CGRect = CGRect(x: 0,
                                         y: 0,
                                         width: Int(UIScreen.main.bounds.width),
                                         height: 60)) {
        super.init(frame: frame)
        self.frame = frame
        self.autoresizingMask = [.flexibleWidth]
        self.autoresizesSubviews = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func getSearchBar(delegate:UISearchBarDelegate) -> UISearchBar{
        self.delegate = delegate
        customizeSearchField()
        return self
    }
    
    fileprivate func customizeSearchField(){
        if (self.value(forKey: "searchField") as? UITextField) != nil {
            setSomeTextFieldCustomizations()
        }
        for view in self.subviews.last!.subviews {
            if type(of: view) == NSClassFromString("UISearchBarBackground"){
                view.alpha = 0.0
            }
        }
    }
    
    func setRightImage(_ image: UIImage, searchTextField: UITextField, imageColor: UIColor) {
        showsBookmarkButton = true
        if let btn = searchTextField.rightView as? UIButton {
            btn.setImage(image, for: .normal)
            btn.setImage(image, for: .highlighted)
            btn.tintColor = imageColor
        }
    }
    
    func setSearchCancelButtonConfig(searchTextField: UITextField){
        UISearchBar.appearance().setPositionAdjustment(UIOffset(horizontal: -100, vertical: 0), for: .clear)
    }
    
    func setSomeTextFieldCustomizations(){
        self.backgroundColor = .systemBackground
        searchTField = searchTextField
        searchTField?.placeholder = "Search user"
        searchTField?.leftView = .none
        NSLayoutConstraint.activate([
            searchTextField.widthAnchor.constraint(equalTo: self.widthAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            searchTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            searchTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            searchTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        ])
        searchTextField.backgroundColor = .clear
        searchTextField.textColor = .systemGray
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let borderBottom = CALayer()
            let borderWidth = CGFloat(3.0)
            borderBottom.borderColor = UIColor(red: 0/255, green: 144/255, blue: 81/255, alpha: 1).cgColor
            let x:CGFloat = 0
            let y = (self.searchTField?.frame.height ?? 0) - 1
            let width = (self.searchTField?.frame.width ?? 0) - ((self.searchTField?.rightView?.frame.width ?? 0))
            let height:CGFloat = 1.0
            borderBottom.frame = CGRect(
                x: x,
                y: y,
                width: width,
                height: height)
            borderBottom.borderWidth = borderWidth
            self.searchTField?.layer.addSublayer(borderBottom)
                
        }
    }

    func setNoResultsMessageSearch(viewController:UIViewController){
        let alert = UIAlertController(title: "Message", message: "List is empty", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
        self.text = ""
    }
        
}
