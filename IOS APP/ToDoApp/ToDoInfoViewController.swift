//
//  ToDoInfoViewController.swift
//  ToDoApp
//
//  Created by Startdevelopment on 12/06/2020.
//  Copyright © 2020 Startdevelopment. All rights reserved.
//

import UIKit

class ToDoInfoViewController: UIViewController {
    var todoObject:ToDo?

    @IBOutlet weak var theDescription: UITextView!
    @IBOutlet weak var inoftitle: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        theDescription.text = todoObject?.description
        inoftitle.text = todoObject?.title
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func saveToDatabase(_ sender: Any) {
        let url = URL(string: "http://localhost:8080/todos")!
        let parameters = ["description": theDescription.text ?? "", "title": inoftitle.text ?? "" ,"id" : todoObject?.id ?? ""] as [String : Any]
              
              var request = URLRequest(url: url)
              request.httpMethod = "PUT"
              
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
                      
                  //    let newtodoList = try JSONDecoder().decode(ToDo.self, from: data)
                      DispatchQueue.main.async {
                        let  alert = UIAlertController(title: "info", message: "Updated", preferredStyle: .alert)
                        alert.addAction(.init(title: "Ok", style: .default, handler: { (_) in
                            alert.dismiss(animated: true, completion: nil)
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                                    }
                      // try to read out a string array
                    
                  } catch let error as NSError {
                      print("Failed to load: \(error.localizedDescription)")
                  }
              })
              
              task.resume()
        
    }
}
