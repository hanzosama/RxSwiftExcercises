//
//  AddTaskViewController.swift
//  TodoList
//
//  Created by Jhoan Mauricio Vivas Rubiano on 14/05/20.
//  Copyright © 2020 Sennin. All rights reserved.
//

import UIKit
import RxSwift

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var taskTitleTextField:UITextField!
    
    @IBOutlet weak var taskPrioritySegmentedControl:UISegmentedControl!
    
    private var taskSubject = PublishSubject<Task>()
    
    var taskSubjecObservable:Observable<Task>{
        return taskSubject.asObservable()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func save(){
        guard let priority = TaskPriority(rawValue: self.taskPrioritySegmentedControl.selectedSegmentIndex), let taskTitle = self.taskTitleTextField.text  else {
            return
        }
        
        let task = Task(title: taskTitle, priority: priority)
        
        taskSubject.onNext(task)
        self.dismiss(animated: true, completion: nil)
    }
    
}
