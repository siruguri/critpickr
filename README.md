# README

## Introduction

This is an experimental app to run a web spider via an API.

## The main steps

* Create instances of `ScraperRegistration` that contain the name of a database model to write the scraped data to, and a JSON formatted description of the scraping methodology (see more below.) If you don't specify a database model, the default is `ScraperAdaptor`.

# Create a scraper

To create a scraper, you have to write its rules in the following format (expressed as JSON):

1. Create a hash with two keys, `data` and `links` (All keys are strings.)
1. `data` is an array of hashes, each of which must have the following keys:
   1. `name` (**required**): A key that will be used to refer to the array  obtained as described below via the `pattern` selector and the `extraction` option
   1. `pattern` (**required**): A CSS selector. All nodes matching this selector will be extracted and an array is returned, one item for each node that corresponds to the value obtained via node extraction (see `extraction` below).
   1. `extraction` (optional): If this key is provided, then its value should be an array, each item of the array being a hash with the following keys:
      
      1. `function` (**required**): It is assumed that the value of `function` is a method name (String type) that is available to a [`Nokogiri Node`](http://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Node#css-instance_method) instance
      1. `args` (optional): Arguments to the method passed above can be specified as an array. For example, a possible use is to set `"extraction" => {"function" => "[]", "args" => ["href"]}`
      
        Each method name is applied in turn, and the final extraction value is the space-separated concatenation of these values. Note, as described above, that by default, `extraction` is set to `{"function" => "text", "args" => []}` In fact, if the provided extraction method is not available as an instance method on `Nokogiri::XML::Node`, then the extraction will default to the `:text` method, with no arguments.
    

## Contribute and Use

Forking this skeleton to build your own app? Please give credit as follows:

This app is based on [the skeleton Rails 4 app](https://github.com/siruguri/baseline_rails_install) written by [@siruguri](https://github.com/siruguri/)

Adding to the repository? Your pull requests are most welcome!
