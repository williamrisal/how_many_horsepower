import Foundation
import CoreLocation
import CoreMotion
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let motionManager = CMMotionManager()
    
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var speedInKmH: Int = 0
    @Published var accelerationMagnitude: Double = 0.0
    @Published var gForce: Double = 0.0
    @Published var gForceMax: Double = 0.0
    @Published var calculatedAcceleration: Double = 0.0  // Acceleration based on GPS

    private var filteredAccelerationMagnitude: Double = 0.0
    private let smoothingFactor: Double = 0.2
    
    private var previousLocation: CLLocation?
    private var previousTimestamp: Date?

    override init() {
        authorizationStatus = locationManager.authorizationStatus
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
    }

    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
        startAccelerometerUpdates() // Démarre les mises à jour de l'accéléromètre
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        motionManager.stopAccelerometerUpdates()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                self.startUpdatingLocation() // Démarre les mises à jour de localisation ici
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        DispatchQueue.global(qos: .background).async { [weak self] in
            let speed = max(latestLocation.speed, 0)
            let speedInKmH = Int(speed * 3.6) // Convert to km/h
            
            DispatchQueue.main.async {
                self?.speedInKmH = speedInKmH
                self?.estimateSpeed()
                self?.checkAndSetSpeed()
            }
        }
        
        // Calculate acceleration based on GPS positions
        calculateAcceleration(currentLocation: latestLocation)
    }

    private func startAccelerometerUpdates() {
        guard motionManager.isAccelerometerAvailable else { return }
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
            guard let data = data else { return }
            let rawAccelerationMagnitude = sqrt(pow(data.acceleration.x, 2) +
                                                pow(data.acceleration.y, 2) +
                                                pow(data.acceleration.z, 2))

            self?.filteredAccelerationMagnitude = (self?.smoothingFactor ?? 0.0) * rawAccelerationMagnitude +
                                                  (1 - (self?.smoothingFactor ?? 0.0)) * (self?.filteredAccelerationMagnitude ?? 0.0)
            self?.accelerationMagnitude = self?.filteredAccelerationMagnitude ?? 0.0
            self?.updateGForce()
        }
    }

    private func estimateSpeed() {
        let estimatedSpeed = Double(speedInKmH) + (filteredAccelerationMagnitude * 3.6 * 0.1)
        speedInKmH = Int(max(estimatedSpeed, Double(speedInKmH))) // Ensure speed does not drop unexpectedly
    }

    private func updateGForce() {
        let gravity: Double = 9.81
        gForce = filteredAccelerationMagnitude / gravity
        gForceMax = max(gForce, gForceMax) // Update max G-force
    }

    func timeToReachTargetSpeed(currentSpeedKmh: Double, targetSpeedKmh: Double, acceleration: Double) -> Double? {
        guard acceleration > 0 else {
            return nil // Retourne nil si l'accélération est zéro ou négative
        }
        
        let currentSpeedMs = currentSpeedKmh * (5.0 / 18.0)
        let targetSpeedMs = targetSpeedKmh * (5.0 / 18.0)
        
        // Calcul du temps nécessaire pour atteindre la vitesse cible
        let time = (targetSpeedMs - currentSpeedMs) / acceleration
        
        // Si le temps est négatif (ce qui ne devrait pas arriver avec une accélération positive), on retourne nil
        return time > 0 ? time : nil
    }


    // Nouvelle fonction pour calculer l'accélération à partir de deux positions GPS
    private func calculateAcceleration(currentLocation: CLLocation) {
        guard let previousLocation = previousLocation, let previousTimestamp = previousTimestamp else {
            // Nous avons besoin de deux positions pour calculer l'accélération
            self.previousLocation = currentLocation
            self.previousTimestamp = Date()
            return
        }
        
        _ = currentLocation.distance(from: previousLocation) // Distance en mètres
        let timeInterval = currentLocation.timestamp.timeIntervalSince(previousTimestamp) // Temps en secondes
        
        if timeInterval > 0 {
            let speedChange = (currentLocation.speed - previousLocation.speed) // Change in speed (m/s)
            let acceleration = speedChange / timeInterval // Calcul de l'accélération (m/s^2)
            
            DispatchQueue.main.async {
                self.calculatedAcceleration = acceleration
            }
        }
        
        // Mettre à jour la dernière position et le timestamp
        self.previousLocation = currentLocation
        self.previousTimestamp = currentLocation.timestamp
    }

    // Fonction pour vérifier et ajuster la vitesse si nécessaire
    private func checkAndSetSpeed() {
        // Vérifier que la vitesse est entre 90 et 100 km/h et que l'accélération est non nulle
        guard speedInKmH > 90 && speedInKmH < 100, calculatedAcceleration > 0 else { return }

        // Calcul du temps nécessaire pour atteindre 100 km/h
        guard let timeToReach100 = timeToReachTargetSpeed(currentSpeedKmh: Double(speedInKmH), targetSpeedKmh: 100, acceleration: calculatedAcceleration) else {
            return // Si le temps ne peut pas être calculé (par exemple, accélération nulle ou négative)
        }
        
        // Si le temps est inférieur à 1 seconde, on met la vitesse à 100 km/h
        if timeToReach100 < 1 {
            speedInKmH = 100
        }
    }
}