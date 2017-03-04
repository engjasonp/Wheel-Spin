//
//  ViewController.swift
//  Wheel Spin
//
//  Created by Jason Eng on 2/25/17.
//  Copyright © 2017 EngJason. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties
    @IBOutlet weak var randomWordLabel: UILabel!
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var words: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        wordTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        words.append(wordTextField.text!)
        wordTextField.text = ""
        wordTextField.resignFirstResponder()
        tableView.reloadData()
        scrollToBottomOfView()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.characters.count > 0 else {
            return true
        }
        
        let currentText = textField.text ?? ""
        
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        return prospectiveText.characters.count <= 30
    }
    
    // MARK: UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entry", for: indexPath)
        cell.textLabel?.text = words[indexPath.row]
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            words.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: Scroll to bottom
    func scrollToBottomOfView() {
        let indexPath = IndexPath(row: words.count - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    // MARK: Keyboard
    
    func tap(gesture: UITapGestureRecognizer) {
        wordTextField.resignFirstResponder()
    }

    // MARK: Actions
    @IBAction func randomizeWord(_ sender: UIButton) {
        wordTextField.resignFirstResponder()
        // If list contains words, randomize order of words in words array
        if words.count > 0 {
            let shuffledArray = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: words) as! [String]
            randomWordLabel.text = shuffledArray[0]
        }
    }
    
    @IBAction func submitWord(_ sender: UIButton) {
        if wordTextField.text != "" {
            words.append(wordTextField.text!)
            wordTextField.text = ""
            wordTextField.resignFirstResponder()
            tableView.reloadData()
            scrollToBottomOfView()
        }
    }
    
}
