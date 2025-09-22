//
//  UITableView+Combine.swift
//  Core
//
//  Created by 윤제 on 4/3/25.
//

import UIKit

import Combine

extension UITableView {
    func bind<T: Hashable>(
        to publisher: AnyPublisher<[T], Never>,
        cellProvider: @escaping (UITableView, IndexPath, T) -> UITableViewCell
    ) -> AnyCancellable {
        let dataSource = UITableViewDiffableDataSource<Int, T>(tableView: self) { tableView, indexPath, item in
            return cellProvider(tableView, indexPath, item)
        }
        
        return publisher
            .sink { items in
                var snapshot = NSDiffableDataSourceSnapshot<Int, T>()
                snapshot.appendSections([0])
                snapshot.appendItems(items)
                dataSource.apply(snapshot, animatingDifferences: true)
            }
    }
}

