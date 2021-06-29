//
//  ListHeaderView.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 26/06/21.
//

import Foundation
import UIKit

class ListHeaderView: UIView {
    
    private var customContainerViewHeader: UIView!
    private var headerSubSectionView:UIView!
    private let height:CGFloat = 60
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addHeaderSubSectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setConfigFromViewController(title:String, view:UIView) {
        view.frame = CGRect(x: headerSubSectionView.frame.origin.x,
                            y: 0,
                            width: headerSubSectionView.frame.width,
                            height: height)
        self.headerSubSectionView.addSubview(view)
    }
  
    func addHeaderSubSectionView(){
        self.headerSubSectionView = UIView(frame: CGRect(x: 0,
                                                         y: 45,
                                                         width: UIScreen.main.bounds.width,
                                                         height: height))
        self.addSubview(headerSubSectionView)
        self.headerSubSectionView.autoresizingMask = [.flexibleWidth]
        self.headerSubSectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.headerSubSectionView.widthAnchor.constraint(equalToConstant: headerSubSectionView.frame.width),
            self.headerSubSectionView.heightAnchor.constraint(equalToConstant: height),
            self.headerSubSectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            self.headerSubSectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

}
