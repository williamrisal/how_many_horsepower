import SwiftUI
import CoreLocation

struct Record: Identifiable {
    let id = UUID()
    let time: Double
    let horsepower: Int
}

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var calculeCh = CheckVehicle()
    @State private var useMPH: Bool = UserDefaults.standard.bool(forKey: "useMPH")
    @State private var useKW: Bool = UserDefaults.standard.bool(forKey: "useKW")

    @State private var isRecording = false
    @State private var startTime: Date?
    @State private var elapsedTime: TimeInterval = 0.0
    @State private var result: String = ""
    @State private var records: [Record] = []
    @State private var progress: Double = 0.0
    @State private var moyenneChevaux = 0
    @State private var showHorseView = false
    @State private var countdownView = CountdownView(isActive: .constant(false)) // Instanciation pour l'accès à loadSound
    @State var Cars = [""]
    @State var CoutDownStart = false
    @State private var navigateToSettings = false
    @State private var showWelcomePopup: Bool = true // New state to control popup display

    let maxSpeed: Double = 10.0

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "1E1E1E")
                    .ignoresSafeArea()
                VStack {
                    TopBarView {
                        navigateToSettings = true // Trigger navigation from parent view
                    }.padding(.top,10)
                    Spacer()

                    if !showHorseView {
                        ZStack {
                            CircularProgressBarView(progress: $locationManager.speedInKmH)
                                .frame(width: 250, height: 250)

                            TimerView(elapsedTime: $elapsedTime)
                                .padding(.top, 200)
                        }
                        .transition(.move(edge: .leading).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.5), value: showHorseView)
                        .gesture(
                            DragGesture().onEnded { value in
                                if value.translation.width < -100 {
                                    withAnimation {
                                        toggleHorseView()
                                    }
                                }
                            }
                        )
                    } else {
                        VStack{
                            ShowHorse(targetNumber: Double(moyenneChevaux))
                                .padding(.top,20)
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                                .animation(.easeInOut(duration: 0.5), value: showHorseView)
                                .gesture(
                                    DragGesture().onEnded { value in
                                        if value.translation.width > 100 {
                                            withAnimation {
                                                toggleHorseView()
                                            }
                                        }
                                    }
                                )
                            ClassementView(displayedCars: Cars, Chevaux: Double(moyenneChevaux))
                        }
                        .padding(.top,-50)
                    }

                    Spacer()

                    HStack {
                        SpeedView(useMPH: useMPH, speed: Double(locationManager.speedInKmH))
                            .padding(.trailing, 50)

                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 1, height: 49)

                        GForceView(gForce: locationManager.gForce, showHorseView: showHorseView)
                            .padding(.leading, 50)
                    }

                    Spacer()

                    HStack {
                        if !isRecording {
                            Button(action: {
                                showHorseView ? resetAllValues() : startRecording()
                            }) {
                                Label(
                                    NSLocalizedString(showHorseView ? "go_back_home" : "start_recording", comment: ""),
                                    systemImage: "play.fill"
                                )
                                    .font(.system(size: 16, weight: .bold))
                                    .padding()
                                    .frame(width: 327, height: 48)
                                    .background(showHorseView ? Color(hex: "FF9C07") : Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(48)
                            }
                        } else {
                            Button(action: stopRecording) {
                                Label(NSLocalizedString("stop_recording", comment: ""), systemImage: "stop.fill")
                                    .font(.system(size: 16, weight: .bold))
                                    .padding()
                                    .frame(width: 327, height: 48)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(48)
                            }
                        }
                    }
                }
                .navigationDestination(isPresented: $navigateToSettings) {
                    SettingsView()
                }
                CountdownView(isActive: $CoutDownStart)
                if showWelcomePopup { // Display the popup conditionally
                    WelcomePopupView {
                        showWelcomePopup = false
                    }
                    .opacity(0.8)

                }
            }
            .onReceive(locationManager.$speedInKmH) { speed in
                if isRecording && speed >= 100 {
                    stopRecording()
                    Cars = calculeCh.compareAccelerationTime(elapsedTime)
                    moyenneChevaux = calculeCh.MoyenChevaux()
                    records.append(Record(time: elapsedTime, horsepower: moyenneChevaux))
                    withAnimation { toggleHorseView() }
                }
            }
            .onAppear {
                locationManager.requestAuthorization()
                useMPH = UserDefaults.standard.bool(forKey: "useMPH")
                useKW = UserDefaults.standard.bool(forKey: "useKW")
                countdownView.loadSound()

            }
            .onDisappear {
                locationManager.stopUpdatingLocation()
            }
        }
    }

    private func toggleHorseView() {
        showHorseView.toggle()

    }

    private func startRecording() {
        CoutDownStart.toggle()

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
                isRecording = true
                startTime = Date()
                startTimer()
                progress = 0.0
            } else {
                locationManager.requestAuthorization()
            }
        }
    }

    private func resetAllValues() {
        isRecording = false
        startTime = nil
        elapsedTime = 0.0
        result = ""
        records = []
        progress = 0.0
        moyenneChevaux = 0
        showHorseView = false
        Cars = [""]
        ReviewManager.shared.openAppStoreForReview(appID: "6739007870") // Remplacez par l'ID de votre app
        ReviewManager.shared.forceRequestReview()

    }

    private func stopRecording() {
        isRecording = false
        startTime = nil
    }

    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            guard let startTime = self.startTime else {
                timer.invalidate()
                return
            }
            self.elapsedTime = Date().timeIntervalSince(startTime)
            self.progress = min(self.elapsedTime / maxSpeed, 1.0)
        }
    }
}

struct SpeedView: View {
    var useMPH: Bool
    var speed: Double

    var body: some View {
        VStack {
            Text(NSLocalizedString("speed_title", comment: "Speed display"))
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color(hex: "FFFF06"))
                .padding(.bottom, 1)

            HStack {
                Text("\(useMPH ? Int(speed) :  Int(Double(speed) / 1.60934) )")                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                Text(NSLocalizedString(useMPH ? "kmh" : "mph", comment: "Speed unit"))
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
    }
}

struct GForceView: View {
    var gForce: Double
    var showHorseView: Bool

    var body: some View {
        VStack {
            Text(NSLocalizedString(showHorseView ? "max_gforce" : "current_gforce", comment: "G-Force display"))
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color(hex: "61E9FF"))
                .padding(.bottom, 1)

            Text(String(format: "%.2f", gForce))
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
        }
    }
}
