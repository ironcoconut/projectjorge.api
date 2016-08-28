# High Level Overview of Project Jorge Lib

This is where the majority of the webservices will happen.

The interactors are responsible for coordinating the actions of all other models.

A typical request will begin from a route on the webserver. It will initialize an interactor with the cookies, props and json body from the request.

Any type of service is able to grab an interactor and kick off an interaction.

Each interactor must implement a main() function that coordinates its actions. 

Interactors have a number of helper methods that test for errors. 

If an error is found, all subsequent actions in the main function are bypassed.

Data processing happens via mutators which filter, map and validate data.

Mutators load together as a block so that if the request is missing data, all the errors from the request return together.

## Overview of Data Flow

$==========================================================$
|                                                          |
|  Route initalizes interactor with request cookie,        |
|  params, and json body                                   |
|                           |                              |
|                           v                              |
|  Interactor coordinates the following:                   |
|                           |                              |
|                           v                              |
|  1+ Mutators process request                             |
|                           |                              |
|                           v                              |
|  Helper methods on interactor load data and validate it  |
|                           |                              |
|                           v                              |
|  Helper methods perform actions necessary to complete    |
|  request such as notifying 3rd party services            |
|                           |                              |
|                           v                              |
|  Helpers and Presenter(s) format the data into a         |
|  response object                                         |
|                           |                              |
|                           v                              |
|  Interactor returns response object to route             |
|                           |                              |
|                           v                              |
|  Route completes response to user                        |
|                                                          |
$==========================================================$
