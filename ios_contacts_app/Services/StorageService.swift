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
  func saveObject<T>(_ object: T) -> Result<Void, Error> where T: Object {
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
}
