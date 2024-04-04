//
//  Constants.swift
//  CCLearn
//
//  Created by Yuxuan Gu on 2023/10/27.
//

import Foundation
import Amplify

/* Use your own Canvas access token here */
/* Substitue studentAccessToken with your own access token if you want to log in as a student */
let studentAccessToken = ""

/* Substitue ta1AccessToken or ta2AccessToken with your own access token if you want to log in as a tutor*/
let ta1AccessToken = ""
let ta2AccessToken = ""

let jsonFileName = "events"

/* Default user when info is not properly fetched from Canvas or it is still loading */
let student = User(id: "001", name: "Loading...", primary_email: "Loading...", avatar_url: "https://example.com/avatar2.jpg")

