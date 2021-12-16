//
//  NoteViewController.swift
//  MilestoneProjects19-21
//
//  Created by Igor Polousov on 16.12.2021.
//

import UIKit

// Добавлено соответсвие SendNotesDelegate чтобы передавать данные массива notes между контроллерами
class NoteViewController: UITableViewController, SendNotesDelegate {
    
    // Массив с заметками
    var notes = [Note]()
    // Кнопка которая будет отображать количество заметок
    var notesCountInfo: UIBarButtonItem!
    // Переменная с обозревателем для количества заметок( можно попробовать убрать)
    var notesCount = 0 {
       didSet {
           notesCountInfo?.title = "\(notesCount) Notes"
       }
   }
    
    override func viewWillAppear(_ animated: Bool) {
        // Перезагрузка таблицы при переходе между view controllers
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Загрузка заметок при старте приложения
        loadData()
        
        title = "Notes"
        
        // Установка цвета кнопок
        navigationController?.toolbar.tintColor = .systemOrange
        // Установка кнопок и пробелов между ними
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let newNoteButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNewNote))
        notesCountInfo = UIBarButtonItem(title: "\(notes.count) Notes", image: nil, primaryAction: nil, menu: nil)
        toolbarItems = [space,notesCountInfo, space, newNoteButton]
        // Чтобы кнопки отображались на экране
        navigationController?.isToolbarHidden = false

      
    }

    // Добавление заметки с переходом на detailViewController
    @objc func addNewNote() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController {
            vc.delegate = self // должно быть установлено в каждом переходе для передачи notes
            vc.notes = notes
            vc.newNote = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notesCount = notes.count
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
    // Загрузка данных
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
    // Сохранение данных
    func saveData() {
        let defaults = UserDefaults.standard
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(notes) {
            defaults.setValue(savedData, forKey: "notes")
        }
    }
    // Соответстиве протоколу SendNotesDelegate
    func transferNotes(_ notes: [Note]) {
        self.notes = notes
    }

}
