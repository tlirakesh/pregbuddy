//
//  BookMarkViewController.swift
//  SampleApp
//
//  Created by Admin on 06/03/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class BookMarkViewController: UIViewController
{
    var bookMarkList:[TweetDTO] = []
    @IBOutlet weak var tableview:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableview.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableview.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BookMarkViewController: UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return bookMarkList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! CustomTableViewCell
        cell.selectionStyle = .none
        var tweet:TweetDTO = TweetDTO()
        tweet = bookMarkList[indexPath.row]
        cell.titleLabel?.text = tweet.text
        cell.titleLabel?.numberOfLines = 2
        cell.descriptionLabel?.text = "Likes : \(tweet.likesCount) Retweets : \(tweet.retweetCount)"
        cell.bookmarkImage.image = UIImage.init(named: "bookMarked")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
}

