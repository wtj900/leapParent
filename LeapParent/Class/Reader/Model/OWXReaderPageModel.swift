//
//  OWXReaderPageModel.swift
//  LeapParent
//
//  Created by 王史超 on 2018/7/2.
//  Copyright © 2018年 offcn. All rights reserved.
//

import UIKit

class OWXReaderPageModel: OWXBaseModel {

    var page_number: String!
    var sections: [OWXReaderSectionModel]!
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["sections" : OWXReaderSectionModel.self]
    }
}
