import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Result "mo:base/Result";
import Text "mo:base/Text";

import Http "http";
import Time "time";
shared ({ caller = superuser }) actor class PC() = this {

    public type Result<Ok, Err> = Result.Result<Ok, Err>;
    public type Time = Time.Time;
    public type BOOT = Nat; // Total supply of $BOOT is limited to 21 Million
    public type SEB = Nat; // 1 BOOT = 10^8 SEB
    public type R3 = Nat;

    public type Action = {
        #write : Text;
    };

    public type Log = {
        time : Time;
        log : Text;
    };

    stable var logs : [Log] = [];

    public shared ({ caller }) func play(
        action : Action
    ) : async Result<Text, Text> {
        assert (caller == superuser);
        switch (action) {
            case (#write(log)) {
                logs := Array.append<Log>(logs, [{ time = Time.now(); log }]);
                return #ok("Your log was saved, Soldier!");
            };
        };
    };

    func journal() : Text {
        var t : Text = "";
        var counter : Nat = logs.size();
        for (log in Array.reverse(logs).vals()) {
            t #= "Player's log #" # Nat.toText(counter) # "\n"
            # "Date: " # Nat.toText(log.time) # "\n"
            # "Entrance: " # log.log # "\n"
            # "======\n\n";
            counter -= 1;
        };
        return t;
    };

    public query func http_request(
        req : Http.Request
    ) : async Http.Response {
        return ({
            body = Text.encodeUtf8(journal());
            headers = [("Content-Type", "text/plain")];
            status_code = 200;
            streaming_strategy = null;
        });
    };

};
