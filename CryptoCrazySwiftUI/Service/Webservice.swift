//
//  Webservice.swift
//  CryptoCrazySwiftUI
//
//  Created by Dilara Akdeniz on 28.09.2024.
//

import Foundation

class Webservice {
    
    //1)Aşağıda verilen ilk fonksiyon en ilkel yazma yöntemidir. View kısmında onAppear kullanarak yazılabilir.
    /*
    func downloadCurrencies(url : URL, completion: @escaping (Result<[CryptoCurrency]?, DownloaderError>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.badUrl))
            }
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            guard let currencies = try? JSONDecoder().decode([CryptoCurrency].self, from: data) else{
                return completion(.failure(.dataParseError))
            }
            
            completion(.success(currencies))
        }.resume()
    }
     */
    
    /*
    
    //2)Aşağıdaki fonksiyonda ise async kullanacağız, bununla escaping kullanmama gerek yok çünkü bir completion bloğu açmayacağız.
    //throws yazma sebebimiz bu kısımda do-try-catch ile uğraşmak istemiyoruz, bu fonksiyonu kullanırken onu yazacağız ve hata varsa şunu döndür diyeceğiz.
    func downloadCurrenciesAsync(url : URL) async throws -> [CryptoCurrency] {
        let (data, _) = try await URLSession.shared.data(from: url) //_ kısmı response temsil ediyor. Kullanmayacağımız için o şekilde yazdık.
        
        let currencies = try? JSONDecoder().decode([CryptoCurrency].self, from: data)
        
        return currencies ?? [] //Fonksiyonda [CryptoCurrency]? yazıp bu kısmı optional yaparak bir şey dönmezse boş döndür diyebilirdik. Orayı optional yapmadık ve bu şekilde return ettik. Aynı şey oldu.
    }
     */
    
    //3) Aşağıdaki fonksiyon ise ilk başta oluşturulan async olmayan fonksiyon async hale getirilerek kullanmak içindir. Bu tarz fonksiyonları bir kütüphanede ya da başkası tarafından hali hazırda async olmadan yazılmış bir fonksiyonu async olarak kullanmak için kullanılır.
    
    func downloadCurrenciesContinuation(url: URL) async throws -> [CryptoCurrency] {
        
        //4 tane continuation fonksiyonu vardır: withUnsafeContinuation - Hata döndürmeyen güvensiz, withCheckedContinuation - Hata döndürmeyen güvenli, withUnsafeThrowingContinuation - Hata döndüren güvensiz, withCheckedThrowingContinuation - Hata döndüren güvenli
        //Continuation fonksiyonunun aacı güncel taski suspend etmek yani duraklatmaktır. Herhangi bir fonksiyon async olmasa da async hale getirip istediğimiz zaman durdurup devam ettirebiliriz. Manuel olarak durduracağımız kısmı da biz seçiyoruz.
        try await withCheckedThrowingContinuation ({ continuation in
            
            downloadCurrencies(url: url) { result in //Aşağıdaki async olmayan fonksiyonu kullandık
                switch result {
                case .success(let cryptos):
                    continuation.resume(returning: cryptos ?? [])
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
    }
        
        func downloadCurrencies(url : URL, completion: @escaping (Result<[CryptoCurrency]?, DownloaderError>) -> Void) {
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure(.badUrl))
                }
                
                guard let data = data, error == nil else {
                    return completion(.failure(.noData))
                }
                
                guard let currencies = try? JSONDecoder().decode([CryptoCurrency].self, from: data) else{
                    return completion(.failure(.dataParseError))
                }
                
                completion(.success(currencies))
            }.resume()
        }
}

enum DownloaderError : Error {
    case badUrl
    case noData
    case dataParseError
}
