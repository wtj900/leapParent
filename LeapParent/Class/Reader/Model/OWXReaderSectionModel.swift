//
//  OWXReaderSectionModel.swift
//  LeapParent
//
//  Created by 王史超 on 2018/7/2.
//  Copyright © 2018年 offcn. All rights reserved.
//

import UIKit

class OWXReaderSectionModel: OWXBaseModel {

    var section_sequence: String!
    var text: String!
    var audio_filename: String!
    var words: [OWXReaderWordModel]!
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["words" : OWXReaderWordModel.self]
    }
    
}
