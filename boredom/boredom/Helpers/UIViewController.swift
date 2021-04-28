//
//  UIViewController.swift
//  WalkthroughOnboarding
//

//

import UIKit

extension UIViewController {
  
  func addChildViewControllerWithView(_ childViewController: UIViewController, toView view: UIView? = nil) {
    let view: UIView = view ?? self.view
    
    childViewController.removeFromParentViewController()
    childViewController.willMove(toParentViewController: self)
    addChildViewController(childViewController)
    childViewController.didMove(toParentViewController: self)
    childViewController.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(childViewController.view)
    view.addConstraints([
      NSLayoutConstraint(item: childViewController.view!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: -10),
      NSLayoutConstraint(item: childViewController.view!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: childViewController.view!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: childViewController.view!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
    ])
    view.layoutIfNeeded()
  }
  
  func removeChildViewController(_ childViewController: UIViewController) {
    childViewController.removeFromParentViewController()
    childViewController.willMove(toParentViewController: nil)
    childViewController.removeFromParentViewController()
    childViewController.didMove(toParentViewController: nil)
    childViewController.view.removeFromSuperview()
    view.layoutIfNeeded()
  }
  
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}
