//
//  ViewController.swift
//  GenericsTest
//
//  Created by Yuki Shinohara on 2020/07/08.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//  https://www.youtube.com/watch?v=-9H_ZjBBeLo

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        APICaller.shared.performAPICall(url: "", expectingReturnType: Car.self, completion: { result in
            switch result {
            case .success(let car):
                print(car.name)
            case .failure(let error):
                print(error)
            }
        })
        
        APICaller.shared.performAPICall(url: "", expectingReturnType: Fruit.self, completion: { result in
                   switch result {
                   case .success(let fruit):
                       print(fruit.name)
                   case .failure(let error):
                       print(error)
                   }
               })
//        APICaller.shared.getFruits()
    }


}


class APICaller{
    static let shared = APICaller()
    
    ///Genericsを使わないバージョン
    ///structごとに関数を作らなければならない
    
    func getFruits(){
        let task = URLSession.shared.dataTask(with: URL(string: "")!) { (data, _, err) in
            guard let data = data, err == nil else {return}
            let fruit: Fruit?
//            let car: Car?
            do {
                fruit = try JSONDecoder().decode(Fruit.self, from: data)
//                car = try JSONDecoder().decode(Car.self, from: data)
            }
            catch{
                fruit = nil
//                car = nil
                print(error)
            }
        }
        task.resume()
    }
    
    ///Genericsバージョン(いろんなstructに使える汎用性あり)
    //TがCodableだと定義
    //returnにはCodableのついた型だとする
    //関数内関数であるcompletionで、success時にはTをfailure時にはErrorを得る
    func performAPICall<T: Codable>(url: String,
                                    expectingReturnType: T.Type,
                                    completion: @escaping ((Result<T, Error>) -> Void)){
                let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, _, err) in
                    guard let data = data, err == nil else {return}
                    let result: T?
//                    let fruit: Fruit?
                    do {
                        result = try JSONDecoder().decode(T.self, from: data)
        //              fruit = try JSONDecoder().decode(Fruit.self, from: data)
                    }
                    catch{
                        result = nil
//                        completion(.failure(error))
//                        print(error)
                    }
                    
                    guard let unwrappedResult = result else {return}
                    completion(.success(unwrappedResult))
                }
        task.resume()
    }
    
}

struct Fruit: Codable {
    let name : String
    let identifier : String
}

struct Car: Codable {
    let name : String
    let identifier : String
    let type : String
}
