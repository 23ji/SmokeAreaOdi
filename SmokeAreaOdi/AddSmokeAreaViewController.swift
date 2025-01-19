import UIKit
import NMapsMap

extension Notification.Name {
    static let smokingAreaAdded = Notification.Name("smokingAreaAdded")
}

class AddSmokeAreaViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var naverMapView: NMFNaverMapView!
    @IBOutlet weak var titleTextField: UITextField!   // 제목 텍스트 필드
    @IBOutlet weak var descriptionTextField: UITextField!   // 상세 설명을 위한 텍스트 필드
    
    private let placeholderText = "상세 설명을 입력해주세요."

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaverMapView()
        setupUI()
    }

    private func setupNaverMapView() {
        let initialLocation = NMGLatLng(lat: 37.500920152198, lng: 127.03618231961)
        let cameraUpdate = NMFCameraUpdate(scrollTo: initialLocation)
        naverMapView.mapView.moveCamera(cameraUpdate)
        naverMapView.showLocationButton = true
    }

    private func setupUI() {
        searchBar.searchTextField.borderStyle = .none
        searchBar.layer.cornerRadius = 15
        searchBar.clipsToBounds = true

        // descriptionTextField의 플레이스홀더 설정
        descriptionTextField.placeholder = placeholderText
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func confirmLocationTapped(_ sender: UIButton) {
        let currentCenter = naverMapView.mapView.cameraPosition.target

        // 제목이 비어 있는지 확인
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(message: "제목을 입력해주세요.") {
                // 빈 제목 입력 시 추가 작업이 필요하면 여기 작성
            }
            return
        }

        // 상세 설명이 플레이스홀더와 같은지 확인하고 적절히 처리
        let description = descriptionTextField.text == placeholderText ? "" : descriptionTextField.text

        // 새로운 흡연구역 데이터를 생성
        let newSmokingArea = SmokingArea(
            name: title,
            latitude: currentCenter.lat,
            longitude: currentCenter.lng,
            description: description ?? "" // 설명이 nil일 경우 빈 문자열로 처리
        )

        // SmokingAreaData를 통해 새로운 흡연구역 데이터 저장
        SmokingAreaData.shared.addSmokingArea(newSmokingArea)

        // NotificationCenter를 통해 다른 뷰 컨트롤러에 알림 전송
        NotificationCenter.default.post(
            name: .smokingAreaAdded,
            object: nil,
            userInfo: ["area": newSmokingArea]
        )

        // 성공 메시지를 사용자에게 표시 후 뷰 종료
        showAlert(message: "새로운 흡연구역이 등록되었습니다!") {
            self.dismiss(animated: true, completion: nil)
        }
    }

    private func showAlert(message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            completion()
        }))
        present(alert, animated: true, completion: nil)
    }
}
