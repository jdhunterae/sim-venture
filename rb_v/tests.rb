require './utils.rb'
require './actions.rb'
require './characters.rb'
require './battles.rb'

def test_character_stats
  people = [Fighter.new, Cleric.new, Mage.new, Thief.new]

  people.each { |person| puts person.get_sheet }
end

def test_monsters
  monsters = [Orc.new, Goblin.new]

  monsters.each { |monster| puts monster.get_sheet }
end

def test_battle
  person = Fighter.new
  monster = Goblin.new
  battle = Battle.new(person, monster, true)
  battle.run
end

def test_magic
  person = Mage.new
  monster = Goblin.new
  battle = Battle.new(person, monster, true)
  battle.run
end

def main
  # test_character_stats
  # test_monsters
  # test_battle
  test_magic
end

main
