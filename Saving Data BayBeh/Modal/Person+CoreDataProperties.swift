//
//  Person+CoreDataProperties.swift
//  Saving Data BayBeh
//
//  Created by Kartheek Repakula on 01/03/21.


import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var type: String?
    @NSManaged public var date: String?
    @NSManaged public var remarks: String?
    @NSManaged public var amount: Int32

}
