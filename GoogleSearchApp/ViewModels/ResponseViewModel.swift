//
//  ResponseViewModel.swift
//  GoogleSearchApp
//
//  Created by Dima Shelkov on 7/10/19.
//  Copyright © 2019 Dima Shelkov. All rights reserved.
//

import Foundation

struct ResponseViewModel {
    let title: String
    let link: String
    
    init(response: GoogleResponse) {
        self.title = response.title
        self.link = response.displayLink
    }
}

