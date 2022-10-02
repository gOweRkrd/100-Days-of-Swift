//
//  ViewController.swift
//  Project1
//
//  Created by Мария Родионова on 10.07.2022.
//
//class ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
//
//    @IBOutlet weak var tableView: UITableView!
//
//     override func viewDidLoad() {
//         super.viewDidLoad()
//
//         //tableView.delegate = self
//        // tableView.dataSource = self
//         tableView.reloadData()
//    }



import UIKit

class ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pictures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   //используем ячейки повторно после прокрутки экрана
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
   //называем именем из массива картинок
        var countPictures = pictures.count
        var picturesNow = indexPath.row + 1
        
        cell.textLabel?.text = "Изображение \(picturesNow) из\(countPictures)  "
            return cell
            
        }
    
    
    var pictures = [String] ()

    
    override func viewDidLoad() {
        
        title = "Storm Viewer"
        
        //используем большие заголовки
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl"){
                pictures.append(item)
           
                
            }
            
           
        }
        
  // сортировка картинки от мелнькой к большему
        pictures.sort()
        //print(pictures)
    }
    
    //подключаем экран для отображения изображения
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures [indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
            
            
    }


}



