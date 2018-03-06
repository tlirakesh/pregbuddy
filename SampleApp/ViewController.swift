//
//  ViewController.swift
//  SampleApp
//
//  Created by Admin on 06/03/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import STTwitter
import Accounts


class ViewController: UIViewController,UIScrollViewDelegate {

    let kTwitterConsumerKey = "EHr8H7VDXRROXWBz4skJ2x5mU"
    let kTwitterSecretKey = "9K4xVSKociGudbZ24T1TfPaj9Bz55I2Jp0lt3Q0CconEhhPNSc"
    let kTwitterAccessToken = "382006942-KbQUIKl4Hhe3ZeBCRxz2gXLNjfvr07JC1JnFtPfp"
    let kTwitterAccessTokenSecret = "Vt6gxLtj0QzJsWLr6sJIs5Z4H3obtEprMmM8nOwdpI8sk"
    
    var searchResults:[TweetDTO] = []
    var totalSearchResults:[TweetDTO] = []
    
    var displayedSearchResults:[TweetDTO] = []
    var displayedTotalResults:[TweetDTO] = []
    
    var bookmarksList:[TweetDTO] = []
    
    @IBOutlet weak var tableview:UITableView!
    @IBOutlet weak var loader:UIActivityIndicatorView!
    @IBOutlet weak var segmentControl:UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = "Tweets"
        self.tableview.tableFooterView = UIView()
        if self.segmentControl.numberOfSegments > 2
        {
            self.segmentControl.setWidth(50.0, forSegmentAt: 0)
            self.segmentControl.setWidth(100.0, forSegmentAt: 1)
            self.segmentControl.setWidth(120.0, forSegmentAt: 2)
        }
        
        let twitter = STTwitterAPI.init(oAuthConsumerKey: kTwitterConsumerKey, consumerSecret: kTwitterSecretKey, oauthToken: kTwitterAccessToken, oauthTokenSecret: kTwitterAccessTokenSecret)

