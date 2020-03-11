//
//  HomeTableTableViewController.swift
//  Twitter
//
//  Created by Roy Perlman on 3/4/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableTableViewController: UITableViewController
{
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    let myRefeshControl = UIRefreshControl()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadTweet()
        myRefeshControl.addTarget(self, action: #selector(loadTweet), for: .valueChanged)
        tableView.refreshControl = myRefeshControl
            /*self.tweetTextView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 50*/
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        self.loadTweet()
    }
    
    @objc func loadTweet()
    {
    numberOfTweets = 20
    let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    let myParams = ["count":numberOfTweets]
        
    TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success:
        {
            (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets
            {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.myRefeshControl.endRefreshing()
            
        }, failure: {(Error) in
        print("Could not retreive tweets!")
        })
    }
    
    func loadMoreTweets()
    {
        let myUrl = "https://api.twitter.com/1.1statuses/home_timeline.json"
        numberOfTweets = numberOfTweets + 20
        let myParams = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success:
        {
            (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets
            {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.myRefeshControl.endRefreshing()
        },
        failure:
        {
          (Error) in
          print("Could not retreive tweets!")
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if indexPath.row + 1 == tweetArray.count
        {
            loadMoreTweets()
        }
    }
   
    @IBAction func onLogout(_ sender: Any)
    {
        TwitterAPICaller.client?.logout()
        
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetConent.text = tweetArray[indexPath.row]["text"] as? String
        
        let imageUrl = URL(fileURLWithPath: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl)
        
        if let imageData = data
        {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        cell.setFavorited(tweetArray[indexPath.row]["favorted"] as! Bool)
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tweetArray.count
    }
}