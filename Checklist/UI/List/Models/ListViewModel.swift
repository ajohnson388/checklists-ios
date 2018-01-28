//
//  ListLiveData.swift
//  Checklist
//
//  Created by Andrew Johnson on 12/17/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation

protocol ListModelOutputProtocol: class {
    func onListLoaded()
    func onListLoadError()
}

/**
    TODO: Fix Listener
 
    Responsible for changing, retrieving, and observering a list. This class should be
    used only in ViewModel classes as member variables.
 */
final class ListViewModel: NSObject {
    
    
}
