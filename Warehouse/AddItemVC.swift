//
//  AddItemVC.swift
//  Warehouse
//

import CoreData
import UIKit

final class AddItemVC: UIViewController {

    @IBOutlet private weak var storeTypePicker: UIPickerView!
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var itemNameTF: UITextField!
    @IBOutlet private weak var deleteButton: UIBarButtonItem!

    /// Set when editing or deleting an existing item.
    var itemToEdit: Items?

    private var storeTypes = [StoredType]()
    private let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        storeTypePicker.dataSource = self
        storeTypePicker.delegate = self
        imagePicker.delegate = self

        loadStoreTypes()
        if let item = itemToEdit {
            populate(with: item)
        }
        deleteButton.isEnabled = itemToEdit != nil
    }

    // MARK: - Data

    private func loadStoreTypes() {
        let request: NSFetchRequest<StoredType> = StoredType.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            storeTypes = try context.fetch(request)
        } catch {
            showAlert(title: "Could not load storage types", message: error.localizedDescription)
        }
    }

    private func populate(with item: Items) {
        itemNameTF.text = item.item_name
        itemImageView.image = item.image as? UIImage

        if let store = item.toStored, let row = storeTypes.firstIndex(of: store) {
            storeTypePicker.selectRow(row, inComponent: 0, animated: false)
        }
    }

    // MARK: - Actions

    @IBAction private func selectImageTapped(_ sender: Any) {
        present(imagePicker, animated: true)
    }

    @IBAction private func saveTapped(_ sender: Any) {
        let name = itemNameTF.text?.trimmingCharacters(in: .whitespaces) ?? ""
        guard !name.isEmpty else {
            showAlert(title: "Missing name", message: "Enter an item name.")
            return
        }
        guard !storeTypes.isEmpty else {
            showAlert(title: "No storage type", message: "Add a storage type before saving items.")
            return
        }

        let item = itemToEdit ?? Items(context: context)
        item.item_name = name
        item.date_add = Date()
        item.image = itemImageView.image
        item.toStored = storeTypes[storeTypePicker.selectedRow(inComponent: 0)]
        appDelegate.saveContext()

        if itemToEdit != nil {
            navigationController?.popViewController(animated: true)
        } else {
            itemNameTF.text = ""
            itemImageView.image = nil
        }
    }

    @IBAction private func deleteTapped(_ sender: Any) {
        guard let item = itemToEdit else { return }
        context.delete(item)
        appDelegate.saveContext()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension AddItemVC: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        storeTypes.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        storeTypes[row].name
    }
}

// MARK: - UIImagePickerControllerDelegate

extension AddItemVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let image = info[.originalImage] as? UIImage {
            itemImageView.image = image
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
