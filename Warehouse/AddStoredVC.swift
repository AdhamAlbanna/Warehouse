//
//  AddStoredVC.swift
//  Warehouse
//

import UIKit

final class AddStoredVC: UIViewController {

    @IBOutlet private weak var storeNameTF: UITextField!

    @IBAction private func saveTapped(_ sender: Any) {
        let name = storeNameTF.text?.trimmingCharacters(in: .whitespaces) ?? ""
        guard !name.isEmpty else {
            showAlert(title: "Missing name", message: "Enter a storage type name.")
            return
        }

        let store = StoredType(context: context)
        store.name = name
        appDelegate.saveContext()
        storeNameTF.text = ""
    }
}
