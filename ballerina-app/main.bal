import ballerina/http;
import ballerina/log;
import ballerina/observe;

service /users on new http:Listener(8080) {

    observe:Counter userCounter = new ("user_requests_total", desc = "Total number of GET /users requests");

    resource function get .() returns json {
        userCounter.increment(); // Count GET requests
        return {
            "message": "User service is running"
        };
    }
}

service /healthz on new http:Listener(8081) {
    resource function get .() returns string {
        // Health check for DB connection
        return "OK";
    }
}
