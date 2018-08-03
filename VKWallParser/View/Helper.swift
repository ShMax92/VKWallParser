//
//  Helper.swift
//  VKWallParser
//
//  Created by Maxim Shirko on 01.08.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

import UIKit

extension UIImageView{
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
