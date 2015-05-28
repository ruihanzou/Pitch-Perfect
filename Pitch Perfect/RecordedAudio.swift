//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Ruihan Zou on 5/26/15.
//  Copyright (c) 2015 Ruihan Zou. All rights reserved.
//

import Foundation
class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    init(filePathUrl: NSURL!, title: String!) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}