//
//  LajmeDetailsViewController.swift
//  GazetaExpressApp
//
//  Created by Esra on 10/26/20.
//  Copyright © 2020 GazetaExpress. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift
import SDWebImage
import GoogleMobileAds

class LajmeDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var lajmeDetailsCollectionView: UICollectionView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var expressButton: UIButton!
    
    var category: Category!
    var viewColor: UIColor?
    let refreshControl = UIRefreshControl()
    var post: Post!
    var posts: Results<Post>!
    var postsArr: [Post?] = []
    var postsIDs: [String?] = []
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = category.name
        setUpCollectionView()
        backgroundView.backgroundColor = viewColor
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        lajmeDetailsCollectionView.insertSubview(refreshControl, at: 0)
        getPosts(pageNumber: 50)
        posts = realm.objects(Post.self).sorted(byKeyPath: "date", ascending: false)
        postsArr = Array(posts).filter({ post in
            post.categories.contains(category.id)
        })
        
    }
    override func viewDidAppear(_ animated: Bool) {
        lajmeDetailsCollectionView.isUserInteractionEnabled = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "\(self.title) ?iOS")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    @IBAction func onRefreshButtonPressed(_ sender: Any) {
        onRefresh()
    }
    func getPosts(pageNumber: Int) {
        ApiManager.getCategoryPostsById(path: "/wp-json/wp/v2/posts?_embed=true&categories=\(category.id)&per_page=\(pageNumber)", parameters: ["_embed" : true, "categories" : category.id, "per_page" : pageNumber]) { (result) in
            switch result {
            case .success(let posts):
                self.postsArr = posts   
                print(self.postsArr)
                self.realm.beginWrite()
                for post in self.postsArr {
                    self.post = post
                    self.postsIDs.append(self.post.slug)
                    self.realm.add(self.post, update: .all)
                }
                self.lajmeDetailsCollectionView.reloadData()
                let realmEntries = self.realm.objects(Post.self)
                for entry in realmEntries {
                    if !self.postsIDs.contains(entry.slug) {
                        self.realm.delete(entry)
                    }
                }
                try! self.realm.commitWrite()
                self.lajmeDetailsCollectionView.reloadData()
                print(self.postsArr)
            case .failure(let error):
                print(error)
                let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func onExpressButtonTapped(_ sender: Any) {
        print("asd")
        self.dismiss(animated:true) {
            let st = UIStoryboard(name: "Main", bundle: nil)
             let TabViewController = st.instantiateViewController(withIdentifier: "MainVC") as! MainViewController
             TabViewController.selectedIndex = 0
             UIApplication.shared.keyWindow?.rootViewController = TabViewController
            self.navigationController?.popToRootViewController(animated: true)
        }
        //navigationController?.popToViewController((self.navigationController?.viewControllers[1]) as! MainViewController, animated: true)
        
    }
    
    func setUpCollectionView() {
        lajmeDetailsCollectionView.delegate = self
        lajmeDetailsCollectionView.dataSource = self
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as! DetailsCollectionViewCell
        let results = postsArr[indexPath.row]
        cell.detaiTitle.text = results?.title?.rendered!.stripOutHtml()
        cell.detailImageView.sd_setImage(with: URL(string: (results?._embedded?.wpfeaturedmedia[0].source_url) ?? ""), placeholderImage: #imageLiteral(resourceName: "expressLogo"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        collectionView.isUserInteractionEnabled = false
        let post = postsArr[indexPath.row]
        for _ in postsArr {
            self.post = post
            cell.isSelected = !cell.isSelected
        }
        performSegue(withIdentifier: "goToDetail", sender: self.post)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            let destinationVC = segue.destination as! NewsOpenedViewController
            destinationVC.categoryPost = self.post
            destinationVC.category = category
            destinationVC.teTjeraItems = postsArr.reversed()
        } else if segue.identifier == "goToOpened" {
            let destinationVC = segue.destination as! NewsOpenedViewController
            destinationVC.categoryPost = self.postsArr[0]
            destinationVC.category = category
            destinationVC.teTjeraItems = postsArr.reversed()
        }
    }
    
    @objc func onRefresh() {
        getPosts(pageNumber: 50)
        refresh()
        
    }
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    func refresh() {
        run(after: 2) {
            self.refreshControl.endRefreshing()
        }
    }
}
extension LajmeDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
}
