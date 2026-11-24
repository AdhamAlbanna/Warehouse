//
//  UIViewController+Extension.swift
//  Warehouse
//

import CoreData
import UIKit

extension UIViewController {

    var appDelegate: AppDelegate {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("The application delegate is not an AppDelegate")
        }
        return delegate
    }

    var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }

    /// Shows a simple one-button alert.
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
