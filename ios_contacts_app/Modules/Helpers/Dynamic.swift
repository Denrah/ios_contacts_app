//
//  Dynamic.swift
//  ios_contacts_app
//

import Foundation

class Dynamic<T> {
  var bind: ((T?) -> Void)?
  
  var value: T? {
    didSet {
      guard let bind = bind else { return }
      bind(value)
    }
  }
  
  init(_ defaultValue: T?) {
    value = defaultValue
  }
}
