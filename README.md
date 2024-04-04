**ECE 564 - Mobile Application Development**
#  CCLearn

## Introduction
Welcome to Team Chatham County! Our team collaborated on the development of the CCLearn mobile application (CC stands for Chatham County \^_\^). This innovative app is integrated with the Canvas API, serving as a tutoring management solution. 

Upon login, CCLearn seamlessly synchronizes with your Canvas account, retrieving calendar events and assignment deadlines. Leveraging real-time information, students can effortlessly request tutoring sessions with their Teaching Assistants (TAs) directly through the app. TAs, in turn, can promptly respond to these requests. We hope you find our app enjoyable to use! 

Should you have any queries or suggestions, feel free to reach out to us via email at [chathamlearn@gmail.com](mailto:chathamlearn@gmail.com).



## Instructions for Setup
1. Install Cocoapods: \
`brew install cocoapods` \
`pod --version`

2. Initialize Cocoapods and install dependencies (You may need to delete existing pod files before doing this step): \
`cd` to the project in the terminal \
`pod init` \
`pod install`

3. Install Amplify CLI: \
`curl -sL https://aws-amplify.github.io/amplify-cli/install | bash && $SHELL`

4. Deploy Amplify environment to the project: \

After this step, you should see the prompts for successfully deploying the environment to your project.

5. Create file amplifytools.xcconfig under AmplifyConfig, copy paste into the file
```
push=false
modelgen=true
profile=default
envName=dev
```

6. Set Pods \
Open the CCLearn.xcworkspace file
In Xcode, select Pods file, select all targets, change iOS deployment target to 17.0 \
Try to build the project

7. Fix Amplify Library \
Try to build the project, it there are errors associated with hasOne functions in the Amplify library, comment out 
the function and remove Pod.xcodeproj from reference. You should have an error free and warning free environment.

8. Check the API key
Check the 'amplifyconfiguration.json' file and 'awsconfiguration.json' to make sure the api key is correct.

9. Init amplify congfiure \
Build the project. If you cannot build the app, check to see if this code is in CCLearnApp file

```
init() {
    do {
        try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: AmplifyModels()))
        try Amplify.configure()
        print("Amplify configured successfully")
    } catch {
        print("Failed to configure Amplify: \(error)")
    }
}
```

10. You should be able to successfully build the project and see the message "Amplify initialized" in the console


## Procedure to Understand the Workflow Mechanism
We strongly recommend using two simulators to fully experience data synchronization.

1. **Simulator 1: Login as a Teaching Assistant (TA):**
   - You may first log in as a TA and navigate to the meeting view to set your availability.

2. **Simulator 2: Login as a Student:**
   - Then, log in as a student and access the meeting view.
   - Choose the TA you logged in with previously to view their availability. Select a suitable time slot to request a meeting, triggering an email notification to the TA about your request.

3. **Back to Simulator 1 (TA):**
   - Access the dashboard to view upcoming meeting requests. Click to navigate to the request confirmation view.
   - Review and either accept or decline the meeting request. This action will also prompt an email notification to inform the student about the decision. Upon acceptance, the meeting will be added to your personal calendar.

4. **Back to Simulator 2 (Student):**
   - If the TA accepted your meeting request, it will reflect on your personal calendar.

Please note:
- The default setup assigns Yuxuan as the student, Zihan as TA1, and Eamon as TA2.
- To modify these default roles, replace the Canvas access code with your own access code in the `Model->Constants` file.


## Full Function List
### Login Page
- Allows the user to use the App in two different roles, Student and TA
- User can select the specific student and TA to login

### Dashboard
- Show greeting message to the user, including the date today.
- Present notifications within the application's interface to promptly alert users about incoming meeting requests.
- The greeting serves as a navigation link to the profile view.
- Display up to five reminders for the user, inluding both personal events and assignment deadlines retrieved from Canvas.
- Included a to-do list functionality, empowering users to conveniently manage their daily tasks. Users can add, edit, and delete events as needed.
- Additionally, users have the option to receive recommended tasks if they require suggestions on what to do.

