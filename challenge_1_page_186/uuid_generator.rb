require_relative 'actor_system'

class UUIDGenerator
  def initialize
    @actor_system = ActorSystem.new
    start
  end

  def start
    @uuid_generator_actor =
      @actor_system.add_actor do |message, state|
        last_used_id = state[:last_used_id] || 0
        new_id = last_used_id + 1
        dispatch(message.fetch(:respond_to), new_id)
        state.merge(last_used_id: new_id)
      end
  end

  def stop
    @actor_system.stop
  end

  def generate
    id = nil

    receiver_actor =
      @actor_system.add_actor do |message, state|
        id = message
        state
      end

    @actor_system.dispatch(@uuid_generator_actor, { respond_to: receiver_actor })

    sleep(0.1) until id != nil

    @actor_system.remove_actor(receiver_actor)

    id
  end
end