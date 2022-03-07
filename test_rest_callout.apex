Http http = new Http();
HttpRequest request = new HttpRequest();
request.setEndpoint('callout:ProjectService');
request.setMethod('POST');
request.setHeader('token','f549aa91-74d4-44c0-baeb-47c666a48966');
request.setHeader('Content-Type','application/json;charset=UTF-8');
request.setBody('{"opportunityId": "0068d000004WckbAAC","opportunityName": "Test","accountName": "ACME Corp, Inc.","closeDate": "2022-10-30",  "amount": 150000}');
HttpResponse response = http.send(request);
system.debug('Response: ' + response);
