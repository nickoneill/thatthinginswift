---
title: "Write Your Own API Clients"
date: "2016-01-23"
htmltitle: "Write Your Own API Clients in Swift"
description: "You probably don't need Alamofire"
previewCode: api-client
---
{{% playground tips="Use this as a base for your favorite API" filename="APIClientPlayground.zip" %}}

Like many iOS developers, I used to use AFNetworking (along the same lines as the Swift counterpart, Alamofire) for all my networking needs. And many developers believe that the existence of such a library must mean that doing something similar is difficult or expensive. And previously it was! `NSURLConnection` in iOS 6 and earlier was a pain to implement and wrapping all that in something more convenient saved you a lot of time.

The truth is that since the introduction of `NSURLSession` in iOS 7, networking is pretty straightforward to do yourself and writing your own API client can simplify your dependencies. If unnecessary dependencies aren't enough to convince you, think about the bugs you can introduce by including 3rd party code that you don't understand or even the size of your binary if you're including a large library just to use a small part of it.

### A simple NSURLSession

I promised that `NSURLSession` was easy though, so let's take a look at a simple example:

{{< highlight swift >}}
let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())

let request = NSURLRequest(URL: NSURL(string: "http://yourapi.com/endpoint")!)

let task: NSURLSessionDataTask = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
    if let data = data {
        let response = NSString(data: data, encoding: NSUTF8StringEncoding)
        print(response)
    }
}
task.resume()
{{</highlight>}}

The first of the three major components is `NSURLSession` which, for the purposes of this post doesn't need to be specially configured. It'll handle all the data or download tasks we give it and call our blocks with the results.

Hopefully you're already familiar with `NSURLRequest` which contains details about the request like the URL, method, any parameters, etc. The simplest configuration just takes a URL and defaults to the GET method.

And the last is the `NSURLSessionDataTask` which I've only explicitly created here for illustration. It contains the block that will fire when we get the results from the request. We'll get back three optionals: `NSData` containing the raw body data from the response, an `NSURLResponse` object with metadata from the response and maybe an `NSError`.

### Your own API client

Now that we've established our basic understanding of `NSURLSession` based , let's use Swift to wrap these basics into a simple API client.

Here's the core: a simple data task wrapper that takes a `NSURLRequest` and method name, and returns an indicator of success and a decoded JSON body. If you had an API that returned XML, you would modify the deserialization for XML rather than JSON but the rest would be the same.

Note the pattern matching in the `where` clause as we check the response code range for success!

{{< highlight swift >}}
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
{{</highlight>}}

Next, we can wrap our common request methods into small methods that specify the HTTP method and pass through the completion block. This will make more sense once we put everything together at the end.

{{< highlight swift >}}
private func post(request: NSMutableURLRequest, completion: (success: Bool, object: AnyObject?) -> ()) {
    dataTask(request, method: "POST", completion: completion)
}

private func put(request: NSMutableURLRequest, completion: (success: Bool, object: AnyObject?) -> ()) {
    dataTask(request, method: "PUT", completion: completion)
}

private func get(request: NSMutableURLRequest, completion: (success: Bool, object: AnyObject?) -> ()) {
    dataTask(request, method: "GET", completion: completion)
}
{{</highlight>}}

The last piece of functionality that we want to simplify is the creation of a `NSURLRequest` with the data we want to send. In this case, we're encoding the parameters as form data and providing an authorization token if we have it. This method will change the most from API to API, but its responsibilities will stay the same.

{{< highlight swift >}}
private func clientURLRequest(path: String, params: Dictionary<String, AnyObject>? = nil) -> NSMutableURLRequest {
    let request = NSMutableURLRequest(URL: NSURL(string: "http://api.website.com/"+path)!)
    if let params = params {
        var paramString = ""
        for (key, value) in params {
            let escapedKey = key.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())
            let escapedValue = value.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())
            paramString += "\(escapedKey)=\(escapedValue)&"
        }

        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
    }

    if let token = token {
        request.addValue("Bearer "+token, forHTTPHeaderField: "Authorization")
    }

    return request
}
{{</highlight>}}

Finally we can start making requests with our API client. This is a simplified login request that issues a POST request to the login url with the email and password parameters. You can access both a generalized success indicator and a `Dictionary` object that might contain relevant data in this method.

{{< highlight swift >}}
func login(email: String, password: String, completion: (success: Bool, message: String?) -> ()) {
    let loginObject = ["email": email, "password": password]

    post(clientURLRequest("auth/local", params: loginObject)) { (success, object) -> () in
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if success {
                completion(success: true, message: nil)
            } else {
                var message = "there was an error"
                if let object = object, let passedMessage = object["message"] as? String {
                    message = passedMessage
                }
                completion(success: true, message: message)
            }
        })
    }
}
{{</highlight>}}

Perhaps you want to retrieve and store a token once the user is logged in or turn the returned data into a `struct` before returning it to the calling method (my favorite!). These request-specific actions should be taken care of here.

We can create small functions like this for each of class of requests we'll be making to our API and customize them to provide a consistent and simple experience for the calling code (probably in a view controller somewhere). We don't need to worry about encoding values or generating `NSURL` objects because our thin wrapper takes care of those issues for us.

---

Here’s what I like about this approach:

#### Easy to reason about

We abstract away some of the parts that are technically uninteresting or repetitive but the code concepts of HTTP that you should understand are there: submit using a url, method name and parameters and get back an indicator of success and any decoded data.

#### Flexible for different APIs

The construction of your URL request is frequently the single detail that changes based on who wrote your server code. I don’t always have control over how this server implementation detail is done as a mobile dev so being able to customize this for each project is key.

#### Short and sweet

The base client is less than 50 lines of code. If I start having to write a ton of boilerplate to replace a dependency it begins to wear on me, particularly when it's a utility that I'll never touch again. This is short and you'll be in here making adjustments and new methods frequently. You should know what's going on in here!

---

Using this? Something else instead? How do you write your API clients? Let us know if there's something you would change.
