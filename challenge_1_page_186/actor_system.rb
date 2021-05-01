require 'securerandom'

class ActorSystem
  def initialize()
    @actors = {}
    @actor_threads = {}
  end

  def add_actor(&process_message)
    return if @stopped

    actor_id = SecureRandom.uuid
    actor = Actor.new(self, actor_id, &process_message)
    @actors[actor_id] = actor
    Thread.new { actor.start }
    actor_id
  end

  def remove_actor(actor_id)
    @actors[actor_id] = nil
  end

  def dispatch(actor_id, message)
    return if @stopped
    @actors[actor_id].push_message(message)
  end

  def stop
    @stopped = true

    @actors.each do |key, _value|
      @actors[key]&.stop
      @actors.delete(key)
    end
  end
end

class ActorSystem::Actor
  def initialize(actor_system, actor_id, &block)
    @actor_system = actor_system
    @actor_id = actor_id
    @process_message = block
    @mailbox = []
    @state = {}
  end

  def start
    return if @stopped

    loop do
      if @mailbox.empty? && @stopped
        break
      end

      if @mailbox.empty?
        Thread.pass
        next
      end

      next_message = @mailbox.shift
      @state = instance_exec(next_message, @state, &@process_message)
    end
  end

  def stop
    @stopped = true
  end

  def push_message(message)
    @mailbox.push(message)
  end

  private

  def dispatch(actor_id, message)
    @actor_system.dispatch(actor_id, message)
  end
end