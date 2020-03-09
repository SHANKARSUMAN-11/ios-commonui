//
//  BM_GridProductListingView.swift
//  BlibliMobile-iOS
//
//  Created by sagar daundkar on 11/07/18.
//  Copyright © 2018 Global Digital Niaga, PT. All rights reserved.
//

import UIKit

public enum ProductStatus {
    case withGradient
    case withoutGradient
}

public class VerticalProductCell: UIView {
    
    @IBOutlet public var view: UIView!
    @IBOutlet public weak var productImage: UIImageView!
    @IBOutlet public weak var variantsView: ProductVariantsView!
    @IBOutlet public weak var favoriteButton: UIButton!
    @IBOutlet public weak var productName: UILabel!
    @IBOutlet public weak var strikeThroughPrice: UILabel!
    @IBOutlet public weak var productPrice: UILabel!
    
    @IBOutlet public weak var stockAvailability: UILabel!
    @IBOutlet public weak var ratingView: UIView!
    @IBOutlet public weak var firstRatingImage: UIImageView!
    @IBOutlet public weak var secondRatingImage: UIImageView!
    @IBOutlet public weak var thirdRatingImage: UIImageView!
    @IBOutlet public weak var fourthRatingImage: UIImageView!
    @IBOutlet public weak var fifthRatingImage: UIImageView!
    @IBOutlet public weak var ratingCount: UILabel!
    @IBOutlet public weak var ratingViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet public weak var productStatusView: UIView!
    @IBOutlet public weak var productStatusLabel: UILabel!
    @IBOutlet public weak var productStatusLabel2: InsetLabel!
    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet public weak var multiMerchantLabel: UILabel!
    @IBOutlet public weak var buyButton: CustomButton!
    @IBOutlet public weak var buyButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var promoImage: UIImageView!
    
    /*
    @IBOutlet public weak var widthConstraintOfLogoImage: NSLayoutConstraint!
    
    
    var buttonClickCompletionBlock : ((UIButton) -> Void)?
    
    @IBAction func buyButtonAction(_ sender: UIButton) {
        self.buttonClickCompletionBlock?(sender)
    }
    
    @IBOutlet weak var productStatus: UIButton!
    
    @IBAction func productStatusButton(_ sender: UIButton) {
        buttonClickCompletionBlock?(sender)
    }
    @IBOutlet weak var heightCNCImageView: NSLayoutConstraint!
    @IBOutlet weak var cncImageView: UIImageView!
    
    var promoEndTime: Double?
    @IBOutlet weak var fulfilledByBlibliLogo: UIImageView! //also for cnc
    
    */
    
    public var productStatus: NSAttributedString? = nil {
        didSet {
            self.productStatusLabel.attributedText = productStatus
            self.productStatusLabel.sizeToFit()
            
            self.productStatusLabel2.attributedText = productStatus
            self.productStatusLabel2.sizeToFit()
        }
    }
    
    public var shouldShowBuyButton: Bool = true {
        didSet {
            if shouldShowBuyButton {
                self.buyButton.isHidden = false
                self.buyButtonHeightConstraint.constant = 40.0
            } else {
                self.buyButton.isHidden = true
                self.buyButtonHeightConstraint.constant = 0.0
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    private func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "VerticalProductCell", bundle: bundle)
        view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        view.fixInView(self)
        addSubview(view)
        
        self.shouldShowBuyButton = false
        configureFavoriteButton()
        self.setRating(averageRating: nil, reviewCount: 0)
        
        self.productStatusLabel2.edgeInset = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 2.0, right: 5.0)
    }
    
    func configureFavoriteButton() {
        favoriteButton.isHidden = true
        favoriteButton.layer.cornerRadius = 15.0
        favoriteButton.layer.borderWidth = 0.0
        favoriteButton.backgroundColor = .white
        favoriteButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        favoriteButton.layer.shadowOpacity = 0.5
        favoriteButton.layer.shadowColor = UIColor.lightGray.cgColor
        favoriteButton.layer.shadowRadius = 6.0
        favoriteButton.layer.masksToBounds = false
    }
    
