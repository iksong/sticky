//
//  StickyViewController.swift
//  StickyCell
//
//  Created by IK on 10/11/21.
//


import UIKit

class StickyCell: UICollectionViewCell {

    static var identifier: String = "StickyCell"

    weak var textLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        let textLabel = UILabel(frame: .zero)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(textLabel)
        NSLayoutConstraint.activate([
            self.contentView.centerXAnchor.constraint(equalTo: textLabel.centerXAnchor),
            self.contentView.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor),
        ])
        self.contentView.backgroundColor = .yellow

        self.textLabel = textLabel
        reset()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }

    func reset() {
        textLabel.textAlignment = .center
    }
}

class StickyFlowLayout: UICollectionViewFlowLayout {
    private var firstSetupDone = false
    var stickyCellIndex = IndexPath.init(row: 2, section: 0)

    override func prepare() {
        super.prepare()
        if !firstSetupDone {
            setup()
            firstSetupDone = true
        }
    }
    
    private func setup() {
        scrollDirection = .vertical
        itemSize = CGSize(width: 350, height: 100)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let allOriginalAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        var allAttributes:[UICollectionViewLayoutAttributes] = allOriginalAttributes.map {$0.copy() as! UICollectionViewLayoutAttributes}
        
        for idx in 0..<allAttributes.count {
            let layoutAttibutes = allAttributes[idx]
            if stickyCellIndex == layoutAttibutes.indexPath {
                let sticky = stickyAttribute(from: layoutAttibutes)
                allAttributes[idx] = sticky
            }
        }
        
        return allAttributes
    }
    
    func stickyAttribute(from att: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let col = collectionView else { return att }
        
        let top = col.contentOffset.y + col.contentInset.top
        let attributeHight = att.frame.height
        let attributeY = att.frame.origin.y
        
        if (top + attributeHight) > attributeY {
            var f = att.frame
            f.origin.y = max(top, attributeY)
            att.frame = f
            att.zIndex = 1
        }
        
        return att
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
            return true
    }
}

class StickyViewController: UIViewController {

    weak var collectionView: UICollectionView!
    var stickyCellIndex = IndexPath.init(row: 2, section: 0)

    var data: [String] = [
        "One", "Tow", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"
    ]
    

    override func loadView() {
        super.loadView()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: collectionView.topAnchor),
            view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
        ])
        
        let flow = StickyFlowLayout()
        flow.stickyCellIndex = self.stickyCellIndex
        collectionView.collectionViewLayout = flow

        self.collectionView = collectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(StickyCell.self, forCellWithReuseIdentifier: StickyCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCapsuleView()
    }
    
    
    func setupCapsuleView() {

    }
}

extension StickyViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StickyCell.identifier, for: indexPath) as! StickyCell
        let data = self.data[indexPath.item]
        cell.textLabel.text = data
        
        if indexPath == stickyCellIndex {
            cell.contentView.backgroundColor = .systemPink
        }
        return cell
    }
}

extension StickyViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension StickyViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) //.zero
    }
}
