//
//  ViewController.swift
//  Dengue Fever
//
//  Created by Jimmy on 2018/4/16.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak private var map: MKMapView!
    @IBOutlet weak private var mapTypeSegment: UISegmentedControl!
    
    private var getTableButton:UIButton = UIButton()
    private var viewModel: ViewModel = ViewModel()
    private var annotationDict: [String:MKAnnotation] = [:]
    private var annotations:[MKAnnotation] = []
    private var tableViewAlert = DengueTableViewAlert()
    private var rightBarItem:UIBarButtonItem = UIBarButtonItem()
    private var annotationFrame:CGRect = CGRect.zero
    private var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        indicator.color = .lightGray
        indicator.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        map.delegate = self
        map.register(DengueCaseView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        map.register(DengueCaseClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
        setupUI()
        
        viewModel = ViewModel()
        
        viewModel.vmListener = {[weak self] (data:[DengueFeverData], isReady:Bool) in
            if let annotations = self?.annotations {
                DispatchQueue.main.async {
                    self?.map.removeAnnotations(annotations)
                }
            }
            
            self?.annotations = []
            self?.annotationDict = [:]
            if isReady {
                DispatchQueue.main.async {
                    self?.indicator.stopAnimating()
                }
                self?.addPinsToMap()
            }
        }
        
        indicator.startAnimating()
        viewModel.fetchVM()
    }
    
    private func setupUI() {
        getTableButton = UIButton.getSideButton(self)
        getTableButton.setImage(#imageLiteral(resourceName: "tableIcon"), for: .normal)
        getTableButton.addTarget(self, action: #selector(getTable(_:)), for: .touchUpInside)
        
        title = "近十二個月登革熱病情"
        
        rightBarItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadData(_:)))
        rightBarItem.isEnabled = false
        navigationItem.rightBarButtonItem = rightBarItem
        
        view.addSubview(indicator)
        view.addConstraints([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            indicator.widthAnchor.constraint(equalTo: view.widthAnchor),
            indicator.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.vmListener == nil {
            viewModel.vmListener = {[weak self] (data:[DengueFeverData], isReady:Bool) in
                if let annotations = self?.annotations {
                    DispatchQueue.main.async {
                        self?.map.removeAnnotations(annotations)
                    }
                }
                
                self?.annotations = []
                self?.annotationDict = [:]
                if isReady {
                    DispatchQueue.main.async {
                        self?.indicator.stopAnimating()
                    }
                    self?.addPinsToMap()
                }
            }
            
            indicator.startAnimating()
            viewModel.fetchVM()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotification(_:)), name: Notification.Name.ErrorOccur, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.vmListener = nil
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - BUTTON FUNCTIONs
    @objc private func getTable(_ sender:UIButton) {
        
        if viewModel.isDataReady {
            modalTransitionStyle = .flipHorizontal
            let storyboard = UIStoryboard.getStoryBoardWithName(.TableData)
            let vc = storyboard.instantiateViewController(withIdentifier: "DengueListNVC")
            vc.modalTransitionStyle = .flipHorizontal
            present(vc, animated: true, completion: nil)
        }
    }
    
    @objc private func reloadData(_ sender:UIBarButtonItem) {
        DispatchQueue.main.async {
            self.indicator.startAnimating()
        }
        annotationDict = [:]
        viewModel.reloadData()
    }
    
    // MARK:- MAP FUNCTIONs
    @IBAction func mapTypeSelected(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            map.mapType = .standard
            sender.tintColor = .blue
        case 1:
            map.mapType = .satellite
            sender.tintColor = .white
        default:
            map.mapType = .hybrid
            sender.tintColor = .white
        }
    }
    
    private func addPinsToMap() {
        
        let numberOfData = viewModel.numberOfData()
        
        for i in 0..<numberOfData {
            if let data = viewModel.getDengueFeverData(i) {
                if annotationDict[data.uniqueKey] == nil {
                    
                    let pin = DengueCase(dengueData: data)
                    pin.coordinate = data.coordinate
                    annotationDict[data.uniqueKey] = pin
                    annotations.append(pin)
                }
            }
        }
        
        DispatchQueue.main.async {[unowned self] in
            self.map.addAnnotations(self.annotations)
            self.getTableButton.isEnabled = true
            self.rightBarItem.isEnabled = true
        }
        
        // Move to Taiwan
        map.setCenter(CLLocationCoordinate2DMake(DengueFeverData.kTaiwanY, DengueFeverData.kTaiwanX), animated: true)
        
    }
    
    //MARK: - NOTIFICATION RECEIVER
    @objc private func receiveNotification(_ sender:Notification) {
        if sender.name == .ErrorOccur {
            
            var message = "Unable to fetch data, please check your connection and refresh again."
            if let errorMessage = sender.userInfo?[NetworkManager.errorKey] as? String {
                message = errorMessage
            }
            
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {[weak self] (_) in
                alert.dismiss(animated: true, completion: nil)
                self?.rightBarItem.isEnabled = true
            }))
            
            present(alert, animated: true, completion: nil)
            
        }
    }
    
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        annotationFrame = view.frame
        if let caseAnnotation = view.annotation as? DengueCase {
            presentAnnotationAlert(caseAnnotation)
        } else if let caseAnnotatioon = view.annotation as? MKClusterAnnotation {
            presentClusterAlert(caseAnnotatioon)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {return nil}
        
        var view:MKAnnotationView? = nil
        
        if let _ = annotation as? MKClusterAnnotation {
            
            view = map.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
            
            if view == nil {
                view = DengueCaseClusterView(annotation: annotation, reuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
            }
        } else {
            
            view = map.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            
            if view == nil {
                view = DengueCaseView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            }
        }
        
        return view
    }
    
    
    //MARK:- SHOW ALERT
    private func presentAnnotationAlert(_ with:DengueCase) {
        tableViewAlert = DengueTableViewAlert()
        let alert = tableViewAlert.createAlert([with])
        
//        UIAlertController(title: "\(with.location)", message: "\(with.description)", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "確定", style: .cancel, handler: {[unowned self] _ in
            alert.dismiss(animated: true, completion: nil)
            self.map.deselectAnnotation(with, animated: true)
        }))
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            
            if let popController = alert.popoverPresentationController {
                popController.sourceView = view
                let sourceRect = CGRect(x: annotationFrame.maxX, y: annotationFrame.maxY * 1.15, width: 0, height: 0)
                popController.sourceRect = sourceRect
                popController.permittedArrowDirections = [.left]
            }
        }
        present(alert, animated: true, completion: nil)
        annotationFrame = CGRect.zero
    }
    
    private func presentClusterAlert(_ with:MKClusterAnnotation) {
        
        tableViewAlert = DengueTableViewAlert()
        
        let alert = tableViewAlert.createAlert(with.memberAnnotations as! [DengueCase])
        alert.addAction(UIAlertAction(title: "確定", style: .cancel, handler: {[unowned self] _ in
            
            self.map.deselectAnnotation(with, animated: true)
            alert.dismiss(animated: true, completion:nil)
        }))
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            
            if let popController = alert.popoverPresentationController {
                popController.sourceView = view
                let sourceRect = CGRect(x: annotationFrame.maxX, y: annotationFrame.maxY * 1.15, width: 0, height: 0)
                print(annotationFrame)
                popController.sourceRect = sourceRect
                
                print(popController.sourceRect)
                popController.permittedArrowDirections = [.left]
            }
        }
        present(alert, animated: true, completion: nil)
    }
    
}

