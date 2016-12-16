# location-ios

iOS application developed for my second assignment for `COMP327 - Mobile Computing` at University of Liverpool.

## Setup

To run this project, you will need:
- Xcode 8.+
- Swift 3.0.+
- [Cocoa Pods](https://cocoapods.org/)

When downloading the project, please run 

`pod install`

on your project path, to update the dependencies

## Rx + MVVM

This project uses the Model-View-ViewModel pattern, in combination with RxSwift. Basically, the view model will emmit streams of data for which the view will subscribe (using Rx observables) to update its UI. For further info about this, you can check [here](http://reactivex.io/), [here](https://realm.io/news/altconf-scott-gardner-reactive-programming-with-rxswift/) and [here](https://upday.github.io/blog/model-view-viewmodel/)

## Data

These are the models used to represent the data in the app. Every model has a unique ID

- __Place__: represents a physical place that can be displayed in the map. 
- __PlaceType__: represents a valid type for a place. The complete list can be found [here](https://developers.google.com/places/supported_types)
- __Review__: represents a comment from someone for a specific place
- __Distance__: represents the distance between two places. Contains the physical `distance` (meters, kms, etc.) and the approximated time(`duration`) to get from an `origin` and a `destination`

## Data Source

The data can be access by two different ways:

- __Web service__: That will return a json responses from Google Services Places & Distance API. This is managed in the [`PlaceServiceRepo`](LocationApp/Data/Source/PlaceServiceRepo.swift). The services that the app consumes are:
  - [Nearby places](https://developers.google.com/places/web-service/search?#PlaceSearchRequests): to get the nearest places in a given radius from current location
  - [Place details](https://developers.google.com/places/web-service/details): to present relevant information for a place
  - [Place photos](https://developers.google.com/places/web-service/photos): to display photos from a place
  - [Distance matrix](https://developers.google.com/maps/documentation/distance-matrix/intro): to get the distance in kms and time from current location to a specific place

- __JSON files__: that fetch the same information as the web service source, but obtain it's info from local json files. This is managed in [`PlaceFileSource`](LocationApp/Data/Source/PlaceFileSource.swift)

## App Features

### Request location permission
It's a good practice to tell the user why you need his location before actually requesting it. In this 'cause we don't say why but that's because it's a demo and I owe you no explanation :D

<img src="https://media.giphy.com/media/3o7TKBvZBF9agzDmQo/source.gif" alt="Request permission preview" width="200" />

### Displaying places and details
As seen in the following preview, the places are both displayed as annotations on the maps, and on an expandable list

<img src="https://media.giphy.com/media/l4JyZwlnsXmFYZTyM/source.gif" alt="Request permission preview" width="200" />

And if we select one of the places, either by picking an entry from the list or by tapping an annotation, we can see its details

<img src="https://media.giphy.com/media/3o7TKq6VCqCxhmAvSg/source.gif" alt="Request permission preview" width="200" />

### Setting location
By default, we use user's current location. He has the option to switch between his current location, and selecting any location in the map

<img src="https://media.giphy.com/media/1j15Lc6XzBGG3wHe/source.gif" alt="Current location preview" width="200" />
<img src="https://media.giphy.com/media/l4JzbKqliFNmcxnZC/source.gif" alt="Select location preview" width="200" />

### Filtering places
We can filters the places by type!

<img src="https://media.giphy.com/media/l0HlHm5nljHQV3DOg/source.gif" alt="Select location preview" width="200" />

