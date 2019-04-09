//
//  JSONDecoderFactory.swift
//  PAYJP
//
//  Created by Tatsuya Kitagawa on 2019/04/09.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

func createJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    return decoder
}
