require './utils.rb'
require './characters.rb'

class Battle
  LOGGER = GameLogger.new(GameLogger::LOG_FILE[:battle])
  @@num_battles = 0

  def self.tick(logging = false)
    LOGGER.clean if logging && @@num_battles == 0
    @@num_battles += 1
  end

  def initialize(party_1, party_2, logging = false)
    Battle.tick(logging)

    party_1 = [party_1] unless party_1.instance_of?(Array)
    party_2 = [party_2] unless party_2.instance_of?(Array)

    @party_1 = party_1
    @party_2 = party_2

    @is_logging = logging
    if @is_logging
      LOGGER.write("\nBattle.initialize: Start Logging Battle #{@@num_battles}")
    end
  end

  def is_active?(battle_queue)
    party_1_active = 0
    party_2_active = 0

    @party_1.each do |member|
      party_1_active += 1 if battle_queue.include?(member) && member.is_alive?
    end
    if party_1_active < 1
      LOGGER.write('  Battle.is_active?: no one in party_1 - battle over') if @is_logging
      return false
    end

    @party_2.each do |member|
      party_2_active += 1 if battle_queue.include?(member) && member.is_alive?
    end
    if party_2_active < 1
      LOGGER.write('  Battle.is_active?: no one in party_2 - battle over') if @is_logging
      return false
    end

    true
  end

  def run
    battle_queue = @party_1
    battle_queue += @party_2
    battle_queue = battle_queue.sort_by(&:speed)

    while is_active?(battle_queue)
      battle_queue.each do |member|
        member.engage(battle_queue) if member.is_alive?
      end
    end
  end
end
