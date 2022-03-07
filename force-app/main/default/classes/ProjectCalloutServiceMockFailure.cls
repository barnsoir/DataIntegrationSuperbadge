@isTest
global class ProjectCalloutServiceMockFailure implements HttpCalloutMock{
   //Implement http mock callout here
   global HTTPResponse respond(HttpRequest request) {
      HttpResponse response = new HttpResponse();
      response.setHeader('Content-Type','application/json');
      response.setStatus('Bad Response');
      response.setStatusCode(500);

      return response;
   }
}