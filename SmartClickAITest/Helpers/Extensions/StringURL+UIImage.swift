//
//  StringURL+UIImage.swift
//  SmartClickAITest
//
//  Created by Sos Avetyan on 5/22/20.
//  Copyright © 2020 Sos Avetyan. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func makeUIImage() -> UIImage? {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first
        {
           let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(self)
           let image    = UIImage(contentsOfFile: imageURL.path)
            return image
        }
        return nil
    }
    
    func imageURL() -> URL? {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
               let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
               let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
               if let dirPath = paths.first
               {
                  return URL(fileURLWithPath: dirPath).appendingPathComponent(self)
               }
               return nil
    }
    
}
