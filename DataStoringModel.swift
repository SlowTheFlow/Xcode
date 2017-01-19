//
//  DataStoringModel.swift
//  SloTheFlow
//
//  Created by Kyle Trambley on 12/22/16.
//  Copyright © 2016 Kyle Trambley. All rights reserved.
//

import Foundation

import UIKit

typealias dataTuple = (ammount: Int, setting: Int, dt: String) // tuple to hold data
var dataHistory: [dataTuple] = [] // Array to hold all of the time data

func addData (Ammount: Int, Setting: Int) -> Void {
    var timeFormat = DateFormatter() // allows us to store the date and time as a string
    timeFormat.dateStyle = .medium // formats the date
    timeFormat.timeStyle = .short // formats the time
    var theDateAndTime = timeFormat.string(from: Date()) // stores the date and time in a string
    var tempData: dataTuple = (Ammount, Setting, theDateAndTime) // creates the Data tuple
    dataHistory.append(tempData) // adds the data tuple to the array
}

