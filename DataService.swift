//
//  DataService.swift
//  showcase-dev
//
//  Created by Alex Beattie on 11/6/15.
//  Copyright © 2015 Alex Beattie. All rights reserved.
//

import Foundation
import Firebase


class DataService {
   
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url:"https://artisanbranding.firebaseio.com/")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
}