//
//  File.swift
//  
//
//  Created by Hadi Sharghi on 8/17/23.
//

import Vapor

enum AppError: String, DebuggableError {
    
    case duplicateName
    case insecurePassword
    case invalidUserPassword

    var status: HTTPResponseStatus {
        switch self {
        case .duplicateName,
                .insecurePassword:
            return .badRequest
            
        case .invalidUserPassword:
            return .unauthorized
        }
    }
    

    
    var identifier: String {
        switch self {
        case .duplicateName:
            return "1001"
        default:
            return self.rawValue
        }
    }
    
    var reason: String {
        switch self {
        case .duplicateName:
            return "نام کاربر تکراری است."
        case .insecurePassword:
            return "پسورد باید حداقل ۶ کاراکتر باشد."
        case .invalidUserPassword:
            return "نام و پسورد نامعتبر است."
        }
    }
}
