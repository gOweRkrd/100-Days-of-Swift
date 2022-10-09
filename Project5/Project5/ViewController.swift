import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //делаем кнопку навигации
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promtForAnswer))
        //открываем текстовый файл для чтения
        if let startWordsUrl = Bundle.main.url(forResource:"Start",withExtension: "txt") {
            if let startWords = try?String(contentsOf:startWordsUrl) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = [ "silkworm"]
    }
        startGame()
}
    func startGame () {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word",for:indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promtForAnswer () {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        //замыкание
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self,weak ac] action in
            //вызываем клавиатуру
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac,animated: true)
    }
    
    func submit (_ answer:String) {
        let lowerAnswer = answer.lowercased()
        
        let errorTitle : String
        let errorMessage : String
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at:0)
                    
                    //меньше затрат ,чем reloaddata
                    let indexPath = IndexPath (row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    errorTitle = "Word not recognized"
                    errorMessage = "You can't just make them up, you know!"
                }
            } else {
                errorTitle = "Word already used"
                errorMessage = "Be more original!"
                
                }
        } else {
            guard let title = title else {return}
            
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from \(title.lowercased())"
        }
        
        //делаем кнопку аллерта
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present (ac,animated: true)
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else {return false}
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
                
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
      //класс,обнаруживающий ошибки в словах
        let checher = UITextChecker ()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checher.rangeOfMisspelledWord(in:word,range:range,startingAt:0,wrap:false,language:"en")
        return misspelledRange.location == NSNotFound
      
    }
}




