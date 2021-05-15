//
//  NewsOpenedViewController.swift
//  GazetaExpressApp
//
//  Created by Esra on 10/20/20.
//  Copyright © 2020 GazetaExpress. All rights reserved.
//
import YoutubePlayer_in_WKWebView
import UIKit
import SDWebImage
import WebKit


@objc(NewsOpenedViewController)
class NewsOpenedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var timeOfPostLabel: UILabel!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var teTjeraTableView: UITableView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    
    var categoryPost: Post!
    var teTjeraItems: [Post?] = []
    var category: Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryNameLabel.text = category.name!.uppercased()
        print(teTjeraItems)
        postTitleLabel.text = categoryPost.title?.rendered?.stripOutHtml()
        setUpTableView()
        teTjeraTableView.reloadData()
        postImageView.sd_setImage(with: URL(string: (categoryPost._embedded?.wpfeaturedmedia[0].source_url) as! String), placeholderImage: #imageLiteral(resourceName: "expressLogo"))
        getTimeForPost()

        self.webView.navigationDelegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionTapped))
       
        let htmlString = "<head><meta name=\"viewport\" content=\"initial-scale=1, user-scalable=no, width=device-width\"/><link href='https://fonts.googleapis.com/css?family=Raleway' rel='stylesheet'><style>body {font-family: 'Raleway';font-size: 15px;} @media (prefers-color-scheme: dark) { body {color: white;}</style></head><body>" + (categoryPost.content?.rendered ?? "") + "</body>"
        
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
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: self.categoryPost.slug)
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    func setUpTableView() {
        teTjeraTableView.delegate = self
        teTjeraTableView.dataSource = self
    }
    @objc func actionTapped(sender: UIBarButtonItem) {
        let firstActivityItem = postTitleLabel.text
        let secondActivityItem : NSURL = NSURL(string: categoryPost.link!)!
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teTjeraItems.count - 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tetjeraCell", for: indexPath) as! TeTjeraTableViewCell
        let tjeter = teTjeraItems.reversed()[indexPath.row]
        cell.teTjeraTitleLabel.text = tjeter?.title?.rendered?.stripOutHtml()
        cell.newsImageView.sd_setImage(with: URL(string: (tjeter?._embedded?.wpfeaturedmedia[0].source_url ?? "") as! String), placeholderImage: #imageLiteral(resourceName: "expressLogo"))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let post = teTjeraItems.reversed()[indexPath.row]
        for _ in teTjeraItems {
            self.categoryPost = post
            cell.isSelected = !cell.isSelected
        }
        performSegue(withIdentifier: "teTjeraShow", sender: self.categoryPost)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "teTjeraShow" {
            let destinationVC = segue.destination as! TeTjeraOpenedViewController
            destinationVC.post = self.categoryPost
        }
    }
    func getTimeForPost() {
        let date = categoryPost.date ?? ""
        let dtf = DateFormatter()
        dtf.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let assignedDate = dtf.date(from: date)
        let calendar = Calendar.current
        let day = calendar.component(.day, from: assignedDate!)
        let month = calendar.component(.month, from: assignedDate!)
        let year = calendar.component(.year, from: assignedDate!)
        let hour = calendar.component(.hour, from: assignedDate!)
        let minutes = calendar.component(.minute, from: assignedDate!)
        timeOfPostLabel.text = "\(day)/\(month)/\(year) \(hour):\(minutes)"
    }
}
extension String {
    func stripOutHtml() -> String? {
        do {
            guard let data = self.data(using: .unicode) else {
                return nil
            }
            let attributed = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            return attributed.string
        } catch {
            return nil
        }
    }
}
