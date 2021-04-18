require_relative './command'
require_relative './drawing'
require_relative './drawing_terminal_reporter'

class AbstractCLI
  class << self
    def def_command(
      letter,
      arguments,
      description,
      &block
    )
      letter = letter.to_s

      command_class = Class.new(Command) do
        define_singleton_method(:letter) { letter.to_s }
        define_singleton_method(:arguments) { arguments }
        define_singleton_method(:description) { description }
        define_method(:execute, &block)
      end

      commands_by_letter[letter] = command_class
    end

    def commands
      commands_by_letter.values
    end

    def commands_by_letter
      @commands_by_letter ||= {}
    end

    def prompt
      @prompt ||= begin
        prompt = "=" * 50 + "\n"
        prompt += "Input a command: \n"
        prompt += commands.map do |c|
          "#{c.letter} #{c.arguments} - #{c.description}"
        end.join("\n")
      end
    end
  end

  def initialize
    self.drawing = Drawing.new
    self.drawing_reporter = DrawingTerminalReporter.new
  end

  def start
    loop do
      find_and_execute_command
    rescue InvalidLineError => e
      puts e.message
    end
  end

  private

  attr_accessor :drawing, :drawing_reporter

  def find_and_execute_command
    print_prompt
    line = gets
    command_letter, argument = parse_line(line)
    execute_line(command_letter, argument)
  end

  def print_prompt = puts(self.class.prompt)

  def parse_line(line)
    match = line.match(/\s*(\w{1})\s+(\d*)?/)
    raise InvalidLineError unless match
    [match[1], match[2]]
  end

  def execute_line(command_letter, argument)
    execute_command(command_letter, argument)
    print_drawing_state
  end

  def execute_command(command_letter, argument)
    command_class = find_command_by_letter(command_letter)
    raise CommandNotFoundError unless command_class
    command = command_class.new(drawing, argument)
    command.execute
  end

  def print_drawing_state
    drawing_reporter.report(drawing)
  end

  def find_command_by_letter(command_letter)
    self.class.commands_by_letter[command_letter]
  end

  class InvalidLineError < StandardError
    def message = 'Invalid command'
  end

  class CommandNotFoundError < InvalidLineError
    def message = 'Command not found'
  end
end