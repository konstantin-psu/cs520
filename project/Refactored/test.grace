import "createGraphics2" as g

var graphics := g.createGraphics(500,500)
var circle := graphics.addCircle
circle.radius := 10
circle.color := "red"
circle.fill := true
circle.draw
circle.click := { 
  print("clicked circle") 
  circle.color := "blue"
  circle.location := 130@130
  circle.update
}

var rect := graphics.addRect
rect.location := 100@100
rect.draw
rect.click := { 
  print("clicked rectangle")
  graphics.play("note3")
  circle.location := 100@50
  circle.color := "red"
  circle.update
  graphics.draw
}

var star := graphics.addPolyStar
star.location := 200@200
star.fill := true
star.color := "orange"
star.draw
star.click := { 
  print "star clicked"
  graphics.play("note1") 
}

var roundRect := graphics.addRoundRect
roundRect.location := 200@100
roundRect.radius := 5
roundRect.width := 20
roundRect.height := 20
roundRect.color := "blue"
roundRect.fill := true
roundRect.click := {
  print("clicked round rect")
}
roundRect.draw

var ellipse := graphics.addEllipse
ellipse.location := 50@400
ellipse.width := 10
ellipse.height := 20
ellipse.color := "blue"
ellipse.fill := true
ellipse.draw

var text := graphics.addText
text.location := 300@300
text.content := "Create Graphics"
text.color := "purple"
text.draw
text.click := { print ("clicked text")}

