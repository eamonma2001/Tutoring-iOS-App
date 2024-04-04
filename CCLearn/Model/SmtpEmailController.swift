//  SmtpEmailController.swift
//  CCLearn
//
//  Created by Yuxuan Gu on 2023/11/25.
//

import Foundation
import SwiftSMTP

func sendMail(receiver: Mail.User, emailType: String, studentName: String, taName: String, meetingDate: String, message: String) {
    let smtp = SMTP(
        hostname: "smtp.gmail.com",     // SMTP server address
        email: "chathamlearn@gmail.com",        // username to login
        password: "jqqysqvydgoowjfr"            // password to login
    )
    
    let me = Mail.User(
        name: "CCLearn",
        email: "chathamlearn@gmail.com"
    )
    
    var subject: String {
        if emailType == "request" {
            return "You received a meeting request"
        } else if emailType == "accept" {
            return "Your meeting request has been accepted"
        } else {
            return "Your meeting request has been declined"
        }
    }
    
    var headLine: String {
        if emailType == "request" {
            return "Hello \(taName), You received a new meeting request from \(studentName)!"
        } else if emailType == "accept" {
            return "Hello \(studentName), \(taName) has accepted your meeting request at \(meetingDate)!"
        } else {
            return "Hello \(studentName), \(taName) has declined your meeting request at \(meetingDate)!"
        }
    }
    
    var messageLine: String {
        if message == "" {
            return ""
        } else {
            return "Your tutor has left you a message: " + message
        }
    }

    // Create an HTML `Attachment`
    let htmlAttachment = Attachment(
        htmlContent:
    """
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Document</title>
            <style>
                .bigContainer {
                    position: absolute;
                    left: 30%;
                    right: 30%;
                    top: 0%;
                    background-color: #ffffeb;
                    text-align: center;
                }
                .logo {
                    width: 120px;
                    height: 120px;
                }
                .greetings {
                    background-color: #4aa7f3;
                    left: 0%;
                    right: 0%;
                    color: white;
                    overflow: auto;
                }
                button {
                    width: 200px;
                    height: 40px;
                    margin-bottom: 3%;
                    background-color: rgb(138, 230, 0);
                    cursor: pointer;
                    border: 0ch;
                    border-radius: 5px;
                    color: black;
                }
                .introduction {
                    left: 0%;
                    right: 0%;
                    background-color: #c0def7;
                    overflow: auto;
                }
                .slogan {
                    top: 3%;
                }
                .introlast {
                    bottom: 3%;
                }
                .help {
                    left: 0%;
                    right: 0%;
                    overflow: auto;
                }
                .notice {
                    color: grey;
                }
            </style>
        </head>
        <body>
            <div class="bigContainer">
                <div class="greetings">
                    <h1>\(headLine)</h1>
                    <p>Please login to CCLearn and check it.</p >
                    <p>\(messageLine)</p >
                </div>
                <div class="introduction">
                    <h3 class="slogan">CCLearn, the best canvas based meeting management App for You!</h3>
                    <p>Powerful dashboard with Personalised Todo List</p >
                    <p>Meeting Management with Powerful Features</p >
                    <p>Personal Calendar to Record Your Important Events </p >
                    <p>Profile Page Allows you to Customize your App</p >
                </div>
                <div class="help">
                    <h3>We are here to help!</h3>
                    <p>Please contact us through chathamlearn@gmail.com</p >
                    <p class="notice">You are receiving this because you've received a meeting request.</p >
                </div>
            </div>
        </body>
        </html>
    """
    )
    
    // Create a `Mail` and include the `Attachment`s
    let mail = Mail(
        from: me,
        to: [receiver],
        subject: subject,
        attachments: [htmlAttachment]
    )
    
    smtp.send(mail) { (error) in
        if let error = error {
            print(error)
        } else {
            print("Send email successful")
        }
    }
}
