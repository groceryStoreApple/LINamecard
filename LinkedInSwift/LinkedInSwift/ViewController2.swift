//
//  ViewController2.swift
//  LinkedInSwift
//
//  Created by Haonan Jing on 7/15/17.
//  Copyright © 2017 4everwild. All rights reserved.
//

import UIKit







class ViewController2: UIViewController {

    var userData: String = ""
    @IBOutlet weak var QRCode: UIImageView!

    @IBOutlet weak var headline: UITextView!
    
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        let data = convertToDictionary(text: userData)
        
        headline.text = data?["headline"] as? String
        userName.text = (data?["firstName"] as? String)! + (data?["lastName"] as? String)!
        
        var QRCodeQuery = "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data="
        var urlEntry = data?["siteStandardProfileRequest"] as? [String : Any]
        var url = urlEntry?["url"] as? String
        // Do any additional setup after loading the view.
        if let checkedUrl = URL(string: QRCodeQuery+url!) {
            QRCode.contentMode = .scaleAspectFit
            downloadImage(url: checkedUrl,imageVw:self.QRCode)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeLeft
    }
    private func shouldAutorotate() -> Bool {
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL, imageVw: UIImageView) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                imageVw.image = UIImage(data: data)
            }
        }
    }

}
