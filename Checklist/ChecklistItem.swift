//
//  ChecklistItem.swift
//  Checklist
//
//  Created by APPLE on 2019/11/18.
//  Copyright © 2019 JeongminKim. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {
    
    @objc var text = ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
}
