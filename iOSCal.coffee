#color settings for calendars
#color is in format suitable for css
#IMPORTANT: enter the names of the local calendars that you want to assign a colour.
# Correspond a colour with each calendar.
#Add or delete lines as appropriate. Unassigned Calendars will appear with white ribbon.
######REMOVE UNASSIGNED LINES OR THE WIDGET WILL NOT WORK!!!!!!!!!#########################

calendars = [
    {name:"CalendarName1",color:"gold"},
    {name:"CalendarName2",color:"mediumseagreen"},
    {name:"CalendarName3",color:"mediumpurple"},
    {name:"CalendarName4",color:"crimson"}
]

#mode of widget (light)
mode = "dark"

#Default color of calendar
defColor = "white"

# Bash command to pull events from icalBuddy
# icalBuddy has more functionality that can be used here

#NOTE: if the widget does not load (Possible in MacOS 10.14 and later) change the command below to the 2nd and add the calendar names listed above after the "-ic" command, separated by a semicolon as per example.

command: "/usr/local/bin/icalbuddy -n -po title,datetime,location -iep title,datetime,location eventsToday+1"

#command: "/usr/local/bin/icalbuddy -n -ic CalendarName1,CalendarName2  -po title,datetime,location -iep title,datetime,location eventsToday+1"

# Update is called once per hour
refreshFrequency: "1h"

#=== DO NOT EDIT AFTER THIS LINE unless you know what you're doing! ===
#======================================================================

# CSS styling
style: """
    color: white
    font-family: SF Pro Rounded
    font-weight: 400
    width: 100%
    height: 220px
    position: absolute
    top: 33%
    font-size: 14px

    #calendar
        border-radius: 10px
        -webkit-backdrop-filter: blur(20px)
        width: 410px
        height: 200px
        position: absolute
        top: 0
        left 50%
        transform: translate(-50%,0)
        padding: 40px 20px 20px 20px
        -webkit-box-shadow: 10px 10px 47px 0px rgba(0,0,0,0.54)
        letter-spacing: 1px

    #calendar.dark
        background-color: rgba(0,0,0,0.45)

    #calendar.light
        background-color: rgba(255,255,255,0.5)
        color: black

    #calendar.light header, #calendar.light .leftBox .time .to, #calendar.light .rightBox .location
        color: rgba(50,50,50,0.8)

    #calendar.dark header, #calendar.dark .leftBox .time .to, #calendar.dark .rightBox .location
        color: rgba(200,200,200,0.8)

    header 
        padding: 10px 0 10px 0
        display: flex
        flex-direction: row
        position: fixed
        top: 0
    
    header img
        width: 20px
        margin-right: 10px
        height: 20px

    header .widgetName
        line-height: 20px

    .mainBox
        overflow-y: scroll
        height: 100%

    .eventBox
        display: flex
        flex-direction: column

    .today h2
        margin-top: 10px
        

    .event
        padding: 5px
        display: flex
        flex-direction: row
        //border-top: 1px solid rgba(200,200,200,0.3)

    .event .title
        line-height: 20px
    
    .event .leftBox
        width: 10%
        padding: 0 10px 0 0
        margin: 0 5px 0 0
        border-right: 2px solid

    .leftBox .time
        text-align: right

    .leftBox .time .from
        line-height: 20px

    .leftBox .time .to
        font-size: 12px;
        line-height: 20px

    .rightBox .location
        font-size: 12px
        line-height: 20px

    .nothing 
        text-align: center
        margin-top: 10px
    
    

"""

# Initial render
render: (output) -> """<div id='calendar' class='#{mode}'>#{output}</div>"""

