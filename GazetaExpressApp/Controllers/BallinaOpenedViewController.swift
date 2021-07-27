//
//  BallinaOpenedViewController.swift
//  GazetaExpressApp
//
//  Created by Esra on 12/7/20.
//  Copyright © 2020 GazetaExpress. All rights reserved.
//

import UIKit
import WebKit
import SDWebImage
import GoogleMobileAds

@objc(BallinaOpenedViewController)
class BallinaOpenedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var timeOfPostLabel: UILabel!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var tjeraTableView: UITableView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    
    var ax: Ballina!
    var ballina: [Ballina] = []
    var tjeraItems: [Post] = []
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        tjeraTableView.reloadData()
        categoryLabel.text = "LAJME"
        postTitleLabel.text = ax.title?.stripOutHtml()
        postImageView.sd_setImage(with: URL(string: ax.featured_img!), placeholderImage: #imageLiteral(resourceName: "expressLogo"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionTapped))
        getTimeForPost()
        self.webView.navigationDelegate = self
        
        let htmlString = "<head><meta name=\"viewport\" content=\"initial-scale=1, user-scalable=no, width=device-width\"/><link href='https://fonts.googleapis.com/css?family=Raleway' rel='stylesheet'><style>body {font-family: 'Raleway';font-size: 15px;} @media (prefers-color-scheme: dark) { body {color: white;}</style></head><body>" + (ax.content ?? "") + "</body>"
        
        webView.loadHTMLString(htmlString, baseURL: nil)
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.webViewHeightConstraint.constant = webView.scrollView.contentSize.height
        }
    }
    
    func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil, completion: {_ in
            //Reset Frame of Webview
            self.webView.evaluateJavaScript("location.reload();")
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: ax.link)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    func getTimeForPost() {
        let date = ax.post_date ?? ""
        let dtf = DateFormatter()
        dtf.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let assignedDate = dtf.date(from: date)
        let calendar = Calendar.current
        let day = calendar.component(.day, from: assignedDate!)
        let month = calendar.component(.month, from: assignedDate!)
        let year = calendar.component(.year, from: assignedDate!)
        let hour = calendar.component(.hour, from: assignedDate!)
        let minutes = calendar.component(.minute, from: assignedDate!)
        timeOfPostLabel.text = "\(day)/\(month)/\(year) \(hour):\(minutes)"
    }
    @objc func actionTapped(sender: UIBarButtonItem) {
        let firstActivityItem = postTitleLabel.text
        let secondActivityItem : NSURL = NSURL(string: "https://www.gazetaexpress.com/\(ax.link!)")!
        let image : UIImage = postImageView.image!
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        if #available(iOS 13.0, *) {
            activityViewController.activityItemsConfiguration = [
                UIActivity.ActivityType.message
            ] as? UIActivityItemsConfigurationReading
        } else {
        }
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.postToFacebook
        ]
        if #available(iOS 13.0, *) {
            activityViewController.isModalInPresentation = true
        } else {
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    //    @objc func actionTapped(sender: UIBarButtonItem) {
    //        let firstActivityItem = postTitleLabel.text
    //        let secondActivityItem : NSURL = NSURL(string: ax.link!)!
    //        let image : UIImage = postImageView.image!
    //            let activityViewController : UIActivityViewController = UIActivityViewController(
    //                activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
    //            activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
    //            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
    //        if #available(iOS 13.0, *) {
    //            activityViewController.activityItemsConfiguration = [
    //                UIActivity.ActivityType.message
    //            ] as? UIActivityItemsConfigurationReading
    //        } else {
    //        }
    //            activityViewController.excludedActivityTypes = [
    //                UIActivity.ActivityType.postToWeibo,
    //                UIActivity.ActivityType.print,
    //                UIActivity.ActivityType.assignToContact,
    //                UIActivity.ActivityType.saveToCameraRoll,
    //                UIActivity.ActivityType.addToReadingList,
    //                UIActivity.ActivityType.postToFlickr,
    //                UIActivity.ActivityType.postToVimeo,
    //                UIActivity.ActivityType.postToTencentWeibo,
    //                UIActivity.ActivityType.postToFacebook,
    //                UIActivity.ActivityType.airDrop,
    //                UIActivity.ActivityType.mail,
    //                UIActivity.ActivityType.postToTwitter
    //            ]
    //        if #available(iOS 13.0, *) {
    //            activityViewController.isModalInPresentation = true
    //        } else {
    //        }
    //            self.present(activityViewController, animated: true, completion: nil)
    //    }
    func setUpTableView() {
        tjeraTableView.delegate = self
        tjeraTableView.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tjeraItems.count - 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ballinaTjeraCell", for: indexPath) as! BallinaTeTjeraTableViewCell
        let tjera = tjeraItems.reversed()[indexPath.row]
        cell.teTjereTitleLabel.text = tjera.title?.rendered?.stripOutHtml()
        cell.teTjereImageView.sd_setImage(with: URL(string: (tjera._embedded?.wpfeaturedmedia[0].source_url) ?? ""), placeholderImage: #imageLiteral(resourceName: "expressLogo"))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let post = tjeraItems.reversed()[indexPath.row]
        for _ in tjeraItems {
            self.post = post
            cell.isSelected = !cell.isSelected
        }
        performSegue(withIdentifier: "showTjeter", sender: self.post)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTjeter" {
            let destinationVC = segue.destination as! TeTjeraOpenedViewController
            destinationVC.post = self.post
        }
    }
}

