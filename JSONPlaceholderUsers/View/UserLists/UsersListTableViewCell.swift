//
//  UsersListTableViewCell.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 26/06/21.
//

import Foundation
import UIKit

class UsersListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var seePostsButton: UIButton!
    @IBOutlet weak var phoneIcon: UIImageView!
    @IBOutlet weak var emailIcon: UIImageView!
    
    var user:User?
    var buttonActionClosure:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCellData(user:User, buttonActionClosure: @escaping (() -> Void)){
        self.user = user
        self.buttonActionClosure = buttonActionClosure
        setupMainContainer()
        setupNameLabel()
        setupPhone()
        setupEmail()
        setupButton()
    }
    
    func setupMainContainer(){
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.mainContainerView.boxStyle1()
        })
    }
    
    func setupNameLabel(){
        self.nameLabel.text = self.user?.name
    }
    
    func setupPhone(){
        self.phoneLabel.text = self.user?.phone
        let image = phoneIcon.image
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        phoneIcon.image = tintedImage
    }
    
    func setupEmail(){
        self.emailLabel.text = self.user?.email
        let image = emailIcon.image
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        emailIcon.image = tintedImage
    }
    
    func setupButton(){
        self.seePostsButton.setTitle("See posts".uppercased(), for: .normal)
    }
    
    @IBAction func potButtonAction(_ sender: Any) {
        self.buttonActionClosure?()
    }
    
}
