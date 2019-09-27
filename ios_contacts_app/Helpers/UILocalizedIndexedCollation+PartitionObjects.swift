//
//  UILocalizedIndexedCollation+PartitionObjects.swift
//  ios_contacts_app
//

import UIKit

extension UILocalizedIndexedCollation {
  func partitionObjects<T: AnyObject>(array: [T], collationStringSelector: Selector) -> [Section<T>] {
    var unsortedSections = [[T]]()

    for _ in self.sectionTitles {
      unsortedSections.append([])
    }

    for item in array {
      let index: Int = section(for: item, collationStringSelector: collationStringSelector)
      unsortedSections[index].append(item)
    }
    var sections: [Section<T>] = []
    for index in 0 ..< unsortedSections.count where !unsortedSections[index].isEmpty {
      if let sortedArray = sortedArray(from: unsortedSections[index],
                                       collationStringSelector: collationStringSelector) as? [T] {
        let section = Section(rows: sortedArray, title: self.sectionTitles[index])
        sections.append(section)
      }
    }
    return sections
  }
}
