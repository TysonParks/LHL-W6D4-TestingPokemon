//
//  ViewController.swift
//  Pokemon
//
//  Created by Sam Meech-Ward on 2018-02-20.
//  Copyright © 2018 lighthouse-labs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  var pokemons: [Pokemon] = []
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    let endpoint = "pokemon"
    var componenets = URLComponents()
    componenets.scheme = "https"
    componenets.host = "pokeapi.co"
    var componentsURL = componenets.url
    componentsURL = componentsURL?.appendingPathComponent("api")
    componentsURL = componentsURL?.appendingPathComponent("v2")
    componentsURL = componentsURL?.appendingPathComponent(endpoint)
    
    guard let url = componentsURL else {
      return
    }
    
    let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
      if let error = error {
        print("Error: \(error)")
        return
      }
      guard let data = data else {
        print("Error getting data")
        return
      }
      
      var jsonObject: Any!
      do {
        jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
      } catch let error {
        print("Error: \(error)")
        return
      }
      
      guard let results = (jsonObject as? [String: Any])?["results"] as? [[String: String]] else {
        print("Data Error")
        return
      }
      
      for result in results {
        guard let name = result["name"], let url = result["url"] else {
          continue
        }
        let pokemon = Pokemon(name: name, url: url)
        self.pokemons.append(pokemon)
      }
      
      OperationQueue.main.addOperation {
        self.tableView.reloadData()
      }
      
    }
    dataTask.resume()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}


extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pokemons.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
    
    let pokemon = pokemons[indexPath.row]
    cell.textLabel?.text = pokemon.name
    
    return cell
  }
}
