import ballerina/http;
import ballerina/time;
import ballerina/io;
import ballerina/log;

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


    //Deleting a programme
    resource function delete Programmes/[string programmeCode]() returns http:Response {
        http:Response response = new http:Response();

        if programmeTable.hasKey(programmeCode) {
            _ = programmeTable.remove(programmeCode);
            response.statusCode = 204; // No Content
        } else {
            response.statusCode = 404; // Not Found
            response.setPayload("Programme Not Found");
        }

        return response;
    }


    // Resource function to update a programme
    resource function put updateProgramme(http:Caller caller, http:Request req, string programmeCode) returns error? {
        // Get the JSON payload from the request
        json|error reqPayload = req.getJsonPayload();

        if (reqPayload is json) {
        // Convert the JSON payload to a Programme type
            Programme|error updatedProgramme = reqPayload.cloneWithType(Programme);

            if (updatedProgramme is Programme) {
                // Check if the programme exists in the table
                Programme? existingProgrammeOpt = programmeTable[programmeCode];

                if (existingProgrammeOpt is Programme) {
                    // Update mutable fields of the programme
                    Programme existingProgramme = existingProgrammeOpt;
                    existingProgramme.title = updatedProgramme.title;
                    existingProgramme.nqfLevel = updatedProgramme.nqfLevel;
                    existingProgramme.faculty = updatedProgramme.faculty;
                    existingProgramme.department = updatedProgramme.department;
                    existingProgramme.registrationDate = updatedProgramme.registrationDate;
                    existingProgramme.courses = updatedProgramme.courses;

                    // Save the updated programme back to the table
                    programmeTable.put(existingProgramme);
                    log:printInfo("Programme updated successfully: " + programmeCode);

                    // Respond with success
                    check caller->respond({
                        message: "Programme updated successfully",
                        programme: existingProgramme
                    });
                } else {
                    log:printError("Programme not found: " + programmeCode);
                    // Respond with not found status
                    check caller->respond({
                        status: http:STATUS_NOT_FOUND,
                        message: "Programme not found"
                    });
                }
            } else {
                log:printError("Invalid request payload structure");
                // Respond with bad request status
                check caller->respond({
                    status: http:STATUS_BAD_REQUEST,
                    message: "Invalid request payload structure"
                });
            }
        } else {
            log:printError("Invalid JSON payload");
            // Respond with bad request status
            check caller->respond({
                status: http:STATUS_BAD_REQUEST,
                message: "Invalid JSON payload"
            });
        }
    }
};
