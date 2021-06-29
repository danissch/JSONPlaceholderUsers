//
//  UserDetailsHeaderView.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 28/06/21.
//

import Foundation
import UIKit

class UserDetailsHeaderView: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneIcon: UIImageView!
    @IBOutlet weak var emailIcon: UIImageView!
    
    var user: User?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCellData(user:User?){
        self.user = user
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.setup()
        })
    }
    
    func setup(){
        setupName()
        setupPhone()
        setupEmail()
    }
    
    func setupName(){
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
    
}
