//
//  CustomJSONDecoder.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 15/10/24.
//

import Foundation

class CustomJSONDecoder: JSONDecoder, @unchecked Sendable {

    public override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        if T.self == NetworkRequest.EmptyBodyObject.self,
           let obj = NetworkRequest.EmptyBodyObject() as? T {
            return obj
        }
        return try super.decode(T.self, from: data)
    }

}
