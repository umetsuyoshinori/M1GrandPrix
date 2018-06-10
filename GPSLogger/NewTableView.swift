//
//  newTableView.swift
//  GPSLogger
//
//  Created by 梅津吉雅 on 2018/06/08.
//  Copyright © 2018年 Kosuke Ogawa. All rights reserved.
//

import UIKit

class NewTableView: UITableView {
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}