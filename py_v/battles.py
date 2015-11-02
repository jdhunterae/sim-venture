from utils import *
from characters import *


class Battle(object):
    logger = GameLogger(GameLogger.LOG_FILE["battle"])
    num_battles = 0

    @staticmethod
    def tick(logging=False):
        if logging and Battle.num_battles is 0:
            Battle.logger.clean()
        Battle.num_battles += 1

    def __init__(self, party_1, party_2, logging=False):
        Battle.tick(logging)

        if not isinstance(party_1, list):
            party_1 = [party_1]
        if not isinstance(party_2, list):
            party_2 = [party_2]

        self.party_1 = party_1
        self.party_2 = party_2

        self.is_logging = logging
        if self.is_logging:
            Battle.logger.write("\nBattle.__init__(): Start Logging Battle #%3d" % (
                Battle.num_battles))

    def is_active(self, battle_queue):
        party_1_active = 0
        party_2_active = 0

        for member in self.party_1:
            if member in battle_queue and member.is_alive():
                party_1_active += 1

        if party_1_active < 1:
            if self.is_logging:
                Battle.logger.write(
                    "  Battle.is_active(): no one in party_1 - battle over")
                return False

        for member in self.party_2:
            if member in battle_queue and member.is_alive():
                party_2_active += 1

        if party_2_active < 1:
            if self.is_logging:
                Battle.logger.write(
                    "  Battle.is_active(): no one in party_2 - battle over")
                return False
        return True

    def run(self):
        battle_queue = self.party_1 + self.party_2
        battle_queue.sort(key=lambda member: member.speed)

        while(self.is_active(battle_queue)):
            for member in battle_queue:
                if member.is_alive():
                    member.engage(battle_queue)
