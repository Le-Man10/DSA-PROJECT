import ballerinax/kafka;
import ballerinax/mongodb;
import ballerina/io;
import ballerina/time;

// Reuse the existing types and enums
enum shipmenttype {
    Standard,
    International,
    Express
}

enum Status {
    StillAtWareHouse,
    OnitsWay,
    Delivered
}

type shipment record {
    shipmenttype deliveryType;
    int deliveryid;
    string CustomerName;
    int ContactNum;
    string PickupLocation;
    string deliveryLocation;
    string PreferredTimes;
    int trackingid;
    Status status;
    int scheduleid;
};

type trackinginfo record {
    int scheduleid;
    shipmenttype deliverytype;
    time:Date deliverytime;
    string customerName;
    int deliveryid;
};

// MongoDB configuration
mongodb:ConnectionConfig dbconfig = {
    connection: {
        host: "localhost",
        port: 27017,
        auth: {
            username: "",
            password: ""
        },
        options: {
            sslEnabled: false,
            serverSelectionTimeout: 5000
        }
    },
    databaseName: "Logistics"
};

string collectionStandardDeliveries = "StandardDeliveries";

mongodb:Client mongoclient = check new (dbconfig);

public function main() returns error? {
    // Kafka producer to send responses back to central logistics
    final kafka:Producer standardProducer = check new (kafka:DEFAULT_URL);

    // Kafka consumer to receive standard delivery requests
    kafka:Consumer standardConsumer = check new (kafka:DEFAULT_URL, {
        groupId: "standard-delivery-group",
        topics: ["Standard"]
    });
     shipment[] requests = check standardConsumer->pollPayload(120);
     kafka:Error? sendreq;
    
        // Poll for new standard delivery requests

        foreach var request in requests {
            // Process the standard delivery request
            trackinginfo response = check processStandardDelivery(request);
               if (request.deliveryType == Standard){
                   
              sendreq = standardProducer->send({
            topic: "Standard",
            value:  response
        });
        if (sendreq is kafka:Error){
            io:println(sendreq.message());
        }
                // Send the response back to central logistics
          
        }
    }
}

function processStandardDelivery(shipment request) returns trackinginfo|error {
    // Store the request in MongoDB
    map<json> document = <map<json>>request.toJson();
    check mongoclient->insert(document, collectionStandardDeliveries);

    // Simulate processing time
    
    time:Date deliveryDate = {year: 2024, month: 5, day: 16};
    // Create and return the tracking info
    trackinginfo response = {
        scheduleid: request.scheduleid,
        deliverytype: Standard,
        deliverytime: deliveryDate,
        customerName: request.CustomerName,
        deliveryid: request.deliveryid
    };

    // Update the status in MongoDB
    //map<json> filter = { "trackingid": request.trackingid };
    //map<json> update = { "$set": { "status": "OnitsWay" } };
    //check mongoclient->update(filter, update, collectionStandardDeliveries);

    return response;
}