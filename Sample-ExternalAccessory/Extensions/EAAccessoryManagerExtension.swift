//
//  EAAccessoryManagerExtension.swift
//  Sample-ExternalAccessory
//
//  Created by NishiokaKohei on 2017/12/27.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import Foundation
import ExternalAccessory

protocol EAManagable {
    var readConnectedAccessories: [EAAccessing] { get }
    func showAccessoryPicker(withNameFilter predicate: NSPredicate?, completion: EABluetoothAccessoryPickerCompletion?)
}

extension EAManagable {
    var readConnectedAccessories: [EAAccessing] {
        get {
            return EAAccessoryManager.shared().connectedAccessories
        }
    }
    func showAccessoryPicker(withNameFilter predicate: NSPredicate?, completion: EABluetoothAccessoryPickerCompletion?) {
        EAAccessoryManager.shared().showBluetoothAccessoryPicker(withNameFilter: predicate, completion: completion)
    }
}

extension EAAccessoryManager: EAManagable { }
