//
//  File.swift
//  ATMs
//
//  Created by Karina Kovaleva on 9.01.23.
//

import Foundation

class HttpRequestHelper {
    func GET(url: String,
             complete: @escaping (Bool, Data?) -> Void) {

        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: problem calling GET")
                print(error!)
                complete(false, nil)
                return
            }
            guard let data = data else {
                print("Error: did not receive data")
                complete(false, nil)
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                complete(false, nil)
                return
            }
            complete(true, data)
        }
        .resume()
    }
}
