//
//  ToDoTableViewController.swift
//  ToDoApp
//
//  Created by Mohamed Nouri on 12/06/2020.
//  Copyright © 2020 Mohamed Nouri. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    
    
    var todoList = [ToDo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        LoadToDo()
    }
    
    // MARK: - Table view data source
    
    func LoadToDo(){
        
        
        let url = URL(string: "http://192.168.1.4:8080/todos")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            
            do {
                // make sure this JSON is in the format we expect
                
                let newtodoList = try JSONDecoder().decode([ToDo].self, from: data)
                
                // try to read out a string array
                self.todoList = newtodoList
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    
    func ADDToDo(title:String,description:String){
        
        
        let url = URL(string: "http://192.168.1.4:8080/todos")!
        let parameters = ["description": description, "title": title]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let data = data else { return }
            
            
            do {
                // make sure this JSON is in the format we expect
                
                let newtodoList = try JSONDecoder().decode(ToDo.self, from: data)
                
                // try to read out a string array
                self.todoList.append(newtodoList)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        })
        
        task.resume()
    }
    
    
    
    func RemoveToDoToDo(ID:Int){
        
        
        let url = URL(string: "http://192.168.1.4:8080/todos")!
         let parameters = ["id": ID]
         
         var request = URLRequest(url: url)
         request.httpMethod = "DELETE"
         
         do {
             request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
         } catch let error {
             print(error.localizedDescription)
         }
         
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.addValue("application/json", forHTTPHeaderField: "Accept")
         let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
             guard let data = data else { return }
             
            print(String(data: data, encoding: .utf8))
             do {
                 // make sure this JSON is in the format we expect
                 
                 let newtodoList = try JSONDecoder().decode(ToDo.self, from: data)
                 
                 // try to read out a string array
                 self.todoList.append(newtodoList)
                 
                 DispatchQueue.main.async {
                     self.tableView.reloadData()
                 }
             } catch let error as NSError {
                 print("Failed to load: \(error.localizedDescription)")
             }
         })
         
         task.resume()
    }
    
    @IBAction func addToDo(_ sender: Any) {
        AddAToDO()
    }
    func AddAToDO() {
        let ac = UIAlertController(title: "Add a new Todo", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addTextField()
        ac.textFields![0].placeholder = "Title"
        ac.textFields![1].placeholder = "description"
        let submitAction = UIAlertAction(title: "ADD", style: .default) { [unowned ac] _ in
            let titles = ac.textFields![0].text
            let description = ac.textFields![1].text
            self.ADDToDo(title: titles ?? "", description: description ?? "")
            
        }
        
        ac.addAction(submitAction)
        
        present(ac, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoIdentifier", for: indexPath)
        
        cell.accessoryType = .checkmark
        cell.textLabel?.text = todoList[indexPath.row].title
        cell.detailTextLabel?.text = todoList[indexPath.row].description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  self.performSegue(withIdentifier: "seeDetails", sender: self)
//        let detailsVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ToDoInfoViewController") as! ToDoInfoViewController
//        detailsVc.todoObject = todoList[indexPath.row]
//        present(detailsVc, animated: true, completion: nil)

    }
    
  
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            RemoveToDoToDo(ID: todoList[indexPath.row].id)
            
            todoList.remove(at:indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

     
        }}
    
   
   
 
    
 
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  
        if (segue.identifier == "ToDoInfoViewController") {
            print(segue.destination)
            let dest =  segue.destination as? ToDoInfoViewController
            dest?.todoObject = todoList[tableView.indexPathForSelectedRow?.row ?? 0]
            
        }
     }
     
    
}
