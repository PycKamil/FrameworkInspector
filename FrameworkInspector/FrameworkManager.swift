//
//  FrameworkManager.swift
//  FrameworkInspector
//
//  Created by Kamil Pyc on 07/05/2020.
//  Copyright © 2020 Kamil Pyc. All rights reserved.
//

import SwiftUI

enum FrameworkManagerState
{
    case waiting, loaded(FrameworkDescription)
}

enum FrameworkType {
    case staticLink, dynamic, unknown(String)
}

struct FrameworkDescription {
    let name: String
    let type: FrameworkType
    let architectures: [String]
}

class FrameworkManager: NSObject, ObservableObject
{
    @Published var state = FrameworkManagerState.waiting
    
    func onDrop(info: DropInfo) -> Bool {
        let id = kUTTypeFileURL as String
           
        guard let itemProvider = info.itemProviders(for: [id]).first else { return false }
        
        itemProvider.loadItem(forTypeIdentifier: id, options: nil) { item, error in
        
            guard let data = item as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
        
            DispatchQueue.main.async {
                self.state = .loaded(FrameworkDescriptionProvider(frameworkUrl: url).frameworkDescription)
            }
        }
        return true
    }

}
