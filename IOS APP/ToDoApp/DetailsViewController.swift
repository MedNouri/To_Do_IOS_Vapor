//
//  DetailsViewController.swift
//  ToDoApp
//
//  Created by Mohamed Nouri on 12/06/2020.
//  Copyright © 2020 Mohamed Nouri All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    
    var todoObject:ToDo?
    
    
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var descriptiontitlz: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        titleLabel.text = todoObject?.title
//        descriptiontitlz.text = todoObject?.description

        
        
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

}
