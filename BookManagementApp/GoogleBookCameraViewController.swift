//
//  GoogleBookCameraViewController.swift
//  ISC BOOK
//
//  Created by Gomi Kouki on 2023/12/26.
//

import UIKit
import Photos
import AVFoundation
import FirebaseFirestore


class GoogleBookCameraViewController: UIViewController{
    
    let photoView:UIImageView = UIImageView()
    let codeLabel:UILabel! = UILabel()
    let searchLabel:UILabel! = UILabel()
    let infoImage = UIImageView(image: UIImage(named: "注意書き"))
    
    var avSession: AVCaptureSession!
    var avInput: AVCaptureDeviceInput!
    var avOutPut: AVCapturePhotoOutput!
    
    let db = Firestore.firestore()
    var checkBook = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        allowedRequestStatus()

        photoView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.view.addSubview(photoView)
        
        if allowedStatus(){
            setupAVCapture()
        }
        
        let tapLabel = UITapGestureRecognizer(target: self, action: #selector(LabelTapped))
        searchLabel.addGestureRecognizer(tapLabel)
        searchLabel.isUserInteractionEnabled = true
        
    }
    
    func allowedRequestStatus() -> Bool{
        var avState = false
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case .authorized:
            avState = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                DispatchQueue.main.async {
                    avState = granted
                    if granted {
                        self.setupAVCapture()
                    }
                }
            })
        default:
            avState = false
        }
        return avState
    }
    
    func allowedStatus() -> Bool{
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            return true
        }else{
            return false
        }
    }

    func setupAVCapture(){
        self.avSession = AVCaptureSession()
        guard let videoDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: videoDevice)
            
            if self.avSession.canAddInput(deviceInput){
                self.avSession.addInput(deviceInput)
                self.avInput = deviceInput
                
                let metadataOutput = AVCaptureMetadataOutput()
                if self.avSession.canAddOutput(metadataOutput){
                    self.avSession.addOutput(metadataOutput)
                    
                    metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    
                    metadataOutput.metadataObjectTypes = [.ean13]
                    
                    let x: CGFloat = 0.1
                    let y: CGFloat = 0.3
                    let width: CGFloat = 0.8
                    let height: CGFloat = 0.2
                    metadataOutput.rectOfInterest = CGRect(x: y, y: 1 - x - width, width: height, height: width)
                    
                    let previewLayer = AVCaptureVideoPreviewLayer(session: self.avSession)
                    previewLayer.frame = self.photoView.bounds
                    previewLayer.videoGravity = .resizeAspectFill
                    self.view.layer.addSublayer(previewLayer)
                    
                    
                    let readingArea = UIView()
                    readingArea.frame = CGRect(x: Int(view.frame.size.width * x), y: Int(view.frame.size.height * y), width: Int(view.frame.size.width * width), height:Int(view.frame.size.height * height))
                    readingArea.layer.borderWidth = 2
                    readingArea.layer.borderColor = UIColor.orange.cgColor
                    view.addSubview(readingArea)
                    
                    infoImage.frame = CGRect(x: 27, y: UIScreen.main.bounds.height - 810, width: 335, height: 180)
                    infoImage.alpha = 0.85
                    infoImage.clipsToBounds = true
                    infoImage.layer.cornerRadius = 15
                    self.view.addSubview(infoImage)
                    
                    codeLabel.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 200, width: UIScreen.main.bounds.width, height: 75)
                    codeLabel.backgroundColor = UIColor.gray
                    codeLabel.textAlignment = .center
                    codeLabel.text = ""
                    self.view.addSubview(codeLabel)
                    
                    searchLabel.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 130, width: UIScreen.main.bounds.width, height: 75)
                    searchLabel.backgroundColor = UIColor.link
                    searchLabel.textAlignment = .center
                    searchLabel.text = "検索"
                    self.view.addSubview(searchLabel)
                    
                    self.avSession.startRunning()
                    
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        
        
    }
    
    func checkDB(){
        db.collection("Book").whereField("isbn", isEqualTo: String(codeLabel.text!)).getDocuments { QuerySnapshot, Error in
            if let Error = Error {
                print(Error)
                return
            }
            
            guard let documents = QuerySnapshot?.documents, !documents.isEmpty else {
                self.performSegue(withIdentifier: "searchBook", sender: nil)
                return
            }
            
            let alert = UIAlertController(title: "検索された本は既に登録されています。", message: "確認の上、もう一度お試しください。", preferredStyle: .alert)
            let ok = UIAlertAction(title: "了解", style: .default)
                alert.addAction(ok)
            self.present(alert,animated: true,completion: nil)
        }
        
    }

    @objc func LabelTapped(){
        checkDB()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchBook" {
            let VC = segue.destination as! BookResultViewController
            VC.searchIsbn = codeLabel.text!
        }
    }
    
    

    
}


extension GoogleBookCameraViewController:AVCaptureMetadataOutputObjectsDelegate{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            if metadata.stringValue == nil { continue }
            
            codeLabel.text = metadata.stringValue!
            
            print(metadata.type)
            print(metadata.stringValue!)
        }
    }
}

