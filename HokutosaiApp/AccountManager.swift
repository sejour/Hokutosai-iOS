//
//  AccountManager.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/24.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation
import KeychainAccess

final class AccountManager {
    
    private static let serviceNameKey = "tech.hokutosai"
    private static let accountIdKey = "account-id"
    private static let accountPassKey = "account-pass"
    private static let userNameKey = "user-name"
    private static let mediaUrlKey = "media-url"
    
    static let sharedManager = AccountManager()
    
    var _account: HokutosaiAccount?
    var account: HokutosaiAccount? {
        return self._account
    }
    
    private init() {}
    
    func fetch(completion: ((HokutosaiAccount?) -> Void)? = nil) {
        guard self._account == nil else {
            return
        }
        
        let keychain = Keychain(service: AccountManager.serviceNameKey)
       
        var id: String?
        
        do {
            id = try keychain.getString(AccountManager.accountIdKey)
        }
        catch {
        }
        
        guard let accountId = id else {
            self.issue(completion)
            return
        }
        
        var accountPass: String?
        var userName: String?
        var mediaUrl: String?
        
        do {
            accountPass = try keychain.getString(AccountManager.accountPassKey)
            userName = try keychain.get(AccountManager.userNameKey)
            mediaUrl = try keychain.get(AccountManager.mediaUrlKey)
        }
        catch {
        }
        
        self._account = HokutosaiAccount(accountId: accountId, accountPass: accountPass, userName: userName, mediaUrl: mediaUrl)
        
        completion?(self._account)
    }
    
    private var waitingIssue: Bool = false
    
    private func issue(completion: ((HokutosaiAccount?) -> Void)? = nil) {
        if waitingIssue { return }
        waitingIssue = true
        
        HokutosaiApi.GET(HokutosaiApi.Accounts.New()) { response in
            if let account = response.model {
                if self._account == nil {
                    self._account = account
                    self.saveAccount(account)
                }
            }
            
            completion?(self._account)
            self.waitingIssue = false
        }
    }
    
    private func saveAccount(account: HokutosaiAccount) {
        let keychain = Keychain(service: AccountManager.serviceNameKey)
        
        keychain[AccountManager.accountIdKey] = account.accountId
        keychain[AccountManager.accountPassKey] = account.accountPass
        keychain[AccountManager.userNameKey] = account.userName
        keychain[AccountManager.mediaUrlKey] = account.mediaUrl
    }
    
}