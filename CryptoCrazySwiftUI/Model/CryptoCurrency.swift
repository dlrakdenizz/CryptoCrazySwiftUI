//
//  CryptoCurrency.swift
//  CryptoCrazySwiftUI
//
//  Created by Dilara Akdeniz on 28.09.2024.
//

import Foundation

//Hashable CodingKey protokolü kullanıldığında kullanılır.
struct CryptoCurrency : Hashable, Decodable, Identifiable {
    
    let id = UUID()
    var currency : String
    var price : String
    
    //Aşağıdaki enum kısmı eğer gelen verinin adı düzgün yazılmadıysa mesela cUrr2ncy yazıldıysa direkt Codingkey protokolü sayesinde case currency = "cUrr2ncy" yazabiliriz böylece bu veriden gelenler currency olmuş olur. Ama veriden bize id gelmiyor o yüzden case id yazmadık. Ama yukarıdaki UUID sayesinde her gelen veriye bir id verilecek.
    private enum CodingKeys : String, CodingKey{
        case currency = "currency"
        case price = "price"
    }
}
