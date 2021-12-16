//
//  Note.swift
//  MilestoneProjects19-21
//
//  Created by Igor Polousov on 16.12.2021.
//

import Foundation

// Класс заметок с протоколом codable чтобы можно было сохранять заметки
class Note: Codable {
    
    var noteTitle: String
    // Функционал не используется, можно поменять на дату создания и модификации
    var noteText: String
    
    init(noteTitle: String, noteText: String) {
        self.noteTitle = noteTitle
        self.noteText = noteText
    }
    
}
