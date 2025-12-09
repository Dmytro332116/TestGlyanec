import UIKit

extension UIView
{

    @IBInspectable var borderWidth : CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor : UIColor? {
        get {
            if let color = self.layer.borderColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
        
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var circle : Bool {
        get {
            return vCornerRadius == self.frame.width/2
        }
        set {
            let minDimension = min(self.frame.width, self.frame.height)
            vCornerRadius = (newValue ? minDimension/2 : 0)
        }
    }
    
    @IBInspectable var vCornerRadius : CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.masksToBounds = newValue > 0
            self.layer.cornerRadius = newValue
        }
    }
    
    
    func border(color: UIColor = UIColor.lightGray,
                width: CGFloat = 1.0) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }

    func cornerRadius(radius: CGFloat = 8.0) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }

    func shadow(opacity: Float = 0.3,
                offset: CGSize = CGSize(width: 0, height: 1),
                radius: CGFloat = 3) {
        self.clipsToBounds = false
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                             cornerRadius: self.layer.cornerRadius).cgPath
    }

    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        layer.add(animation, forKey: "shake")
    }

    func roundCorners(cornerRadius: Double) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
         let maskLayer = CAShapeLayer()
         maskLayer.frame = self.bounds
         maskLayer.path = path.cgPath
         self.layer.mask = maskLayer
     }
    
    func roundExtensionCorners(corners: UIRectCorner, radius: CGFloat) {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
}

extension UIView {

