dateOptions =
  # display not only 'time' also 'date'
  showDate: true
  # format of 'date'
  date: '%A, %e %B'

format = (->
  if dateOptions.showDate
    dateOptions.date + '\n' +'%H:%M '
  else
    '%H:%M:%S'
)()

command: "date +\"#{format}\""

# the refresh frequency in milliseconds
refreshFrequency: 1000

# for update function
dateOptions: dateOptions

render: (output) -> """
  <div id='simpleClock'>#{output}</div>
"""

update: (output) ->
  if this.dateOptions.showDate
    data = output.split('\n')

    html = ""
    html += "<div class='clock'>"
    html += data[1]
    html += "</div>"
    html += '<div class="date">'
    html += data[0]
    html += '</div>'

  else
    html = output

  $(simpleClock).html(html)

style: (->
  fontSize = '7em'
  width = 'auto'
  transform = 'auto'
  bottom = '3%'
  top = 'auto'

  return """
    color: white
    font-family: SF Pro Rounded
    width: 100%
    height: 33%

    #simpleClock
      font-size: 7em
      font-weight: 200
      text-align: center
      position: absolute
      bottom 0
      left 50%
      transform: translate(-50%,0)
      text-shadow: 0px 0px 20px rgba(0,0,0,0.8)   
    
    #simpleClock .clock
      margin-bottom: -5px

    #simpleClock .date
      font-size: 0.20em
      font-weight: 300
      padding-bottom: 20px
  """
)()
