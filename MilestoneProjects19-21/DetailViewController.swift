//
//  DetailViewController.swift
//  MilestoneProjects19-21
//
//  Created by Igor Polousov on 16.12.2021.
//

import UIKit

protocol SendNotesDelegate {
    func transferNotes(notes: [Note])
}

class DetailViewController: UIViewController {
    
    var notes = [Note]()
    var newNote: Bool!
    var noteText: String!
    var noteIndex: Int!
    
    var delegate: SendNotesDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Note"
        navigationController?.toolbar.tintColor = .systemOrange
        navigationController?.navigationBar.tintColor = .systemOrange
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done)), UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))]
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        let newNoteButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNote))
        toolbarItems = [trashButton, space, newNoteButton]
        navigationController?.isToolbarHidden = false
        

    }
    
    @objc func done() {
        
    }
    
    @objc func shareNote() {
        
    }
    
    @objc func deleteNote() {
        
    }
    
    @objc func addNote() {
        
    }

}