        twitter!.verifyCredentials(userSuccessBlock: { (username, userId) -> Void in
        
            twitter!.getSearchTweets(withQuery: "pregnancy", geocode: "12.8522117,77.6707922,100mi", lang: "en", locale: "", resultType: "recent", count: "100", until: "2018-03-03", sinceID: "0", maxID: "0", includeEntities: 1, callback: "", useExtendedTweetMode: 1, successBlock: { (searchMetadata, statuses) in
                
                for result in statuses!
                {
                    let tweet:TweetDTO = TweetDTO()
                    let resultTweet = result as? NSDictionary ?? NSDictionary()
                    tweet.text = resultTweet.object(forKey: "full_text") as? String ?? ""
                    tweet.likesCount = resultTweet.object(forKey: "favorite_count") as? Int ?? 0
                    tweet.retweetCount = resultTweet.object(forKey: "retweet_count") as? Int ?? 0
                    self.totalSearchResults.append(tweet)
                }
                
                if self.totalSearchResults.count > 20
                {
                    let arraySlice = self.totalSearchResults.prefix(20)
                    self.displayedTotalResults = Array(arraySlice)
                }
                //self.searchResults.sort {$0.retweetCount > $1.retweetCount}
                self.tableview.reloadData()
                self.loader.stopAnimating()
            }, errorBlock: { (error) in
                print(error?.localizedDescription ?? "no results")
            })
            
            //commented this code because it will only top 15 results
//            twitter!.getSearchTweets(withQuery: "pregnancy", successBlock: { (searchMetadata, statuses) in
//                print(searchMetadata as! NSDictionary)
//                print(statuses!)
//
//                for status in statuses!
//                {
//                    let dic = status as? Dictionary<String, Any>
//                    print("\n")
//                    print(dic!["text"] as? String ?? "")
//                }
//            }, errorBlock: { (error) in
//                print(error?.localizedDescription ?? "no results")
//            })
        }) { (error) -> Void in
            print(error?.localizedDescription ?? "login error")
        }
    }

    @IBAction func segmentChanged()
    {
        searchResults = []
        displayedSearchResults = []
        displayedTotalResults = []
        
        self.tableview.setContentOffset(CGPoint.zero, animated: false)

        switch segmentControl.selectedSegmentIndex {
        case 0:
            if self.totalSearchResults.count > 20
            {
                let arraySlice = self.totalSearchResults.prefix(20)
                self.displayedTotalResults = Array(arraySlice)
            }
//            displayedTotalResults = totalSearchResults
            break
        case 1:
            searchResults = totalSearchResults
            searchResults.sort {$0.likesCount > $1.likesCount}
            if searchResults.count > 10
            {
                displayedSearchResults = Array(searchResults.prefix(10))
            }
//            displayedSearchResults = searchResults
            break
        case 2:
            searchResults = totalSearchResults
            searchResults.sort {$0.retweetCount > $1.retweetCount}
            if searchResults.count > 10
            {
                displayedSearchResults = Array(searchResults.prefix(10))
            }
//            displayedSearchResults = searchResults
            break
        default:
            break
        }
        
        UIView.animate(withDuration: 0, delay: 0.5, options: .curveEaseInOut, animations: {
        }, completion: { (status) in
            self.tableview.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadNextPage(_ nextCount:Int)
    {
        if searchResults.count > 0
        {
            let lastIndex = displayedSearchResults.count
            for _ in 1 ..< nextCount
            {
                var tweet:TweetDTO = TweetDTO()
                if lastIndex < searchResults.count
                {
                    tweet = searchResults[lastIndex]
                    displayedSearchResults.append(tweet)
                }
            }
        }
        else
        {
            let lastIndex = displayedTotalResults.count

            for _ in 1 ..< nextCount
            {
                var tweet:TweetDTO = TweetDTO()
                if lastIndex < totalSearchResults.count
                {
                    tweet = totalSearchResults[lastIndex]
                    displayedTotalResults.append(tweet)
                }
            }
        }
        
        tableview.reloadData()
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if displayedSearchResults.count > 0
        {
            return displayedSearchResults.count
        }
        else
        {
            return displayedTotalResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! CustomTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        var tweet:TweetDTO = TweetDTO()
        if displayedSearchResults.count > 0 && displayedSearchResults.count > indexPath.row
        {
            tweet = displayedSearchResults[indexPath.row]
        }
        else if displayedTotalResults.count > indexPath.row
        {
            tweet = displayedTotalResults[indexPath.row]
        }
        cell.tweet = tweet
        cell.titleLabel?.text = tweet.text
        cell.titleLabel?.numberOfLines = 2
        cell.descriptionLabel?.text = "Likes : \(tweet.likesCount) Retweets : \(tweet.retweetCount)"

        if cell.tweet.bookMarked
        {
            cell.bookmarkImage.image = UIImage.init(named: "bookMarked")
        }
        else
        {
            cell.bookmarkImage.image = UIImage.init(named: "bookMark")
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if displayedSearchResults.count == 0
        {
            let lastIndex = displayedTotalResults.count - 1
            if indexPath.row == lastIndex && (lastIndex + 1) < totalSearchResults.count
            {
                self.loadNextPage(20)
            }
        }
    }
}

extension ViewController : CustomTableViewCellDelegate
{
    func favTapped(_ cell: CustomTableViewCell, _ tweet: TweetDTO) {
        if cell.tweet.bookMarked == false
        {
            cell.tweet.bookMarked = true
            bookmarksList.append(tweet) //add selected tweet to bookmark list
        }
        
        if self.tabBarController?.viewControllers != nil
        {
            let secondTab:BookMarkViewController = self.tabBarController?.viewControllers![1] as! BookMarkViewController
            secondTab.bookMarkList = bookmarksList
        }
        self.tableview.reloadData()
    }
}

