require './utils.rb'
require './effects.rb'

class Action
  attr_accessor :actor, :success_effect, :failure_effect

  def initialize(actor)
    @actor = actor
    @success_effect = NoEffect.new(self)
    @failure_effect = NoEffect.new(self)
  end

  def perform(target_options)
    targets = choose_targets(target_options)
    if attempt(targets)
      @success_effect.cause(targets)
    else
      @failure_effect.cause(targets)
    end
  end

  def choose_targets(target_options)
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
    @success_effect = DamageEffect.new(self)
    @failure_effect = MissEffect.new(self)
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
    @success_effect = RunAwayEffect.new(self)
    @failure_effect = BlockedEffect.new(self)
  end
end

class MagicMissleAction < Action
  def initialize(actor)
    super(actor)
    @success_effect = MagicDamageEffect.new(self)
    @failure_effect = MagicMissEffect.new(self)
  end

  def perform(target_options)
    super(target_options)
    @actor.mana = [0, @actor.mana - 1].max
  end

  def attempt(targets)
    if @actor.mana >= 1
      return super(targets)
    else
      return false
    end
  end

  def choose_targets(target_options)
    super(target_options)

    targets = [] << target_options
    targets -= [@actor]

    return targets if targets
    nil
  end
end
