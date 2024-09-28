//
//  CryptoViewModel.swift
//  CryptoCrazySwiftUI
//
//  Created by Dilara Akdeniz on 28.09.2024.
//

import Foundation

//Observable Object, Combine Framework'ten çıkan bir yapıdır. CryptoList içerisinde değişiklik olursa view'da direkt yenilensin istiyoruz. Bunun için gözlemlenen obje tutarız ve @Published diyerek bunu view'a göndeririz. View'da yani Main View'da da Observed Obje diyerek onu tutarız. Bu kısmı struct değil de class yapma sebebimiz de ObservableObject'den inheritance almaktır çünkü structlarda inheritance alınamaz. Bu kısım kullanıcı arayüzünü değiştirecek bir işlem yaptığından da DispatchQueue içinde yapılmalı.

@MainActor //Eğer sınıfın başına bu yazılırsa bu sınıf içerisindeki property'ler main thread'de işlem görecek demektir. Böylece DispachQueue.main.async kullanmadan da işlem yapılabilir
class CryptoListViewModel : ObservableObject {
    
    //cryptoList, downloadCryptos fonksiyonu başarılı olarak çalışırsa gelen crytoları tutacak listedir.
    @Published var cryptoList = [CryptoViewModel]()
    
    let webservice = Webservice()
    
    //Aşağıdaki fonksiyon webservice kısmındaki downloadCurrencies fonksiyonu ile kullanılabilir.
    /*
    func downloadCryptos (url: URL) {
        
        webservice.downloadCurrencies(url: url) { result in
            
            switch result {
                
                case .failure(let error):
                    print(error)
                
                case .success(let cryptos):
                    if let cryptos = cryptos {
                        DispatchQueue.main.async { //Main View'da görünüm değişeceği için yaptık bu kısmı
                            self.cryptoList = cryptos.map(CryptoViewModel.init) //crytoList, CrytoViewModel'dan oluşan bir listedir. cryptos ise CryptoCurrency'dir. Birbirlerine çevirmek şiçin map fonksiyonu kullanılır. Bu fonksiyon birçok yazılım dilinde vardır.
                        }
                    }
            }
        }
    }
    */
    
    //Aşağıdaki fonksiyon webservice kısmındaki downloadCurrenciesAsync fonksiyonu ile kullanılabilir.
    /*
    func downloadCryptosAsync(url: URL) async {
        do {
            let cryptos = try await webservice.downloadCurrenciesAsync(url: url)
            DispatchQueue.main.async {
                self.cryptoList = cryptos.map(CryptoViewModel.init)
            }
        } catch {
            print(error)
        }
    }
    */
    
    //Aşağıdaki fonksiyon webservice kısmındaki downloadCurrenciesContinuation fonksiyonu ile kullanılabilir.
    
    func downloadCryptosContinuation(url: URL) async {
        
        do {
            let cryptos = try await webservice.downloadCurrenciesContinuation(url: url)
            self.cryptoList = cryptos.map(CryptoViewModel.init)
            
            /* MainActor'den sonra burası yorum satırı oldu.
            DispatchQueue.main.async {
                self.cryptoList = cryptos.map(CryptoViewModel.init)
            }
             */
        } catch {
            print(error)
        }
        
    }
}

 
//Bu kısımda direkt View model structı oluşturuldu. MVVM yapısına uygun olması için yapıldı.
struct CryptoViewModel {
    
    let crypto: CryptoCurrency
    
    var id : UUID?{
        crypto.id
    }
    
    var currency : String {
        crypto.currency
    }
    
    var price : String {
        crypto.price
    }
}
