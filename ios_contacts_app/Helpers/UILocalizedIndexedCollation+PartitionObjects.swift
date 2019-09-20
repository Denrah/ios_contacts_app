//
//  UILocalizedIndexedCollation+PartitionObjects.swift
//  ios_contacts_app
//

import UIKit

extension UILocalizedIndexedCollation {
  func partitionObjects(array: [AnyObject], collationStringSelector: Selector) -> ([AnyObject], [String]) {
    var unsortedSections = [[AnyObject]]()

    for _ in self.sectionTitles {
      unsortedSections.append([])
    }

    for item in array {
      let index: Int = self.section(for: item, collationStringSelector: collationStringSelector)
      unsortedSections[index].append(item)
    }

    var sectionTitles: [String] = []
    var sections: [AnyObject] = []
    for index in 0 ..< unsortedSections.count where !unsortedSections[index].isEmpty {
      sectionTitles.append(self.sectionTitles[index])
      sections.append(self.sortedArray(from: unsortedSections[index],
                                       collationStringSelector: collationStringSelector) as AnyObject)
    }
    return (sections, sectionTitles)
  }
}
