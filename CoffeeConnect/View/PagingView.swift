import UIKit
import SnapKit


class PagingView: UIView, UIScrollViewDelegate {
    
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    private var models: [SpecialModel] = []
    

    init(models: [SpecialModel]) {
        self.models = models
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView() {
        backgroundColor = AppColors.special.color
        clipsToBounds = true
        layer.cornerRadius = 30
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.delaysContentTouches = true
        scrollView.canCancelContentTouches = true
        addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupPages()
        
        pageControl = UIPageControl()
        pageControl.numberOfPages = models.count
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        addSubview(pageControl)
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupPages() {
        var previousPageView: UIView?
        
        for (index, model) in models.enumerated() {
            let pageView = UIView()
            scrollView.addSubview(pageView)
            
            pageView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(self)
                
                if let previous = previousPageView {
                    make.left.equalTo(previous.snp.right)
                } else {
                    make.left.equalTo(scrollView)
                }
            }

            let titleLabel = UILabel()
            titleLabel.text = model.title
            titleLabel.textAlignment = .left
            titleLabel.textColor = .white
            titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
            pageView.addSubview(titleLabel)
            
            titleLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.leading.equalTo(pageView.snp.leading).offset(20)
            }

            let subtitleLabel = UILabel()
            subtitleLabel.text = model.subtitle
            subtitleLabel.textAlignment = .left
            subtitleLabel.textColor = .white
            pageView.addSubview(subtitleLabel)
            
            subtitleLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
                make.leading.equalTo(pageView.snp.leading).offset(20)
            }

            let button = UIButton(type: .system)
            button.setTitle(model.buttonText, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.tag = index
            button.isUserInteractionEnabled = true
            button.isEnabled = true
            button.isExclusiveTouch = true
            pageView.addSubview(button)
            
            button.snp.makeConstraints { make in
                make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
                make.leading.equalTo(pageView.snp.leading).offset(20)

            }
            
            previousPageView = pageView
        }
        
        if let previous = previousPageView {
            scrollView.snp.makeConstraints { make in
                make.right.equalTo(previous)
            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
