//
//  UserDetailsViewController.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 28/06/21.
//

import Foundation
import UIKit

class UserDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let heightForCells:CGFloat = 160
    private let heightForHeader:CGFloat = 92
    private let heightForFooter:CGFloat = 60
    private var user: User?
    private var posts: [Post]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.layoutSubviews()
    }
    
    func setupUser(user: User, usersPosts:[Post]){
        self.user = user
        self.posts = usersPosts.sorted(by: { $0.id < $1.id })
        self.title = "@\(user.username ?? "")"
    }

    private func setupViews(){
        let headernib = UINib(nibName: "UserDetailsHeaderView", bundle: nil)
        tableView.register(headernib,
                           forHeaderFooterViewReuseIdentifier: "UserDetailsHeaderView")
        tableView.register(UINib(nibName: "UserDetailsTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "UserDetailsTableViewCell")
        tableView.register(UINib(nibName:"NoRecordsFoundTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "NoRecordsFoundTableViewCell")
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = heightForCells
    }
    
}

extension UserDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getPostListCount() == 0 ? 1 : getPostListCount()
    }
       
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
           
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
       
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeader
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightForFooter
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UserDetailsHeaderView.instanceFromNib() as! UserDetailsHeaderView
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: heightForHeader)
        headerView.setCellData(user: self.user)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 70))
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(tableView: tableView, cellForRowAt: indexPath)
    }
       
    private func getCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listCount = getPostListCount()
        if listCount == 0  { return getNoRecordsFoundTableViewCell(indexPath: indexPath) }
        guard let userDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserDetailsTableViewCell") as? UserDetailsTableViewCell else {
            return UITableViewCell()
        }
        if let post = posts?[indexPath.row] {
            userDetailsTableViewCell.setCellData(post: post)
        }
        return userDetailsTableViewCell
    }
    
    private func getNoRecordsFoundTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        let noRowsCell = tableView.dequeueReusableCell(withIdentifier: "NoRecordsFoundTableViewCell",
                                                       for: indexPath) as! NoRecordsFoundTableViewCell
        noRowsCell.messageLabel.text = ""
        return noRowsCell
    }
    
    private func getPostListCount() -> Int {
        return self.posts?.count ?? 0
    }

}
