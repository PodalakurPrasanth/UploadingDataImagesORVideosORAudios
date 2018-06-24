//
//  ViewController.swift
//  UploadingDataURLSession
//
//  Created by Apple on 24/06/18.
//  Copyright © 2018 Prasanth. All rights reserved.
//

import UIKit

typealias Parameters = [String: AnyObject]

class ViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //Prasanth
    }
    
    @IBAction func getRequest(_ sender: Any) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        var request = URLRequest(url: url)
        
        let boundary = generateBoundary()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let dataBody = createDataBody(withParameters: nil, media: nil, boundary: boundary)
        request.httpBody = dataBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            }.resume()
        
    }
    
    //toilet/toiletMaintenance
    @IBAction func postRequest(_ sender: Any) {
        //["name": Srikanth, "emp_id": 1234, "phone_number": 8096242529, "user_id": 1, "designation": Inspector/MEO, "inspection_id": 32]
        let parameters = ["name": "Srikanth", "emp_id": "1234", "phone_number": "8096242529", "user_id": "1", "designation": "Inspector/MEO", "inspection_id": "32"]
        let value =  "{\"toilet_type_id\":\"3\",\"inspection_id\":\"21\",\"no_of_toilets\":\"2\",\"minor_repairs\":\"1\",\"major_repairs\":\"1\",\"remarks\":\"iostest1\",\"maintenance\":\"good\"}"
        //        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        //        let decoded = String(data: jsonData, encoding: .utf8)!
        //        print(decoded)
        let param = ["content":value]
        let imagesArray = [#imageLiteral(resourceName: "testImage"),#imageLiteral(resourceName: "testImage"),#imageLiteral(resourceName: "testImage")]
        var mediaData = [Media]()
        var val = 1
        for image in imagesArray
        {
            
            guard let mediaImage = Media(withImage: image, forKey: "images[]", imageName: "IMG_"+"\(val)") else { return }
            mediaData.append(mediaImage)
            val = val+1
        }
        
        //guard let mediaImage = Media(withImage: nil, forKey: "profile") else { return }
        // http://192.168.1.66/veekshanam/api/Visitor/saveVisitor
        guard let url = URL(string: "http://192.168.1.66/veekshanam/api/toilet/toiletMaintenance") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = generateBoundary()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let loginString = String(format: "%@:%@", "admin", "1234")
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        // request.addValue("admin 1234", forHTTPHeaderField: "Authorization")
        
        let dataBody = createDataBody(withParameters: param as Parameters, media: mediaData, boundary: boundary)
        request.httpBody = dataBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            }.resume()
    }
    
    
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(((value as AnyObject) as! String) + lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                if photo.data != nil{
                    body.append("--\(boundary + lineBreak)")
                    body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                    body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                    
                    body.append(photo.data!)
                    body.append(lineBreak)
                }
                
                
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
    
    
    
}


extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}






