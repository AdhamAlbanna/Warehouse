//
//  ItemCell.swift
//  Warehouse
//

import UIKit

final class ItemCell: UITableViewCell {

    @IBOutlet private weak var storeNameLabel: UILabel!
    @IBOutlet private weak var dateAddedLabel: UILabel!
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var itemNameLabel: UILabel!

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    func configure(with item: Items) {
        storeNameLabel.text = item.toStored?.name
        itemImageView.image = item.image as? UIImage
        itemNameLabel.text = item.item_name
        dateAddedLabel.text = item.date_add.map { Self.dateFormatter.string(from: $0) }
    }
}
