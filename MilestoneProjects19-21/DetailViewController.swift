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
    
    var delegate: SendNotesDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

}
