require_relative './abstract_cli.rb'

class CLI < AbstractCLI
  def_command(:P, '[1-3]', 'Choose a pen') { drawing.set_pen(argument) }
  def_command(:D, nil, 'Move pen down') { drawing.pen_down }
  def_command(:U, nil, 'Move pen up n units') { drawing.pen_up }
  def_command(:W, 'n', 'Move pen west n units') { drawing.move_west(Integer(argument)) }
  def_command(:E, 'n', 'Move pen east n units') { drawing.move_east(Integer(argument)) }
  def_command(:N, 'n', 'Move pen north n units') { drawing.move_north(Integer(argument)) }
  def_command(:S, 'n', 'Move pen south n units') { drawing.move_south(Integer(argument)) }
end