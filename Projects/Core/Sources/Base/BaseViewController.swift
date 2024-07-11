//
//  BaseViewController.swift
//  Core
//
//  Created by 윤제 on 7/11/24.
//

import UIKit

import ReactorKit
import RxSwift

open class BaseViewController<R: Reactor>: UIViewController, View {
    
    public typealias Reactor = R
    
    public var disposeBag = DisposeBag()
    
    public func bind(reactor: R) {
        
    }
    
    // MARK: - Intializer
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public convenience init(reactor: Reactor? = nil) {
        self.init()
        self.reactor = reactor
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Life Cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    open func setup() {}
}
