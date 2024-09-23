import ballerina/io;
import ballerina/http;

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
json addprogram= {
    programmeCode: "CS101",
        nqfLevel: 7,
        faculty: "Computing",
        department: "Computer Science",
        title: "BSc Computer Science",
        registrationDate: "2024-09-10T00:30:00Z",
        courses: [
            {courseCode: "CS101", courseName: "Introduction to Programming", nqfLevel: 5},
            {courseCode: "CS102", courseName: "Data Structures", nqfLevel: 6}
        ]
};
json updateProgramme={
        programmeCode: "CS101",
        nqfLevel: 8,
        faculty: "Computing",
        department: "Computer Science",
        title: "BSc Computer Science",
        registrationDate: "2024-09-10T00:30:00Z",
        courses: [
            {courseCode: "CS101", courseName: "Introduction to Programming", nqfLevel: 5},
            {courseCode: "CS102", courseName: "Data Structures", nqfLevel: 6}
        ]
};

public function main() returns error?{

    http:Client ProgrammeClient = check new("localhost:8081");
    //Retrieve and display all programmes
    Programme []Programmes= check ProgrammeClient->get("/programmes/allProgrammes");
    io:println("Programmes available : ",Programmes.toJsonString());
    //Add new programme 
     http:Response resp = check ProgrammeClient->post("/programmes/addNewProgramme",addprogram);
    //if programme doesnt exist
    if (resp.statusCode == 201) {
        io:println( resp.getJsonPayload());
    }
    //if programme does exist
    else {
        io:println(resp.getJsonPayload());
    }
    //Retrive specific programme
    string programmeCode = "CS101";
    http:Response a_person = check ProgrammeClient->get("/programmes/getProgramme/" + programmeCode);
    io:println("Get Request", a_person.getTextPayload());
    //Retrieve all programmes that a due for review
    Programme []Programmesdue = check ProgrammeClient->get("/programmes/reiviewDueProgramme");
    io:println("Programmes that are due for review :", Programmesdue.toJsonString());
    //Update existing Programme
    string programmeCode2 = "CS101";
    http:Response update = check ProgrammeClient->put("/programmes/updateProgramme/"+programmeCode2,updateProgramme);
    io:println(update.getJsonPayload());
    //deleting a specific program
    string deletecode = "07BBMA";
    http:Response deleteresp = check ProgrammeClient->delete("/programmes/Programmes/" +deletecode);
    io:println(deleteresp.getTextPayload());
};
