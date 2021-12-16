//
//  DetailViewController.swift
//  MilestoneProjects19-21
//
//  Created by Igor Polousov on 16.12.2021.
//

import UIKit
// Протокол для передачи данных
protocol SendNotesDelegate {
    func transferNotes(_ notes: [Note])
}

class DetailViewController: UIViewController {
    
    var notes = [Note]()
    var newNote: Bool!
    var noteText: String!
    var noteIndex: Int!
    @IBOutlet var textView: UITextView!
    
    var deletedNote =  false
    var originalText: String!
    // Для передачи данных delegate
    var delegate: SendNotesDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = noteText
        originalText = noteText
        
        title = "Note"
        // Установка цвета кнопок и текста
        navigationController?.toolbar.tintColor = .systemOrange
        navigationController?.navigationBar.tintColor = .systemOrange
        // Установка кнопок навигации
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done)), UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))]
        // Установка нижних кнопок
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        let newNoteButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNote))
        toolbarItems = [trashButton, space, newNoteButton]
        navigationController?.isToolbarHidden = false
        // Подписка на уведомления notification center для метода adjustForKeyboard
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification , object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification , object: nil)

    }
    // Сохранение заметки при нажитии кнопки назад
    override func viewWillDisappear(_ animated: Bool) {
        addingNotes()
        saveData()
        updateDelegate()
        textView.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    // Сохранение заметки при нажатии кнопки done
    @objc func done() {
        addingNotes()
        saveData()
        updateDelegate()
        textView.endEditing(true)
        newNote = false
    }
    
    // Нажатие кнопки поделиться заметкой
    @objc func shareNote() {
        if let index = noteIndex {
            let ac = UIActivityViewController(activityItems: [notes[index].noteTitle], applicationActivities: [])
            present(ac, animated: true)
        }
    }
    
    // Нажатие кнопки корзина
    @objc func deleteNote() {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.forDeleteNote()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    // Вспомогательная для deleteNote()
    func forDeleteNote() {
        deletedNote = true
        if let index = noteIndex {
            notes.remove(at: index)
        }
        if notes.count == 0 {
            noteIndex = nil
        }
        noteIndex = nil
        textView.text = ""
        deletedNote = false
        newNote = true
        updateDelegate()
        saveData()
    }
    
    // Нажатие кнопки новая заметка
    @objc func addNote() {
        saveData()
        newNote = true
        updateDelegate()
        noteIndex = nil
        textView.text = ""
    }
    // Функция проверки добавления новой заметки или редактирования старой
    func addingNotes() {
        if !deletedNote {
            if textView.text != "" && newNote {
                let example = Note(noteTitle: textView.text, noteText: "")
                notes.insert(example, at: 0)
            }
            
            if textView.text != originalText {
                if let text = textView.text {
                    if let index = noteIndex {
                        notes[index].noteTitle = text
                        
                    }
                }
            }
        }
    }
    
    // Функция для указания кодгда нужно передавть данные в NoteViewController
    func updateDelegate() {
        delegate?.transferNotes(notes)
    }
    // Сохранение данных
    func saveData() {
        let defaults = UserDefaults.standard
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(notes) {
            defaults.setValue(savedData, forKey: "notes")
        }
    }
    
    // Настройки для клавиатуры
    @objc func adjustForKeyboard(notification: Notification) {
        
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
        
    }

}