### Meeting (For TA)
- TAs have the capability to choose their available time slots for meeting with students.
- Selection is limited to future time slots exclusively.

### Meeting (For Student)
- Students have the option to initially choose the TA they wish to collaborate with, after which the application displays the available time slots for that specific TA.
- After the student selects a time slot and requests a meeting, an email notification will be dispatched to notify the TA about the request.

### Meeting Confirmation (For TA)
- Displays a list of pending meeting requests from students, enabling TAs to take actions by swiping each individual meeting request.
- Upon the TA's acceptance of the meeting request, the scheduled meeting will be added to the calendar as an event. Subsequently, an email notification will be sent to the student to communicate the decision.
- In case of the TA declining the meeting request, an opportunity will be provided to include a message for the student. A notification email will be dispatched to the student to convey the status of the request, along with the message provided by the TA.

### Calendar
- Events of the current user are displayed (e.g. calendar events fetched from Canvas, meetings of this tutor/student, manually added events)
- Display Canvas Calendar events with the selected date/Dates with Canvas Calendar events are highlighted with pins (scroll up and down to access previous and future months).

### Profile
- Display the user's name and avatar.
- Allow users to modify their information by selecting the 'Edit' button.
- Enable users to log out directly from this interface.

## Contributions

  

### Zihan Cao
**1\. Backend Set Up on My Local Machine:**

- I pulled backend configuration from the cloud deployed by Eamon. I also took the initiative to document a comprehensive setup guide, aiding team members in configuring their running environments. Additionally, I provided hands-on support to a Yuxuan during the setup process.

**2\. UI Design and Implementation with Amplify:**

- Profile View:

I developed the Profile View, offering features such as user information editing, login/logout functionality, and seamless retrieval of user details such as name, email, and avatar. This ensures a user-friendly and personalized experience.

- Student Meeting View:

Implemented the Student Meeting View, enabling students to select tutors and displaying a detailed view of available times sent from the tutor's end. Integrated email functionality for sending reminders to tutors. I also introduced conditional checks to determine whether the user is a student, adapting the Dashboard View to display different content based on the user role.

- AddEventView:

Designed and implemented the AddEventView, allowing users to effortlessly add events to their calendars. This feature enhances the overall usability of the application.

- ToDoView and ReminderView Enhancements:

Revamped the Checkbox, ToDoRow, and ToDoView components to facilitate the saving of to-do lists for each user. Synchronized the local task array after each add/edit/save operation, ensuring consistency. Implemented the storage of corresponding checkboxes for each to-do list item, enhancing the user experience.

I also Filtered and displayed user-specific reminders directly from the database. This improvement ensures that users only see relevant reminders tailored to their individual needs and preferences. 

- ConfirmView Modifications:

Enhanced the ConfirmView to save confirmed meeting as calendar event in database with by calling the datamodel.saveCalendarEvent written by my teammate.

- Data Model: 

Introduced an additional function designed to interact with the Amplify database: `getTasks`, which facilitates the retrieval of task-related information and synchronize local data with the cloud.

**3\. SQLite Integration (Later Transitioned to Amplify Backend):**

- Initially, I configured SQLite for local functionality to store user profiles, to-do lists, reminders, etc. This involved creating schemas for each entity, allowing for easy addition and editing of information on the user's disk. As the project evolved, we identified the need for real-time communication between students and tutors during session booking, prompting the transition to Amplify for enhanced functionality.

**4\. Git Collaboration**

- Helped manage feature-specific branches, ensuring seamless parallel development. Addressed merge conflicts adeptly during code integration, preserving code integrity. Actively participated in collaborative code reviews, enhancing overall code quality.
  

