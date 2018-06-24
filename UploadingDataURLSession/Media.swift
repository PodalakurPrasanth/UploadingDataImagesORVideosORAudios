//
//  Media.swift
//  UploadingDataURLSession
//
//  Created by Apple on 24/06/18.
//  Copyright © 2018 Prasanth. All rights reserved.
//

import Foundation
import UIKit

struct Media {
    let key: String
    let filename: String
    var data: Data?
    let mimeType: String
    
    init?(withImage image: UIImage?, forKey key: String,imageName:String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = imageName+".jpg"
        if image != nil {
            guard let data = UIImageJPEGRepresentation(image!, 0.7) else { return nil }
            self.data = data
        }else{
            //guard let data = UIImageJPEGRepresentation(image!, 0.7) else { return nil }
            self.data = nil
        }
        //        guard let data = UIImageJPEGRepresentation(image!, 0.7) else { return nil }
        //        self.data = data
    }
    
}
