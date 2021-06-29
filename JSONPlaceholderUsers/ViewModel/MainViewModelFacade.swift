//
//  MainViewModelFacade.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 27/06/21.
//


import CoreData
import Foundation
import UIKit.UIApplication

class MainViewModelFacade {
    
    var delegate: MainViewModelFacadeDelegate?
    private var userViewModel: UserViewModelProtocol?
    private var postViewModel: PostViewModelProtocol?
    private var localUsersList = [User]()
    private var localPostsList = [Post]()
    
    init(delegate: MainViewModelFacadeDelegate){
        self.delegate = delegate
        setup()
    }

    private func setup(){
        retrieveLocalData()
        if thereAreLocalUsers(), thereAreLocalPosts() {
            return
        }
        
        NetworkService.get.afSessionManager = AFSessionManager()
        let userViewModel = UserViewModel()
        userViewModel.networkService = NetworkService.get
        self.userViewModel = userViewModel as UserViewModelProtocol

        let postViewModel = PostViewModel()
        postViewModel.networkService = NetworkService.get
        self.postViewModel = postViewModel as PostViewModelProtocol
        
        loadRemoteUsers()
    }
    
    private func loadRemoteUsers(){
        userViewModel?.getRemoteUsers(){(result) in
            switch result {
            case .Success(_, _):
                self.loadRemotePosts()
            case .Error(let message, let statusCode):
                print("Error \(message) \(statusCode ?? 0)")
            }
        }
    }
    
    private func loadRemotePosts(){
        postViewModel?.getPosts(){(result) in
            switch result {
            case .Success(_, _):
                self.createData()
                self.retrieveLocalData()
            case .Error(let message, let statusCode):
                print("Error \(message) \(statusCode ?? 0)")
            }
        }
    }
    
    private func createData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext) else { return }
        
        userViewModel?.remoteUserList.forEach(){remoteUser in
            let userManagedObject = NSManagedObject(entity: userEntity, insertInto: managedContext) as! User
            userManagedObject.setValue(remoteUser.id, forKeyPath: "id")
            userManagedObject.setValue(remoteUser.name, forKeyPath: "name")
            userManagedObject.setValue(remoteUser.username, forKeyPath: "username")
            userManagedObject.setValue(remoteUser.email, forKeyPath: "email")
            userManagedObject.setValue(remoteUser.address, forKeyPath: "address")
            userManagedObject.setValue(remoteUser.phone, forKeyPath: "phone")
            userManagedObject.setValue(remoteUser.website, forKeyPath: "website")
            userManagedObject.setValue(remoteUser.company, forKeyPath: "company")
            do {
                try managedContext.save()
            }catch let error as NSError{
                print("appflow::Could not save. error: \(error), \(error.userInfo)")
            }
        }
        
        guard let postEntity = NSEntityDescription.entity(forEntityName: "Post", in: managedContext) else { return }
        postViewModel?.postsList.forEach(){ post in
            let postManagedObject = NSManagedObject(entity: postEntity, insertInto: managedContext) as! Post
            postManagedObject.setValue(post.id, forKeyPath: "id")
            postManagedObject.setValue(post.userID, forKeyPath: "userId")
            postManagedObject.setValue(post.title, forKeyPath: "title")
            postManagedObject.setValue(post.body, forKeyPath: "body")
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("appflow::Could not save. error: \(error), \(error.userInfo)")
            }
        }
        
    }
    
    private func retrieveLocalData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            self.localUsersList = try managedContext.fetch(User.fetchRequest())
            self.localPostsList = try managedContext.fetch(Post.fetchRequest())
            if thereAreLocalUsers(), thereAreLocalPosts() {
                delegate?.onDataLoaded(users: localUsersList, posts: localPostsList)
            }
        } catch  {
            print("appflow::Error retrieving data: \(error.localizedDescription)")
        }
    }
    
}

extension MainViewModelFacade {
    func thereAreLocalUsers() -> Bool {
        return self.localUsersList.count == 0 ? false : true
    }
    
    func thereAreLocalPosts() -> Bool {
        return self.localPostsList.count == 0 ? false : true
    }
}
