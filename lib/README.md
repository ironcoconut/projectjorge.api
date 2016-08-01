# High Level Overview of Project Jorge Lib

This is where the majority of the webservices will happen.

The interactors are responsible for coordinating the actions of all other models.

Typically, a request will begin from a route on the webserver that will initialize an interactor with an action and the props from the request.

The interactor will then pass the data through the following steps before returning a response to the request:

1. Validators: verify the params passed in are correct
2. Preload: create/preload data needed by subsequent steps
3. Policies: ensure the request is authenticated/authorized and necessary data is present
3. Models: CRUD for primary PSQL database
4. Services: handle interactions with external apis if any (mail, phone, etc)
5. Presenters: format the data for the response
6. Routes: handle requests and responses from the webserver
