//
//  CheckVehicle.swift
//  how many horsepower ?
//
//  Created by William Risal on 20/06/2024.
//
import Foundation

class CheckVehicle {
    var CarsChevaux: [Double] = []
    var Cars: [String] = []

    func deleteCarsList() {
        CarsChevaux.removeAll()
    }
    func MoyenChevaux() -> Int {
        guard !Cars.isEmpty else {
            return 0
        }
        
        let somme = CarsChevaux.reduce(0, +)
        let moyenne = Int(somme) / CarsChevaux.count
        print("Moyenne des chevaux : \(moyenne)")
        print(CarsChevaux.count)
        deleteCarsList()
        return moyenne
    }
    
    // Méthode pour comparer le temps d'accélération avec le fichier recupdata.txt
    func compareAccelerationTime(_ elapsedTime: TimeInterval) -> [String] {
        guard let path = Bundle.main.path(forResource: "recupdata", ofType: "txt") else {
            print("Erreur : fichier non trouvé.")
            return [""]
        }
        let adjustedTime = elapsedTime * 0.85

        do {
            let data = try String(contentsOfFile: path, encoding: .utf8)
            let lines = data.components(separatedBy: .newlines)
            
            for line in lines {
                let components = line.components(separatedBy: " -> ")
                if components.count == 2 {
                    let carInfo = components[1]
                    let roundedDouble = (adjustedTime * 10).rounded() / 10
                    if components[0].contains(" " + String(+roundedDouble)) {
                        print("test ::", roundedDouble, "vehicule :", carInfo)
                        Cars.append(carInfo)
                        if let index = carInfo.range(of: " HorsePower")?.lowerBound {
                            let startIndex = carInfo.index(index, offsetBy: -4)
                            let substring = String(carInfo[startIndex..<index])
                            
                            // Filtrer uniquement les chiffres
                            if let filteredString = Double(substring.filter { "0123456789".contains($0) }) {
                                CarsChevaux.append(filteredString)
                            } else {
                                print("Conversion en Double échouée pour la chaîne \(substring)")
                            }
                        }
                    }
                }
            }
        } catch {
            print("Erreur de lecture du fichier : \(error.localizedDescription)")
        }
        return(Cars)
    }
}
