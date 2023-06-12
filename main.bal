// import ballerina/io;
import ballerina/log;
import ballerina/tcp;
import ballerina/io;
import ballerinax/health.hl7v2;
import ballerinax/health.hl7v23;

// Bind the service to the port. 
service on new tcp:Listener(9090) {

    // This remote method is invoked when the new client connects to the server.
    remote function onConnect(tcp:Caller caller) returns tcp:ConnectionService {
        log:printInfo("Client connected to HL7 server: " + caller.remotePort.toString());
        return new HL7ServiceConnectionService();
    }
}

service class HL7ServiceConnectionService {
    *tcp:ConnectionService;

    remote function onBytes(tcp:Caller caller, readonly & byte[] data) returns tcp:Error? {
        string|error fromBytes = string:fromBytes(data);
        if fromBytes is string {
            log:printInfo("Received HL7 Message: " + fromBytes);
        }

        // Note: When you know the message type you can directly get it parsed.
        hl7v23:QRY_A19|error parsedMsg = hl7v2:parse(data).ensureType(hl7v23:QRY_A19);
        if parsedMsg is error {
            return error(string `Error occurred while parsing the received message: ${parsedMsg.message()}`, 
            parsedMsg);
        }
        log:printInfo(string `Parsed HL7 message: ${parsedMsg.toJsonString()}`);
    }

    remote function onError(tcp:Error err) {
        io:print(string `An error occurred while receiving HL7 message: ${err.message()}. Stack trace: `, 
        err.stackTrace());
    }

    remote function onClose() {
        log:printInfo("Client left");
    }
}