    public func setWishlistStatus(with isAddedToWishlist: Bool, imageName: String? = nil, selectedImageName: String? = nil) {
        
        if isAddedToWishlist {
            favoriteButton.setImage(UIImage().getImage(named: selectedImageName ?? "favorite_selected"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage().getImage(named: imageName ?? "favorite"), for: .normal)
        }
        self.favoriteButton.isHidden = false
    }
    
    public func setPromoImage(with image: UIImage?) {
        
        if let image = image {
            promoImage.image = image
            promoImage.isHidden = false
        } else {
            promoImage.isHidden = true
        }
    }
    
    public func setProductStatus(with status: ProductStatus, text: NSAttributedString? = nil, colorRange: [UIColor]? = nil) {
        
        switch status {
        case .withGradient:
            productStatusView.isHidden = false
            productStatusLabel.attributedText = text
            productStatusLabel2.isHidden = true
            productStatusView.roundedCorners(corners: [.topRight, .bottomRight], radius: 9.0)
            productStatusView.setGradient(with: colorRange, from: CGPoint(x: 0.0, y: 1.0), to: CGPoint(x: 1.0, y: 1.0))
            
        case .withoutGradient:
            productStatusView.isHidden = true
            productStatusLabel2.isHidden = false
            productStatusLabel2.attributedText = text
            productStatusLabel2.layer.cornerRadius = 9
            productStatusLabel2.clipsToBounds = true
            productStatusLabel2.backgroundColor = colorRange?.first
        }
        
    }
    /*
    fileprivate func addToCartButtonSetUp(_ isAddToCart: Bool, _ product: BM_PLProducts) {
        if isAddToCart {
            buyButton.isHidden = false
            buyButtonHeightConstraint.constant = 40.0
            self.setBuyButtonBlue()
            if let  tags = product.tags, tags.contains("BIG_PRODUCT") {
                buyButton.setTitle(BMLocalized("common.viewLabel"), for: .normal)
            } else if product.status == "OUT_OF_STOCK" || product.status == "COMING_SOON" {
                buyButton.setTitle(BMLocalized("common.viewLabel"), for: .normal)
            } else {
                buyButton.setTitle(BMLocalized("Add to Cart"), for: .normal)
            }
        } else {
            buyButton.isHidden = true
            buyButtonHeightConstraint.constant = 0.0
        }
    }
    
    fileprivate func productStatusInfo(_ product: BM_PLProducts) {
        if let productStatus = product.status, let status = BM_ProductStatusAvailability(rawValue: productStatus) {
            switch status {
            case .comingSoon:
                productStatusView.isHidden = false
                self.productStatusView.backgroundColor = BM_Color.getColorValue(colorType: .lightBlue)
                self.productStatusLabel.text = BMLocalized("Segera Hadir").uppercased()
            case .limitedStock:
                productStatusView.isHidden = false
                self.productStatusView.backgroundColor = BM_Color.getColorValue(colorType: .green)
                self.productStatusLabel.text = BMLocalized("Stok Terbatas").uppercased()
            default:
                break
            }
        }
        if let tags = product.tags, tags.count > 0, tags.contains("NEW") {
            productStatusView.isHidden = false
            self.productStatusView.backgroundColor = BM_Color.getColorValue(colorType: .green)
            self.productStatusLabel.text = BMLocalized("Baru").uppercased()
        }
    }
 
    func setUpXib(product:BM_PLProducts, isAddToCart:Bool,timerHelper: BM_CommonTimerHelper? = nil) {
        self.timerLabel.isHidden = true
        self.timerLabel.text = ""
        self.productName.text = product.name
        self.setUpDiscountAndPriceLabel(priceDisplay: product.price?.priceDisplay, strikeThroughPriceDisplay: product.price?.strikeThroughPriceDisplay, isCNC: product.tags?.contains("CNC_AVAILABLE"), discount: product.price?.discount)
        if let img = product.images?.first, let url = URL(string: img) {
            self.productImage.sd_setImage(url: url, options: .continueInBackground, contentMode: UIView.ContentMode.scaleToFill, completed: nil)
        }
        productStatusView.layer.cornerRadius = 2
        productStatusView.layer.masksToBounds = true
        productStatusView.isHidden = true
        productStatusLabel.text = nil
        productStatusInfo(product)
        self.configureRating(averageRating: product.review?.rating, reviewCount:  product.review?.count)
        
        // MultiMerchant & other offers section
        multiMerchantLabel.text = nil
        if let count = product.otherOfferings?.count, count > 0, let minSyncProductPrice = product.otherOfferings?.startPrice {
            var isLinkable = false
            if let formattedId = product.formattedId, !formattedId.isEmpty, formattedId.lowercased().contains("pr") {
                isLinkable = true
            }
            self.setUpMultiMerchantText(minSyncProductPrice: minSyncProductPrice, count: count, linkable: isLinkable)
        }
        addToCartButtonSetUp(isAddToCart, product)
        self.productStatus.setTitle("", for: .normal)
        self.productStatus.isHidden = true
        self.blurrView.isHidden = true
        self.setProductStatusInfo(product: product)
        if let promoEndTime = product.promoEndTime,
            promoEndTime > 0 {
            self.promoEndTime = promoEndTime
            timerHelper?.getTimer(for: promoEndTime, with: self)
            self.timerLabel.isHidden = false
            var serverDate = Date()
            if let date = timerHelper?.serverTime {
                serverDate = date
            }
            let timerObject = BM_CommonTimerHelper.getTimeDifference(fromTime: serverDate, endTime: BM_DateHelper.dateFromMilliSeconds(withDoubleValue: promoEndTime))
            self.currentTimeString(timerObject.hour, timerObject.min, timerObject.sec, timerObject.remainingTime)
        }
        setProductTagLogo(product: product)
    }
    
    func setProductStatusInfo(product: BM_PLProducts) {
        self.productStatus.layer.cornerRadius = 2
        self.productStatus.layer.masksToBounds = true
        if product.status == "OUT_OF_STOCK" {
            self.productStatus.setTitle(BMLocalized("Stok Habis").uppercased(), for: .normal)
            self.productStatus.isHidden = false
            self.blurrView.isHidden = false
        }
        if product.storeClosingInfo?.storeClosed == true {
            self.productStatus.setTitle(BMLocalized("Toko Tutup").uppercased(), for: .normal)
            self.productStatus.isHidden = false
            self.blurrView.isHidden = false
            buyButton.setTitle(BMLocalized("common.viewLabel"), for: .normal)
            setBuyButtonBlue()
        }
    }
    */
    
    public func setPrice(withPrice price: String?, strikeThroughPriceDisplay: String?, isCNC: Bool?, discount: Int?) {
        
        self.strikeThroughPrice.text = nil
        self.productPrice.text = price
        
        if let discount = discount, discount > 0 , let strikeThroughPriceDisplay = strikeThroughPriceDisplay {
            
            let strikeThroughPriceWithDiscount = "\(String(describing: strikeThroughPriceDisplay)) \(discount)% OFF"
            let attrStrikeThroughPriceWithDiscount = NSMutableAttributedString(string: strikeThroughPriceWithDiscount)
            attrStrikeThroughPriceWithDiscount.addAttribute(NSAttributedString.Key.baselineOffset, value: 0, range: NSMakeRange(0, strikeThroughPriceWithDiscount.count))
            attrStrikeThroughPriceWithDiscount.addAttributes([NSAttributedString.Key.strikethroughStyle: 1], range: (strikeThroughPriceWithDiscount as NSString).range(of: strikeThroughPriceDisplay))
            attrStrikeThroughPriceWithDiscount.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: "#ef3b42")], range: (strikeThroughPriceWithDiscount as NSString).range(of: "\(discount)% OFF"))
            strikeThroughPrice.attributedText = attrStrikeThroughPriceWithDiscount
        }
    }
    
    
    public func setRating(averageRating: Int?, reviewCount:Int?) {
        //Set rating
        self.ratingView.isHidden = true
        self.ratingCount.text = nil
        ratingViewHeightConstraint.constant = 0.0
        if let averageRating = averageRating, averageRating > 0 {
            self.ratingView.isHidden = false
            ratingViewHeightConstraint.constant = 15.0
            self.setRatings(averageRating)
            
            if let reviewCount = reviewCount {
                if reviewCount > 100 {
                    self.ratingCount.text = "(100+)"
                } else if reviewCount > 0 {
                    self.ratingCount.text = "(\(reviewCount))"
                }
            }
        }
    }
    
    public func setMerchant(minSyncProductPrice: String, count: Int, linkable:Bool = false) {
        multiMerchantLabel.text = nil
        
        /*
        var offerPrice = minSyncProductPrice
        if let doublePriceValue = Double(minSyncProductPrice) {
            offerPrice = Utilities.formatCurrency(from: doublePriceValue)
        }
        let offerMaxCount = BM_BlibliConfigManager.sharedInstance.otherOffersMaxCount > 0 ? BM_BlibliConfigManager.sharedInstance.otherOffersMaxCount : 50
        let attributedString = NSMutableAttributedString(string: String.init(format: BMLocalized("searchResult.moreOffers.text%d%@"), count > offerMaxCount ? offerMaxCount : count, count > offerMaxCount ? "+" : ""), attributes: [NSAttributedString.Key.foregroundColor: ColorType.blackText.value])
        attributedString.append(NSAttributedString(string: offerPrice, attributes: [NSAttributedString.Key.foregroundColor: linkable ? ColorType.lightBlue.value : ColorType.blackText.value , NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13.0)]))
        */
        
        let moreMerchants = (count > 50) ? "+" : ""
        
        let attributedString = NSAttributedString(string: "\(count)\(moreMerchants) penawaran lain", attributes: [NSAttributedString.Key.foregroundColor: linkable ? UIColor(hexString: "#0095da") : UIColor.black])
        multiMerchantLabel.attributedText = attributedString
    }
    
    //MARK: - Cell setup methods
    
    func setRatings(_ rating: Int) {
        let imageViews = [firstRatingImage, secondRatingImage, thirdRatingImage, fourthRatingImage, fifthRatingImage]
        var ratingLimited = rating
        if ratingLimited > 5 {
            ratingLimited = 5
        }
        if ratingLimited < 0 {
            ratingLimited = 0
        }
        for i in 0 ..< ratingLimited {
            imageViews[i]?.image = UIImage().getImage(named: "star-filled")
        }
        for j in ratingLimited ..< 5 {
            imageViews[j]?.image = UIImage().getImage(named: "star-filled-greyed")
        }
    }
    
    /*
    func setBuyButtonWhite() {
        buyButton.borderColor = ColorType.lightBlue.value
        buyButton.layer.borderWidth = 2.0
        buyButton.backgroundColor = UIColor.white
        buyButton.setTitleColor(ColorType.lightBlue.value, for: .normal)
    }
    
    func setBuyButtonBlue() {
        buyButton.borderColor = UIColor.clear
        buyButton.layer.borderWidth = 0.0
        buyButton.backgroundColor = ColorType.lightBlue.value
        buyButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func setProductTagLogo(product:BM_PLProducts) {
        heightCNCImageView.constant = 0
        widthConstraintOfLogoImage.constant = 0
        cncImageView.isHidden = true
        if let url =  BM_NewProductListCollectionViewCell.getTheUrl(product: product) {
            self.setLogoURL(url: url)
        }
        if let url = BM_NewProductListCollectionViewCell.getPromoBadgeURL(product: product) {
            self.setPromoURL(url: url)
        }
    }
    
    func setPromoURL(url: URL) {
        promoImageLogo.sd_setImage(url: url,options: .continueInBackground, contentMode: .scaleAspectFill, completed: nil)
    }
    
    func setLogoURL(url: URL) {
        fulfilledByBlibliLogo.sd_setImage(url: url, options: .continueInBackground, contentMode: .scaleAspectFill, completed: nil)
    }
}
extension BM_GridProductListingView : BM_CommonTimerObserver {
    
    var observerId: String {
        get {
            return UUID().uuidString
        }
    }
    
    func currentTimeString(_ hour: Int, _ min: Int, _ sec: Int,_ remainingTime: Int) {
        if remainingTime > 0 {
            if hour < 24 {
                let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: BMLocalized("product.listing.timeRemaining"), attributes: [NSAttributedString.Key.foregroundColor:ColorType.timerRed.value, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)]))
                attributedText.append(NSAttributedString(string: String.init(format: "%02d:%02d:%02d", hour,min,sec), attributes: [NSAttributedString.Key.foregroundColor:ColorType.timerRed.value, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)]))
                self.timerLabel.attributedText = attributedText
            } else if let promoendTime = self.promoEndTime {
                let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: BMLocalized("product.listing.time.alternateText"), attributes: [NSAttributedString.Key.foregroundColor:ColorType.timerRed.value, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)]))
                attributedText.append(NSAttributedString(string: BM_DateHelper.stringFromDate(BM_DateHelper.dateFromMilliSeconds(withDoubleValue: promoendTime), format: "dd-MM-yyyy"), attributes: [NSAttributedString.Key.foregroundColor:ColorType.timerRed.value, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)]))
                self.timerLabel.attributedText = attributedText
            }
        } else {
            self.timerLabel.attributedText = NSAttributedString(string: BMLocalized("product.listing.timeEnded").uppercased(), attributes: [NSAttributedString.Key.foregroundColor:ColorType.red.value, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15.0)])
        }
    }
 */
}
