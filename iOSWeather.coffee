#mode of widget (light)
mode = "dark"

#api Key from OpenWeatherMap API
apiKey = "dfa02a9fcf5fd313582d592f8953b972"

#list of city IDs from API database
cityList = "3060972,724443,723736"

#if you want to use imperial just change to "imperial"
units = "metric"


command: "curl -s 'http://api.openweathermap.org/data/2.5/group?id=#{cityList}&units=#{units}&appid=#{apiKey}'"
#http://api.openweathermap.org/data/2.5/group?id=7046,7049,2008861&units=metric&appid=dfa02a9fcf5fd313582d592f8953b972
refreshFrequency: '15m'

#=== DO NOT EDIT AFTER THIS LINE unless you know what you're doing! ===
#======================================================================

render: (output) -> """
  <div id='weather' class='#{mode}'>#{output}</div>
"""

update: (output) ->
    weatherData = JSON.parse(output)
    console.log(weatherData)

    inner = ""
    inner += "<header><img src='ubersicht-ios-clock-upnext-weather.widget/icons/weather.png' alt='icon'></img><div class='widgetName'>WEATHER</div></header>"

    inner += "<div class='weatherBox'>" 
    
    for i in [0...weatherData.cnt]
        city = weatherData.list[i].name
        condition = weatherData.list[i].weather[0].main
        temperature = Math.round(weatherData.list[i].main.temp)
        rainChance = weatherData.list[i].clouds.all
        windSpeed = Math.round(weatherData.list[i].wind.speed * 10) / 10
        icon = weatherData.list[i].weather[0].icon

        inner += "<div class='city'><div class='leftBox'><img src='ubersicht-ios-clock-upnext-weather.widget/icons/weather/#{icon}.svg' alt='#{icon}'></img></div><div class='middleBox'><div class='cityName'>"
        inner += city
        inner += "</div><div class='condition'>"
        inner += condition
        inner += "</div><div class='rainChance'>Chance of Rain "
        inner += rainChance
        inner += " %</div></div><div class='rightBox'><div class='temperature'>"
        inner += temperature
        inner += "°</div><div class='wind'>"
        inner += windSpeed
        inner += " km/h</div></div></div>"

        console.log(city + condition + temperature)
    
    inner += "</div>"

    $(weather).html(inner)


style: """
    color: white
    font-family: SF Pro Rounded
    font-weight: 400
    width: 100%
    position: absolute
    top: calc(33% + 280px)
    font-size: 14px
    
    #weather
        border-radius: 10px
        background-color: rgba(0,0,0,0.45)
        -webkit-backdrop-filter: blur(20px)
        width: 410px
        height: 70px
        position: absolute
        top: 0
        left 50%
        transform: translate(-50%,0)
        padding: 40px 20px 20px 20px
        -webkit-box-shadow: 10px 10px 47px 0px rgba(0,0,0,0.54)
        letter-spacing: 1px

    #weather.dark
        background-color: rgba(0,0,0,0.45)

    #weather.light
        background-color: rgba(255,255,255,0.5)
        color: black

    #weather.light header
        color: rgba(50,50,50,0.8)

    #weather.dark header
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

    header .widgetName
        line-height: 20px
    
    .weatherBox
        overflow-y: scroll
        height: 100%

    .city
        padding: 5px
        display: flex
        flex-direction: row
        //border-top: 1px solid rgba(200,200,200,0.3)

    .city .leftBox
        width: auto
        padding: 0 10px 0 0
        margin: 0 5px 0 0

    .leftBox img
        width: 57px
        height: 57px

    .city .middleBox
        flex-grow: 1
    
    .middleBox .cityName
        font-size: 20px
        line-height: 20px
        font-weight: 500

    .middleBox .condition
        font-size: 12px
        line-height: 20px
        margin-top: 5px

    .middleBox .rainChance
        font-size: 12px
        line-height: 12px

    .city .rightBox
        width: 20%
        text-align:right

    .rightBox .temperature
        font-size: 40px
        line-height: 45px
        font-weight: 300

    .rightBox .wind
        font-size: 12px
        line-height: 12px
        text-align: center
"""
