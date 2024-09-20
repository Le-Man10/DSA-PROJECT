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
};