    func addConstaintsToPinHorizontalEdgesToSuperView(padding: CGFloat = 0) {
        prepareForConstraints()
        self.superview!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(padding)-[view]-(padding)-|",
                                                                      options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                      metrics: ["padding":padding],
                                                                      views: ["view":self]))
    }
    
    func addConstaintsToPinVerticalEdgesToSuperView(padding: CGFloat = 0) {
        prepareForConstraints()
        self.superview!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(padding)-[view]-(padding)-|",
                                                                      options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                      metrics: ["padding":padding],
                                                                      views: ["view":self]))
    }
    
    func addConstaintsToCenterVertically() {
        prepareForConstraints()
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .centerY,
                                                         relatedBy: .equal,
                                                         toItem: self.superview!,
                                                         attribute: .centerY,
                                                         multiplier: 1.0, constant: 0))
    }
    
    func addConstaintsToCenterHorizontally() {
        prepareForConstraints()
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .centerX,
                                                         relatedBy: .equal,
                                                         toItem: self.superview!,
                                                         attribute: .centerX,
                                                         multiplier: 1.0, constant: 0))
    }
    
    func addConstaintsToPinLeadingToSuperview(constant: CGFloat) -> NSLayoutConstraint {
        prepareForConstraints()
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: self.superview!,
                                            attribute: .leading,
                                            multiplier: 1, constant: constant)
        
        self.superview!.addConstraint(constraint)
        return constraint
    }
    
    func addConstaintsToPinTrailingToSuperview(constant: CGFloat) -> NSLayoutConstraint {
        prepareForConstraints()
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .trailing,
                                            relatedBy: .equal,
                                            toItem: self.superview!,
                                            attribute: .trailing,
                                            multiplier: 1, constant: constant)
        self.superview!.addConstraint(constraint)
        return constraint
    }
    
    func addConstaintsToPinTopToSuperview(constant: CGFloat) -> NSLayoutConstraint {
        prepareForConstraints()
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: self.superview!,
                                            attribute: .top,
                                            multiplier: 1, constant: constant)
        self.superview!.addConstraint(constraint)
        return constraint
    }
    
    func addConstaintsToPinTopToView(view:UIView,constant: CGFloat) -> NSLayoutConstraint {
        prepareForConstraints()
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .top,
                                            multiplier: 1, constant: constant)
        self.superview!.addConstraint(constraint)
        return constraint
    }
    func addConstaintsToPinTopToViewBottom(view:UIView,constant: CGFloat) -> NSLayoutConstraint {
        prepareForConstraints()
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .bottom,
                                            multiplier: 1, constant: constant)
        self.superview!.addConstraint(constraint)
        return constraint
    }
    
    func addConstaintsToPinBottomToView(constant: CGFloat) -> NSLayoutConstraint {
        prepareForConstraints()
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: self.superview!,
                                            attribute: .bottom,
                                            multiplier: 1,
                                            constant: constant)
        self.superview!.addConstraint(constraint)
        return constraint
    }
    
    func addWidthConstaintsToView(constant: CGFloat) -> NSLayoutConstraint {
        prepareForConstraints()
        let constraint = NSLayoutConstraint (item: self,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .width,
                                             multiplier: 1,
                                             constant: constant)
        self.superview!.addConstraint(constraint)
        return constraint
    }
    
    func addHeightConstaintsToView(constant: CGFloat) -> NSLayoutConstraint {
        prepareForConstraints()
        let constraint = NSLayoutConstraint (item: self,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .height,
                                             multiplier: 1,
                                             constant: constant)
        self.superview!.addConstraint(constraint)
        return constraint
    }
    
    func addTopLeftConstaints(view: UIView, xIndent: CGFloat, yIndent: CGFloat) {
        prepareForConstraints()
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: xIndent) .isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: yIndent) .isActive = true
    }
    func addTopLeftHeightWidthConstaints(view: UIView, top: CGFloat, left: CGFloat, height: CGFloat, width: CGFloat) {
        prepareForConstraints()
        heightAnchor.constraint(equalToConstant: height) .isActive = true
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: left) .isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: top) .isActive = true
        widthAnchor.constraint(equalToConstant: width) .isActive = true
    }
    
    func addTopRightHeightWidthConstaints(view: UIView, top: CGFloat, right: CGFloat, height: CGFloat, width: CGFloat) {
        prepareForConstraints()
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: right) .isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: top) .isActive = true
        heightAnchor.constraint(equalToConstant: height) .isActive = true
        widthAnchor.constraint(equalToConstant: width) .isActive = true
    }
    
    func addTopHeightWidthConstaints(view: UIView, top: CGFloat, height: CGFloat, width: CGFloat) {
        
        topAnchor.constraint(equalTo: view.topAnchor, constant: top) .isActive = true
        heightAnchor.constraint(equalToConstant: height) .isActive = true
        widthAnchor.constraint(equalToConstant: width) .isActive = true
        
    }
    
    func addTopLeftRightConstaints(view: UIView, right: CGFloat, left: CGFloat, top: CGFloat) {
        prepareForConstraints()
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: right) .isActive = true
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: left) .isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: top) .isActive = true
    }
    
    func addTopLeftRightHeightConstaints(view: UIView, right: CGFloat, left: CGFloat,height: CGFloat, top: CGFloat) {
        prepareForConstraints()
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: right) .isActive = true
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: left) .isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: top) .isActive = true
        heightAnchor.constraint(equalToConstant: height) .isActive = true
    }
    
    func addTopLeftRightBottomConstaints(view: UIView, right: CGFloat, left: CGFloat,bottom: CGFloat, top: CGFloat) {
        prepareForConstraints()
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: right) .isActive = true
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: left) .isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: top) .isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom) .isActive = true
    }
    
    func addBottomLeftRightConstaints(view: UIView, right: CGFloat, left: CGFloat, bottom: CGFloat) {
        prepareForConstraints()
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: right) .isActive = true
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: left) .isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom) .isActive = true
    }
    
    func addLeftRightConstaints(view: UIView, right: CGFloat, left: CGFloat ) {
        prepareForConstraints()
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: right) .isActive = true
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: left) .isActive = true
    }
    
    func addTopRightConstaints(view: UIView, xIndent: CGFloat, yIndent: CGFloat) {
        prepareForConstraints()
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: xIndent) .isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: yIndent) .isActive = true
    }
    
    func addLeftBottomConstaints(view: UIView, xIndent: CGFloat, yIndent: CGFloat) {
        prepareForConstraints()
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: xIndent) .isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: yIndent) .isActive = true
    }
    
    func addTopLeftBottomWidthConstaints(view: UIView, left: CGFloat, bottom: CGFloat, top: CGFloat, width: CGFloat) {
        prepareForConstraints()
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: left) .isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom) .isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: top) .isActive = true
        widthAnchor.constraint(equalToConstant: width) .isActive = true
    }
    
    func addTopRightBottomWidthConstaints(view: UIView, right: CGFloat, bottom: CGFloat, top: CGFloat, width: CGFloat) {
        prepareForConstraints()
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: right) .isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom) .isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: top) .isActive = true
        widthAnchor.constraint(equalToConstant: width) .isActive = true
    }
    
    func addTopLeftAnchorBottomWidthConstaints(view: UIView,leftViewAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, left: CGFloat, bottom: CGFloat, top: CGFloat, width: CGFloat) {
        prepareForConstraints()
        leftAnchor.constraint(equalTo: leftViewAnchor , constant: left) .isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom) .isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: top) .isActive = true
        widthAnchor.constraint(equalToConstant: width) .isActive = true
    }
    
    func addTopAnchorLeftRightBottomConstaints(view: UIView,topViewAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, left: CGFloat, bottom: CGFloat, top: CGFloat,right: CGFloat) {
        prepareForConstraints()
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: right) .isActive = true
        leftAnchor.constraint(equalTo: view.leftAnchor , constant: left) .isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom) .isActive = true
        topAnchor.constraint(equalTo:topViewAnchor , constant: top) .isActive = true
        
    }
    
    func addRightBottomConstaints(view: UIView, xIndent: CGFloat, yIndent: CGFloat) {
        prepareForConstraints()
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: xIndent) .isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: yIndent) .isActive = true
    }
    
    func addSizeConstaints(weight: CGFloat, height: CGFloat) {
        prepareForConstraints()
        widthAnchor.constraint(equalToConstant: weight) .isActive = true
        heightAnchor.constraint(equalToConstant: height) .isActive = true
    }
    
    func addConstaintsToFillSuperviewWithPadding(padding: CGFloat = 0) {
        prepareForConstraints()
        addConstaintsToPinHorizontalEdgesToSuperView(padding: padding)
        addConstaintsToPinVerticalEdgesToSuperView(padding: padding)
    }
    
    private func prepareForConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        if superview == nil {
            assert(false, "You need to have a superview before you can add contraints")
        }
    }
    
    func showActivityIndicator() -> UIActivityIndicatorView {
        let activityView = UIActivityIndicatorView(style: .whiteLarge)
        activityView.center = self.center
        activityView.startAnimating()
        
        self.addSubview(activityView)
        activityView.startAnimating()
        
        return activityView
    }
    
    func asImage() -> UIImage {
    
        UIGraphicsBeginImageContext(self.frame.size)
        self.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImage(cgImage: image!.cgImage!)
        
    }    
}

