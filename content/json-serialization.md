+++
title = "JSON Serialization"
date = 2014-06-25T10:54:37Z
draft = true
+++

Essentially no difference.

let jsonError: NSErrorPointer?

                let decodedJson = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: jsonError!) as NSDictionary
