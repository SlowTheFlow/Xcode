//
//  DataAnalysisModel.swift
//  SloTheFlow
//
//  Created by Kyle Trambley on 12/24/16.
//  Copyright © 2016 Kyle Trambley. All rights reserved.
//

import Foundation
import UIKit

func analyzeData() -> (String, Int) {
    let tempData = dataHistory[dataHistory.count - 1]
    let Ammount = tempData.ammount
    let Setting = tempData.setting
    
    if (Ammount > Setting) {
        return ("Overflow", (Ammount - Setting))
    }
    else if (Setting > Ammount) {
        return ("Underflow", (Setting - Ammount))
    }
    else {
        return ("Normal", 0)
    }
}