### Yuxuan Gu
1. **Project Setup:**
   - Established the foundational structure of the project by organizing and creating essential file directories.
   - Initiated the `TabView` within the `ContentView` to serve as the primary framework for the application's user interface, laying the groundwork for navigation and content presentation.

2. **Work on Canvas APIs:**
   - Generated access tokens manually from Canvas user profile pages and utilized these tokens to call Canvas APIs.
   - Retrieved user profile information from Canvas using `GET /api/v1/users/:user_id/profile`.
   - Obtained a comprehensive list of user-associated courses through `GET /api/v1/courses`.
   - Retrieved all calendar events of the user via `GET /api/v1/calendar_events`.
   - Accessed assignment events using `GET /api/v1/calendar_events` with parameters specifying event type as assignment and relevant time intervals.

3. **Processing Canvas API Responses and Data Model Integration:**
   - Parsed JSON responses obtained from the Canvas API.
   - Saved crucial user information such as user ID, name, email, and avatar to the data model.
   - Integrated lists of user courses, calendar events, and assignment events into the data model.

4. **Designing Initial Data Model and Key Structures:**
   - Configured the DataModel and implemented it as the `environmentObject`.
   - Developed essential data structures including `User`, `Course`, `CalendarEvent`, `AssignmentEvent`, `ReminderEvent`, `Task`, and `MeetingRequest`.

5. **App Icon Design:**
   - Crafted the design for the application's icon.

6. **Login View Implementation:**
   - Created and implemented the login functionality for users, enabling login as two distinct roles.

7. **Dashboard View Design and Implementation:**
   - Implemented a greeting message within the dashboard view.
   - Integrated pending meeting request notifications, displaying a badge indicating the number of requests.
   - Developed the Reminder section by aggregating personal and assignment events from Canvas and presenting them collectively.
   - Designed and implemented the To-Do list, enabling users to add, edit, delete tasks, and providing task suggestions.
   - Incorporated a search feature within the dashboard to filter reminders and to-dos.

8. **Meeting Request Confirmation View:**
   - Enabled Teaching Assistants (TAs) to accept or decline meeting requests in this dedicated view.
   - TAs will be able to leave a message to the student if they chosen to decline the meeting request.

9. **Email Sending Feature Implementation using Swift-SMTP Package:**
   - Registered a dedicated email address for the app (chathamlearn@gmail.com) and acquired tokens for sending notifications.
   - Designed and implemented HTML and CSS-based email templates.
   - Implemented email sending functionality for student meeting requests, TA responses (acceptance or rejection).

10. **Gitlab Branch Maintenance and Merge Requests:**
    - Managed branch creation and deletion.
    - Oversaw most of the merge requests within the Gitlab repository.

11. **Backend Environment Configuration Collaboration on Local Machines with Zihan:**
    - Collaborated on pulling the backend environment from the cloud deployed by Eamon on local machines.

  

### Eamon Ma

* **Architectural Design and Full Backend Implementation:** This encompassed everything from setup and configuration to defining and managing the various service integrations. **Yes, this includes EVERYTHING about the backend and database, and I take credit for ALL OF IT.**
    - **Amplify Integration:** Established the foundational prerequisites for Amplify and successfully integrated it with the application.
    - **Amplify Models Customization:** Carefully modified the generated AmplifyModels to be compatible with the existing views and to align perfectly with the app's functionalities.
    - **AWS CloudFormation for Infrastructure Management:** Utilized AWS CloudFormation to define the entire cloud infrastructure as code, ensuring consistent and repeatable deployments.
    - **GraphQL Schema and API Deployment:** Meticulously configured the GraphQL schema, catering to the specific data needs of the application. Used the CLI to convert the schema into CloudFormation templates, which are responsible for creating a cloud backend representation of the models. Subsequently, I developed a robust GraphQL API, powered by AWS AppSync, to facilitate efficient and flexible data management and retrieval.
    - **Database Deployment:** Initiated and set up the database using Amazon DynamoDB, providing a highly scalable and performance-oriented database solution.
    - **IAM User Configuration for Team Access:** Expertly configured Identity and Access Management (IAM) users, providing them with appropriate credentials and access keys. This meticulous setup was instrumental in ensuring that my teammates had the necessary access for collaborative development.
    - **Code Integration and Management:** 
        - Integrated all existing code, including both local storage components and contributions from my teammates, with the newly implemented backend solutions. 
        - To integrate with the existing code, I modified almost all the files, so I did not document which exact files I modified. Data structures are completely revised to be compatible with the newly implemented backend solutions. 
