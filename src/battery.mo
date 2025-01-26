import Cycles "mo:base/ExperimentalCycles";
import Nat "mo:base/Nat";
module {

    let PUSHUP_IN_CYCLES = 100_000_000_000;
    let PUSHUP_MAX = 30;
    public type Pushup = Nat; // 1 pushup = 1 T Cycle (1$)
    public type Capacity = Pushup; //

    // Returns the balance of this actor in Number of Pushup
    public func balance() : Nat {
        return Cycles.balance() / PUSHUP_IN_CYCLES;
    };

    // Returns the maximum amount of Pushup in this actor
    public func capacity() : Nat {
        PUSHUP_MAX;
    };

    // Returns the charge of this actor in %
    public func indicator() : Text {
        var energyBar = "";
        let b = balance();
        let c = capacity();

        var i = 0;
        while (i < 10) {
            energyBar := energyBar # (if (i < ((b * 10) / c)) "▮" else "▯");
            i += 1;
        };

        "Energy : " # Nat.toText(b) # "/" # Nat.toText(c) # " [" # energyBar # "]";
    };
};
