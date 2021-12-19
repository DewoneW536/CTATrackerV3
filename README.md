# CTATrackerV3
In this iOS project, we have developed an application that accesses web contents provided in JSON format from the official CTA
website used to keep track of train/bus schedules via (https://www.transitchicago.com/developers/) and upload the most current train
schedule for every CTA train in real time throughout the Chicagoland area. Users are also given the option to select which train
they would like to keep track of via segmentControlIndex (i.e Red Line, Purple Line, Brown Line, etc.).

The underlying goal of this application is to build an app that asynchronously accesses web contents provided in JSON format, while
properly handling error conditions that may occur during the communication and in the data content.
## Features
1. Accesses the data content in the JSON format and properly handles error conditions that may occur.
2. Properly parses JSON data/handles potential data anomalies.
3. Designed appropriate UI to access, display, and interact with the data, updating the content display in the UI at an appropriate
interval. For example, using the CAT train tracker API, user should be able to select all or some of the train lines and update the
UI for upcoming arrivals, etc. Therefore, app required at least 2-3 screens.
4. UI presents data in an informative/usable manner.
5. Data access is strictly handled in the background, allowing the UI to remain responsive and informative at all times.
## Main Concepts
1. JSON parsing
2. WebKit Accessing
3. Protocols
4. UI Design
5. Error Handling
