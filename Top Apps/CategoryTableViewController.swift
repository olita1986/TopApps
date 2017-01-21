//
//  CategoryTableViewController.swift
//  Top Apps
//
//  Created by orlando arzola on 23.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit
import ReachabilitySwift
import AMScrollingNavbar
import GuillotineMenu
import PMAlertController


class CategoryTableViewController: UITableViewController {
    
    // MARK: - Vatiables
    
    let categoryArray = ["📙 Books", "📊 Business" , "📖 Catalogues", "🎓 Education","📺 Entertainment" , "💰 Finance", "🍕 Food & Drink", "🎮 Games", "💊 Health & Fitness", "🏄🏽 Lifestyle", "📰 Magazines & Newspapers", "💉 Medical", "🎤 Music", "🛳 Navigation", "🗞 News", "🎥 Photo & Video", "📈 Productivity", "📁 Reference", "🛍 Shopping", "👫 Social Networking", "🏀 Sports", "✈️ Travel", "⚒ Utilities", "☔️ Weather" ]
    
    // Creacion de los numero correspondientes a las categorias
    let genreArray = ["6018", "6000", "6022", "6017", "6016", "6015", "6023", "6014", "6013", "6012", "6020", "6011", "6010", "6009", "6021" , "6008", "6007", "6006","6024", "6005", "6004", "6003", "6002", "6001"]
    
     var timer = Timer()
    var name = ""
    
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(image: UIImage(named: "background_2.jpg"))
        imageView.alpha = 0.5
        
        imageView.contentMode = .scaleAspectFill
        tableView.backgroundView = imageView
        
        
        if UserDefaults.standard.string(forKey: "welcome") == nil {
            
            let alertVC = PMAlertController(title: "Welcome to Top Apps", description: "Please Enter Your Name", image: UIImage(named: "exclametionMark.png"), style: .alert)
            
            alertVC.addTextField { (textField) in
                textField?.placeholder = "E.g: Orlando"
            }
            
        
            alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
                
                self.name = alertVC.textFields[0].text!
                self.perform(#selector(CategoryTableViewController.secondAlert), with: nil, afterDelay: 0.5)
               
            }))
            
           
            self.present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    func secondAlert () {
        
        let alertVC2 = PMAlertController(title: "Welcome " + self.name, description: "Here you will find the top 25 Apps for each category shown. Don't forget to visit 'Info' on the left top corner. Enjoy", image: UIImage(named:"ranking.png"), style: .walkthrough )
        
        alertVC2.addAction(PMAlertAction(title: "Ok", style: .default, action: {
            UserDefaults.standard.set("welcomed", forKey: "welcome")
        }))
        
        self.present(alertVC2, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CategoryTableViewController.reachabilityChanged(note:)),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
        NotificationCenter.default.post(name: ReachabilityChangedNotification, object: reachability)
        
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 50.0)
        }
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationController?.navigationBar.alpha = 0
        
        UIView.animate(withDuration: 0.5) { 
             self.navigationController?.navigationBar.alpha = 1
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.stopFollowingScrollView()
        }
        
        self.navigationController?.navigationBar.isHidden = true
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
        }
        return true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        
        return headerView
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = categoryArray[indexPath.section]
        
        cell.textLabel?.textAlignment = .center
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
             cell.textLabel?.font = UIFont(name: "Avenir", size: 40)
            
        } else {
            
             cell.textLabel?.font = UIFont(name: "Avenir", size: 20)
        }
        
       
        
        cell.layer.cornerRadius = 8
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1

        return cell
    }
 

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            let indexPath: IndexPath = tableView.indexPathForSelectedRow!
            
            let appVC = segue.destination as! AppCollectionViewController
            
            appVC.categoryNumber = genreArray[indexPath.section]
            appVC.appTitle = categoryArray[indexPath.section]
            
        } else {
            
            let indexPath: IndexPath = tableView.indexPathForSelectedRow!
            
            let appVC = segue.destination as! AppsTableViewController
            
            appVC.categoryNumber = genreArray[indexPath.section]
            appVC.appTitle = categoryArray[indexPath.section]
        }
        
    }
    
    @IBAction func unwindFromAppController (_ sender: UIStoryboardSegue) {
        
        
    }
    
    // MARK: - Reachability for internet connection
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            
            
            //application.createAlert(title: "Oops!", message: "You don't have Internet connection!")
            
            self.perform(#selector(CategoryTableViewController.alert), with: nil, afterDelay: 1)
            
        }
    }
    
    func alert() {
        
        createAlert(title: "Opps!", message: "You don't have Internet connection!")
        
    }
    
    // Helper method for creating alerts
    
    func createAlert (title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    

    // MARK: - Guillotine Meny Setup
    @IBAction func showMenu2(_ sender: Any) {
        setUpMenu()
    }
    @IBAction func showMenu(_ sender: Any) {
        
       setUpMenu()
    }
    
    
    func setUpMenu () {
        let menuViewController = storyboard!.instantiateViewController(withIdentifier: "guillotineMenu") as! MenuViewController
        menuViewController.modalPresentationStyle = .custom
        menuViewController.transitioningDelegate = self
        
        presentationAnimator.animationDelegate = menuViewController
        
        presentationAnimator.animationDuration = 0.5
        presentationAnimator.supportView = navigationController!.navigationBar
        present(menuViewController, animated: true, completion: nil)
    }

}

extension CategoryTableViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .presentation
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }
}
