//
//  AddStoredVC.swift
//  Warehouse
//
//  Created by Adham Albanna on 8/14/20.
//  Copyright © 2020 Adham Albanna. All rights reserved.
//

import UIKit

class AddStoredVC: UIViewController {

    @IBOutlet weak var StoreNameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func BtnSave(_ sender: Any) {
        let store=StoredType(context: context)
        store.name=StoreNameTF.text
        do{
            ad.saveContext()
            StoreNameTF.text=""
            print("saved")
        }catch{
            print("cannot save")
        }
    }

}
