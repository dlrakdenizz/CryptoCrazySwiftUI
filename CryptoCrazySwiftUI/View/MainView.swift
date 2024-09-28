//
//  ContentView.swift
//  CryptoCrazySwiftUI
//
//  Created by Dilara Akdeniz on 28.09.2024.
//


//Async: Bir fonksiyonun asenkron olarak çalışacağını belirtir. Bu, fonksiyonun işlemlerinin tamamlanmasını beklemek zorunda kalmadan geri dönebileceği anlamına gelir. Fonksiyonun sonucu, işlem tamamlandığında geri döner.
//Await: Bir asenkron işlemi başlatmak ve sonucunu beklemek için kullanılır. await ifadesi, bir işlemin bitmesini bekler ancak bu bekleme sırasında uygulamanın diğer kısımları çalışmaya devam edebilir.


import SwiftUI

struct MainView: View {
    
    @ObservedObject var cryptoListViewModel : CryptoListViewModel
    
    //Burada bir obje tanımlanınca Preview kısmı hata vermesin diye init oluşturulabilir. Böylece bu ekran ilk açıldığında fonksiyon içerisinde yazanlar görülür.
    init() {
        self.cryptoListViewModel = CryptoListViewModel()
    }
    
    var body: some View {
        
        NavigationStack{
            
            //Buradaki id kısmı viewModel kısmından geliyor, oradan gelen UUID'leri id olarak tanımladığımız için bu kısma da id yazdık, ne olarak tanımlarsak o şekilde yazılmalı burada da.
            List(cryptoListViewModel.cryptoList, id: \.id) { crypto in
                VStack{
                    Text(crypto.currency)
                        .font(.title3)
                        .foregroundStyle(Color.blue)
                        .frame(maxWidth: .infinity, alignment: .leading )
                    
                    Text(crypto.price)
                        .foregroundStyle(Color.black)
                        .frame(maxWidth: .infinity, alignment: .leading )
                }
            }.toolbar(content: {
                //Button kendi başına async olmadığı için Task.init içinde butona tıklanınca olacak olanları yazdırarak asenkron işlem yapabilmiş oluyoruz.
                Button {
                    Task.init{
                        cryptoListViewModel.cryptoList = [] //Refresh olma kısmını görüntülemek için yaptık bunu
                        await cryptoListViewModel.downloadCryptosContinuation(url: URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json")!)
                    }
                    
                } label: {
                    Text("Refresh")
                }

            })
            
            .navigationTitle(Text("Crypto Crazy"))
        }.task {
            await cryptoListViewModel.downloadCryptosContinuation(url: URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json")!)
        }
        
        /*
        //.task kısmı asenkron işlemleri gerçekleştirmek için kullanılır.
        .task {
            await cryptoListViewModel.downloadCryptosAsync(url: URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json")!)
        }
        */
    }
    
    
    /*
     //.onAppear bu view açıldığında ne görünsün kısmı içindir. (Life cycle) Ama artık SwiftUI kısmında bu kullanılamıyor.
     .onAppear {
     cryptoListViewModel.downloadCryptos(url: URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json")!)
     }
     */
    
}

#Preview {
    MainView()
}
