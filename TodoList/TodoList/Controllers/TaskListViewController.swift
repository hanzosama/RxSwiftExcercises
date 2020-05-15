//
//  TaskListViewController.swift
//  TodoList
//
//  Created by Jhoan Mauricio Vivas Rubiano on 14/05/20.
//  Copyright © 2020 Sennin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let disposeBag = DisposeBag()
    @IBOutlet weak var prioritySegmentedControl:UISegmentedControl!
    @IBOutlet weak var taskTableView:UITableView!
    
    private var tasks = BehaviorRelay<[Task]>(value: [])
    
    private var filterTask = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        cell.textLabel?.text = self.filterTask[indexPath.row].title
        return cell
    }
    
    @IBAction func priorityValueChanged(segmentedControl: UISegmentedControl){
        let priority = TaskPriority(rawValue: segmentedControl.selectedSegmentIndex - 1)
        filterTask(by: priority)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let nvC = segue.destination as? UINavigationController, let addTaskVc = nvC.viewControllers.first as? AddTaskViewController else {
            fatalError("Controller not found...")
        }
        
        addTaskVc.taskSubjecObservable.subscribe(onNext: { [unowned self](task) in
            
            let priority = TaskPriority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
            
            var existingArrayTask =  self.tasks.value
            existingArrayTask.append(task)
            self.tasks.accept(existingArrayTask)
            self.filterTask(by: priority)
        }).disposed(by: disposeBag)
    }
    /**
     Filter base on the priority
     */
    private func filterTask(by priority:TaskPriority?){
        if priority == nil {
            self.filterTask = self.tasks.value
        }else{
            self.tasks.map { task in
                return task.filter { return $0.priority == priority
                }
            }.subscribe(onNext: { [weak self] (tasks) in
                self?.filterTask = tasks
            }).disposed(by: disposeBag)
        }
        
        DispatchQueue.main.async {
            self.taskTableView.reloadData()
            
        }
    }
    
    
}
