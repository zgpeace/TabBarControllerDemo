//
//  BooksViewController.swift
//  Library
//
//  Created by Bart Jacobs on 07/12/15.
//  Copyright © 2015 Envato Tuts+. All rights reserved.
//

import UIKit

class BooksViewController: UITableViewController {

    let CellIdentifier = "Cell Identifier"
    let SegueBookCoverViewController = "BookCoverViewController"
    
    var author: [String: AnyObject]?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tabBarItem = UITabBarItem(title: "Books", image: UIImage(named: "icon-books"), tag: 1)
        tabBarItem.badgeValue = "8"
    }
    
    lazy var books: [AnyObject] = {
       var buffer = [AnyObject]()
        
        if let author = self.author, let books = author["Books"] as? [AnyObject] {
            buffer += books
        } else {
            let filePath = Bundle.main.path(forResource: "Books", ofType: "plist")
            
            if let path = filePath {
                let authors = NSArray(contentsOfFile: path) as! [AnyObject]
                
                for author in authors {
                    if let books = author["Books"] as? [AnyObject] {
                        buffer += books
                    }
                }
            }
        }
        
        return buffer
    }()
    
    
    // MARK: -
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let author = author, let name = author["Author"] as? String {
            title = name
        } else {
            title = "Books"
        }
        
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueBookCoverViewController {
            if let indexPath = tableView.indexPathForSelectedRow, let book = books[indexPath.row] as? [String: String]  {
                let destinationViewController = segue.destination as! BookCoverViewController
                destinationViewController.book = book
            }
        }
    }
    
    // MARK: -
    // MARK: Table View Data Source Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue Resuable Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
        
        if let book = books[indexPath.row] as? [String: String], let title = book["Title"] {
            // Configure Cell
            cell.textLabel?.text = title
        }
        
        return cell;
    }
    
    // MARK: -
    // MARK: Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Perform Segue
        performSegue(withIdentifier: SegueBookCoverViewController, sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
