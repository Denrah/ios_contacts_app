//
//  StorageService.swift
//  ios_contacts_app
//

import Realm
import RealmSwift

enum StorageError: Error {
  case initFail
  case objectConvertionFailed
  case failWriteToStorage
  case generalSaveFailure
}

extension StorageError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .initFail:
      return "Can't inialize storage"
    case .objectConvertionFailed:
      return "Can't convert object to realm entity"
    case .failWriteToStorage:
      return "Can't write to storage"
    case .generalSaveFailure:
      return "Some error has occured while contact saving"
    }
  }
}

class StorageService {
  func saveObject<T>(object: T) -> Result<Void, Error> where T: Object {
    guard let realm = try? Realm() else {
      return Result.failure(StorageError.initFail)
    }

    do {
      try realm.write {
        realm.add(object)
      }
    } catch {
      return Result.failure(StorageError.failWriteToStorage)
    }
    return Result.success(())
  }
  
  func getObjects<T>(ofType: T.Type) -> Result<[T], Error> where T: Object {
    guard let realm = try? Realm() else {
      return Result.failure(StorageError.initFail)
    }
    
    let objects = realm.objects(T.self)
    
    return Result.success(Array(objects))
  }
  
  func saveContact(contact: Contact) -> (Result<Void, Error>) {
    let realmContact = RealmContact()
    realmContact.firstName = contact.firstName
    realmContact.lastName = contact.lastName
    realmContact.phoneNumber = contact.phoneNumber
    realmContact.ringtone = contact.ringtone
    realmContact.notes = contact.notes
    realmContact.image = contact.image?.pngData()
    
    let result = saveObject(object: realmContact)
    
    switch result {
    case .success:
      return .success(())
    case .failure(let error):
      print(error)
      return .failure(StorageError.generalSaveFailure)
    }
  }
  
  func getContacts() -> Result<[Contact], Error> {
    let result = getObjects(ofType: RealmContact.self)
    
    switch result {
    case .success(let realmContacts):
      let contacts = realmContacts.map { contact -> Contact in
        var image: UIImage?
        if let data = contact.image {
          image = UIImage(data: data)
        }
        return Contact(firstName: contact.firstName, lastName: contact.lastName,
                       phoneNumber: contact.phoneNumber, ringtone: contact.ringtone,
                       notes: contact.notes, image: image)
      }
      return Result.success(contacts)
    case .failure(let error):
      return Result.failure(error)
    }
  }
}
