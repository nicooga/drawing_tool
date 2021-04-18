class DrawingTerminalReporter
  def report(drawing)
    puts '======================================='
    puts 'Drawing lines:'
    drawing.lines.each do |line|
      puts "#{point_to_s(line.start_point)} => #{point_to_s(line.end_point)}"
    end
    puts '======================================='
  end

  private

  def point_to_s(point)
    "(#{point.x}, #{point.y})"
  end
end