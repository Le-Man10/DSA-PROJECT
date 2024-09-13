import ballerina/http;
import ballerina/time;
import ballerina/io;

// Define Course record
type Course record {
    string courseCode;
    string courseName;
    int nqfLevel;
};

// Define Programme record
type Programme record {
    readonly string programmeCode;
    int nqfLevel;
    string faculty;
    string department;
    string title;
    string registrationDate;
    Course[] courses;
};

// Table to store Programme records, keyed by programmeCode
table<Programme> key(programmeCode) programmeTable = table[];

// HTTP service to handle programme-related operations
service /programmes on new http:Listener(8080) {

    // Add a new programme
    resource function post addNewProgramme(http:Caller caller, http:Request req) returns error? {
        // Get the JSON payload
        json payload = check req.getJsonPayload();
        
        // Convert JSON to Programme record
        Programme programme = check payload.fromJsonWithType(Programme);
        
        // Check if programmeCode already exists
        if programmeTable.hasKey(programme.programmeCode) {
            // Create a response with status 409 (Conflict)
            http:Response response = new;
            response.statusCode = 409;
            response.setJsonPayload({ "message": "Programme with this code already exists!" });
            check caller->respond(response);
            return;
        }

        // Add the new programme to the table
        programmeTable.add(programme);

        // Create a response with status 201 (Created)
        http:Response response = new;
        response.statusCode = 201;
        response.setJsonPayload({ "message": "Programme added successfully!" });
        check caller->respond(response);
    }

    // Get all programmes
    resource function get allProgrammes(http:Caller caller) returns error? {
        // Retrieve all programme records
        check caller->respond(programmeTable.toArray());
    }

    // Retrieve a specific programme by its programme code
    resource function get getProgramme/[string programmeCode](http:Caller caller) returns error? {
        Programme? programme = programmeTable[programmeCode];
        if programme is Programme {
            check caller->respond(programme);
        } else {
            // Respond with status 404 (Not Found)
            http:Response response = new;
            response.statusCode = 404;
            response.setJsonPayload({ "message": "Programme not found" });
            check caller->respond(response);
        }
    }

    //Retrieve all  programmes that are due for review.
    resource function get reiviewDueProgramme(http:Caller caller) returns error? {
        time:Seconds reviewCycle = 5*365*24*60*60;
        io:println("reviewCycle "+reviewCycle.toString());

        time:Utc currentTime = time:utcNow();

        //Filtering Programmes that are due for review
        Programme[] dueProgramme = [];
        foreach Programme programme in programmeTable.toArray() {
            // Parse the registration date to time:Utc
            time:Utc registrationTime = check time:utcFromString(programme.registrationDate);
            time:Seconds elapsedTime = time:utcDiffSeconds(currentTime, registrationTime);
            if  elapsedTime >= reviewCycle {
                io:println("reviewCycle has been breached "+elapsedTime.toString());
                dueProgramme.push(programme);
            }
        }
        check caller->respond({message: dueProgramme});
    }
}
