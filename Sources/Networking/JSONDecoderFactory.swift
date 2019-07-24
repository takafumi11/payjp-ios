//
//  JSONDecoderFactory.swift
//  PAYJP
//
//  Created by Tatsuya Kitagawa on 2019/04/09.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

extension JSONDecoder {
    
    static var shared: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }
    
    static var since1970StrategyDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }
}
