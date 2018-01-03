//
//  ViewController.swift
//  Bluetooth
//
//  Created by Noé on 14.11.17.
//  Copyright © 2017 Liip AG. All rights reserved.
//

import UIKit
import os.log
import CoreBluetooth

class ViewController: UIViewController {
  let nokeServiceUUID = CBUUID(string: "1BC50001-0200-D29E-E511-446C609DB825")

  var centralManager: CBCentralManager!
  var peripheral: CBPeripheral?

  override func viewDidLoad() {
    super.viewDidLoad()

    centralManager = CBCentralManager(delegate: self, queue: nil)
  }
}

extension ViewController: CBCentralManagerDelegate {
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    os_log("[TestBluetooth] State updated")

    switch central.state {
    case .poweredOn:
      os_log("[TestBluetooth] Bluetooth ON")
      os_log("[TestBluetooth] Start scan")

      centralManager.scanForPeripherals(withServices: [nokeServiceUUID], options: [CBCentralManagerScanOptionSolicitedServiceUUIDsKey: [nokeServiceUUID]])

    case .poweredOff:
      os_log("[TestBluetooth] Bluetooth OFF")
    default:
      break
    }
  }

  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
    os_log("[TestBluetooth] Peripheral discovered %@ %@", peripheral.name ?? "/!\\ NO NAME", peripheral.identifier.description)

    self.peripheral = peripheral
    peripheral.delegate = self
    centralManager.connect(peripheral, options: nil)
  }

  func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
    os_log("[TestBluetooth] Peripheral willRestoreState %@", dict)
  }

  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    os_log("[TestBluetooth] Peripheral connected %@", peripheral.identifier.description)
    centralManager.cancelPeripheralConnection(peripheral)
  }

  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    os_log("[TestBluetooth] Peripheral disconnected %@", peripheral.identifier.description)
  }
}

extension ViewController: CBPeripheralDelegate {
}
