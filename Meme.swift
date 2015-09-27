//
//  Meme.swift
//  MemeMe1
//
//  Created by Pekka Kaariainen on 27/09/15.
//  Copyright (c) 2015 Pekka Kaariainen. All rights reserved.
//

import Foundation
import UIKit
class Meme: NSObject{
    
    var topText: String!
    var bottomText: String!
    var image: UIImage!
    var memeImage: UIImage!
    
    init(topText: String, bottomText: String, image: UIImage, memeImage: UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memeImage = memeImage
    }
}