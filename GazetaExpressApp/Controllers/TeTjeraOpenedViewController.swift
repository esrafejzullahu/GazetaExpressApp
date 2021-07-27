//
//  TeTjeraOpenedViewController.swift
//  GazetaExpressApp
//
//  Created by Esra on 11/29/20.
//  Copyright © 2020 GazetaExpress. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

class TeTjeraOpenedViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var timePostedLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleOfPostLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var webViewHeight: NSLayoutConstraint!
    @IBOutlet weak var webView: WKWebView!
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topicLabel.text = "LAJME"
        titleOfPostLabel.text = post.title?.rendered?.stripOutHtml()
        postImageView.sd_setImage(with: URL(string: (post._embedded?.wpfeaturedmedia[0].source_url) as! String), placeholderImage: #imageLiteral(resourceName: "expressLogo"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionTapped))
        getTimeForPost()
        self.webView.navigationDelegate = self
        let htmlString = "<head><meta name=\"viewport\" content=\"initial-scale=1, user-scalable=no, width=device-width\"/><link href='https://fonts.googleapis.com/css?family=Raleway' rel='stylesheet'><style>body {font-family: 'Raleway';font-size: 15px;} @media (prefers-color-scheme: dark) { body {color: white;}</style></head><body>" + (post.content?.rendered ?? "") + "</body>"
        
        webView.loadHTMLString(htmlString, baseURL: nil)
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.webViewHeight.constant = webView.scrollView.contentSize.height
        }
    }
    
    func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil, completion: {_ in
            //Reset Frame of Webview
            self.webView.evaluateJavaScript("location.reload();")
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: post.slug)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    @objc func actionTapped(sender: UIBarButtonItem) {
        let firstActivityItem = titleOfPostLabel.text
        let secondActivityItem : NSURL = NSURL(string: post.link!)!
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
    func getTimeForPost() {
        let date = post.date ?? ""
        let dtf = DateFormatter()
        dtf.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let assignedDate = dtf.date(from: date)
        let calendar = Calendar.current
        let day = calendar.component(.day, from: assignedDate!)
        let month = calendar.component(.month, from: assignedDate!)
        let year = calendar.component(.year, from: assignedDate!)
        let hour = calendar.component(.hour, from: assignedDate!)
        let minutes = calendar.component(.minute, from: assignedDate!)
        timePostedLabel.text = "\(day)/\(month)/\(year) \(hour):\(minutes)"
    }
}
