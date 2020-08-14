//
//  AddItem.swift
//  Warehouse
//
//  Created by Adham Albanna on 8/14/20.
//  Copyright © 2020 Adham Albanna. All rights reserved.
//

import UIKit
import CoreData

class AddItemVC: UIViewController , UIPickerViewDelegate
    ,UIPickerViewDataSource,
UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var pvSotreType: UIPickerView!
    @IBOutlet weak var imgToolImage: UIImageView!
    @IBOutlet weak var ToolNameTF: UITextField!
    var ListStoreType=[StoredType]()
    var EditOrDeleteItem:Items?
    var imagePicker:UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        pvSotreType.dataSource=self
        pvSotreType.delegate=self
        imagePicker=UIImagePickerController()
        imagePicker.delegate=self
        LoadStoesd()
        if EditOrDeleteItem != nil {
            LoadForEdit()
        }
    }
    
    
    func LoadStoesd() {
        let fecthRequest:NSFetchRequest<StoredType>=StoredType.fetchRequest()
        do{
            ListStoreType=try context.fetch(fecthRequest)
        }catch{
            
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ListStoreType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store=ListStoreType[row]
        return store.name
    }
    
    @IBAction func BtnSelectImage(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imgToolImage.image=image
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    // end implment image picker
    
    @IBAction func BtnSave(_ sender: Any) {
        
        let newItem:Items!
        if EditOrDeleteItem == nil {
            newItem=Items(context: context)
        }else{
            newItem=EditOrDeleteItem
        }
        
        
        newItem.item_name=ToolNameTF.text
        newItem.date_add=NSDate() as Date
        newItem.image=imgToolImage.image
        newItem.toStored=ListStoreType[pvSotreType.selectedRow(inComponent: 0)]
        do{
            ad.saveContext()
            ToolNameTF.text=""
            print("saved")
        }catch
        {
            print("Error")
        }
    }
    
    func   LoadForEdit() {
        if let item = EditOrDeleteItem{
            ToolNameTF.text=item.item_name
            imgToolImage.image=item.image as? UIImage
            
            if let store=item.toStored {
                var index=0
                while index<ListStoreType.count {
                    let row=ListStoreType[index]
                    if row.name==store.name{
                        pvSotreType.selectRow(index, inComponent: 0, animated: false)
                    }
                    index=index+1
                }
            }
        }
        
    }
    
    
    @IBAction func BuDelete(_ sender: Any) {
        if EditOrDeleteItem != nil{
            context.delete(EditOrDeleteItem! )
            ad.saveContext()
            _ =  navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    
}
