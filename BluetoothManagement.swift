//
//  BluetoothManagement.swift
//  SloTheFlow
//
//  Created by Kyle Trambley on 1/4/17.
//  Copyright © 2017 Kyle Trambley. All rights reserved.
//

/********************************************************************************************************
 Note: Option Click on the CBCentralManager and then open the developer docs to read about core bluetooth
*********************************************************************************************************/

import CoreBluetooth
// defines the blueprint for a method needed for the CBCentralManager.
protocol SimpleBluetoothIODelegate: class {
    // The func takes in something of type SimpleBluetoothIO Class [defined below] and a value of type Int8
    func simpleBluetoothIO(simpleBluetoothIO: SimpleBluetoothIO, didReceiveValue value: Int8)
}

class SimpleBluetoothIO: NSObject {
    // Creating Variables
    let serviceUUID: String
    weak var delegate: SimpleBluetoothIODelegate?
    
    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    var targetService: CBService?
    var writableCharacteristic: CBCharacteristic?
    // Initializing the class with a type string and a type SimpleBluetoothIODelegate
    init(serviceUUID: String, delegate: SimpleBluetoothIODelegate?) {
        // set variables equal to what is being taken in
        self.serviceUUID = serviceUUID
        self.delegate = delegate
        // Since this class is of type NSObject, it needs to be initialized at a higher inheritence level
        super.init()
        // Setting the varble equal to the Core Bluetooth Central Manager with the delegate taking in itself (nil doesnt matter)
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    // This funciton can be called to write a value to the Peripheral
    func writeValue(value: Int8) {
        // Checking to see if we have a connectedPeripheral and the Characteristics associated with it to write to
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        // Creating the data we want to send using the Int8.swift file
        let data = NSData.dataWithValue(value: value)
        peripheral.writeValue(data as Data, for: characteristic, type: .withResponse)
    }
    
}
// Adding onto the SimpleBluetoothIO Class and making it of type CBCentralManagerDelagate
extension SimpleBluetoothIO: CBCentralManagerDelegate {
    
    // this function discovers the Services of the peripheral
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
    // This function Connects to a Peripheral
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        
        connectedPeripheral = peripheral
        
        // if discovered peripheral is the peripheral we want connect to it
        if let connectedPeripheral = connectedPeripheral {
            connectedPeripheral.delegate = self
            centralManager.connect(connectedPeripheral, options: nil)
        }
        centralManager.stopScan()
    }
    // This funciton scans for Peripherals advertizing
    // the underscore in front of central means it has different argument names from those required by protocol CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // Checks to see if the bluetooth chip is powered on
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: [CBUUID(string: serviceUUID)], options: nil)
        }
    }
}

// Adding onto the SimpleBluetoothIO Class and making it of type CBPeripheralDelegate
extension SimpleBluetoothIO: CBPeripheralDelegate {
    // Allow the services we want to be unwrapped
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        guard let services = peripheral.services else {
            return
        }
        
        targetService = services.first
        // if service can be eual to the first service, set Target service equal to it and look for the characterstics of that service
        if let service = services.first {
            targetService = service
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        // if the unwrapped service charactersistic exists, lets use it
        guard let characteristics = service.characteristics else {
            return
        }
        
        for characteristic in characteristics {
            // checks to see if there is a charactersistic we can write to
            if characteristic.properties.contains(.write) || characteristic.properties.contains(.writeWithoutResponse) {
                writableCharacteristic = characteristic
            }
            // Unknown, it will set a notificaiton
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        // if there is data inside of the charactersitics, lets use it
        guard var data = characteristic.value, let delegate = delegate else {
            return
        }
        // delegate uses the data it recieved 
        delegate.simpleBluetoothIO(simpleBluetoothIO: self, didReceiveValue: (data as NSData).int8Value())
    }
}
