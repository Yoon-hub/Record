//
//  MovieImageViewController.swift
//  App
//
//  Created by 윤제 on 8/6/24.
//

import UIKit

import PinLayout

final class MovieImageViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    var image: UIImage?
    
    var closeButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .light)
        $0.setImage(UIImage(systemName: "xmark", withConfiguration: imageConfig), for: .normal)
        $0.tintColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ScrollView 설정
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.delegate = self
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .black
        view.addSubview(scrollView)
        view.addSubview(closeButton)
        
        // ImageView 설정
        imageView = UIImageView(image: UIImage(named: "your_image_name"))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = scrollView.bounds
        scrollView.addSubview(imageView)
        
        // ScrollView의 content size 설정
        scrollView.contentSize = imageView.bounds.size
        
        // 이중 탭 제스처 설정
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)
        
        // Pan Gesture 설정
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
        
        bind(image: self.image!)
        setUI()
    }
    
    func setUI() {
        closeButton.pin
            .top(64)
            .right()
            .size(40)
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    // UIScrollViewDelegate 메서드 - 어떤 뷰를 확대할지 결정
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private func bind(image: UIImage) {
        imageView.image = image
    }
    
    @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1.0 {
            scrollView.setZoomScale(2.0, animated: true)
        } else {
            scrollView.setZoomScale(1.0, animated: true)
        }
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        // 최소 이동 거리 설정 (예: 50포인트)
        let minimumDragDistance: CGFloat = 20.0
        
        // Y축으로 일정 거리 이상 이동했을 때만 처리
        if translation.y > minimumDragDistance {
            view.transform = CGAffineTransform(translationX: 0, y: translation.y - minimumDragDistance)
        }
        
        // 제스처가 끝난 경우
        if gesture.state == .ended {
            if translation.y > 200 {
                // 200포인트 이상 드래그하면 dismiss
                self.dismiss(animated: true, completion: nil)
            } else {
                // 그렇지 않으면 원래 위치로 돌아감
                UIView.animate(withDuration: 0.3) {
                    self.view.transform = .identity
                }
            }
        }
    }
}
