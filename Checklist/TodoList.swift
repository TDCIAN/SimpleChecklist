//
//  ToDoList.swift
//  Checklist
//
//  Created by APPLE on 2019/11/18.
//  Copyright © 2019 JeongminKim. All rights reserved.
//

import Foundation

class TodoList {
    
    enum Priority: Int, CaseIterable {
        case high, medium, low, no
    }
    
    private var highPriorityTodos: [ChecklistItem] = []
    private var mediumPriorityTodos: [ChecklistItem] = []
    private var lowPriorityTodos: [ChecklistItem] = []
    private var noPriorityTodos: [ChecklistItem] = []
    
    init () {
        let row0Item = ChecklistItem()
        let row1Item = ChecklistItem()
        let row2Item = ChecklistItem()
        let row3Item = ChecklistItem()
        let row4Item = ChecklistItem()
        let row5Item = ChecklistItem()
        let row6Item = ChecklistItem()
        let row7Item = ChecklistItem()
        let row8Item = ChecklistItem()
        let row9Item = ChecklistItem()
        
        row0Item.text = "스트레칭"
        row1Item.text = "달리기"
        row2Item.text = "스쿼트"
        row3Item.text = "벤치프레스"
        row4Item.text = "데드리프트"
        row5Item.text = "밀리터리 프레스"
        row6Item.text = "사이드 레터럴레이즈"
        row7Item.text = "행잉 레그레이즈"
        row8Item.text = "사람구실"
        row9Item.text = "프로틴 섭취"
        
        addTodo(row0Item, for: .high)
        addTodo(row1Item, for: .low)
        addTodo(row2Item, for: .high)
        addTodo(row3Item, for: .high)
        addTodo(row4Item, for: .high)
        addTodo(row5Item, for: .medium)
        addTodo(row6Item, for: .low)
        addTodo(row7Item, for: .medium)
        addTodo(row8Item, for: .no)
        addTodo(row9Item, for: .high)
    }
    
    func addTodo(_ item: ChecklistItem, for priority: Priority, at index: Int = -1) {
        switch priority {
        case .high:
            if index < 0 {
                highPriorityTodos.append(item)
            } else {
                highPriorityTodos.insert(item, at: index)
            }
        case .medium:
            if index < 0 {
                mediumPriorityTodos.append(item)
            } else {
                mediumPriorityTodos.insert(item, at: index)
            }
        case .low:
            if index < 0 {
                lowPriorityTodos.append(item)
            } else {
                lowPriorityTodos.insert(item, at: index)
            }
        case .no:
            if index < 0 {
                noPriorityTodos.append(item)
            } else {
                noPriorityTodos.insert(item, at: index)
            }
        }
    }
    
    func todoList(for priority: Priority) -> [ChecklistItem] {
        switch priority {
        case .high:
           return highPriorityTodos
        case .medium:
           return mediumPriorityTodos
        case .low:
           return lowPriorityTodos
        case .no:
           return noPriorityTodos
        }
    }
    
    func newTodo() -> ChecklistItem {
        let item = ChecklistItem()
        item.checked = true
        mediumPriorityTodos.append(item)
        return item
    }
    
    func move(item: ChecklistItem, from sourcePriority: Priority, at sourceIndex: Int, to destinationPriority: Priority, at destinationIndex: Int) {
        remove(item, from: sourcePriority, at: sourceIndex)
        addTodo(item, for: destinationPriority, at: destinationIndex)
    }
    
    func remove(_ item: ChecklistItem, from priority: Priority, at index: Int) {
        switch priority {
        case .high:
            highPriorityTodos.remove(at: index)
        case .medium:
            mediumPriorityTodos.remove(at: index)
        case .low:
            lowPriorityTodos.remove(at: index)
        case .no:
            noPriorityTodos.remove(at: index)
        }
    }
}