* **Data Model:**
    - **Amplify DataStore:** Used DataStore API to save, query, update, delete, or fetch the item(s)/filtered item(s) in the database (e.g. Users, Tasks, CalendarEvents, TimeSlots, MeetingRequest..). Completed **ALL** functions related to database operations except 'getTasks()'.
    - **Canvas API:** Completed the 'initializeTAs()‘ and 'initializeStudent()' as well as 'getUser(accessToken: String)' and getStudent(accessToken: String)' to populate the user fetched from canvas to the database.
    
* **UI Designs and Workflow Integration:**
    - Completed the **Calendar View**.
        - I used the following library for the 'Calendar View': [Reference](https://github.com/WenchaoD/FSCalendar)
        - To integrate this library with SwiftUI, I followed this tutorial: [Tutorial](https://blog.logrocket.com/working-calendars-swift/)
        - **Key functions realized:**
            - Events of the current user are displayed (e.g. calendar events fetched from Canvas, meetings of this tutor/student, manually added events)
            - Display Canvas Calendar events with the selected date/Dates with Canvas Calendar events are highlighted with pins (scroll up and down to access previous and future months).
    - Completed the **Meeting View** and **Slot View** for tutor to select their availabilities for the selected date (Tutor can select multiple slots).
        - Stored this tutor's availabilities as TimeSlots to the database so that the student can select from those availabilities.
        - Implemented logic to display unavailability on dates with pre-existing Canvas calendar events. (E.g. if you log in as TA 2 - Eamon, you will see you can't select availabilities for Dec. 8th. It is my birthday. I set it on Canvas, so it becomes an unavailable day.)
    - Revised the **Student Meeting View** (This view is for the student to select a tutor from the tutor list) that was previously with hard-coded dummy tutors before my revision.
    - Revised the **Tutor Detail View** (This view is for the student to request tutoring sessions with the selected tutor) that was previously with hard-coded non-scrollable availabilities before my revision.
        - **Key functions realized:**
            - The student can select multiple slots. Emails with corresponding info will be sent to this tutor separately. (Previously, this was hard-coded sending one email with the info of the first slot before revision)
            - Corresponding meeting requests are stored in the database.
    - Revised the **Add Event View** that was previously not connected with the database and contained fields with incorrect types.
        - **Key functions realized:**
            - Added events will be stored and displayed on the calendar view of the current user
    - Modified the **workflow logics** on **Confirm View:** This view is for the student to view pending meeting requests (neither accepted nor declined by the tutor) and for the tutor to accept/decline requests. Previously, the view was with hard-coded meeting requests before modification. By 'Modified the workflow logics', I mean I did not change any UI component of this view.
        - Students and tutors are only seeing requests related to them.
        - Only the tutor can accept/decline requests.
        - If the tutor accepts a request, add a new calendar event to the database, so the event will be displayed on 'Calendar View' for both this tutor and the student (Since there are string, Date, Temporal.DateTime conversions, I put effort to make sure everything is in the same time zone).
        - Handled requests are deleted from the database and the list
        - Made sure the notification on 'Dashboard View' displays the correct number of pending requests.
* **Others**:
    - Carefully modified 'Tagerts' settings to ensure the project is warning-free.
    - Test to run on multiple simulators to ensure data synchronization
    - Maintain the latest code and actively participated in collaborative code reviews, enhancing overall code quality.

