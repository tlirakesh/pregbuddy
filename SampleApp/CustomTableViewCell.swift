//
//  CustomTableViewCell.swift
//  SampleApp
//
//  Created by Admin on 06/03/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

protocol CustomTableViewCellDelegate:NSObjectProtocol {
    func favTapped(_ cell:CustomTableViewCell, _ tweet:TweetDTO)
}

class CustomTableViewCell: UITableViewCell
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bookmarkImage: UIImageView!
    
    var delegate:CustomTableViewCellDelegate?
    var tweet:TweetDTO = TweetDTO()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func favButtonTapped(_ sender: Any) {
        self.delegate?.favTapped(self, tweet)
    }
    
}


