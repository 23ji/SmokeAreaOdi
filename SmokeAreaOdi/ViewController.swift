import UIKit
import NMapsMap
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: - Properties
    let locationManager = CLLocationManager() // 위치 관리자 객체
    @IBOutlet weak var naverMapView: NMFNaverMapView! // 스토리보드에서 연결한 NaverMapView
    @IBOutlet weak var addMarkerButton: UIButton!  // 추가 버튼
    
    var currentMarker: NMFMarker?  // 현재 마커를 추적할 변수
    var isAddingMarker = false     // 마커 추가 상태 추적 변수
    var isChecked = false  // 버튼 상태 추적 (체크됨/체크 안 됨)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NaverMapView 설정
        setupNaverMapView()
        addSmokingAreaMarkers()
    }
    
    // MARK: - Setup Methods
    private func setupNaverMapView() {
        // 지도 초기 위치 설정 (역삼역)
        let initialLocation = NMGLatLng(lat: 37.500920152198, lng: 127.03618231961)
        let cameraUpdate = NMFCameraUpdate(scrollTo: initialLocation)
        naverMapView.mapView.moveCamera(cameraUpdate)
        
        // 위치 버튼 표시
        naverMapView.showLocationButton = true
    }
    
    private func addSmokingAreaMarkers() {
        // SmokingAreaData.swift의 데이터를 사용해 마커 추가
        for area in smokingAreas {
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: area.latitude, lng: area.longitude)
            marker.captionText = area.name
            marker.mapView = naverMapView.mapView
        }
    }
    
    // MARK: - addMarkerButton 클릭 시 마커 생성
    @IBAction func addMarkerButtonTapped(_ sender: UIButton) {
        isChecked.toggle()
                
                // 버튼 아이콘 업데이트
                updateButtonIcon()
                
                // 아이콘 상태에 맞게 마커 추가
                if isChecked {
                    // 버튼이 체크됨 상태이면 마커 추가
                    addMarker()
                } else {
                    // 버튼이 체크 안 됨 상태이면 마커 제거
                    removeMarker()
                }
    }
    
    // MARK: - 마커 추가
        private func addMarker() {
            let mapView = naverMapView.mapView
            let center = mapView.cameraPosition.target
            
            // 마커가 없다면 새로 생성
            if currentMarker == nil {
                currentMarker = NMFMarker()
                currentMarker?.position = center
                currentMarker?.mapView = mapView
                currentMarker?.captionText = "새로운 마커"
                //currentMarker?.isDraggable = true
            } else {
                // 이미 마커가 있다면 위치만 업데이트
                currentMarker?.position = center
            }
        }

        // MARK: - 마커 제거
        private func removeMarker() {
            if let marker = currentMarker {
                marker.mapView = nil  // 마커 제거
                currentMarker = nil  // 마커 변수 초기화
            }
        }
    
    private func updateButtonIcon() {
           if isChecked {
               // 체크된 상태: checkmark.circle.fill
               addMarkerButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
           } else {
               // 체크 안 된 상태: circle
               addMarkerButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
           }
       }
    
    private func startMarkerAddition() {
        print("마커 추가 시작")
        
     
        // 버튼을 완료 아이콘으로 변경
        addMarkerButton.setImage(UIImage(named: "complete_icon"), for: .normal)
        
        // 마커 생성
        let mapView = naverMapView.mapView
        let center = mapView.cameraPosition.target
        
        // 마커가 없다면 새로 생성
        if currentMarker == nil {
            currentMarker = NMFMarker()
            currentMarker?.position = center
            currentMarker?.mapView = mapView
            currentMarker?.captionText = "새로운 마커"  // 기본 이름 설정
        } else {
            // 이미 마커가 있다면 위치만 업데이트
            currentMarker?.position = center
        }
        
        // 마커가 지도에 제대로 추가되었는지 확인
        print("현재 마커 위치: \(center.lat), \(center.lng)")
        
        // 상태를 변경하여 다음 클릭 시 완료 버튼으로 바뀌도록 설정
        isAddingMarker = true
    }
    
    private func completeMarkerAddition() {
        print("마커 추가 완료")
        
        // 완료 후 버튼을 다시 추가 아이콘으로 변경
        addMarkerButton.setImage(UIImage(named: "add_icon"), for: .normal)
        
        // 마커 추가 완료 후 더 이상 이동하지 않도록 할 수 있음 (필요 시)
        //currentMarker?.isDraggable = false
        
        // 상태를 변경하여 다시 추가 상태로 돌아가게 설정
        isAddingMarker = false
    }
}
