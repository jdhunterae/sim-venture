import random

LOG_FILE = {"odds": "odds.log", "battle": "battle.log"}


class Die(object):

    def __init__(self, sides=6):
        self.sides = sides

    def roll(self):
        return random.randint(1, self.sides)


class GameLogger(object):

    def __init__(self, file_name="log.log"):
        self.file_name = file_name
        self.run_number = self.parse_run()

    def parse_run(self):
        number = 0
        with open(self.file_name, "r") as in_file:
            header = in_file.readline()
            words = header.split(" ")
            number = words[-2]
            try:
                number = int(number)
            except:
                pass
        return number + 1

    def clean(self):
        with open(self.file_name, "w") as out_file:
            out_file.write("== TEST %3d ==\n" % self.run_number)

    def write(self, line):
        with open(self.file_name, "a") as out_file:
            out_file.write("%s\n" % line)


class GameStatsLogger(GameLogger):

    def __init__(self, file_name):
        super(GameStatsLogger, self).__init__(file_name)

    def append(self, stats):
        # https://en.wikibooks.org/wiki/Non-Programmer's_Tutorial_for_Python_3/File_IO
        with open(self.file_name, "a") as out_file:
            for hero in stats:
                h_stats = stats[hero]

                out_file.write("::: %s :::\n" % (hero))
                for mon in h_stats:
                    m_stats = h_stats[mon]
                    win, lose, draw = (m_stats["win"], m_stats[
                                       "lose"], m_stats["draw"])
                    tot = win + lose + draw
                    out_file.write("  :: %s ::\n" % (mon))
                    out_file.write("    W %3d  |  L %3d  |  D %3d  |  T %3d\n" % (
                        win, lose, draw, tot))
                    out_file.write("      %3d%% |    %3d%% |    %3d%%\n" %
                                   (100.0 * win / tot, 100.0 * lose / tot, 100.0 * draw / tot))
                    out_file.write("\n")

                out_file.write("\n\n\n\n::: DUMP :::\n" + str(stats))
