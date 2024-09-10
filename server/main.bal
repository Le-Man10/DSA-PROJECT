import ballerina/http;

type Course record {
    string courseCode;
    string courseName;
    int nqfLevel;
};

type Programme record {
    readonly string programmeCode;
    int nqfLevel;
    string faculty;
    string department;
    string title;
    string registrationDate;
    Course[] courses;
};

table<Programme> key(programmeCode) programmeTable = table[];

service /programmes on new http:Listener(8080) {

    // Add a new programme
   resource function post addNewProgramme(Programme programme) returns string{
        programmeTable.add(programme);
        return "Programme added successfully";
    }
}
