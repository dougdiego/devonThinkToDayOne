devonThinkToDayOne
==================

An AppleScript to export item(s) from [DEVONthink](http://www.devontechnologies.com/products/devonthink/overview.html) to [Day One](http://dayoneapp.com).

## Requirements
Download and install Day One Command Line Interface: http://dayoneapp.com/downloads/dayone-cli.pkg

## Instructions
1. Open DEVONthink and select the entries you want to export.  You can select 1 or more than 1.
2. Run the script.  An entry will be made into Day One for each entry you selected in DEVONthink.

## Configurations
To make the name of the DEVONthink entry a header in Day One, set the following property to ON:
```   
property dayHeader : "OFF"
```

By default the create date of the entry in DEVONthink is used as the entry date in Day One. I organize my entries in DEVONthink like: 20110101-journal, 20110102-journal.  If you use this format, set the following property to "ON"
```   
property extractDateFromTitle : "OFF"
```
Note: you can modifiy the script if you use a diffent format for you note name.

## Credit
The inspiration for this script came from:
* http://veritrope.com/code/devonthink-to-evernote-export/
* http://veritrope.com/code/export-evernote-items-to-day-one/
