//
//  BaseViewController.swift
//  Core
//
//  Created by 윤제 on 7/11/24.
//

import UIKit

import ReactorKit
import RxSwift

open class BaseViewController<R: Reactor, V: BaseView>: UIViewController, View {
    
    public typealias Reactor = R
    
    public var disposeBag = DisposeBag()
    
    public var contentView: V
    
    open func bind(reactor: R) {}
    
    // MARK: - Intializer
    public init(contentView: V, reactor: Reactor? = nil) {
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    open override func loadView() {
        self.view = contentView
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    open func setup() {}
}
