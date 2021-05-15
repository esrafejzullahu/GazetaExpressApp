//
//  MoreViewController.swift
//  GazetaExpressApp
//
//  Created by Esra on 10/10/20.
//  Copyright © 2020 GazetaExpress. All rights reserved.
//

import UIKit

struct MoreItem {
    var moreLabel: String
    var moreDesc: String
}

class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var moreTableView: UITableView!
    
    var moreItems: [MoreItem] = []
    var moreItem: MoreItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        populateTableView()
        moreTableView.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setUpTableView(){
        moreTableView.delegate = self
        moreTableView.dataSource = self
    }
    
    func populateTableView(){
        moreItems.append(MoreItem(moreLabel: "About Us", moreDesc: """
                    Gazeta Express është portali më i lexuar, jo vetëm në trojet shqiptare por edhe në gjithë Ballkanin. Gazeta ka lexues të rregullt edhe në vendet e perëndimit, si Zvicër, Gjermani, Austri e madje edhe në SHBA.

                    Express sjell për lexuesit lajme në kohë reale, për të gjitha zhvillimet në vend dhe në botë, në të gjitha fushat për të cilat janë të interesuar.

                    E themeluar që nga shkurti i vitit 2005 si pjesë e Media Works, Gazeta Express ka bërë revolucion edhe kur ka vendosur që të ‘shuajë’ gazetën e shtypur dhe të fillojë vetëm me publikimet ‘online’ që nga viti 2013, duke qenë gjithmonë një hap para kohës.

                    Me Gazetën Express mund të mbaheni të informuar përmes:
                    Website:   https://www.gazetaexpress.com/
                    Instagram: https://www.instagram.com/gazetaexpress/
                    Twitter:   https://twitter.com/gazetaexpress

                    Për kontakt:
                    E-mail:   info@gazetaexpress.com
                    Tel:      +383 38 767676
                    """))
        moreItems.append(MoreItem(moreLabel: "Share this app", moreDesc: "Thank you for sharing the app"))
        moreItems.append(MoreItem(moreLabel: "Privacy policy", moreDesc: ""))
        moreItems.append(MoreItem(moreLabel: "Terms and conditions", moreDesc: ""))
        moreItems.append(MoreItem(moreLabel: "Version 1.1.1", moreDesc: ""))
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moreItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moreItemCell", for: indexPath) as! MoreTableViewCell
        let more = moreItems[indexPath.row]
        cell.configureCell(with: more)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.isUserInteractionEnabled = false
        cell.isSelected = !cell.isSelected
        moreItem = moreItems[indexPath.row]
        if indexPath.row == 1 {
            let firstActivityItem = "Install the app"
            let secondActivityItem : NSURL = NSURL(string: "https://apps.apple.com/us/app/gazeta-express-app/id1556243182")!
            let image : UIImage = #imageLiteral(resourceName: "expressLogo")
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
        
        performSegue(withIdentifier: "goToMoreOpened", sender: moreItem)
        cell.isUserInteractionEnabled = true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMoreOpened" {
            let destinationVC = segue.destination as? MoreOpenedViewController
            destinationVC?.item = moreItem
            
        }
    }
}
