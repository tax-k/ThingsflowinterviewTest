//
//  httpRequest.swift
//  interviewTest
//
//  Created by tax_k on 10/11/2018.
//  Copyright © 2018 tax_k. All rights reserved.
//

import Foundation
import UIKit

class httpRequest {
    func parseJSONResults(jString:String) -> [String: AnyObject]? {
        let jData = jString.data(using: .utf8)
        
        do {
            if let data = jData,
                let json = try JSONSerialization.jsonObject(with: data, options:[]) as? [String: AnyObject] {
                return json
            } else {
                print("No Data :/")
            }
        } catch {
            // 실패한 경우, 오류 메시지를 출력합니다.
            print("Error, Could not parse the JSON request")
        }
        return nil
    }
}

extension UIImageView {
    func setImageFromURl(stringImageUrl url: String){
        
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
}
