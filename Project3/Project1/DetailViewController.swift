//
//  DetailViewController.swift
//  Project1
//
//  Created by Мария Родионова on 12.07.2022.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //заголовок,никогда не используем большие заголовки на этой странице
        
      
        
        title = selectedImage
        navigationItem.largeTitleDisplayMode = .never
        
        
        //делаем кнопки навигации
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
       
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //делает видимым для objc
    @objc func shareTapped (){
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8)
        else {
            print ("No image found")
            return
        }
        
          let vc = UIActivityViewController (activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present (vc,animated : true)
    }

}
