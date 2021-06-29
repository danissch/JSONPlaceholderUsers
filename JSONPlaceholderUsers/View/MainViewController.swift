//
//  MainViewController.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 25/06/21.
//
import Foundation
import UIKit
import NVActivityIndicatorView

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let heightForCells:CGFloat = 130
    private let heightForHeader:CGFloat = 60
    private let heightForFooter:CGFloat = 60
    private var customSearchBar:CustomSearchBar?
    private var isSearching: Bool = false
    private var searchTextFieldValue: String = ""
    private var searchTextFieldIsFirstResponder: Bool = false
    var mainViewModel: MainViewModelProtocol?
    var window: UIWindow?
    var loading:NVActivityIndicatorView!
    var coverView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.layoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        fixOrientationBehaviors()
    }
    
}

extension MainViewController {
    private func setup(){
        setupViewModels()
        setupViews()
        getData()
        self.hideKeyboardWhenTappedAround()
        setActivityIndicatorConfig()
    }
    
    private func setupViewModels(){
        let mainViewModel = MainViewModel()
        self.mainViewModel = mainViewModel as MainViewModelProtocol
    }
    
    private func getData(){
        mainViewModel?.loadData()
        mainViewModel?.dataDidLoaded = {
            self.tableView.reloadData()
        }
    }
    
    private func setupViews(){
        let headernib = UINib(nibName: "ListHeaderView", bundle: nil)
        tableView.register(headernib,
                           forHeaderFooterViewReuseIdentifier: "listHeaderView")
        tableView.register(UINib(nibName: "UsersListTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "UsersListTableViewCell")
        tableView.register(UINib(nibName:"NoRecordsFoundTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "NoRecordsFoundTableViewCell")
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = heightForCells
    }
    
}

extension MainViewController {
    func setActivityIndicatorConfig(){
        let view = UIView(frame: self.navigationController?.view.frame ?? self.view.frame)
        coverView = view
        coverView.backgroundColor = .black
        coverView.alpha = 0.0
        loading = NVActivityIndicatorView(frame: coverView.frame, type: .ballSpinFadeLoader, color: .systemGray, padding: self.view.frame.width / 3)
        coverView.addSubview(loading)
        self.navigationController?.view.addSubview(coverView)
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
            self.coverView.alpha = 0.8
        }, completion: nil)
        coverView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loading.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin]
        loading.translatesAutoresizingMaskIntoConstraints = true
    }

    func startActivityIndicator(){
        self.loading.startAnimating()
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
                self.coverView?.alpha = 0.8
        })
    }

    func stopActivityIndicator(){
        DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + 3){
            UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
                    self.coverView?.alpha = 0
            }) { (_) in
                    self.loading.stopAnimating()
            }
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getUserListCount() == 0 ? 1 : getUserListCount()
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
        let headerView = ListHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: heightForHeader))
        headerView.setConfigFromViewController(title: "", view: getSearchBarView() ?? UISearchBar())
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
       
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleCellAction(indexPath: indexPath)
    }
    
    private func getCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listCount = getUserListCount()
        if listCount == 0  {
            startActivityIndicator()
            let noRowsCell = tableView.dequeueReusableCell(withIdentifier: "NoRecordsFoundTableViewCell",
                                                           for: indexPath) as! NoRecordsFoundTableViewCell
           noRowsCell.messageLabel.text = ""
           return noRowsCell
        }
        stopActivityIndicator()
        guard let usersListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UsersListTableViewCell") as? UsersListTableViewCell else {
            return UITableViewCell()
        }
        if let user = getUsersList()?[indexPath.row] {
            usersListTableViewCell.setCellData(user: user, buttonActionClosure: {
                self.handleCellAction(indexPath: indexPath)
            })
        }
        return usersListTableViewCell
    }
    
    private func getUserListCount() -> Int {
        let usersListCount = mainViewModel?.usersCount()
        let filteredUsersListCount = mainViewModel?.filteredUsersCount()
        let count = isSearching ? filteredUsersListCount : usersListCount
        return count ?? 0
    }
    
    private func getUsersList() -> [User]? {
        let usersList = mainViewModel?.usersList
        let filteredUsersList = mainViewModel?.filteredUsersList
        guard let list = isSearching ? filteredUsersList : usersList else { return [] }
        return list
    }
    
    private func handleCellAction(indexPath: IndexPath){
        let count = mainViewModel?.usersCount()
        if count == 0 { return }
        let list = getUsersList()

        if let user = list?[indexPath.row] {
            guard let usersPosts = mainViewModel?.getPostsByUser(userId: Int(user.id)) else { return }
           let vc = UserDetailsViewController.instantiateFromXIB() as UserDetailsViewController
            vc.setupUser(user: user, usersPosts: usersPosts)
           pushVc(vc, animated: true, navigationBarIsHidden: false)
        }
    }
    
}


extension MainViewController: UISearchBarDelegate {
    
    func getSearchBarView() -> CustomSearchBar? {
        customSearchBar = CustomSearchBar()
        customSearchBar = customSearchBar?.getSearchBar(delegate: self as UISearchBarDelegate) as? CustomSearchBar
        customSearchBar?.resignFirstResponder()
        return customSearchBar
    }
        
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isEditing = true
        searchBar.searchTextField.text = searchTextFieldValue
        searchTextFieldValue = ""
        searchTextFieldIsFirstResponder = false
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isEditing = false
        if searchTextFieldIsFirstResponder {
            searchTextFieldValue = searchBar.searchTextField.text ?? ""
            searchTextFieldIsFirstResponder = true
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isEditing = false
        searchBar.text = ""
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isEditing = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            isSearching = false
            getData()
        } else {
            isSearching = true
            guard let predicateString = searchBar.text?.lowercased() else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.mainViewModel?.filteredUsersList.removeAll(keepingCapacity: false)
                guard let newList = self.mainViewModel?.usersList.filter({($0.name?.lowercased().range(of: predicateString) != nil) || ($0.phone?.lowercased().range(of: predicateString) != nil) || ($0.email?.lowercased().range(of: predicateString) != nil)}) else { return }
                self.mainViewModel?.filteredUsersList = newList

                self.isSearching = (self.mainViewModel?.filteredUsersCount() == 0) ? false: true
                self.tableView.reloadData()
                if self.mainViewModel?.filteredUsersCount() == 0 {
                    self.customSearchBar?.setNoResultsMessageSearch(viewController: self)
                }
            })
        }
    }
    
    func fixOrientationBehaviors(){
        guard let searchTextFieldIsFirstResponder = customSearchBar?.searchTextField.isFirstResponder else { return }
        self.searchTextFieldIsFirstResponder = searchTextFieldIsFirstResponder
        self.customSearchBar?.searchTextField.resignFirstResponder()
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            if searchTextFieldIsFirstResponder {
                self.customSearchBar?.searchTextField.text = self.searchTextFieldValue
                self.customSearchBar?.searchTextField.becomeFirstResponder()
            }
            
        })
    }
}
