//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Roy Perlman on 3/5/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell
{
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetConent: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    var favorited:Bool = false
    var tweetId:Int = -1
    
    @IBAction func favoriteTweet(_ sender: Any)
    {
        let toBeFavorited = !favorited
        if (toBeFavorited)
        {
          TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success:
                {
                    self.setFavorited(true)
                },
                  failure:
                  {
                    (error) in
                    print("Favorite did not work: \(error)")
                  })
        }
        else
        {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success:
                {
                self.setFavorited(false)
                },
                failure:
                {
                   (error) in
                    print("Unfavorite did not work: \(error)")
                })
        }
    }
    
    @IBAction func retweet(_ sender: Any)
    {

    }
    
    func setFavorited(_ isFavorited:Bool)
    {
        favorited = isFavorited
        
        if (favorited)
        {
            favButton.setImage(UIImage(named:"favor-icon-red"), for: UIControl.State.normal)
        }
        else
        {
            favButton.setImage(UIImage(named:"favor-icon"), for: UIControl.State.normal)
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
