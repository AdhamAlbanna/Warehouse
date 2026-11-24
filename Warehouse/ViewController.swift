//
//  ViewController.swift
//  Warehouse
//

import CoreData
import UIKit

final class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private var fetchedResultsController: NSFetchedResultsController<Items>!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadItems()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "EditOrDelete",
              let destination = segue.destination as? AddItemVC,
              let item = sender as? Items else { return }
        destination.itemToEdit = item
    }

    // MARK: - Data

    private func loadItems() {
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date_add", ascending: false)]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            showAlert(title: "Could not load items", message: error.localizedDescription)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ItemCell else {
            return UITableViewCell()
        }
        cell.configure(with: fetchedResultsController.object(at: indexPath))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: "EditOrDelete", sender: item)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let newIndexPath { tableView.insertRows(at: [newIndexPath], with: .fade) }
        case .delete:
            if let indexPath { tableView.deleteRows(at: [indexPath], with: .fade) }
        case .update:
            if let indexPath, let cell = tableView.cellForRow(at: indexPath) as? ItemCell {
                cell.configure(with: fetchedResultsController.object(at: indexPath))
            }
        case .move:
            if let indexPath { tableView.deleteRows(at: [indexPath], with: .fade) }
            if let newIndexPath { tableView.insertRows(at: [newIndexPath], with: .fade) }
        @unknown default:
            tableView.reloadData()
        }
    }
}
