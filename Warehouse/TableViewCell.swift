//
//  TableViewCell.swift
//  Warehouse
//
//  Created by Adham Albanna on 8/14/20.
//  Copyright © 2020 Adham Albanna. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var laStoreName: UILabel!
    @IBOutlet weak var laDateAdded: UILabel!
    @IBOutlet weak var laImage: UIImageView!
    @IBOutlet weak var laItemName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
     
     
     func setMyCell(item:Items) {
    laStoreName.text=item.toStored!.name
         laImage.image=item.image as? UIImage
         laItemName.text=item.item_name
         // convert date to string  
         let dateformat=DateFormatter()
         dateformat.dateFormat="MM/DD/yy h:mm a"
        laDateAdded.text=dateformat.string(from: item.date_add!)
     }

}