# Update when refresh occurs
update: (output, domEl) ->

    getCalendarColor = (calendarName) -> 
        for i in calendars
            if i.name == calendarName
                return i.color

        return defColor
        

    lines = output.split('• ')
    lines = lines.map((str) => ({event:str}))

    for i in [0...lines.length]
        lines[i].event = lines[i].event.split('\n')

    lines.splice(0,1)

    for i in [0...lines.length]
        name = lines[i].event[0];
        location = lines[i].event[2];
        if ( location.includes('location:'))
            location = location.replace('location:','') 
            location = location.replace(/\\s/g, '')
        time = lines[i].event[1];
        if (time.includes('    '))
            time = time.replace('    ', '')
        lines[i].event = {"name":name,"location":location,"time":time}

    inner = ''
    inner += "<header><img src='ubersicht-ios-clock-upnext-weather.widget/icons/calendar.png' alt='icon'></img><div class='widgetName'>UP NEXT</div></header>"
    today = []
    tomorrow = []

    for i in [0...lines.length]
        if (lines[i].event.time.includes('today at'))
            lines[i].event.time = lines[i].event.time.replace("today at ","")
            #lines[i].event.name = lines[i].event.name.replace(/\([A-z]*\)/i, "")
            lines[i].event.time = lines[i].event.time.split(' - ')
            today.push(lines[i].event)
            continue
        else if(lines[i].event.time.includes('today')&&!lines[i].event.time.includes('at'))
            lines[i].event.time = lines[i].event.time.replace("today ","")
            lines[i].event.time = "Whole - Day"
            #lines[i].event.name = lines[i].event.name.replace(/\([A-z]*\)/i, "")
            lines[i].event.time = lines[i].event.time.split(' - ')
            today.push(lines[i].event)
            continue
        else if (lines[i].event.time.includes('tomorrow at'))
            lines[i].event.time = lines[i].event.time.replace("tomorrow at ","")
            #lines[i].event.name = lines[i].event.name.replace(/\([A-z]*\)/i, "")
            lines[i].event.time = lines[i].event.time.split(' - ')
            tomorrow.push(lines[i].event)
            continue
        else if(lines[i].event.time.includes('tomorrow')&&!lines[i].event.time.includes('at'))
            lines[i].event.time = lines[i].event.time.replace("tomorrow ","")
            lines[i].event.time = "Whole - Day"
            #lines[i].event.name = lines[i].event.name.replace(/\([A-z]*\)/i, "")
            lines[i].event.time = lines[i].event.time.split(' - ')
            tomorrow.push(lines[i].event)
            continue

    inner += "<div class='mainBox'>" 
    inner += "<div class='today eventBox'>"   
    if today.length > 0
        inner += "<h2>Today</h2>"
        for i in [0...today.length]
            name = today[i].name
            
            calendarName = name.match(/\([a-zA-Z0-9\/\s]*?\)$/gmi)
            calendarName = calendarName[0].replace(/[\(-\)]+/gm,"")
            
            calendarColor = getCalendarColor(calendarName)

            name = name.replace(/\([a-zA-Z0-9\/\s]*?\)$/gmi, "")
            loc = today[i].location
            time = today[i].time
            inner += "<div class='event'><div class='leftBox' style=' border-color: #{calendarColor}'><div class='time'><div class='from'>"
            inner += time[0]
            inner += "</div><div class='to'>"
            inner += time[1]
            inner += "</div></div></div><div class='rightBox'><div class='title'>"
            inner += name
            inner += "</div><div class='location'>"
            inner += loc
            inner += "</div></div></div>"
    else
        inner += "<div class='nothing'>No events today</div>"
    
    inner += "</div>"

    inner += "<div class='tomorrow eventBox'>"
    if tomorrow.length > 0
        inner += "<h2>Tomorrow</h2>"
        for i in [0...tomorrow.length]
            name = tomorrow[i].name
            
            calendarName = name.match(/\([a-zA-Z0-9\/\s]*?\)$/gmi)
            calendarName = calendarName[0].replace(/[\(-\)]+/gm,"")
            
            calendarColor = getCalendarColor(calendarName)
            
            name = name.replace(/\([a-zA-Z0-9\/\s]*?\)$/gmi, "")
            loc = tomorrow[i].location
            time = tomorrow[i].time
            inner += "<div class='event'><div class='leftBox' style=' border-color: #{calendarColor}'><div class='time'><div class='from'>"
            inner += time[0]
            inner += "</div><div class='to'>"
            inner += time[1]
            inner += "</div></div></div><div class='rightBox'><div class='title'>"
            inner += name
            inner += "</div><div class='location'>"
            inner += loc
            inner += "</div></div></div>"
    else
        inner += "<div class='nothing'>No events tomorrow</div>"
    
    inner += "</div>"
    inner += "</div>"

    $(calendar).html(inner)


