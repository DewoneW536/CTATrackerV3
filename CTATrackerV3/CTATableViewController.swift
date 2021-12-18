//
//  CTATableViewController.swift
//  CTATrackerV2
//
//  Created by Dewone Westerfield on 5/1/21.
//

//From CTA documentation:
//prdt -> Date-time format stamp for when the prediction was generated:yyyyMMdd HH:mm:ss (24-hour format, time local to Chicago)
//arrT -> Date-time format stamp for when a train is expected to arrive/depart:yyyyMMdd HH:mm:ss (24-hour format, time local to Chicago)

//staId -> Numeric GTFS parent station ID which this prediction is for (five digits in 4xxxx range) (matches “mapid” specified by requestor in query) ****IMPORTANT!****
//stpid -> A single five-digit code to tell the server which specific stop (in this context, specific platform or platform side within a larger station) you’d like to receive predictions for. See appendix for information about valid stop codes.
//isApp -> Indicates that Train Tracker is now declaring “Approaching” or “Due” on site for this train

//isDly -> Boolean flag to indicate whether a train is considered “delayed” in Train Tracker
//staNm -> Textual proper name of parent station

//stpDe -> Textual description of platform for which this prediction applies
//rn -> Run number of train being predicted for

//rt -> Textual, abbreviated route name of train being predicted for (matches GTFS routes)/(Allows you to specify a single route for which you’d like results (if not specified, all available results for the requested stop or station will be returned))
//destSt -> GTFS unique stop ID where this train is expected to ultimately end its service run (experimental and supplemental only—see note below)

//destNm -> Friendly destination description (see note below)
//trDr -> Numeric train route direction code (see appendices)

//isFit -> Boolean flag to indicate whether a potential fault has been detected (see note below)
//heading -> Heading, expressed in standard bearing degrees (0 = North, 90 = East, 180 = South, and 270 = West; range is 0 to 359, progressing clockwise)

//eta -> Container element (one per individual prediction)
//tmst -> Shows time when response was generated in format: yyyyMMdd HH:mm:ss (24-hour format, time local to Chicago)
//errNm -> Textual error description/message (see appendices)

//JSON request: - Will not pull up on safari; will have to stick with xml request given in email/converted to JSON.
//let JsonRequestFeed = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=2602ed5aee1c457ca4811a7e58f962b6&mapid=40380&max=1&outputType=JSON"



import UIKit
class CTARoutes{
    var nextStop:String = ""; //nextStaNm in Json
    var finalDest:String = ""; //final destination of train/destNm
    var updatedArrivals:String = ""; //will use this var in alertViewController; when user clicks on a stop/tableCell.
    var arrivalTime:String = ""; //labeled 'arrT' in JSON
    var isApproaching:String = ""; //based on if 'isApp' is 1, train is approaching (if 0 make this empty str).
    var trainDirection:String = ""; //trDr in Json
    //Use this as a way to change train routes based on userSegmentIndex -> get N&S mapId's!!!
    //This initially has the 95th/Howard Red line, but will update as user clicks segments.
    var routeColor:String = "red"; //@name in Json, will change based in API link based on userSegmentIndexPosition.
    //need these to place train stops on AppleMaps for assignment3.
    var latitude: String = "";
    var longitude:String = "";
    
}
enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

//Original JSON link:http://lapi.transitchicago.com/api/1.0/ttpositions.aspx?key=2602ed5aee1c457ca4811a7e58f962b6&rt=red&outputType=JSON
let lineInfo = CTARoutes();
var ctatt = "http://lapi.transitchicago.com/api/1.0/ttpositions.aspx?key=2602ed5aee1c457ca4811a7e58f962b6&rt=\(lineInfo.routeColor)&outputType=JSON";



class CTATableViewController: UITableViewController {
    // **** Important Train Tracker API key: 2602ed5aee1c457ca4811a7e58f962b6 ****
    //Create an alertView so that when users click on a tableCell it shows the updated information for the stop (whatever is shown via JSON file).
    var getTrainLineSegIndex:Int = 0;
    var isDataAvailable = false;
    var routes:[CTARoutes] = [];
    
