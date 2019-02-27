//
//  OWXReaderViewController.swift
//  LeapParent
//
//  Created by 王史超 on 2018/7/2.
//  Copyright © 2018年 offcn. All rights reserved.
//

import UIKit

class OWXReaderViewController: OWXBaseViewController {

    var bookModel: OWXReaderBookModel?
    var collectionView: UICollectionView!
    var attributeString: NSMutableAttributedString?
    var displayLink: CADisplayLink!
    var lastPage: Int = NSNotFound
    var isSlide: Bool = false
    var isAutoPlay: Bool = true
    
    deinit {
        print("deinit")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopPlayStatement()
        displayLink.invalidate() // 此方法应该在惦记返回按钮的时候才调用，否则整个控制器都不会被销毁
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        playStatement(page: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        buidlSubViews()
        loadData()
        setupTimer()
    }
    
    func buidlSubViews() {
        
        view.addSubview(self.backButton)
        
        let button = UIButton()
        view.addSubview(button)
        button.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(self.backButton)
            make?.right.offset()(-50)
            make?.size.mas_equalTo()(CGSize(width: 100, height: 50))
        }
        
        button.setTitle("自动播放", for: .normal)
        button.setTitle("取消自动", for: .selected)
        button.addTarget(self, action: #selector(autoPlay(button:)), for: .touchUpInside)
        
        collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: OWXReaderLayout())
        collectionView.register(OWXReaderCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(OWXReaderCollectionViewCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.clear
        view.addSubview(collectionView)
        collectionView.mas_makeConstraints { (make) in
            make?.top.offset()(80)
            make?.left.equalTo()(self.view)
            make?.right.equalTo()(self.view)
            make?.bottom.equalTo()(self.view)
        }
        
    }
    
    @objc func autoPlay(button: UIButton) {
        isAutoPlay = button.isSelected
        button.isSelected = !button.isSelected
        
        if isAutoPlay {
            guard let cell = collectionView.visibleCells.first as? OWXReaderCollectionViewCell else { return }
            guard let indexPath = collectionView.indexPath(for: cell) else { return }
            playStatement(page: indexPath.item)
        }
    }
    
    func loadData() {
        
        let lrcPath = Bundle.main.path(forResource: "lrc", ofType: "json")
        // 加载json文件
        let data = try? Data(contentsOf: URL(fileURLWithPath: lrcPath!))
        var dict: [AnyHashable : Any] = [:]
        // json转为dictionnary或者array
        do {
            let jsonDict = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
            dict = jsonDict as! [AnyHashable : Any]
        } catch {
            print(error)
        }
        
        bookModel = OWXReaderBookModel.model(with: dict)
        
        collectionView.reloadData()
        
    }
    
    fileprivate func setupTimer() {
        
        displayLink = CADisplayLink(target: self, selector: #selector(OWXReaderViewController.displayWord))
        displayLink.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        // mode 为 NSRunLoopCommonModes
        // 调用的频率 默认为值1，代表60Hz，即每秒刷新60次，调用每秒 displayWord() 60次，这里设置为10，代表6Hz
        displayLink.frameInterval = 10
        displayLink.isPaused = true
    }
    
    @objc func displayWord() {
        
        guard let cell = collectionView.visibleCells.first as? OWXReaderCollectionViewCell else { return }
        guard let section = cell.sectionModel else { return }
        let wordRanges = cell.wordRanges
        
        var i = 0
        while true {
            
            guard let _ = wordRanges.first else { break }
            guard let _ = section.words.first else { break }
            
            let currentTime = OWXAudioManager.share().currentTime // 播放声音的的时间，ms
            let word = section.words[i]
            let currentRange = wordRanges[i]
            
            if Int(currentTime * 1000) >= Int(word.cue_start_ms)! { // 拿当前播放的声音时间与json每个单词的开始读取时间相比，
                cell.updateStatementState(rang: currentRange)
            }
            
            i += 1
            
            if i >= wordRanges.count || i >= section.words.count {
                break
            }
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class OWXReaderLayout: UICollectionViewFlowLayout {
    override func prepare() {
        itemSize = CGSize(width: (collectionView?.frame.width)!, height: (collectionView?.frame.height)!)
        minimumLineSpacing = 0
        scrollDirection = .horizontal
    }
}

extension OWXReaderViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let count = bookModel?.pages.count else { return 1 }
        
        return count - 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(OWXReaderCollectionViewCell.self), for: indexPath) as! OWXReaderCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("willDisplay-----\(indexPath.item)")
        let section = bookModel?.pages[indexPath.item].sections.first
        (cell as! OWXReaderCollectionViewCell).sectionModel = section
    }
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        let currentPage = Int(scrollView.contentOffset.x / scrollView.size.width)
        playStatement(page: currentPage)

        print("scrollViewDidEndScrollingAnimation")
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if isSlide {
            return
        }
        
        isSlide = true
        
        stopPlayStatement()
        lastPage = Int(scrollView.contentOffset.x / scrollView.size.width)
        
        print("scrollViewWillBeginDragging---lastPage----\(lastPage)")
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    
        isSlide = false
        
        let currentPage = Int(scrollView.contentOffset.x / scrollView.size.width)
        playStatement(page: currentPage)
        
        print("scrollViewDidEndDecelerating---currentPage----\(currentPage)")
        
    }
    
    func stopPlayStatement() {
        
        displayLink.isPaused = true
        OWXAudioManager.share().pauseStreamer()
    }
    
    func playStatement(page: Int) {
        
        displayLink.isPaused = false
        
        if page == lastPage {
            OWXAudioManager.share().playStreamerComplete {
                [weak self] in
                self?.statementPlayComplete(page: page)
            }
        }
        else {
            playNewStatement(page: page)
        }
    }
    
    func playNewStatement(page: Int) {
        
        var audioName = "cover.mp3"
        if page > 0 {
            audioName = "p_\(page).mp3"
        }
        
        let audioPath = Bundle.main.path(forResource: audioName, ofType: nil)
        let fileUrl = URL(fileURLWithPath: audioPath!)
        
        OWXAudioManager.share().playStreamer(withAudioFile: fileUrl) {
            [weak self] in
            self?.statementPlayComplete(page: page)
        }
    }
    
    func statementPlayComplete(page: Int) {
        
        stopPlayStatement()
        
        guard let cell = collectionView.visibleCells.first as? OWXReaderCollectionViewCell else { return }
        cell.updateStatementState(rang: nil)
        
        guard let pageCount = bookModel?.pages.count, page < pageCount - 2 else { return }
        
        if isAutoPlay {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                self.lastPage = page
                self.collectionView.scrollToItem(at: IndexPath(item: page + 1, section: 0), at: .left, animated: true)
            }
        }
        
    }
    
}
