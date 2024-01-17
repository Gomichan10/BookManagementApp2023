//
//  BookMainViewController.swift
//  ISC BOOK
//
//  Created by Gomi Kouki on 2023/11/21.
//

import UIKit

class BookMainViewController: UIViewController, UIScrollViewDelegate{
    
    struct Photo {
        var imageName:String
    }
    
    var photoList = [
        Photo(imageName: "インフラ"),
        Photo(imageName: "モバイル"),
        Photo(imageName: "資格")
    ]

    @IBOutlet weak var scrollView: UIScrollView!
    
    var offsetx:CGFloat = 0
    var timer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 200, width: self.view.frame.size.width, height: 200))
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width * 3, height: 200)
        self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(self.scrollView)
        
        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self,selector: #selector(self.scrollPage),userInfo: nil,repeats: true)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func createImageView(x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat,image:Photo) -> UIImageView{
        let imageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
        let image = UIImage(named: image.imageName)
        imageView.image = image
        return imageView
    }
    
    func setUpImageView(){
        for i in 0 ..< self.photoList.count{
            let photoItem = self.photoList[i]
            let imageView = createImageView(x: 0, y: 0, width: self.view.frame.size.width, height: self.scrollView.frame.size.height, image: photoItem)
            imageView.frame = CGRect(origin: CGPoint(x: self.view.frame.size.width * CGFloat(i), y: 0),size: CGSize(width: self.view.frame.size.width, height: self.scrollView.frame.size.height))
            self.scrollView.addSubview(imageView)
        }
    }
    
    @objc func scrollPage(){
        self.offsetx += self.view.frame.size.width
        if self.offsetx < self.view.frame.size.width * 3{
            UIView.animate(withDuration: 0.3){
                self.scrollView.contentOffset.x = self.offsetx
            }
        }else{
            UIView.animate(withDuration: 0.3){
                self.offsetx = 0
                self.scrollView.contentOffset.x = self.offsetx
            }
        }
    }

}
