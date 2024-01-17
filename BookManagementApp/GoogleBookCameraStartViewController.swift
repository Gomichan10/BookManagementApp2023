//
//  GoogleBookCameraStartViewController.swift
//  ISC BOOK
//
//  Created by Gomi Kouki on 2023/12/27.
//

import UIKit
import Photos
import AVFoundation

class GoogleBookCameraStartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton()
        button.backgroundColor = .orange
        button.frame = CGRect(x: UIScreen.main.bounds.width/3, y: 200, width: UIScreen.main.bounds.width/3, height: 50)
        button.setTitle("カメラ起動", for: .normal)
        button.addTarget(self, action: #selector(tapedAudio), for: .touchUpInside)
        view.addSubview(button)
        
        allowedRequestStatus()
        
    }
    
    @objc func tapedAudio(){
        self.present(GoogleBookCameraViewController(),animated: true,completion: nil)
    }
    
    func allowedRequestStatus() -> Bool{
        var avState = false
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case .authorized:
            avState = true
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                DispatchQueue.main.async {
                    avState = granted
                }
            })
        default:
            avState = false
            break
        }
        return avState
    }
    
    
 
    
}
