//
//  WeatherTableViewController.swift
//  Weather
//
//  Created by venkat kukunuru on 5/21/19.
//  Copyright © 2019 venkat kukunuru. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherTableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate {
    
    
    var locationManager:CLLocationManager!

    var hourlyData = [Weather]()
    var dailyData = [Weather]()
    var city: String = ""


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
        print(city)

        Weather.forecast(withLocation: location.coordinate, city: city, completion: { (hourly:[Weather]?, daily:[Weather]?, city:String?) in
            
            self.city = city ?? ""
            
            if let weatherData = hourly {
                self.hourlyData = weatherData
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            if let weatherData = daily {
                self.dailyData = weatherData
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        })
    }
    

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if hourlyData.count > 0 && dailyData.count > 0 {
            return 2
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1 {
            return dailyData.count - 1
        } else if section == 0{
            return 2
        }
        return 0
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
            let weatherObject = hourlyData[section]
            
            let cityName = UILabel()
            cityName.text = "city"
            cityName.numberOfLines = 0
            cityName.sizeToFit()
            
            let firstAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)]
            let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]

            let firstString = NSMutableAttributedString(string: self.city + " \n", attributes: firstAttributes)
            let secondString = NSAttributedString(string: weatherObject.summary, attributes: secondAttributes)

            firstString.append(secondString)

            cityName.attributedText = firstString
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
        }
        
        return 25
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {

            if indexPath.row == 0 {
                let weatherObject = hourlyData[indexPath.section]

                let cell = tableView.dequeueReusableCell(withIdentifier: "TempCell", for: indexPath)
                    as! TempCell
                cell.tempLabel?.text = "\(Int(weatherObject.temperature))°"
                
                return cell
                
            } else {
                let weatherObject = dailyData[indexPath.section]

                let todayCell = tableView.dequeueReusableCell(withIdentifier: "TodayCell", for: indexPath)
                    as! TodayCell

                let date = Date(timeIntervalSince1970: weatherObject.time)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"

                todayCell.todayLabel?.text = "Today"
                todayCell.weekdayLabel?.text = dateFormatter.string(from: date)
                
                todayCell.tempHighLabel?.text = "\(Int(weatherObject.tempMax))"
                todayCell.tempLowLabel?.text = "\(Int(weatherObject.tempMin))"
                
                return todayCell

            }
            
        } else {
            let weatherObject = dailyData[indexPath.row + 1]
            
            let todayCell = tableView.dequeueReusableCell(withIdentifier: "TodayCell", for: indexPath)
                as! TodayCell
            
            let date = Date(timeIntervalSince1970: weatherObject.time)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            
            todayCell.todayLabel?.text = ""
            todayCell.weekdayLabel?.text = dateFormatter.string(from: date)
            
            todayCell.tempHighLabel?.text = "\(Int(weatherObject.tempMax))"
            todayCell.tempLowLabel?.text = "\(Int(weatherObject.tempMin))"
            
            todayCell.iconImage?.image = UIImage(named: weatherObject.icon)

            return todayCell

        }
        

    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCell", for: indexPath) as! ForecastCell
        
        let weatherObject = hourlyData[indexPath.row]

        let date = Date(timeIntervalSince1970: weatherObject.time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H a"
        myCell.timeLabel?.text = dateFormatter.string(from: date)
        myCell.iconImage?.image = UIImage(named: weatherObject.icon)
        myCell.temperatureLabel?.text = "\(Int(weatherObject.temperature))°F"
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyData.count
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
