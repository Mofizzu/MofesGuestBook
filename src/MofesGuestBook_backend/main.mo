import Text "mo:base/Text";

import List "mo:base/List";
import Result "mo:base/Result";
 actor mofe{
  //variables

  //Type declarations
  type event = {
    #Funeral;
    #Birthday;
    #Wedding;
    #WorkMeeting;
    #GetTogether;
  };

  type Guest = {
    firstName : Text;
    lastName : Text;
    event : event;
    eventDetails : Text; //what is the event about
    messageBox : Text;
    //start: Time.Time;
    //end: Time.TIme;
  };

  var guestBook = List.nil<Guest>();
  //Update Queries
  public func createGuest(guest : Guest) : async Result.Result<Text, Text> {

    guestBook := List.push<Guest>(guest, guestBook);
    switch (guestBook) {
      case (?guestBook) { return #ok("guest created") };
      case (null) { return #err("No guestbook") };
    };
  };

  //Regular Queries

  public query func getGuests() : async Result.Result<List.List<Guest>, Text> {
    let size = List.size<Guest>(guestBook);
    if (size == 0) {
      return #err "No guests found";
    } else {
      return #ok guestBook;
    };
  };

  public query func displayGuestMessage(guest : Text) : async Result.Result<List.List<Guest>, Text> {
    let guestFound = List.filter<Guest>(
      guestBook,
      func (findGuest : Guest) : Bool {
        (guest == findGuest.firstName) or (guest == findGuest.lastName);
      },
    );

    if (List.size<Guest>(guestFound) == 0) {
      return #err("No guests found with the provided name!");
    } else {
      return #ok(guestFound);
    }
  };

  public func delete(firstName : Text, lastName: Text) : async Result.Result<Text, Text> {
    let initialSize = List.size<Guest>(guestBook);
    let guestRemainder = List.filter<Guest>(
      guestBook,
      func (findGuest : Guest) : Bool {
        not (firstName == findGuest.firstName and lastName == findGuest.lastName);
      },
    );
    guestBook := guestRemainder;
    if (List.size<Guest>(guestBook) < initialSize) {      
      return #ok("The removal was successful!!");
    } else {
      return #err("No guests found with the provided name!");      
    }
  };

};