    override func viewDidLoad(){
        super.viewDidLoad()
        loadData();
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }

   
    @IBAction func trainLineColorSelectedV2(_ sender: UISegmentedControl) {
        getTrainLineSegIndex = sender.selectedSegmentIndex;
        //I think when a new segment is selected, we also need to empty out the array routes[CTARoutes] so it can store
        //new info and return that instead of overlapping.
        if(getTrainLineSegIndex == 0){
            lineInfo.routeColor = "red";
            ctatt = "http://lapi.transitchicago.com/api/1.0/ttpositions.aspx?key=2602ed5aee1c457ca4811a7e58f962b6&rt=\(lineInfo.routeColor)&outputType=JSON";
            routes = [];
            loadData();
        }
        else if(getTrainLineSegIndex == 1){
            lineInfo.routeColor = "blue";
            routes = [];
            ctatt = "http://lapi.transitchicago.com/api/1.0/ttpositions.aspx?key=2602ed5aee1c457ca4811a7e58f962b6&rt=\(lineInfo.routeColor)&outputType=JSON";
            loadData();
        }
        else if(getTrainLineSegIndex == 2){
            lineInfo.routeColor = "brn";
            ctatt = "http://lapi.transitchicago.com/api/1.0/ttpositions.aspx?key=2602ed5aee1c457ca4811a7e58f962b6&rt=\(lineInfo.routeColor)&outputType=JSON";
            routes = [];
            loadData();
        }
        else if(getTrainLineSegIndex == 3){
            lineInfo.routeColor = "g";
            ctatt = "http://lapi.transitchicago.com/api/1.0/ttpositions.aspx?key=2602ed5aee1c457ca4811a7e58f962b6&rt=\(lineInfo.routeColor)&outputType=JSON";
            routes = [];
            loadData();
        }
        else if(getTrainLineSegIndex == 4){
            lineInfo.routeColor = "org";
            ctatt = "http://lapi.transitchicago.com/api/1.0/ttpositions.aspx?key=2602ed5aee1c457ca4811a7e58f962b6&rt=\(lineInfo.routeColor)&outputType=JSON";
            routes = [];
            loadData();
        }
        else if(getTrainLineSegIndex == 5){
            lineInfo.routeColor = "p";
            ctatt = "http://lapi.transitchicago.com/api/1.0/ttpositions.aspx?key=2602ed5aee1c457ca4811a7e58f962b6&rt=\(lineInfo.routeColor)&outputType=JSON";
            routes = [];
            loadData();
        }
        else if(getTrainLineSegIndex == 6){
            lineInfo.routeColor = "pink";
            ctatt = "http://lapi.transitchicago.com/api/1.0/ttpositions.aspx?key=2602ed5aee1c457ca4811a7e58f962b6&rt=\(lineInfo.routeColor)&outputType=JSON";
            routes = [];
            loadData();
        }
        else if(getTrainLineSegIndex == 7){
            lineInfo.routeColor = "y";
            ctatt = "http://lapi.transitchicago.com/api/1.0/ttpositions.aspx?key=2602ed5aee1c457ca4811a7e58f962b6&rt=\(lineInfo.routeColor)&outputType=JSON";
            routes = [];
            loadData();
        }
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return (ctaData?.ctatt.eta.count)!;
        return isDataAvailable ? routes.count : 15; //return eta data count or 15 rows to fill up screen.
    }
    
    //Eta.CodingKeys.arrT.description -> Just did this to understand how I get Eta info from struct!
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrainStopCell", for: indexPath)
        if(isDataAvailable){
            // Configure the cell...
            let route = routes[indexPath.row];
            if(route.isApproaching == "1"){
                cell.textLabel?.text = "Next Stop: \(route.nextStop) APPROACHING!";
            }
            else{
                cell.textLabel?.text = "Next Stop: \(route.nextStop)";
            }
            cell.detailTextLabel?.text = "Heading towards: \(route.finalDest)";
        }
        return cell;
    }
    //ctatt is the var that holds the JSON data we must parse() through.
    func loadData(){
        guard let ctattURL = URL(string: ctatt)else{
            return;
        }
        let request = URLRequest(url: ctattURL);
        let session = URLSession.shared
        session.dataTask(with: request){ data, response, error in
            guard error == nil else{
                print(error!.localizedDescription);
                return;
            }
            guard let data = data else {return;}
            print(data);
            do{
                if let json =
                    try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                    //print(json);
                    
                    guard let ctatt = json["ctatt"] as? [String:Any] else{
                        throw SerializationError.missing("ctatt");
                    }
                    guard let routes = ctatt["route"] as? [[String:Any]] else{
                        throw SerializationError.missing("route");
                    }
                    let trainPos = routes[0];
                    guard let trains = trainPos["train"] as? [[String:Any]] else{
                        throw SerializationError.missing("train");
                    }
                    for t in trains{
                        do{
                            if let train = t as? [String:Any] {
                                guard let nextStopName = train["nextStaNm"] as? String else{
                                    throw SerializationError.missing("nextStaNm");
                                }
                                guard let fDestinationNm = train["destNm"] as? String else{
                                    throw SerializationError.missing("destNm");
                                }
                                //"1" means heading NorthBound,"5" means heading SouthBound
                                guard let trainDirectionNum = train["trDr"] as? String else{
                                    throw SerializationError.missing("trDr");
                                }
                                guard let exactArrivalTime = train["arrT"] as? String else{
                                    throw SerializationError.missing("arrT");
                                }
                                //Looking for a "1" or "0" out of this (it's a boolean value)
                                //If it's 1, train is approaching (within 1min), if not trainStop is not close yet.
                                guard let isTrainApproaching = train["isApp"] as? String else{
                                    throw SerializationError.missing("isApp");
                                }
                                //need these for assigning stops to the appleMaps in HW3.
                                guard let exactLatitude = train["lat"] as? String else{
                                    throw SerializationError.missing("lat");
                                }
                                guard let exactLongitude = train["lon"] as? String else{
                                    throw SerializationError.missing("lon");
                                }
                                let ctaRoute = CTARoutes();
                                ctaRoute.nextStop = nextStopName;
                                ctaRoute.finalDest = fDestinationNm;
                                ctaRoute.trainDirection = trainDirectionNum;
                                ctaRoute.arrivalTime = exactArrivalTime;
                                ctaRoute.isApproaching = isTrainApproaching;
                                ctaRoute.latitude = exactLatitude;
                                ctaRoute.longitude = exactLongitude;
                                
                                self.routes.append(ctaRoute);
                            }
                        }catch SerializationError.missing(let msg){
                            print("Missing \(msg)");
                        } catch SerializationError.invalid(let msg, let data){
                            print("Invalid \(msg): \(data)");
                        } catch let error as NSError{
                            print(error.localizedDescription);
                        }
                        self.isDataAvailable = true;
                        DispatchQueue.main.async {
                            self.tableView.reloadData();
                        }
                    }
                }
                }catch SerializationError.missing(let msg){
                    print("Missing \(msg)");
                }catch SerializationError.invalid(let msg, let data){
                    print("Invalid \(msg): \(data)");
                }catch let error as NSError{
                    print(error.localizedDescription)
                }
        }.resume();
    }
    
    
    
    
    
}
//TableViewController bracket - don't touch.


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
