//
//  Note.swift
//  MilestoneProjects19-21
//
//  Created by Igor Polousov on 16.12.2021.
//

import Foundation

class Note: Codable {
    
    var noteTitle: String
    var noteText: String
    
    init(noteTitle: String, noteText: String) {
        self.noteTitle = noteTitle
        self.noteText = noteText
    }
    
}
