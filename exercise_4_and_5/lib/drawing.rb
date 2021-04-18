class Drawing
  attr_reader :lines

  PEN_STATES = %i[up down]

  def initialize
    self.lines = []
    self.cursor = Point.new(0, 0)
  end

  def pen_down = self.pen_state = :down
  def pen_up = self.pen_state = :up
  def move_east(n) = move(n, 0)
  def move_west(n) = move(-n, 0)
  def move_north(n) = move(0, n)
  def move_south(n) = move(0, -n)

  private

  attr_accessor :cursor
  attr_reader :pen_state
  attr_writer :lines

  def move(x, y)
    new_cursor = Point.new(
      cursor.x + x,
      cursor.y + y,
    )

    draw_line_to(new_cursor) if pen_down?

    self.cursor = new_cursor
  end

  def draw_line_to(end_point)
    line = Line.new(cursor, end_point)
    lines.push(line)
  end

  def pen_state=(state)
    @pen_state = state
  end
  def pen_down? = pen_state == :down
  def pen_up? = pen_state == :up

  class Line
    attr_reader :start_point, :end_point

    def initialize(start_point, end_point)
      self.start_point = start_point
      self.end_point = end_point
    end

    private

    attr_writer :start_point, :end_point
  end

  class Point
    attr_reader :x, :y

    def initialize(x, y)
      self.x = x
      self.y = y
    end

    private

    attr_writer :x, :y
  end
end