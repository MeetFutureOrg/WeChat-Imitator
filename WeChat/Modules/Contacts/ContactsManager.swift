//
//  ContactsManager.swift
//  WeChat
//
//  Created by Sun on 2021/12/26.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import RxSwift
import RxCocoa
import Contacts

typealias ContactsHandler = (_ contacts: [CNContact], _ error: Error?) -> Void

enum ContactsError: Error {
    case accessDenied
}

class ContactsManager: NSObject {
    
    static let `default` = ContactsManager()
    
    let contactsStore = CNContactStore()
    
    func fetchContacts(_ keyword: String = "") -> Observable<[Contact]> {
        return Single.create { single in
            switch CNContactStore.authorizationStatus(for: CNEntityType.contacts) {
            case CNAuthorizationStatus.denied, CNAuthorizationStatus.restricted:
                single(.failure(ContactsError.accessDenied))
                
            case CNAuthorizationStatus.notDetermined:
                self.contactsStore.requestAccess(for: CNEntityType.contacts, completionHandler: { granted, error -> Void in
                    if granted {
                        self.fetchContacts().subscribe(onNext: { newContacts in
                            single(.success(newContacts))
                        }).disposed(by: self.rx.disposeBag)
                    } else if let error = error {
                        single(.failure(error))
                    }
                })
                
            case  CNAuthorizationStatus.authorized:
                var contactsArray = [CNContact]()
                let contactFetchRequest = CNContactFetchRequest(keysToFetch: self.allowedContactKeys())
                contactFetchRequest.sortOrder = .givenName
                do {
                    try self.contactsStore.enumerateContacts(with: contactFetchRequest, usingBlock: { contact, _ -> Void in
                        contactsArray.append(contact)
                    })
                    
                    single(.success(contactsArray.map { Contact($0) }.filter({ contact -> Bool in
                        if let name = contact.name, !keyword.isEmpty {
                            return name.contains(keyword, caseSensitive: false)
                        }
                        return true
                    })))
                } catch {
                    single(.failure(error))
                    debugPrint(error.localizedDescription)
                }
            @unknown default: break
            }
            return Disposables.create { }
        }.asObservable()
    }
    
    func allowedContactKeys() -> [CNKeyDescriptor] {
        return [CNContactNamePrefixKey as CNKeyDescriptor,
                CNContactGivenNameKey as CNKeyDescriptor,
                CNContactFamilyNameKey as CNKeyDescriptor,
                CNContactOrganizationNameKey as CNKeyDescriptor,
                CNContactBirthdayKey as CNKeyDescriptor,
                CNContactImageDataKey as CNKeyDescriptor,
                CNContactThumbnailImageDataKey as CNKeyDescriptor,
                CNContactImageDataAvailableKey as CNKeyDescriptor,
                CNContactPhoneNumbersKey as CNKeyDescriptor,
                CNContactEmailAddressesKey as CNKeyDescriptor
        ]
    }
}
