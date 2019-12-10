//
//  AddItemTableViewController.swift
//  Checklist
//
//  Created by APPLE on 2019/11/19.
//  Copyright © 2019 JeongminKim. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
  func ItemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
  func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
  func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController {
    
    weak var delegate: ItemDetailViewControllerDelegate?
    weak var todoList: TodoList?
    weak var itemToEdit: ChecklistItem?
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var textfield: UITextField!
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.ItemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done(_ sender: Any) {
        if let item = itemToEdit, let text = textfield.text {
            item.text = text
            delegate?.ItemDetailViewController(self, didFinishEditing: item)
        } else {
            if let item = todoList?.newTodo() {
                if let textFieldText = textfield.text {
                    item.text = textFieldText
                }
                item.checked = false
                delegate?.ItemDetailViewController(self, didFinishAdding: item)
            }
        }
        

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = itemToEdit {
            title = "수정하기" // 편집창 네비게이션 뷰의 제목을 변경함
            textfield.text = item.text // 텍스트 필드에 들어가있는 내용은 기존의 내용
            addBarButton.isEnabled = true
        }
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // 키보드 자동으로 뜨게 해주는 함수
    override func viewWillAppear(_ animated: Bool) {
        textfield.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

extension ItemDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string:String) -> Bool {
        
        guard let oldText = textfield.text,
              let stringRange = Range(range, in: oldText) else {
            return false
        }
        
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty {
            addBarButton.isEnabled = false
        } else {
            addBarButton.isEnabled = true
        }
        return true
    }
    
}

