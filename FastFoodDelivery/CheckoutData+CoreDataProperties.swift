//
//  CheckoutData+CoreDataProperties.swift
//  
//
//  Created by Richard Rusli on 21/05/2017.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension CheckoutData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CheckoutData> {
        return NSFetchRequest<CheckoutData>(entityName: "CheckoutData");
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var qty: Int32

}
