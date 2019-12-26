//
//  JSONDecodable.swift
//  PAYJP
//
//  Created by Tatsuya Kitagawa on 2019/12/26.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol JSONDecodable {

    static func decodeJson(with data: Data, using decoder: JSONDecoder) throws -> Self
}
