//
//  Sections.swift
//  ios_contacts_app
//

import Foundation

struct Section<T> {
  var rows: [T]
  var title: String
  
  init(rows: [T], title: String) {
    self.rows = rows
    self.title = title
  }
}
