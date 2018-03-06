//
//  OrderDetailDTO.swift
//  Tapplent
//
//  Created by Admin on 06/03/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

class TweetDTO {
    
    var text:String = ""
    var retweetCount:Int = 0
    var likesCount:Int = 0
    var bookMarked = false
    
    init()
    {
        self.text      = ""
        self.retweetCount   = 0
        self.likesCount = 0
        self.bookMarked = false
    }
}
