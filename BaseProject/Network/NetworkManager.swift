//
//  NetworkManager.swift
//  BaseProject
//
//  Created by Cüneyt AYVAZ on 5.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import Foundation


import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

public class NetworkManager {
    
    private static let TIMEOUT_INTERVAL: TimeInterval = 30
    
    public static func sendRequest<T: Mappable>(endPoint: ServiceEndPoint, method: HTTPMethod = .post, requestModel: Mappable, indicatorEnabled: Bool = true,
                                                completion: @escaping(T) -> ()) {
        
        guard let request = prepareRequest(endPoint: endPoint, method: method, requestModel: requestModel),
            let viewController = UIApplication.getTopViewController()
            else { return }
        
        if indicatorEnabled {
            viewController.view.showIndicator(identifier: String(describing: request.self))
        }
        AF.request(request).responseObject { (response: DataResponse<T>) in
            if indicatorEnabled {
                viewController.view.hideIndicator(identifier: String(describing: request.self))
            }
            
            switch response.result {
            case .success(let responseModel):
                completion(responseModel)
                
            case .failure(let error as NSError):
                viewController.showAlert(title: "Warning", message: "An error occurred when requesting", buttonText: "OK")
                debugPrint(error.description)
            }
        }
    }
    
    public static func sendRequest<T: Mappable>(url : String,endPoint: ServiceEndPoint, method: HTTPMethod = .post, parameters: Parameters? = nil, indicatorEnabled: Bool = true,
                                                completion: @escaping(T) -> ()) {
        
        guard let request = prepareRequest(endPoint: endPoint, method: method, parameters: parameters),
            let viewController = UIApplication.getTopViewController()
            else { return }
        
        if indicatorEnabled {
            viewController.view.showIndicator(identifier: String(describing: request.self))
        }
        AF.request(request).responseObject { (response: DataResponse<T>) in
            if indicatorEnabled {
                viewController.view.hideIndicator(identifier: String(describing: request.self))
            }
            
            switch response.result {
            case .success(let responseModel):
                completion(responseModel)
                
            case .failure(let error as NSError):
                viewController.showAlert(title: "Warning", message: "An error occurred when requesting", buttonText: "OK")
                debugPrint(error.description)
            }
        }
    }
    
    private static func prepareRequest(endPoint: ServiceEndPoint, method: HTTPMethod, requestModel: Mappable) -> URLRequest? {
        let urlPath = Constants.BASE_SERVICE_URL + endPoint.rawValue
        
        var request = URLRequest(url: URL(string: urlPath)!)
        request.timeoutInterval = TIMEOUT_INTERVAL
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method.rawValue
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestModel.toJSON())
        
        return request
    }
    
    private static func prepareRequest(endPoint: ServiceEndPoint, method: HTTPMethod, parameters: Parameters? = nil) -> URLRequest? {
        let urlPath = Constants.BASE_SERVICE_URL + endPoint.rawValue
        
        var request = URLRequest(url: URL(string: urlPath)!)
        request.timeoutInterval = TIMEOUT_INTERVAL
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method.rawValue
        
        if parameters != nil {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters!)
        }
        
        return request
    }
    
}
