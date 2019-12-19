global class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader( 'Content-Type', 'application/json' );
        res.setStatusCode(204);
        return res;
    }
}