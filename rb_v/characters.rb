require './utils.rb'
require './actions.rb'

class Character
  attr_accessor :name, :health, :health_max, :attack_p, :defense_p, :mana, :mana_max, :attack_m, :defense_m, :speed, :experience, :inventory, :level, :experience_to_next_level, :actions
  def initialize(name = '[error]', health = 1, attack_p = 1, defense_p = 1, mana = 0, attack_m = 0, defense_m = 0, speed = 1, experience = 1, inventory = {})
    @name = name
    @health = health
    @health_max = health
    @attack_p = attack_p
    @defense_p = defense_p
    @mana = mana
    @mana_max = mana
    @attack_m = attack_m
    @defense_m = defense_m
    @speed = speed
    @experience = experience
    @level = 1
    @experience_to_next_level = -1
    @inventory = inventory

    @actions = []
    @attack_action = AttackAction(self)
    @escape_action = EscapeAction(self)
    @actions << @attack_action
    @actions << @escape_action

    @state = :normal
  end

  def update_state
    if @state == :normal
      @state = :bloody if @health <= 0.3 * @health_max
    elsif @state == :bloody
      @state = :normal if @health > 0.3 * @health_max
    end
  end

  def is_dead?
    @health <= 0
  end

  def is_alive?
    @health > 0
  end

  def engage(battle_queue)
    round_action = choose_action(battle_queue)
    round_action.perform(battle_queue)
  end

  def choose_action(_battle_queue)
    @attack_action
  end

  def get_sheet
    sheet = "== %-20s === LV %2d | [%8s]\n".format(@name, @level, self.class.name.upcase)
    sheet += "   heal  (  %3d / %3d )  mana  (  %3d / %3d )\n".format(@health, @health_max, @mana, @mana_max)
    sheet += "   phys  < %2d >  [ %2d ]               exp: %3d\n".format(@attack_p, @defense_p, @experience)
    sheet += "   magi  < %2d >  [ %2d ]\n".format(@attack_m, @defense_m)
    sheet
  end
end

class Player < Character
  def initialize(name = '[error]', health = 1, attack_p = 1, defense_p = 1, mana = 0, attack_m = 0, defense_m = 0, speed = 1, experience = 1, inventory = {})
    super(name, health, attack_p, defense_p, mana, attack_m, defense_m, speed, experience, inventory)
    @experience_to_next_level = 10
  end

  def get_sheet
    sheet = "== %-20s === LV %2d | [%8s]\n".format(@name, @level, self.class.name.upcase)
    sheet += "   heal  (  %3d / %3d )  mana  (  %3d / %3d )\n".format(@health, @health_max, @mana, @mana_max)
    sheet += "   phys  < %2d >  [ %2d ]               exp: %3d\n".format(@attack_p, @defense_p, @experience)
    sheet += "   magi  < %2d >  [ %2d ]            to nxt: %3d\n".format(@attack_m, @defense_m, @experience_to_next_level)
    sheet
  end
end

class Fighter < Player
  def initialize
    super('Steve', 10, 5, 5, 2)
  end
end

class Cleric < Player
  def initialize
    super('Carl', 8, 4, 4, 4, 1, 1)
  end
end

class Mage < Player
  def initialize
    super('Gary', 6, 2, 2, 6, 3, 3)
    @magic_action = MagicMissleAction(self)
    @actions << @magic_action
  end

  def choose_action(_battle_queue)
    return @magic_action if @mana >= 1
    @attack_action
  end
end

class Thief < Player
  def initialize
    super('Jimmy', 8, 3, 3, 4, 2, 2, 2)
  end
end

class Monster < Character
  def initialize(name = '[error]', health = 1, attack_p = 1, defense_p = 1, mana = 0, attack_m = 0, defense_m = 0, speed = 1, experience = 1, inventory = {})
    super(name, health, attack_p, defense_p, mana, attack_m, defense_m, speed, experience, inventory)
  end

  def choose_action(_battle_queue)
    update_state

    return @escape_action if @state == :bloody
    @attack_action
  end
end

class Goblin < Monster
  def initialize
    super('a goblin', 8, 3, 4, speed = 2)
  end
end

class Orc < Monster
  def initialize
    super('an orc', 10, 4, 3)
  end
end
