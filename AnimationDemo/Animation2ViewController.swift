//
//  Animation2ViewController.swift
//  AnimationDemo
//
//  Created by 郭建斌 on 16/5/13.
//  Copyright © 2016年 郭建斌. All rights reserved.
//

import UIKit

class Animation2ViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning,UIViewControllerInteractiveTransitioning {

    var indexPath: NSIndexPath?
    @IBOutlet weak var collectionView: UICollectionView!
    
    var navigationOperation: UINavigationControllerOperation?
    
    var interactivePopTransition: UIPercentDrivenInteractiveTransition!
    
    var transitioningView: UIView?
    
    var transitioningContext:UIViewControllerContextTransitioning?
    
    var isTransiting:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.delegate = self
        
        let  screenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(Animation1ViewController.handlePopRecognizer(_:)))
        
        screenEdgePanGestureRecognizer.edges = UIRectEdge.Left
        
        self.navigationController!.view.addGestureRecognizer(screenEdgePanGestureRecognizer)
    }
    func handlePopRecognizer(screenEdgePanGestureRecognizer:UIScreenEdgePanGestureRecognizer) -> Void {
        
        let point = screenEdgePanGestureRecognizer.translationInView(self.navigationController?.view).x
        var progress:CGFloat!
        
        let width = self.view.bounds.size.width
        
        progress = point / width
        
        
        progress = min(1.0, max(0.0, progress))
        
        if screenEdgePanGestureRecognizer.state == UIGestureRecognizerState.Began {
            isTransiting = true
            self.interactivePopTransition = UIPercentDrivenInteractiveTransition()
            self.navigationController?.popViewControllerAnimated(true)
            
            
        }else if screenEdgePanGestureRecognizer.state == UIGestureRecognizerState.Changed
        {
            self.interactivePopTransition.updateInteractiveTransition(progress)
//            updateInteractiveTransition(progress)
        }
        else if screenEdgePanGestureRecognizer.state == UIGestureRecognizerState.Ended || screenEdgePanGestureRecognizer.state == UIGestureRecognizerState.Cancelled
        {
            if progress > 0.5 {
                self.interactivePopTransition.finishInteractiveTransition()
                self.interactivePopTransition = nil
            }
            else
            {
                self.interactivePopTransition.cancelInteractiveTransition()
                self.interactivePopTransition = nil
            }
            self.interactivePopTransition = nil
//            finishBy(progress < 0.5)
//            isTransiting = false
        }
        
        
    }
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        
//        if !self.isTransiting {
//            return nil
//        }
//        
//        return self
        
        if  self.interactivePopTransition == nil {
            return nil
        }
        return self.interactivePopTransition
    }
    func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitioningContext = transitionContext
        
        let containerView = transitioningContext!.containerView()
        
        let toViewController = transitioningContext!.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let fromViewController = transitioningContext!.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        containerView?.insertSubview((toViewController?.view)!, belowSubview: (fromViewController?.view)!)
        
        self.transitioningView = fromViewController?.view
    }
    
    
    func updateInteractiveTransition(percentComplete: CGFloat)
    {
        let scale = CGFloat(fabs(percentComplete - CGFloat(1.0)))
        //        print(scale)
        self.transitioningView?.transform = CGAffineTransformMakeScale(scale, scale)
        transitioningContext?.updateInteractiveTransition(percentComplete)
    }
    
    func finishBy(cancelled:Bool) -> Void {
        if cancelled {
            UIView.animateWithDuration(0.5, animations: {
                self.transitioningView!.transform = CGAffineTransformIdentity
                }, completion: ({
                    completed in
                    self.transitioningContext!.cancelInteractiveTransition()
                    self.transitioningContext!.completeTransition(false)
                }))
        }
        else
        {
            UIView.animateWithDuration(0.5, animations: {
                self.transitioningView!.transform = CGAffineTransformMakeScale(0, 0)
                }, completion: ({
                    completed in
                    self.transitioningContext!.finishInteractiveTransition()
                    self.transitioningContext!.completeTransition(true)
                    
                }))
        }
        
    }
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        navigationOperation = operation
        
        return self
        
    }
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()!
        
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
       
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        var detailVC: DetailViewController!
        var fromView: UIView!
        var alpha: CGFloat = 1.0
        var destTransform: CGAffineTransform!
        
        var snapshotImageView: UIView!
        //获取到当前选择的Cell
        let originalView = self.collectionView.cellForItemAtIndexPath(self.indexPath!)
            
            
        if navigationOperation == UINavigationControllerOperation.Push {
            containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
            snapshotImageView = originalView?.snapshotViewAfterScreenUpdates(false)
            detailVC = toViewController as! DetailViewController
            fromView = fromViewController.view
            alpha = 0
            detailVC.view.transform = CGAffineTransformMakeScale(0.99, 0.99)
            destTransform = CGAffineTransformMakeScale(1, 1)
            
            snapshotImageView.frame = self.view!.convertRect(originalView!.frame, fromView: self.collectionView)
            
            print(snapshotImageView.frame)
            
        } else if navigationOperation == UINavigationControllerOperation.Pop {
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            detailVC = fromViewController as! DetailViewController
            
            snapshotImageView = detailVC.detailImageView?.snapshotViewAfterScreenUpdates(false)
            
            fromView = toViewController.view
            // 如果IDE是Xcode6 Beta4+iOS8SDK，那么在此处设置为0，动画将会不被执行(不确定是哪里的Bug)
            destTransform = CGAffineTransformMakeScale(0.1, 0.1)
            snapshotImageView.frame = detailVC.detailImageView!.frame
        }
        originalView?.hidden = true
        detailVC.detailImageView?.hidden = true
        
        containerView.addSubview(snapshotImageView)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            detailVC.view.transform = destTransform
            if CGAffineTransformIsIdentity(detailVC.view.transform)
            {
                detailVC.view.alpha = 1;
            }
            else
            {
                detailVC.view.transform = CGAffineTransformIdentity
                detailVC.view.alpha = 0;
            }
            fromView.alpha = alpha
       
        if self.navigationOperation == UINavigationControllerOperation.Push {
            
            UIView.animateWithDuration(0.35, animations: { 
                detailVC.view.layoutIfNeeded()
            })
            
            snapshotImageView.frame = detailVC.detailImageView!.frame
            
        } else if self.navigationOperation == UINavigationControllerOperation.Pop {
            snapshotImageView.frame = self.view!.convertRect(originalView!.frame, fromView: self.collectionView)
        }
        }, completion: ({completed in
            originalView?.hidden = false
            detailVC.detailImageView?.hidden = false
            snapshotImageView.removeFromSuperview()
            //告诉系统你的动画过程已经结束，这是非常重要的方法，必须调用。
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: CollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        
        cell.imageView.image = UIImage(imageLiteral: "girl")
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        self.indexPath = indexPath
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
