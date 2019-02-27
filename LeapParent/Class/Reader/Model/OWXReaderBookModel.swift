//
//  OWXReaderBookModel.swift
//  LeapParent
//
//  Created by 王史超 on 2018/7/2.
//  Copyright © 2018年 offcn. All rights reserved.
//

import UIKit

class OWXReaderBookModel: OWXBaseModel {

    var book_id: String!
    var pages: [OWXReaderPageModel]!
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["pages" : OWXReaderPageModel.self]
    }
    
}
