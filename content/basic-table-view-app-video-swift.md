---
title: "Basic Table View app with JSON Client"
date: "2016-03-08"
htmltitle: "Basic Table View app with JSON Client video in Swift"
description: "Our first try livecoding with Swift"
---
Here's an hour-long livecoding video we did last week to make a basic table view app that downloads and parses JSON and builds a set of dynamic, expanding table view cells. Lots of helfup tips and tricks for working with Xcode and Swift are sprinkled throughout. The resulting code is available [on Github](https://github.com/nickoneill/colorbox).

Want to be notified when livecoding is coming up? Follow [That Thing in Swift on Twitter](https://twitter.com/objctoswift).

{{< youtube E0YKylaqrQs >}}

Some relevant code snippits from the video so you can follow along:

This is our `viewDidLoad` override in our main view controller. Note the `estimatedRowHeight` so that we can automatically grow and shrink our table view cell sizes.

Our `ColorClient` (code below), fetches a list of colors and returns them to us as `ColorBox` objects.

{{< highlight swift >}}
override func viewDidLoad() {
    super.viewDidLoad()

    tableView.estimatedRowHeight = 125
    tableView.rowHeight = UITableViewAutomaticDimension

    ColorClient.sharedClient.getColors {[weak self](colors) in
        self?.colors = colors

        dispatch_async(dispatch_get_main_queue(), {
            self?.tableView.reloadData()

            if colors.count > 0 {
                self?.selected(colors.first!.color)
            }
        })
    }
}
{{< /highlight >}}

The `ColorBox` object uses a failable initializer based on if we can correctly decode the correct data from the JSON file. Note the `guard` usage here!

{{< highlight swift >}}
struct ColorBox {
    let name: String
    let desc: String
    let color: UIColor

    init?(json: Dictionary<String, AnyObject>) {
        guard let name = json["name"] as? String else {
            return nil
        }
        self.name = name

        guard let colors = json["rgb"] as? [Int] where colors.count == 3 else {
            return nil
        }
        let color = UIColor(red: CGFloat(colors[0]) / 255, green: CGFloat(colors[1]) / 255, blue: CGFloat(colors[2]) / 255, alpha: 1)
        self.color = color

        if let desc = json["description"] as? String {
            self.desc = desc
        } else {
            self.desc = ""
        }
    }
}
{{< /highlight >}}

Configuring our table cell display is simple and important. I always move this into a `configure` method on my custom table view cells.

{{< highlight swift >}}
class ColorBoxTableViewCell: UITableViewCell {
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!

    func configure(color: ColorBox) {
        titleLabel.text = color.name
        descLabel.text = color.desc

        colorView.backgroundColor = color.color
    }
}
{{< /highlight >}}

The core of the app is a custom API client, based on the [Swift API client](https://thatthinginswift.com/write-your-own-api-clients-swift/) we featured here previously. 

{{< highlight swift >}}
class ColorClient {
    static let sharedClient = ColorClient()

    func getColors(completion: ([ColorBox]) -> ()) {
        get(clientURLRequest("videosrc/colors.json")) { (success, object) in
            var colors: [ColorBox] = []

            if let object = object as? Dictionary<String, AnyObject> {
                if let results = object["results"] as? [Dictionary<String, AnyObject>] {
                    for result in results {
                        if let color = ColorBox(json: result) {
                            colors.append(color)
                        }
                    }
                }
            }

            completion(colors)
        }
    }

    private func get(request: NSMutableURLRequest, completion: (success: Bool, object: AnyObject?) -> ()) {
        dataTask(request, method: "GET", completion: completion)
    }

    private func clientURLRequest(path: String, params: Dictionary<String, AnyObject>? = nil) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://thatthinginswift.com/"+path)!)

        return request
    }

    private func dataTask(request: NSMutableURLRequest, method: String, completion: (success: Bool, object: AnyObject?) -> ()) {
        request.HTTPMethod = method

        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())

        session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let data = data {
                let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                if let response = response as? NSHTTPURLResponse where 200...299 ~= response.statusCode {
                    completion(success: true, object: json)
                } else {
                    completion(success: false, object: json)
                }
            }
        }.resume()
    }
}
{{< /highlight >}}
