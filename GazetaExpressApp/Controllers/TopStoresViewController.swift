//
//  TopStoresViewController.swift
//  GazetaExpressApp
//
//  Created by Esra on 10/3/20.
//  Copyright © 2020 GazetaExpress. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import SDWebImage
import GoogleMobileAds

class TopStoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var topNewsTableView: UITableView!
    @IBOutlet weak var frequentCollectionView: UICollectionView!
    @IBOutlet weak var sportTableView: UITableView!
    @IBOutlet weak var shnetaTableView: UITableView!
    @IBOutlet weak var rozeTableView: UITableView!
    @IBOutlet weak var ballinaTableView: UITableView!
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var meShumeNgaSporti: UIButton!
    @IBOutlet weak var meShumeNgaShneta: UIButton!
    @IBOutlet weak var meShumeNgaRoze: UIButton!
    @IBOutlet weak var a1ImageView: UIImageView!
    @IBOutlet weak var a1Label: UILabel!
    @IBOutlet weak var a1button: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    
    
    var category: Category!
    var sportCategory: Category!
    var shnetaCategory: Category!
    var rozeCategory: Category!
    var bckgColor: UIColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
    let refreshControl = UIRefreshControl()
    var ballinaPosts: [Ballina] = []
    var ax: Ballina!
    let realm = try! Realm()
    var ballinaPostIDs: [Int] = []
    var ballinapositions: [String] = []
    var frekuentuara: [Post] = []
    var sporte: [Post] = []
    var roze: [Post] = []
    var shnete: [Post] = []
    var post: Post!
    var postsId: [String?] = []
    var interstitial: GADInterstitialAd!
    var ballina: Results<Ballina>!
    var freq: Results<Post>!
    var sports: Results<Post>!
    var rozet: Results<Post>!
    var shnetat: Results<Post>!
    var arte: Results<Post>!
    var oped: Results<Post>!
    var fun: Results<Post>!
    var autotech: Results<Post>!
    var shqiperi: Results<Post>!
    var maqedoni: Results<Post>!
    var english: Results<Post>!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableViewAndCollectionViews()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        scrollView.insertSubview(refreshControl, at: 0)
        let hasLaunchedKey = "HasLaunched"
        let defaults = UserDefaults.standard
        let hasLaunched = defaults.bool(forKey: hasLaunchedKey)
        if !hasLaunched {
            defaults.set(true, forKey: hasLaunchedKey)
            getHome()
            getFrekuentuara()
            getSport()
            getRoze()
            getShnete()
        }
        
        print("This is: ", hasLaunched)
        print(Realm.Configuration.defaultConfiguration.fileURL)
        //interstitial = createAndLoadInterstitial()
        ballina = realm.objects(Ballina.self).sorted(byKeyPath: "position", ascending: true)
        freq = realm.objects(Post.self).sorted(byKeyPath: "date", ascending: false)
        sports = realm.objects(Post.self).sorted(byKeyPath: "date", ascending: false)
        rozet = realm.objects(Post.self).sorted(byKeyPath: "date", ascending: false)
        shnetat = realm.objects(Post.self).sorted(byKeyPath: "date", ascending: false)
        arte = realm.objects(Post.self).sorted(byKeyPath: "date", ascending: false)
        oped = realm.objects(Post.self).sorted(byKeyPath: "date", ascending: false)
        fun = realm.objects(Post.self).sorted(byKeyPath: "date", ascending: false)
        autotech = realm.objects(Post.self).sorted(byKeyPath: "date", ascending: false)
        shqiperi = realm.objects(Post.self).sorted(byKeyPath: "date", ascending: false)
        maqedoni = realm.objects(Post.self).sorted(byKeyPath: "date", ascending: false)
        english = realm.objects(Post.self).sorted(byKeyPath: "date", ascending: false)
        
        frekuentuara = Array(freq).filter({ frek in
            frek.categories.contains(4)
        })
        sporte = Array(sports).filter({ sport in
            sport.categories.contains(5)
        })
        roze = Array(rozet).filter({ rozi in
            rozi.categories.contains(6)
        })
        shnete = Array(shnetat).filter({ shnet in
            shnet.categories.contains(7)
        })
        a1ImageView.sd_setImage(with: URL(string: ballina[0].featured_img!), placeholderImage: #imageLiteral(resourceName: "expressLogo"))
        a1Label.text = ballina[0].title?.stripOutHtml()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleAppDidBecomeActiveNotification(notification:)),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        
    }
    
    @objc func handleAppDidBecomeActiveNotification(notification: Notification) {
        getHome()
        getFrekuentuara()
        getSport()
        getRoze()
        getShnete()
        refresh()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        ballinaTableView.isUserInteractionEnabled = true
        topNewsTableView.isUserInteractionEnabled = true
        frequentCollectionView.isUserInteractionEnabled = true
        sportTableView.isUserInteractionEnabled = true
        shnetaTableView.isUserInteractionEnabled = true
        rozeTableView.isUserInteractionEnabled = true
        meShumeNgaSporti.isUserInteractionEnabled = true
        meShumeNgaRoze.isUserInteractionEnabled = true
        meShumeNgaShneta.isUserInteractionEnabled = true
        a1button.isUserInteractionEnabled = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onRefresh()
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "ballina")
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    @IBAction func a1ButtonPressed(_ sender: Any) {
        a1button.isUserInteractionEnabled = false
        performSegue(withIdentifier: "a1toOpened", sender: self.ballina[0])
    }
    
    @IBAction func onRefreshButtonPressed(_ sender: Any) {
        onRefresh()
    }
    
    func getHome() {
        ApiManager.getHome { (result) in
            switch result {
            case .success(let posts):
                self.ballinaPosts = posts
                print(self.ballinaPosts)
                self.realm.beginWrite()
                for post in self.ballinaPosts {
                    self.ax = post
                    //self.ballinaPostIDs.append(self.ax.ID)
                    self.ballinapositions.append(self.ax.position!)
                    self.realm.add(self.ax, update: .all)
                }
                let realmEntries = self.realm.objects(Ballina.self)
                for entry in realmEntries {
                    //                    if !self.ballinaPostIDs.contains(entry.ID){
                    //                        self.realm.delete(entry)
                    //                    }
                    if !self.ballinapositions.contains(entry.position!) {
                        self.realm.delete(entry)
                    }
                }
                try! self.realm.commitWrite()
                self.a1ImageView.sd_setImage(with: URL(string: self.ballina[0].featured_img!), placeholderImage: #imageLiteral(resourceName: "expressLogo"))
                self.a1Label.text = self.ballina[0].title?.stripOutHtml()
                self.ballinaTableView.reloadData()
                self.topNewsTableView.reloadData()
            case .failure(let error):
                print(error)
                let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func getFrekuentuara() {
        ApiManager.getCategoryPostsById(path: "/wp-json/wp/v2/posts?_embed=true&categories=4", parameters: ["_embed": true, "categories" : 4]) { (result) in
            switch result {
            case .success(let posts):
                self.frekuentuara = posts
                print(self.frekuentuara)
                self.realm.beginWrite()
                for post in self.frekuentuara {
                    self.post = post
                    self.postsId.append(self.post.slug)
                    self.realm.add(self.post, update: .all)
                }
                let realmEntries = self.realm.objects(Post.self)
                for entry in realmEntries {
                    if !self.postsId.contains(entry.slug) {
                        self.realm.delete(entry)
                    }
                }
                try! self.realm.commitWrite()
                self.frequentCollectionView.reloadData()
            case .failure(let error):
                print(error)
                let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func getSport() {
        ApiManager.getCategoryPostsById(path: "/wp-json/wp/v2/posts?_embed=true&categories=5", parameters: ["_embed" : true, "categories" : 5]) { (result) in
            switch result {
            case .success(let posts):
                self.sporte = posts
                print(self.sporte)
                self.realm.beginWrite()
                for post in self.sporte {
                    self.post = post
                    self.postsId.append(self.post.slug)
                    self.realm.add(self.post, update: .all)
                }
                let realmEntries = self.realm.objects(Post.self)
                for entry in realmEntries {
                    if !self.postsId.contains(entry.slug) {
                        self.realm.delete(entry)
                    }
                }
                try! self.realm.commitWrite()
                self.sportTableView.reloadData()
            case .failure(let error):
                print(error)
                let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func getShnete() {
        ApiManager.getCategoryPostsById(path: "/wp-json/wp/v2/posts?_embed=true&categories=7", parameters: ["_embed" : true, "categories" : 7]) { (result) in
            switch result {
            case .success(let posts):
                self.shnete = posts
                print(self.shnete)
                self.realm.beginWrite()
                for post in self.shnete {
                    self.post = post
                    self.postsId.append(self.post.slug)
                    self.realm.add(self.post, update: .all)
                }
                let realmEntries = self.realm.objects(Post.self)
                for entry in realmEntries {
                    if !self.postsId.contains(entry.slug) {
                        self.realm.delete(entry)
                    }
                }
                try! self.realm.commitWrite()
                self.shnetaTableView.reloadData()
            case .failure(let error):
                print(error)
                let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func getRoze() {
        ApiManager.getCategoryPostsById(path: "/wp-json/wp/v2/posts?_embed=true&categories=6", parameters: ["_embed" : true, "categories" : 6]) { (result) in
            switch result {
            case .success(let posts):
                self.roze = posts
                print(self.roze)
                self.realm.beginWrite()
                for post in self.roze {
                    self.post = post
                    self.postsId.append(self.post.slug)
                    self.realm.add(self.post, update: .all)
                }
                let realmEntries = self.realm.objects(Post.self)
                for entry in realmEntries {
                    if !self.postsId.contains(entry.slug) {
                        self.realm.delete(entry)
                    }
                }
                try! self.realm.commitWrite()
                self.rozeTableView.reloadData()
            case .failure(let error):
                print(error)
                let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func onMeShumeNgaSportiTapped(_ sender: UIButton) {
        bckgColor = #colorLiteral(red: 0.1014586762, green: 0.8121945262, blue: 0.6200477481, alpha: 1)
        meShumeNgaSporti.isUserInteractionEnabled = false
        ApiManager.getSporte { (result) in
            switch result {
            case .success(let category):
                self.category = category
                self.performSegue(withIdentifier: "goToMoreFrom", sender: sender)
                print(category)
            case .failure(let error):
                print(error)
                let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func onMeShumeNgaShnetaPressed(_ sender: UIButton) {
        bckgColor = #colorLiteral(red: 0.7598826885, green: 0.8379737139, blue: 0.1874131262, alpha: 1)
        meShumeNgaShneta.isUserInteractionEnabled = false
        ApiManager.getShneta { (result) in
            switch result {
            case .success(let category):
                self.category = category
                self.performSegue(withIdentifier: "goToMoreFrom", sender: sender)
                print(category)
            case .failure(let error):
                print(error)
                let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func onMeShumeNgaRozePressed(_ sender: UIButton) {
        bckgColor = #colorLiteral(red: 0.937963903, green: 0.2980265021, blue: 0.9199023843, alpha: 1)
        meShumeNgaRoze.isUserInteractionEnabled = false
        ApiManager.getRoze { (result) in
            switch result {
            case .success(let category):
                self.category = category
                self.performSegue(withIdentifier: "goToMoreFrom", sender: sender)
                print(category)
            case .failure(let error):
                print(error)
                let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func setUpTableViewAndCollectionViews() {
        ballinaTableView.delegate = self
        ballinaTableView.dataSource = self
        topNewsTableView.delegate = self
        topNewsTableView.dataSource = self
        frequentCollectionView.delegate = self
        frequentCollectionView.dataSource = self
        sportTableView.delegate = self
        sportTableView.dataSource = self
        shnetaTableView.delegate = self
        shnetaTableView.dataSource = self
        rozeTableView.delegate = self
        rozeTableView.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == topNewsTableView {
            return ballina.count - 4
        } else if tableView == ballinaTableView {
            return ballina.count - 5
        }else if tableView == sportTableView {
            return sporte.count - 7
        } else if tableView == shnetaTableView {
            return shnete.count - 7
        } else if tableView == rozeTableView {
            return roze.count - 7
        }else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == topNewsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsMostReadCell", for: indexPath) as! TopMostReadTableViewCell
            let results = ballina[indexPath.row + 4]
            cell.newsLabel.text = results.title?.stripOutHtml()
            cell.newsTopicLabel.text = "LAJME"
            cell.newsImageView.sd_setImage(with: URL(string: results.featured_img!), placeholderImage: #imageLiteral(resourceName: "expressLogo"))
            return cell
        } else if tableView == ballinaTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ballinaCell", for: indexPath) as! BallinaTableViewCell
            let results = ballina[indexPath.row + 1]
            cell.firstTitleLabel.text = results.title?.stripOutHtml()
            cell.ballinaImageView.sd_setImage(with: URL(string: (results.featured_img)!), placeholderImage: #imageLiteral(resourceName: "expressLogo"))
            return cell
        } else if tableView == sportTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sportCell", for: indexPath) as! SportTableViewCell
            let results = sporte[indexPath.row]
            cell.sportTitleLabel.text = results.title?.rendered?.stripOutHtml()
            cell.sportTopicLabel.text = "SPORT"
            cell.sportImageView.sd_setImage(with: URL(string: (results._embedded?.wpfeaturedmedia[0].source_url)!), placeholderImage: #imageLiteral(resourceName: "expressLogo"))
            return cell
        } else if tableView == shnetaTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "shnetaCell", for: indexPath) as! ShnetaTableViewCell
            let results = shnete[indexPath.row]
            cell.shnetaTitleLabel.text = results.title?.rendered?.stripOutHtml()
            cell.shnetaTopicLabel.text = "SHNETA"
            cell.shnetaImageView.sd_setImage(with: URL(string: (results._embedded?.wpfeaturedmedia[0].source_url) as! String), placeholderImage: #imageLiteral(resourceName: "expressLogo"))
            return cell
        } else if tableView == rozeTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rozeCell", for: indexPath) as! RozeTableViewCell
            let results = roze[indexPath.row]
            cell.titleLabel.text = results.title?.rendered?.stripOutHtml()
            cell.topicLabel.text = "ROZË"
            cell.rozeImageView.sd_setImage(with: URL(string: (results._embedded?.wpfeaturedmedia[0].source_url) as! String), placeholderImage: #imageLiteral(resourceName: "expressLogo"))
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        if tableView == topNewsTableView {
            topNewsTableView.isUserInteractionEnabled = false
            let post = ballina[indexPath.row + 4]
            for _ in ballina {
                self.ax = post
                cell.isSelected = !cell.isSelected
            }
            ApiManager.getLajme { (result) in
                switch result {
                case .success(let category):
                    self.category = category
                    self.performSegue(withIdentifier: "goToBallinaOpened", sender: self.ax)
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        } else if tableView == ballinaTableView {
            ballinaTableView.isUserInteractionEnabled = false
            let post = ballina[indexPath.row + 1]
            for _ in ballina {
                self.ax = post
                cell.isSelected = !cell.isSelected
            }
            ApiManager.getLajme { (result) in
                switch result {
                case .success(let category):
                    self.category = category
                    self.performSegue(withIdentifier: "goToBallinaOpened", sender: self.ax)
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else if tableView == sportTableView {
            sportTableView.isUserInteractionEnabled = false
            //            if interstitial.isReady {
            //                interstitial.present(fromRootViewController: self)
            //            } else {
            //                print("Ad wasn't ready")
            //            }
            let post = sporte[indexPath.row]
            for _ in sporte {
                self.post = post
                cell.isSelected = !cell.isSelected
            }
            ApiManager.getSporte { (result) in
                switch result {
                case .success(let category):
                    self.category = category
                    self.performSegue(withIdentifier: "goToNewsOpened", sender: [self.post, self.category])
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        } else if tableView == shnetaTableView {
            shnetaTableView.isUserInteractionEnabled = false
            //            if interstitial.isReady {
            //                interstitial.present(fromRootViewController: self)
            //            } else {
            //                print("Ad wasn't ready")
            //            }
            let post = shnete[indexPath.row]
            for _ in shnete {
                self.post = post
                cell.isSelected = !cell.isSelected
            }
            ApiManager.getShneta { (result) in
                switch result {
                case .success(let category):
                    self.category = category
                    self.performSegue(withIdentifier: "goToNewsOpened", sender: [self.post, self.category])
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }else if tableView == rozeTableView {
            rozeTableView.isUserInteractionEnabled = false
            let post = roze[indexPath.row]
            for _ in roze {
                self.post = post
                cell.isSelected = !cell.isSelected
            }
            ApiManager.getRoze { (result) in
                switch result {
                case .success(let category):
                    self.category = category
                    self.performSegue(withIdentifier: "goToNewsOpened", sender: [self.post, self.category])
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        frekuentuara.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "frequentCell", for: indexPath) as! FrekuentuaraCollectionViewCell
        let results = frekuentuara[indexPath.row]
        cell.numberLabel.text = String(indexPath.row + 1)
        cell.titleLabel.text = results.title?.rendered?.stripOutHtml()
        cell.frekImageView.sd_setImage(with: URL(string: (results._embedded?.wpfeaturedmedia[0].source_url) ?? ""), placeholderImage: #imageLiteral(resourceName: "expressLogo"))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        let post = frekuentuara[indexPath.row]
        collectionView.isUserInteractionEnabled = false
        for _ in frekuentuara {
            self.post = post
            cell.isSelected = !cell.isSelected
        }
        ApiManager.getLajme { (result) in
            switch result {
            case .success(let category):
                self.category = category
                self.performSegue(withIdentifier: "goToNewsOpened", sender: [self.post, self.category])
            case .failure(let error):
                print(error)
                let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMoreFrom" {
            let destinationVC = segue.destination as? LajmeDetailsViewController
            destinationVC?.category = category
            destinationVC?.viewColor = bckgColor
        } else if segue.identifier == "goToNewsOpened" {
            let destinationVC = segue.destination as! NewsOpenedViewController
            destinationVC.categoryPost = self.post
            destinationVC.category = self.category
            destinationVC.teTjeraItems = self.frekuentuara
        } else if segue.identifier == "goToBallinaOpened" {
            let destinationVC = segue.destination as! BallinaOpenedViewController
            destinationVC.ax = self.ax
            destinationVC.ballina = self.ballinaPosts
            destinationVC.tjeraItems = self.frekuentuara
            
        } else if segue.identifier == "a1toOpened" {
            let destinationVC = segue.destination as! BallinaOpenedViewController
            destinationVC.ax = self.ballina[0]
            destinationVC.ballina = self.ballinaPosts
            destinationVC.tjeraItems = self.frekuentuara
        }
    }
    @objc func onRefresh() {
        getHome()
        getFrekuentuara()
        getRoze()
        getSport()
        getShnete()
        a1ImageView.sd_setImage(with: URL(string: ballina[0].featured_img!), placeholderImage: #imageLiteral(resourceName: "expressLogo"))
        a1Label.text = ballina[0].title?.stripOutHtml()
        ballinaTableView.reloadData()
        rozeTableView.reloadData()
        sportTableView.reloadData()
        shnetaTableView.reloadData()
        topNewsTableView.reloadData()
        frequentCollectionView.reloadData()
        refresh()
        
    }
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
        ballinaTableView.reloadData()
        rozeTableView.reloadData()
        sportTableView.reloadData()
        shnetaTableView.reloadData()
        topNewsTableView.reloadData()
        frequentCollectionView.reloadData()
        a1ImageView.sd_setImage(with: URL(string: ballina[0].featured_img!), placeholderImage: #imageLiteral(resourceName: "expressLogo"))
        a1Label.text = ballina[0].title?.stripOutHtml()
    }
    func refresh() {
        run(after: 2) {
            self.refreshControl.endRefreshing()
        }
    }
    
}

