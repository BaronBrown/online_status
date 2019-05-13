// Alternative Profile Picture v0.1 by djphil (CC-BY-NC-SA 2.0 BE) (https://forums.osgrid.org/viewtopic.php?f=5&t=5920)
// Heavily modified by Baron Brown @ OSgrid May 2019
string gSTRING__timezone="GMT"; // Set the timezone for your local time
list gLIST__month_name = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]; // Global list to hold the month names
key gKEY__owner_key; // Global key to hold the key of the objects owners key
string gSTRING__owner_name; // Global string variable to hold the object owners name
key gKEY__query; // Global key to hold the query that is sent to the llHTTPRequest used to get the picture
string gSTRING__url = "http://helper.osgrid.org/get_picture_uuid.php?name="; // Global string to hold the URL of the picture helper script. THIS IS SPECIFIC TO OSGRID.
string gSTRING__online_status; // Global string to hold the actual online / offline status from the llRequestAgentData.
float gFLOAT__update_interval = 60; // Global float variable which holds the update interval in seconds.
vector gVECTOR__set_text_colour; // Global vector variable that holds the colour of the settext.

default
{
    state_entry()
    {
        llSetTexture(TEXTURE_BLANK, ALL_SIDES); // Clear existing images from all sides
        gKEY__owner_key = llGetOwner(); // Get the owners key from the object
        gSTRING__owner_name = llKey2Name(gKEY__owner_key); // Convert the key to the owners name
        gSTRING__online_status = llRequestAgentData(gKEY__owner_key, DATA_ONLINE); // Request the agent data t find ut if they are on or off line
        gKEY__query = llHTTPRequest(gSTRING__url + gSTRING__owner_name, [HTTP_METHOD, "GET"], ""); // Query the url set in the declarations to try and obtain the picture
        llSetTimerEvent(gFLOAT__update_interval); // Start the timer for the number of seconds declared
    }
    
    touch_start(integer n)
    {
        llSay(PUBLIC_CHANNEL, "Updating picture for " + gSTRING__owner_name); // On touch, update the picture
        gKEY__query = llHTTPRequest(gSTRING__url + gSTRING__owner_name, [HTTP_METHOD, "GET"], ""); // Query the url set in the declarations to try and obtain the picture
    }

    http_response(key lKEYresponse, integer status, list data, string lSTRINGbody) // This is where the response from the server is processed
    {
        if (lKEYresponse == gKEY__query) // Check to see if the response from the server was the same as the query sent
        {
            lSTRINGbody = llStringTrim(lSTRINGbody, STRING_TRIM); // Remove any white space from the returned string
            if (lSTRINGbody == "00000000-0000-0000-0000-000000000000") llResetScript(); // Check to see if the picture is blank, if it is, reset the script
            llSetTexture(lSTRINGbody, ALL_SIDES); // Set the texture on all sides to the imake key returned from the server
        }
    }
    
    timer() // This is the automatic timer that is called every number of seconds defined in the inital declaration
    {
        gSTRING__online_status = llRequestAgentData(llGetOwner(), DATA_ONLINE); // Update to the global variable that holds the actual online / offline data, this is passed to the dataserver section
    }
    
    dataserver(key queryid, string lSTRING__data)
    {
        string lSTRING__time_now=llGetTimestamp(); // Local string to get the current time
        string lSTRING__time_now_year=llGetSubString(lSTRING__time_now, 0, 3); // Local string to set the current year
        string lSTRING__time_now_month=llGetSubString(lSTRING__time_now, 5, 6); // Local string to set the current month
        integer lINTEGER__time_now_month=(integer)lSTRING__time_now_month; // Local integer to convert the current string month to a number
        lSTRING__time_now_month=llList2String(gLIST__month_name,(lINTEGER__time_now_month-1)); // update and change the month number to an actual name
        string lSTRING__time_now_day=llGetSubString(lSTRING__time_now, 8, 9); // Local integer to set the current day 
        // lSTRING__time_now_day="03"; // Used for testing
        integer lINTEGER__time_now_day=(integer)lSTRING__time_now_day; // Create a integer to hold the string value stripped of any leading 0 (zero)
        lSTRING__time_now_day=(string)lINTEGER__time_now_day; // Pass back the stripped integer to the string  
        if (lSTRING__time_now_day == "1" || lSTRING__time_now_day == "21" || lSTRING__time_now_day == "31")
        {
            lSTRING__time_now_day=lSTRING__time_now_day + "st "; // Set the "01", "21" and "31" to "01st ", "21st " and "31st "
        }
        else if (lSTRING__time_now_day == "2" || lSTRING__time_now_day == "22")
        {
            lSTRING__time_now_day=lSTRING__time_now_day + "nd "; // Set the "02" and "22" to "02nd " and "22nd "
        }
        else if (lSTRING__time_now_day == "3" || lSTRING__time_now_day == "23")
        {
            lSTRING__time_now_day=lSTRING__time_now_day + "rd "; // Set the "03" and "23" to "03rd " and "23rd "
        }
        else
        {
            lSTRING__time_now_day=lSTRING__time_now_day+"th "; // Set all others to "??th "
        }
        string lSTRING__time_now_hour=llGetSubString(lSTRING__time_now, 11, 12); //Local string to set the hour
        string lSTRING__time_now_minute=llGetSubString(lSTRING__time_now, 14, 15); // Local string to set the minutes
        string lSTRING__time_now_second=llGetSubString(lSTRING__time_now, 17, 18); // Local string to set the seconds
        if((integer)lSTRING__data == TRUE) // Check to see if owner is online, if true
        {
            lSTRING__data = "online"; // Set the local variable to online
            gVECTOR__set_text_colour=<0.0, 1.0, 0.0>; // Set the text colour to green
            llSetObjectDesc(lSTRING__time_now); // Set the object description with the current time
            llSetText("The time now is the " + lSTRING__time_now_day + lSTRING__time_now_month + " " + lSTRING__time_now_year + " at " + lSTRING__time_now_hour + ":" + lSTRING__time_now_minute + ":" + lSTRING__time_now_second + gSTRING__timezone + " and\n" + gSTRING__owner_name + " is " + lSTRING__data + ".",gVECTOR__set_text_colour,1); // Set the object text
        }
        else
        {
            lSTRING__data = "Offline";
            gVECTOR__set_text_colour=<1.0, 0.0, 0.0>;
            string lSTRING__time_last_seen = llGetObjectDesc();
            string lSTRING__time_last_seen_year=llGetSubString(lSTRING__time_last_seen, 0, 3);
            string lSTRING__time_last_seen_month=llGetSubString(lSTRING__time_last_seen, 5, 6);
            integer lINTEGER__time_last_seen_month=(integer)lSTRING__time_last_seen_month;
            lSTRING__time_last_seen_month=llList2String(gLIST__month_name,(lINTEGER__time_last_seen_month-1));
            string lSTRING__time_last_seen_day=llGetSubString(lSTRING__time_last_seen, 8, 9);
            if (lSTRING__time_last_seen_day == "01" || lSTRING__time_last_seen_day == "21" || lSTRING__time_last_seen_day == "31")
            {
                lSTRING__time_last_seen_day=lSTRING__time_last_seen_day+"st ";
            }
            else if (lSTRING__time_last_seen_day == "02" || lSTRING__time_last_seen_day == "22")
            {
                lSTRING__time_last_seen_day=lSTRING__time_last_seen_day+"nd ";
            }
            else if (lSTRING__time_last_seen_day == "03" || lSTRING__time_last_seen_day == "23")
            {
                lSTRING__time_last_seen_day=lSTRING__time_last_seen_day+"rd ";
            }
            else
            {
                lSTRING__time_last_seen_day=lSTRING__time_last_seen_day+"th ";
            }
            string lSTRING__time_last_seen_hour=llGetSubString(lSTRING__time_last_seen, 11, 12);
            string lSTRING__time_last_seen_minute=llGetSubString(lSTRING__time_last_seen, 14, 15);
            string lSTRING__time_last_seen_second=llGetSubString(lSTRING__time_last_seen, 17, 18);
            llSetText("The time now is the " + lSTRING__time_now_day + lSTRING__time_now_month + " " + lSTRING__time_now_year + " at " + lSTRING__time_now_hour + ":" + lSTRING__time_now_minute + ":" + lSTRING__time_now_second + gSTRING__timezone + "and\n" + gSTRING__owner_name + " was last seen on the\n" + lSTRING__time_last_seen_day + " " + lSTRING__time_last_seen_month + " " + lSTRING__time_last_seen_year + " at " + lSTRING__time_last_seen_hour +":" + lSTRING__time_last_seen_minute + ":" + lSTRING__time_last_seen_second + gSTRING__timezone + ".",gVECTOR__set_text_colour,1);
            }
   }
}
