//
//  RingtonePicker.swift
//  ios_contacts_app
//

import UIKit

class RingtonePickerView: UIPickerView {
  private var viewModel: RingtonePickerViewModel
  private var data: [String]?
  
  init(viewModel: RingtonePickerViewModel) {
    self.viewModel = viewModel
    super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    self.backgroundColor = UIColor.white
    super.delegate = self
    super.dataSource = self
    self.reloadAllComponents()
    bindToViewModel()
  }
  
  // MARK: - View setup
  
  private func bindToViewModel() {
    viewModel.data.bind = { [weak self] data in
      data.flatMap { self?.data = $0 }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Picker configuration

extension RingtonePickerView: UIPickerViewDataSource, UIPickerViewDelegate {
  public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    guard let data = data else { return 0 }
    return data.count
  }
  
  public func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    guard let data = data else { return nil }
    return data[row]
  }
  
  public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    guard let data = data else { return }
    viewModel.ringtonePickerView(didSelected: data[row])
  }
}
