//
//  UserDetailsTableViewCell.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 28/06/21.
//

import Foundation
import UIKit

class UserDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postIdValueLabel: UILabel!
    @IBOutlet weak var postTitleValueLabel: UILabel!
    @IBOutlet weak var postBodyContentValueLabel: UILabel!
    @IBOutlet weak var mainContainerView: UIView!
    
    var post:Post?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCellData(post:Post?){
        self.post = post
        setup()
    }
    
    func setup(){
        setupMainContainer()
        setupId()
        setupTitle()
        setupContent()
    }
    
    func setupMainContainer(){
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.mainContainerView.boxStyle1()
        })
    }
    
    func setupId(){
        self.postIdValueLabel.text = self.post?.id.description
    }
    func setupTitle(){
        self.postTitleValueLabel.text = self.post?.title
    }
    func setupContent(){
        self.postBodyContentValueLabel.text = self.post?.body
    }
    
}
