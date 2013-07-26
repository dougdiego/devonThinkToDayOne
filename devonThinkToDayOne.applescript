(*
diego.org
Export DevonThink Items to Day One
Version 0.1
July 24 , 2013

// CREDIT
The inspiration for this script came from:
http://veritrope.com/code/devonthink-to-evernote-export/
http://veritrope.com/code/export-evernote-items-to-day-one/

// TERMS OF USE:
This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License. 
To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

// REQUIREMENTS
** THIS SCRIPT REQUIRES YOU TO DOWNLOAD THE DAYONE COMMAND LINE APP:
http://dayoneapp.com/downloads/dayone-cli.pkg


*)

(* 
======================================
// USER SWITCHES (YOU CAN CHANGE THESE!)
======================================
*)

-- IF YOU'D LIKE THE SCRIPT TO CREATE A 
-- "HEADER LINE" FOR THE DAY ONE ENTRY USING
-- THE TITLE OF THE EVERNOTE ITEM, THEN
-- CHANGE THIS VALUE TO "ON"É
property dayHeader : "OFF"

-- IF THIS PROPERTY IS SET TO "ON",
-- THEN IT WILL EXPECT THE TITLES
-- TO BE IN THE FORMAT "20130718-notes"
-- THE DATE OF THE JOURNAL ENTRY WILL BE
-- PARSED FROM THIS TITLE
property extractDateFromTitle : "ON"

(* 
======================================
// PROPERTIES (USE CAUTION WHEN CHANGING)
======================================
*)
property noteName : ""
property noteCreated : ""
property noteText : ""
property noteRichText : ""
property noteLink : ""
property noteDate : ""

(* 
======================================
// MAIN PROGRAM 
======================================
*)
tell application "DEVONthink Pro"
	set this_count to 0
	set selected_Items to selection
	repeat with selected_Item in selected_Items
		
		-- Get the DevonThink note data
		my getDevonthink_Info(selected_Item)
		
		-- Convert note text to pain string
		set noteText to my convert_Plaintext(noteRichText)
		
		-- Convert date to plain text date string	
		if extractDateFromTitle is "ON" then
			set noteDate to my convert_title_to_date(noteName)
		else
			set noteDate to my convert_Date(noteCreated)
		end if
		
		-- Make new Day One item
		my make_DayOne(noteName, noteDate, noteText)
		
		-- Increment counter
		set this_count to this_count + 1
		
	end repeat
	
	display alert "Complete" message "Created " & (this_count as string) & " entries in Day One"
	
end tell

(* 
======================================
// DevonTHINK
======================================
*)

--Get DevonTHINK Data
on getDevonthink_Info(this_item)
	tell application "DEVONthink Pro"
		try
			
			set noteKind to (the kind of this_item)
			if (MIME type of this_item) contains "image" then set theKind to "Image"
			set noteRichText to (the rich text of this_item)
			set noteName to (the name of this_item)
			if length of noteName > 254 then set noteName to (characters 1 thru 254 of noteName) as string
			set noteURL to (the URL of this_item)
			set noteText to (the rich text of this_item)
			set noteSource to (the source of this_item)
			set notePath to (the path of this_item)
			set noteCreated to (the creation date of this_item)
			set noteModDate to (the modification date of this_item)
			
			-- Debug
			(*
			display alert "noteName" message (noteName as string)
			display alert "noteText" message (noteText as string)
			display alert "noteLink" message (noteLink as string)
			display alert "noteCreated" message (noteCreated as string)
			display alert "noteModDate" message (noteModDate as string)
			*)
			
		end try
	end tell
end getDevonthink_Info

(* 
======================================
// Day One
======================================
*)

-- Make Day One item
on make_DayOne(noteName, note_Date, note_Text)
	if dayHeader is "ON" then
		--ADD A "HEADER" AND MAKE THE ENTRY
		set note_Text to (noteName & return & return & note_Text)
		set new_DayOne to "echo " & (quoted form of note_Text) & " | '/usr/local/bin/dayone' -d=\"" & note_Date & "\" new"
		do shell script new_DayOne
	else
		--MAKE THE ENTRY WITH NO "HEADER"
		set new_DayOne to "echo " & (quoted form of note_Text) & " | /usr/local/bin/dayone -d=\"" & note_Date & "\" new"
		do shell script new_DayOne
	end if
end make_DayOne


(* 
======================================
// Utils
======================================
*)

-- Convert HTML to plain text
on convert_Plaintext(noteHTML)
	set shell_Text to "echo " & (quoted form of noteHTML) & " | textutil -stdin -convert txt -stdout"
	set note_Text to do shell script shell_Text
	return note_Text
end convert_Plaintext

-- Convert date to plain text date string
on convert_Date(noteCreated)
	set AppleScript's text item delimiters to ""
	set m to ((month of noteCreated) * 1)
	set d to (day of noteCreated)
	set y to (year of noteCreated)
	set t to (time string of noteCreated)
	set date_String to (m & "/" & d & "/" & y & " " & t) as string
	return date_String
end convert_Date

-- Convert note title to plain text date string
on convert_title_to_date(noteTitle)
	
	-- Split the note tiltle into words
	set date_elements to every word of noteTitle
	
	-- initilize the date
	set the_date to current date
	set {time of the_date, day of the_date} to {0, 1}
	--set month of the_date to (item 2 of date_elements) as integer
	
	-- year
	set yearSubstring to (get characters 1 thru 4 of (item 1 of date_elements)) as string
	set year of the_date to yearSubstring as integer
	
	-- month 
	set monthSubstring to (get characters 5 thru 6 of (item 1 of date_elements)) as string
	set month of the_date to monthSubstring as integer
	
	-- day 
	set daySubstring to (get characters 7 thru 8 of (item 1 of date_elements)) as string
	set day of the_date to daySubstring as integer
	
	--log the_date
	return the_date
	
end convert_title_to_date