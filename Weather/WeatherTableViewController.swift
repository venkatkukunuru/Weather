//
//  WeatherTableViewController.swift
//  Weather
//
//  Created by venkat kukunuru on 5/21/19.
//  Copyright © 2019 venkat kukunuru. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class WeatherTableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate {
    
    
    var locationManager:CLLocationManager!
    var weatherModel : WeatherModel?
    let extendedInfo: [ExtendedInfo] = [.sunrise, .sunset, .humidity, .wind, .feelLike, .dewPoint, .pressure, .visibility, .uvIndex]
    var weatherExtendedInfoViewModel: WeatherExtendedInfoViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateWeatherForLocation(location: "Winthrop", city: "Winthrop")
        
        let hour = Calendar.current.component(.hour, from: Date())
        
        var backgroundImage = UIImage(named: "Nightview")

        switch hour {
        case 6..<12 :
            backgroundImage = UIImage(named: "Morningview")
        case 12 :
            backgroundImage = UIImage(named: "Duskview")
        case 13..<17 :
            backgroundImage = UIImage(named: "Noonview")
        case 17..<22 :
            backgroundImage = UIImage(named: "Nightview")
        default:
            backgroundImage = UIImage(named: "Nightview")
        }

        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .center
        tableView.backgroundView = imageView


        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        determineMyCurrentLocation()
    }

    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                return
            }else if let _ = placemarks?.first?.country,
                let city = placemarks?.first?.locality {
                print(city)
                self.callAPI(location: userLocation, city: city)
            }
            else {
            }
        })

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateWeatherForLocation(location:String, city: String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    self.callAPI(location: location, city: city)
                }
            }
        }
    }
    
    func callAPI(location:CLLocation, city: String) {

        Weather.forecast(withLocation: location.coordinate, city: city, completion: { (weatModel:WeatherModel?) in
            
            if let weatherModel = weatModel {
                self.weatherModel = weatherModel
                
                DispatchQueue.main.async {
                    guard let weatherExtendedInfo = self.weatherModel?.extendedInfo else { return }

                    self.weatherExtendedInfoViewModel = WeatherExtendedInfoViewModel(weatherExtendedInfo: weatherExtendedInfo)
                    
                    self.tableView.reloadData()
                }
            }
            
        })
    }
    

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if self.weatherModel?.hourlyArray.count ?? 0 > 0 && self.weatherModel?.dailyArray.count ?? 0 > 0 {
            return 3
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1 {
            return self.weatherModel?.dailyArray.count ?? 0
        } else if section == 0{
            return 2
        } else {
            return extendedInfo.count
        }
    }
    
    /*
     override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
     let dateFormatter = DateFormatter()
     dateFormatter.dateFormat = "MMMM dd, yyyy"
     
     return dateFormatter.string(from: date!)
     }
     */
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 115
        } else if section == 0 {
            return 80
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 30, right: 10)
            layout.itemSize = CGSize(width: 70, height: 100)
            layout.scrollDirection = .horizontal
            
            let myCollectionView:UICollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
            myCollectionView.dataSource = self
            myCollectionView.delegate = self
            myCollectionView.register(UINib.init(nibName: "ForecastCell", bundle: nil), forCellWithReuseIdentifier: "ForecastCell")

            myCollectionView.backgroundColor = UIColor.clear
            return myCollectionView
        } else if section == 0 {
            
            let cityName = UILabel()
            cityName.text = "city"
            cityName.numberOfLines = 0
            cityName.sizeToFit()
            
            let firstAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)]
            let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
            
            let firstString: NSMutableAttributedString
            if let city = self.weatherModel?.overview.city {
                firstString = NSMutableAttributedString(string: city + " \n", attributes: firstAttributes)
                if let description = self.weatherModel?.overview.shortDescription {
                    let secondString = NSAttributedString(string: description, attributes: secondAttributes)
                    firstString.append(secondString)
                    cityName.attributedText = firstString
                }
            }

            cityName.textAlignment = .center
            cityName.backgroundColor = UIColor.clear
            return cityName
        }
        return nil;

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 170
            }
            return 25
        } else if indexPath.section == 1 {
            return 25
        }
        
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {

            if indexPath.row == 0 {

                let cell = tableView.dequeueReusableCell(withIdentifier: "TempCell", for: indexPath)
                    as! TempCell
                
                if let temperature = self.weatherModel?.overview.currentTemperature {
                    cell.tempLabel?.text = "\(String(describing: temperature))°"
                }
                
                return cell
                
            } else {
                let weatherObject = self.weatherModel?.overview

                let todayCell = tableView.dequeueReusableCell(withIdentifier: "TodayCell", for: indexPath)
                    as! TodayCell


                todayCell.todayLabel?.text = "Today"
                todayCell.weekdayLabel?.text = weatherObject?.weekDay
                
                if let temperatureHigh = weatherObject?.temperatureHigh {
                    todayCell.tempHighLabel?.text = "\(String(describing: temperatureHigh))°"
                }
                
                if let temperatureLow = weatherObject?.temperatureLow {
                    todayCell.tempLowLabel?.text = "\(String(describing: temperatureLow))°"
                }
                
                return todayCell

            }
            
        } else if indexPath.section == 1 {
            let weatherObject = self.weatherModel?.dailyArray[indexPath.row]
            
            let todayCell = tableView.dequeueReusableCell(withIdentifier: "TodayCell", for: indexPath)
                as! TodayCell
            
            todayCell.todayLabel?.text = ""
            todayCell.weekdayLabel?.text = weatherObject?.day
            
            if let temperatureHigh = weatherObject?.temperatureHigh {
                todayCell.tempHighLabel?.text = "\(String(describing: temperatureHigh))°"
            }
            
            if let temperatureLow = weatherObject?.temperatureLow {
                todayCell.tempLowLabel?.text = "\(String(describing: temperatureLow))°"
            }

            todayCell.iconImage?.image = weatherObject?.description

            return todayCell

        } else {
            
            
            let extendedInfoCell = tableView.dequeueReusableCell(withIdentifier: "ExtendedInfoCell", for: indexPath)

            let infoString = self.weatherExtendedInfoViewModel?.setupString(key: extendedInfo[indexPath.row])

            extendedInfoCell.textLabel?.text = extendedInfo[indexPath.row].stringValue
            extendedInfoCell.detailTextLabel?.text = infoString

            return extendedInfoCell
            
        }
        

    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCell", for: indexPath) as! ForecastCell
        
        let weatherObject = self.weatherModel?.hourlyArray[indexPath.row]

        myCell.timeLabel?.text = weatherObject?.hour
        myCell.iconImage?.image = weatherObject?.description
        myCell.temperatureLabel?.text = "\(String(describing: weatherObject?.temperature))°F"
        if let temperature = weatherObject?.temperature {
            myCell.temperatureLabel?.text = "\(String(describing: temperature))°"
        }

        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.weatherModel?.hourlyArray.count ?? 0
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on item \(indexPath.row)")
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(15)
    }

}
