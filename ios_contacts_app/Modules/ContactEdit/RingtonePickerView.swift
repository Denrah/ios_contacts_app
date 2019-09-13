//
//  RingtonePicker.swift
//  ios_contacts_app
//

import UIKit

class RingtonePickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
  private var data: [String]
  
  public var textFieldBeingEdited: UITextField?
  
  public var selectedValue: String {
    return data[selectedRow(inComponent: 0)]
  }
  
  init(data: [String]) {
    self.data = data
    super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 00))
    self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    self.backgroundColor = UIColor.white
    super.delegate = self
    super.dataSource = self
    self.reloadAllComponents()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return data.count
  }
  
  public func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return data[row]
  }
}
