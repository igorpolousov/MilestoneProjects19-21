//
//  NoteViewController.swift
//  MilestoneProjects19-21
//
//  Created by Igor Polousov on 16.12.2021.
//

import UIKit

class NoteViewController: UITableViewController, SendNotesDelegate {
    
    var notes = [Note]()
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        title = "Notes"
        
        navigationController?.toolbar.tintColor = .systemOrange
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let newNoteButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNewNote))
        let NotesCountInfo = UIBarButtonItem(title: "\(notes.count) Notes", image: nil, primaryAction: nil, menu: nil)
        toolbarItems = [space,NotesCountInfo, space, newNoteButton]
        navigationController?.isToolbarHidden = false

      
    }

    @objc func addNewNote() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController {
            vc.delegate = self
            vc.notes = notes
            vc.newNote = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].noteTitle
        cell.detailTextLabel?.text = notes[indexPath.row].noteText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            saveData()
        }
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController {
            vc.noteText = notes[indexPath.row].noteTitle
            vc.delegate = self
            vc.newNote = false
            vc.noteIndex = indexPath.row
            vc.notes = notes
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func loadData() {
        let defaults = UserDefaults.standard
        let jsonDecoder = JSONDecoder()
        
        if let savedData = defaults.object(forKey: "notes") as? Data {
            do {
                notes = try jsonDecoder.decode([Note].self, from: savedData)
            } catch {
                print("Unable to load data")
            }
        }
    }
    
    func saveData() {
        let defaults = UserDefaults.standard
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(notes) {
            defaults.setValue(savedData, forKey: "notes")
        }
    }
    
    func transferNotes(notes: [Note]) {
        self.notes = notes
    }

}
