require_relative 'actor_system'

class UUIDGenerator
  def initialize
    @actor_system = ActorSystem.new
    start
  end

  def start
    @uuid_generator_actor =
      Ractor.new do
        last_used_id = 0

        loop do
          message = Ractor.receive
          new_id = last_used_id + 1
          receiver_actor = message.fetch(:respond_to)
          receiver_actor.send(new_id)
          last_used_id = new_id
        end
      end
  end

  def stop
    # @actor_system.stop
  end

  def generate
    @uuid_generator_actor.send({ respond_to: Ractor.current })
    Ractor.receive
  end
end