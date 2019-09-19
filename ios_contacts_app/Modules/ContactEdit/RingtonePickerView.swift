//
//  RingtonePicker.swift
//  ios_contacts_app
//

import UIKit

class RingtonePickerView: UIPickerView {
  private var viewModel: RingtonePickerViewModel
  
  // MARK: - View setup
  
  init(viewModel: RingtonePickerViewModel) {
    self.viewModel = viewModel
    super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup() {
    autoresizingMask = [.flexibleHeight, .flexibleWidth]
    backgroundColor = UIColor.white
    delegate = self
    dataSource = self
    reloadAllComponents()
  }
  
  func update(viewModel: RingtonePickerViewModel) {
    self.viewModel = viewModel
  }
}

// MARK: - Picker configuration

extension RingtonePickerView: UIPickerViewDataSource, UIPickerViewDelegate {
  public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return viewModel.numberOfRows
  }
  
  public func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    guard let ringtones = viewModel.ringtones else { return nil }
    return ringtones[row]
  }
  
  public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    guard let ringtones = viewModel.ringtones else { return }
    viewModel.selectRingtone(ringtone: ringtones[row])
  }
}
