# High Level Overview of Project Jorge Lib

This is where the majority of the webservices will happen.

The interactors are responsible for coordinating the actions of all other models.

Typically, a request will begin from a route on the webserver that will initialize an interactor with an action and the props from the request, but any type of request is able to grab an interactor and kick off an interaction.

Each interactor must implement a main() function that coordinates its actions. 

Interactors have a number of methods that test for errors. If an error is found, all subsequent actions in the main function should be bypassed.


