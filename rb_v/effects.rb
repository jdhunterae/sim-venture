class Effect
  attr_accessor :action

  def initialize(action)
    @action = action
  end

  def cause(_targets)
    puts '[error]: no cuase defined'
  end
end

class NoEffect < Effect
  def initialize(action)
    super(action)
  end

  def cause(_targets)
    puts "[error]: no effect declared for '#{@action.class.name}'"
  end
end

class DamageEffect < Effect
  def initialize(action)
    super(action)
  end

  def cause(targets)
    if targets
      targets.each do |target|
        target.health = [0, target.health - @action.actor.attack_p].max
        puts "#{@action.actor.name} attacks #{target.name} for #{@action.actor.attack_p} damage..."
        puts "    #{target.name}: #{target.health}/#{target.health_max}"
      end
    else
      puts "[error]: #{@action.actor.name} can't find anything to attack..."
    end
  end
end

class MissEffect < Effect
  def initialize(action)
    super(action)
  end

  def cause(targets)
    if targets
      targets.each { |target| puts "#{@action.actor.name} swings at #{target.name}...and misses" }
    else
      puts "[error]: #{@action.actor.name} can't find anything to miss..."
    end
  end
end

class RunAwayEffect < Effect
  def initialize(action)
    super(action)
  end

  def cause(targets)
    if targets && targets.include?(@action.actor)
      puts "#{@action.actor.name} tries to run..."
      targets.delete(@action.actor)
      puts "    #{@action.actor.name} has escaped the battle."
    else
      puts "[error]: #{@action.actor.name} can't run away from nothing..."
    end
  end
end

class BlockedEffect < Effect
  def initialize(action)
    super(action)
  end

  def cause(targets)
    if targets && targets.include?(@action.actor)
      puts "#{@action.actor.name} tries to run...but can't escape"
    else
      puts "[error]: #{@action.actor.name} can't run away from nothing..."
    end
  end
end

class MagicDamageEffect < Effect
  def initialize(action)
    super(action)
  end

  def cause(targets)
    if targets
      targets.each do |target|
        puts "targets: #{targets}"
        puts "target:  #{target}"
        
        target.health = [0, target.health - @action.actor.attack_m].max
        puts "#{@action.actor.name} launches a barrage of magical missiles at #{target.name} for #{@action.actor.attack_m} damage..."
        puts "    #{target.name}: #{target.health}/#{target.health_max}"
      end
    else
      puts "[error]: #{@action.actor.name} can't find anyone to focus on..."
    end
  end
end

class MagicMissEffect < Effect
  def initialize(action)
    super(action)
  end

  def cause(targets)
    if targets
      targets.each { |_target| puts "#{@action.actor.name} summons up energies...and they fizzle" }
    else
      puts "[error]: #{@action.actor.name} can't find anyone to focus on..."
    end
  end
end
