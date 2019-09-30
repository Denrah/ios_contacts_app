//
//  RingtoneService.swift
//  ios_contacts_app
//

import Foundation

class RingtoneService {
  private let ringtones = ["Default", "Classic bell", "Old phone", "Siren", "Bip-Bip"]
  
  func getRingtones() -> [String] {
    return ringtones
  }
  
  func getDefaultRingtone() -> String? {
    return ringtones.first
  }
}
