//
//  NetworkAPI.swift
//  ATMs
//
//  Created by Karina Kovaleva on 27.12.22.
//

import Foundation

protocol NetworkAPIProtocol {
    func getAtmsList(completion: @escaping (_ success: Bool, _ results: [ATM]?, _ error: String?) -> Void)
    func getInfoboxList(completion: @escaping (_ success: Bool, _ results: [Infobox]?, _ error: String?) -> Void)
    func getFilialsList(completion: @escaping (_ success: Bool, _ results: [Filials]?, _ error: String?) -> Void)
}

class NetworkAPI: NetworkAPIProtocol {
    func getAtmsList(completion: @escaping (Bool, [ATM]?, String?) -> Void) {
        HttpRequestHelper().GET(url: "https://belarusbank.by/api/atm") { success, data in
            if success {
                do {
                    guard let data = data else { return }
                    let model = try JSONDecoder().decode([ATM].self, from: data)
                    completion(true, model, nil)
                } catch {
                    completion(false, nil, "Error: Trying to parse Atms to model")
                }
            } else {
                completion(false, nil, "Error: Atms GET Request failed")
            }
        }
    }

    func getInfoboxList(completion: @escaping (Bool, [Infobox]?, String?) -> Void) {
        HttpRequestHelper().GET(url: "https://belarusbank.by/api/infobox") { success, data in
            if success {
                do {
                    guard let data = data else { return }
                    let model = try JSONDecoder().decode([Infobox].self, from: data)
                    completion(true, model, nil)
                } catch {
                    completion(false, nil, "Error: Trying to parse Infoboxes to model")
                }
            } else {
                completion(false, nil, "Error: Infoboxes GET Request failed")
            }
        }
    }
    
    func getFilialsList(completion: @escaping (Bool, [Filials]?, String?) -> Void) {
        HttpRequestHelper().GET(url: "https://belarusbank.by/api/filials_info") { success, data in
            if success {
                do {
                    guard let data = data else { return }
                    let model = try JSONDecoder().decode([Filials].self, from: data)
                    completion(true, model, nil)
                } catch {
                    completion(false, nil, "Error: Trying to parse Filials to model")
                }
            } else {
                completion(false, nil, "Error: Filials GET Request failed")
            }
        }
    }
}
