//
//  AuthorsViewController.swift
//  Library
//
//  Created by Bart Jacobs on 06/12/15.
//  Copyright © 2015 Envato Tuts+. All rights reserved.
//

import UIKit

class AuthorsViewController: UITableViewController {

    let CellIdentifier = "Cell Identifier"
    let SegueBooksViewController = "BooksViewController"
    
    var authors = [AnyObject]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tabBarItem = UITabBarItem(title: "Authors", image: UIImage(named: "icon-authors"), tag: 0)
    }
    
    // MARK: -
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Title
//        title = "Authors"
        navigationItem.title = "Authors"
        
        let filePath = Bundle.main.path(forResource: "Books", ofType: "plist")
        
        if let path = filePath {
            authors = NSArray(contentsOfFile: path) as! [AnyObject]
        }
        
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueBooksViewController {
            if let indexPath = tableView.indexPathForSelectedRow, let author = authors[indexPath.row] as? [String: AnyObject]  {
                let destinationViewController = segue.destination as! BooksViewController
                destinationViewController.author = author
            }
        }
    }
    
    // MARK: -
    // MARK: Table View Data Source Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue Resuable Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
        
        if let author = authors[indexPath.row] as? [String: AnyObject], let name = author["Author"] as? String {
            // Configure Cell
            cell.textLabel?.text = name
        }
        
        return cell;
    }
    
    // MARK: -
    // MARK: Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Perform Segue
        performSegue(withIdentifier: SegueBooksViewController, sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
