from utils import *
from action import *
from character import *
from battle import *


def test_character_stats():
    people = [Fighter(), Cleric(), Mage(), Thief()]

    for person in people:
        print(person.get_sheet())
