//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            name.text = tweet.user.name
            userName.text = tweet.retweetedByUser?.name
            print("Profile URL: ", tweet.user.profileURL! )
            let url = URL(string: tweet.user.profileURL!)!
            print("CURRENT URL", url)
            imageLabel.af_setImage(withURL: url)
            retweetedLabel.text = String(tweet.retweetCount)
            favoriteCountLabel.text = String(tweet.favoriteCount!)
            dateLabel.text = tweet.createdAtString
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func refreshData() {
        retweetedLabel.text = String(tweet.retweetCount)
        favoriteCountLabel.text = String(tweet.favoriteCount!)
    }
    
    @IBOutlet weak var tapFavorite: UIButton!
    
    @IBAction func didTapFavorite(_ sender: Any) {
        
        if(tweet.favorited! == false) {
            tweet.favorited! = true
            tweet.favoriteCount! += 1
            tapFavorite.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
            refreshData()
            APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                }
            }
        } else {
            tweet.favorited! = false
            tweet.favoriteCount! -= 1
            tapFavorite.setImage(#imageLiteral(resourceName: "favor-icon.png"), for: .normal)
            refreshData()
            APIManager.shared.unfavorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unfavoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                }
                
            }
        }
    }
    
    @IBOutlet weak var retweetSymbol: UIButton!
    
    @IBAction func onRetweet(_ sender: Any) {
        
        if !tweet.retweeted {
            tweet.retweetCount += 1
            retweetSymbol.setImage(#imageLiteral(resourceName: "retweet-icon-green.png"), for: .normal)
        }
        else {
            tweet.retweetCount -= 1
            retweetSymbol.setImage(#imageLiteral(resourceName: "retweet-icon.png"), for: .normal)
        }
        tweet.retweeted = !tweet.retweeted
        refreshData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
