//
//  TableViewController.swift
//  GazetaExpressApp
//
//  Created by Esra on 10/30/20.
//  Copyright © 2020 GazetaExpress. All rights reserved.
//

import UIKit
struct MenuItem {
    var itemTitle: String
}
class MenuTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    var items: [MenuItem] = []
    var category: Category!
    var bckgColor: UIColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateTableView()
        setUpTableView()
    }
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    func populateTableView() {
        items.append(MenuItem(itemTitle: "Lajme"))
        items.append(MenuItem(itemTitle: "Sport"))
        items.append(MenuItem(itemTitle: "Op/Ed"))
        items.append(MenuItem(itemTitle: "Rozë"))
        items.append(MenuItem(itemTitle: "Shneta"))
        items.append(MenuItem(itemTitle: "Fun"))
        items.append(MenuItem(itemTitle: "Arte"))
        items.append(MenuItem(itemTitle: "Auto-Tech"))
        items.append(MenuItem(itemTitle: "Shqipëri"))
        items.append(MenuItem(itemTitle: "Maqedoni"))
        items.append(MenuItem(itemTitle: "English"))
        items.append(MenuItem(itemTitle: ""))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.isUserInteractionEnabled = true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuItem", for: indexPath) as! MenuTableViewCell
        let item = items[indexPath.row]
        cell.configureCell(with: item)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.isUserInteractionEnabled = false
        if indexPath.row == items.startIndex {
            bckgColor = #colorLiteral(red: 0.9990847707, green: 0.2392956018, blue: 0, alpha: 1)
            ApiManager.getLajme { (result) in
                switch result {
                case .success(let category):
                    self.category = category
                    print(category)
                    self.performSegue(withIdentifier: "goToItemClicked", sender: category)
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else if indexPath.row == items.index(after: items.startIndex) {
            bckgColor = #colorLiteral(red: 0.1014586762, green: 0.8121945262, blue: 0.6200477481, alpha: 1)
            ApiManager.getSporte { (result) in
                switch result {
                case .success(let category):
                    self.category = category
                    print(category)
                    self.performSegue(withIdentifier: "goToItemClicked", sender: category)
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else if indexPath.row == items.index(after: (items.index(after: items.startIndex))) {
            bckgColor = #colorLiteral(red: 0.003939820919, green: 0.7387096286, blue: 0.9267136455, alpha: 1)
            ApiManager.getOPED { (result) in
                switch result {
                case .success(let category):
                    self.category = category
                    print(category)
                    self.performSegue(withIdentifier: "goToItemClicked", sender: category)
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else if indexPath.row == items.index(after: items.index(after: (items.index(after: items.startIndex)))) {
            bckgColor = #colorLiteral(red: 0.9379754663, green: 0.2983233631, blue: 0.9158793092, alpha: 1)
            ApiManager.getRoze { (result) in
                switch result {
                case .success(let category):
                    self.category = category
                    print(category)
                    self.performSegue(withIdentifier: "goToItemClicked", sender: category)
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else if indexPath.row == items.index(after: items.index(after: items.index(after: (items.index(after: items.startIndex))))) {
            bckgColor = #colorLiteral(red: 0.7598826885, green: 0.8379737139, blue: 0.1874131262, alpha: 1)
            ApiManager.getShneta { (result) in
                switch result {
                case .success(let category):
                    self.category = category
                    print(category)
                    self.performSegue(withIdentifier: "goToItemClicked", sender: category)
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else if indexPath.row == items.index(after: items.index(after: items.index(after: items.index(after: (items.index(after: items.startIndex)))))) {
            bckgColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            ApiManager.getFun { (result) in
                switch result {
                case .success(let category):
                    self.category = category
                    print(category)
                    self.performSegue(withIdentifier: "goToItemClicked", sender: category)
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else if indexPath.row == items.index(before: items.index(before: items.endIndex)) {
            bckgColor = #colorLiteral(red: 1, green: 0.2312947512, blue: 0, alpha: 1)
            ApiManager.getEnglish { (result) in
                switch result {
                case .success(let category):
                    self.category = category
                    print(category)
                    self.performSegue(withIdentifier: "goToItemClicked", sender: category)
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else if indexPath.row == items.index(before: items.index(before: items.index(before: items.endIndex))) {
            bckgColor = #colorLiteral(red: 1, green: 0.2312947512, blue: 0, alpha: 1)
            ApiManager.getMaqedoni { (result) in
                switch result {
                case .success(let category):
                    self.category = category
                    print(category)
                    self.performSegue(withIdentifier: "goToItemClicked", sender: category)
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else if indexPath.row == items.index(before: items.index(before: items.index(before: items.index(before: items.endIndex)))) {
            bckgColor = #colorLiteral(red: 1, green: 0.2312947512, blue: 0, alpha: 1)
            ApiManager.getShqiperi { (result) in
                switch result {
                case .success(let category):
                    self.category = category
                    print(category)
                    self.performSegue(withIdentifier: "goToItemClicked", sender: category)
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else if indexPath.row == items.index(before: items.index(before: items.index(before: items.index(before: items.index(before: items.endIndex))))) {
            bckgColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
            ApiManager.getAutoTech { (result) in
                switch result {
                case .success(let category):
                    self.category = category
                    print(category)
                    self.performSegue(withIdentifier: "goToItemClicked", sender: category)
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else if indexPath.row == items.index(before: items.index(before: items.index(before: items.index(before: items.index(before: items.index(before: items.endIndex)))))) {
            bckgColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
            ApiManager.getArte { (result) in
                switch result {
                case .success(let category):
                    self.category = category
                    print(category)
                    self.performSegue(withIdentifier: "goToItemClicked", sender: category)
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "Could not display news", message: error.localizedDescription.description, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItemClicked" {
            let destinationVC = segue.destination as! LajmeDetailsViewController
            destinationVC.category = category
            destinationVC.viewColor = bckgColor
        }
    }
}
