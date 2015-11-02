from utils import *
from actions import *
from characters import *
from battles import *


def test_character_stats():
    people = [Fighter(), Cleric(), Mage(), Thief()]

    for person in people:
        print(person.get_sheet())


def test_monsters():
    monsters = [Orc(), Goblin()]

    for monster in monsters:
        print(monster.get_sheet())


def test_battle():
    person = Fighter()
    monster = Goblin()
    battle = Battle(person, monster, True)
    battle.run()


def test_magic():
    person = Mage()
    monster = Goblin()
    battle = Battle(person, monster, True)
    battle.run()

def test_odds():
    odds_log = GameStatsLogger(GameLogger.LOG_FILE["odds"])

    # heroes = [Fighter(), Cleric(), Thief(), Mage()]
    heroes = [Fighter(), Cleric()]
    monsters = [Goblin(), Orc()]

    hero_stats = {}

    for h in heroes:
        hero_stats[type(h).__name__] = {        }
        for m in monsters:
            hero_stats[type(h).__name__][type(m).__name__] = {'win': 0, 'lose': 0, ''}


if __name__ == "__main__":
    # test_character_stats()
    # test_monsters()
    # test_battle()
    # test_magic()
    test_odds()
