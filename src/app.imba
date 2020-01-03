def snakedirection x,y,dx,dy
  let x0 = 30 * x + 14
  let y0 = 30 * y + 14
  let rot = 0
  rot = 180 if dx == -1
  rot = 90 if dy == 1
  rot = 270 if dy == -1

  <svg:polygon.direction points="-8,-8 8,0 -8,8" transform="translate({x0},{y0}) rotate({rot})">

def snake {snake,dx,dy}
  <svg:g.snake>
    for item, index in snake
      if index == 0
        <svg:g>
          <svg:rect.snake-head x=(30*item.x) y=(30*item.y) width="28" height="28">
          <snakedirection(item.x,item.y,dx,dy)>
      else
        let color = "hsl(120, 100%, {(0.2 + 0.6*index / snake.length)*100}%)"
        <svg:rect x=(30*item.x) y=(30*item.y) width="28" height="28" css:fill=color>

tag snake-game
  def setup
    @startGame()

  def startGame
    @active = true
    @dx = 1
    @dy = 0
    @snake = [{x:10, y:10}, {x:9, y:10}, {x:8, y:10}]
    @fruit = []
    for i in Array.from({length: 30})
      @addRandomFruit()
    @score = 0

  def isFruitAt(x, y)
    @fruit.some do |item|
      (item.x == x && item.y == y)

  def isSnakeAt(x, y)
    @snake.some do |item|
      (item.x == x && item.y == y)

  def addRandomFruit
    while true
      let x = Math.floor(Math.random() * 21)
      let y = Math.floor(Math.random() * 21)
      if @isSnakeAt(x, y) || @isFruitAt(x, y)
        continue
      @fruit.push({x: x, y: y})
      break

  def removeFruitAt(x, y)
    @fruit = @fruit.filter do |f|
      !(f.x == x && f.y == y)

  def gameOver
    @active = false

  def moveSnake
    let snakeHead = @snake[0]
    let nextX = (snakeHead.x + @dx + 21) % 21
    let nextY = (snakeHead.y + @dy + 21) % 21

    if @isSnakeAt(nextX, nextY)
      @gameOver()
    elif @isFruitAt(nextX, nextY)
      @removeFruitAt(nextX, nextY)
      @snake.unshift({x: nextX, y: nextY})
      @score += 1
      @addRandomFruit()
    else
      @snake.unshift({x: nextX, y: nextY})
      @snake.pop()

  def mount
    document.add-event-listener("keydown") do |event|
      @handle_key(event)
      imba.commit()
    setInterval(&,100) do
      if @active
        @moveSnake()
      imba.commit()

  def handle_key(event)
    return @startGame() unless @active
    if event.key == "ArrowLeft"
      return if @dy == 0
      @dx = -1
      @dy = 0
    elif event.key == "ArrowRight"
      return if @dy == 0
      @dx = 1
      @dy = 0
    elif event.key == "ArrowUp"
      return if @dx == 0
      @dx = 0
      @dy = -1
    elif event.key == "ArrowDown"
      return if @dx == 0
      @dx = 0
      @dy = 1

  def render
    <self.snake-game>
      <h2> "Score: { @score }"
      <svg:svg>
        snake(self)
        for item in @fruit
          <svg:circle.fruit cx=(15+30*item.x) cy=(15+30*item.y) r="12">

      <.help> "Keys to change snake direction."

tag app-root
  def render
    <self>
      <header> "Snake"
      <snake-game>

imba.mount <app-root>

### css
header {
  font-size: 64px;
  text-align: center;
}

snake-game {
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
  width: 630px;
  margin: auto;
}

.help {
  margin-top: 1em;
}

svg {
  background-color: #ccf;
  height: 630px;
  width: 630px;
  margin: auto;
}

polygon.direction {
  fill: red;
}

.snake-head {
  fill: black;
}

.fruit {
  fill: red;
}
###
