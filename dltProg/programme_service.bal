import ballerina/http;


type Course record {
    string courseCode;
    string courseName;
    int nqfLevel;
};

type Programme record {
    string proCode;
    string title;
    int nqfLevel;
    string faculty;
    string department;
    string regDate;
    Course[] courses;
};

// Define the map at the top level to be accessible
map<Programme> proTable = {
    "P001": {
        proCode: "P001",
        title: "BSc of Computer Science",
        nqfLevel: 7,
        faculty: "Computing and Informatics",
        department: "Computer Studies",
        regDate: "2022-02-15",
        courses: [
            {courseCode: "CSC101", courseName: "Introduction to Programming", nqfLevel: 4},
            {courseCode: "CSC201", courseName: "Data Structures and Algorithms", nqfLevel: 5},
            {courseCode: "CSC301", courseName: "Operating Systems", nqfLevel: 6}
        ]
    },
    "P002": {
        proCode: "P002",
        title: "BSc of Business Admin",
        nqfLevel: 5,
        faculty: "Management Science",
        department: "Business Management",
        regDate: "2023-02-02",
        courses: [
            {courseCode: "BUS101", courseName: "Introduction to Business", nqfLevel: 4},
            {courseCode: "BUS202", courseName: "Organizational Behavior", nqfLevel: 5},
            {courseCode: "BUS303", courseName: "Strategic Management", nqfLevel: 6}
        ]
    },
    "P003": {
        proCode: "P003",
        title: "BSc of Engineering in Civil Eng",
        nqfLevel: 8,
        faculty: "Engineering",
        department: "Civil Engineering",
        regDate: "2024-02-20",
        courses: [
            {courseCode: "ENG101", courseName: "Engineering Mathematics", nqfLevel: 4},
            {courseCode: "ENG202", courseName: "Fluid Mechanics", nqfLevel: 6},
            {courseCode: "ENG303", courseName: "Structural Analysis", nqfLevel: 7}
        ]
    }
};

service /programmes on new http:Listener(9000) {

    resource function delete Programmes/[string proCode]() returns http:Response {
        http:Response response = new http:Response();

        if proTable.hasKey(proCode) {
            _ = proTable.remove(proCode);
            response.statusCode = 204; // No Content
        } else {
            response.statusCode = 404; // Not Found
            response.setPayload("Programme Not Found");
        }

        return response;
    }
};