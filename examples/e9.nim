
# e9.nim: Simple Calendar example

import std/times
import ngui


proc main =
  # ALWAYS start with app()
  let app = app()
  let output = label("Click on a day")
  let calendar = calendar() # calendar(now()/initDateTime()) works too
  let button = button("Be Immortal")

  output.wrap = true

  calendar.onChangeDo:
    let date = calendar.selected
    output.text = "You will die in " & date.getDateStr
    if calendar.marked(date.monthDay): echo "Bingo!"    
    
  calendar.mark(5)
  
  button.onClickDo:
    calendar.selected =
      calendar.selected + initDuration(weeks = 100 * 12 * 4)
    output.text = "Surely the opposite of life is not the death, but life is eternal"

  app.add(output, calendar, button)
  # NEVER add new elements to app after run()
  run(app)

main()