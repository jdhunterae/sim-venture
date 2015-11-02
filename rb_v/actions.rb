require './utils.rb'
require './effects.rb'

class Action
  attr_accessor :actor, :success_effect, :failure_effect

  def initialize(actor)
    @actor = actor
    @success_effect = NoEffect(self)
    @failure_effect = NoEffect(self)
  end

  def perform(target_options)
    targets = choose_targets(target_options)
    if attempt(targets)
      @success_effect.cause(targets)
    else
      @failure_effect.cause(targets)
    end
  end

  def choose_targets(_target_options)
    if target_options.class.name != [].class.name
      target_options = [target_options]
    end
    target_options
  end

  def attempt(_targets)
    if Die.new(2).roll == 1
      return true
    else
      return false
    end
  end
end

class AttackAction < Action
  def initialize(actor)
    super(actor)
    @success_effect = DamageEffect(self)
    @failure_effect = MissEffect(self)
  end

  def choose_targets(target_options)
    super(target_options)

    target_options.each do |member|
      return [member] unless member == @actor
    end

    nil
  end
end

class EscapeAction < Action
  def initialize(actor)
    super(actor)
    @success_effect = RunAwayEffect(self)
    @failure_effect = BlockedEffect(self)
  end
end


class MagicMissleAction < Action
