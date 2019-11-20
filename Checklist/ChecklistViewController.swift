//
//  ViewController.swift
//  Checklist
//
//  Created by APPLE on 2019/11/18.
//  Copyright © 2019 JeongminKim. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var todoList: TodoList
    
    private func priorityForSectionIndex(_ index: Int) -> TodoList.Priority? {
        return TodoList.Priority(rawValue: index)
    }
    
    @IBAction func addItem(_ sender: Any) {
        let newRowIndex = todoList.todoList(for: .medium).count
        _ = todoList.newTodo()
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic) // 테이블뷰에 새롭게 생성된 열들이 추가된다
    }
    
    @IBAction func deleteItems(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                if let priority = priorityForSectionIndex(indexPath.section) {
                    let todos = todoList.todoList(for: priority)
                    
                    let rowToDelete = indexPath.row > todos.count - 1 ? todos.count - 1 : indexPath.row
                    let item = todos[rowToDelete]
                    
                    todoList.remove(item, from: priority, at: rowToDelete)
                }
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        todoList = TodoList()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 통제하기 - 화면 상단에 네비게이션 바가 보이게 한다
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.title = "수정"
        tableView.allowsMultipleSelectionDuringEditing = true // 편집간 다중 선택을 가능하게 한다
        
    }
    
    // Edit 버튼을 관리하는 곳
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        // 편집중일 때는 "완료"로 바뀌게 하고, 편집을 마치면 다시 "수정"으로 바꾼다
        if(self.isEditing) {
            self.editButtonItem.title = "완료"
        } else {
            self.editButtonItem.title = "수정"
        }
        tableView.setEditing(tableView.isEditing, animated: true)
    }
    
    // 얼마나 많은 TableViewRows를 사용할 것인가를 결정하는 함수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let priority = priorityForSectionIndex(section) {
            return todoList.todoList(for: priority).count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        if let priority = priorityForSectionIndex(indexPath.section) {
            let items = todoList.todoList(for: priority)
            let item = items[indexPath.row]
            configureText(for: cell, with: item)
            configureCheckmark(for: cell, with: item)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Edit해서 다중선택할 때 Checkmark가 클릭을 뺏어가는 것을 막기 위한 함수
        if tableView.isEditing {
            return
        }
        // checkmark를 떼었다 붙였다 할 수 있게 해주는 if문
        if let cell = tableView.cellForRow(at: indexPath) {
            if let priority = priorityForSectionIndex(indexPath.section) {
                let items = todoList.todoList(for: priority)
                let item = items[indexPath.row]
                item.toggleChecked()
                configureCheckmark(for: cell, with: item)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    // row를 Swipe했을 때 Delete하게 해주는 함수
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) { // 이 내용만 있을 때는 삭제 UI만 나오고 실제로 삭제할 수는 없음
        if let priority = priorityForSectionIndex(indexPath.section) {
            let item = todoList.todoList(for: priority)[indexPath.row]
            // 아래 코드가 더해져야 실제로 Row를 삭제할 수 있다.
            todoList.remove(item, from: priority, at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
        
    }
    
    // 열의 순서를 바꿀 수 있게 해주는 함수
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if let srcPriority = priorityForSectionIndex(sourceIndexPath.section),
            let destPriority = priorityForSectionIndex(destinationIndexPath.section) {
            
            let item = todoList.todoList(for: srcPriority)[sourceIndexPath.row]
            todoList.move(item: item, from: srcPriority, at: sourceIndexPath.row, to: destPriority, at: destinationIndexPath.row)
            
        }
        
        tableView.reloadData()
    }
    
    // 레이블에 제목이 들어갈 수 있게 해주는 함수
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        if let checkmarkCell = cell as? ChecklistTableViewCell {
            checkmarkCell.todoTextLabel.text = item.text
        }
    }
    
    // 셀을 클릭했을 때 보이는 체크 표시를 관장하는 함수
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        guard let checkmarkCell = cell as? ChecklistTableViewCell else {
            return
        }
        if item.checked {
            checkmarkCell.checkmarkLabel.text = "√"
        } else {
            checkmarkCell.checkmarkLabel.text = ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            // identifier는 storyboard에서 테이블뷰와 네비게이션 테이블뷰 사이 세그의 이름인 AddItemSegue
            if let ItemDetailViewController = segue.destination as? ItemDetailViewController {
                ItemDetailViewController.delegate = self
                ItemDetailViewController.todoList = todoList
            }
        }   else if segue.identifier == "EditItemSegue" {
            // identifier는 storyboard에서 체크리스트 아이템으로 네비게이션 뷰에 이어 놓은 세그의 Identifier인 EditItemSegue
            if let ItemDetailViewController = segue.destination as? ItemDetailViewController {
                if let cell = sender as? UITableViewCell,
                    let indexPath = tableView.indexPath(for: cell),
                    let priority = priorityForSectionIndex(indexPath.section)
                {
                    let item = todoList.todoList(for: priority)[indexPath.row]
                    ItemDetailViewController.itemToEdit = item
                    ItemDetailViewController.delegate = self
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TodoList.Priority.allCases.count
    }
    
    // 체크리스트 카테고리 제목 설정
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title:String? = nil
        if let priority = priorityForSectionIndex(section) {
            switch priority {
            case .high:
                title = "중요도 상"
            case .medium:
                title = "중요도 중"
            case .low:
                title = "중요도 하"
            case .no:
                title = "언젠가는 해야 할 일"
            }
        }
        return title
    }
}

extension ChecklistViewController: ItemDetailViewControllerDelegate {
    func ItemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        navigationController?.popViewController(animated: true)
        let rowIndex = todoList.todoList(for: .medium).count - 1
        let indexPath = IndexPath(row: rowIndex, section: TodoList.Priority.medium.rawValue)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        
        for priority in TodoList.Priority.allCases {
            let currentList = todoList.todoList(for: priority)
            if let index = currentList.index(of: item) {
                let indexPath = IndexPath(row: index, section: priority.rawValue)
                if let cell = tableView.cellForRow(at: indexPath) {
                    configureText(for: cell, with: item)
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    
}
