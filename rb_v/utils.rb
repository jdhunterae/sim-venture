LOG_FILE = { odds: 'odds.log', battle: 'battle.log' }

class Die
  def initialize(sides = 6)
    @sides = sides
  end

  def roll
    rand(@sides) + 1
  end
end

class GameLogger
  LOG_EXT = '.log'
  LOG_DIR = 'log/'

  def initialize(file_name = 'log')
    @file_name = "#{LOG_DIR}#{file_name}#{LOG_EXT}"
    @run_number = parse_run
  end

  def parse_run
    number = 0

    if File.file?(@file_name)
      in_file = open(@file_name, 'r')
      header = in_file.readline
      words = header.split(' ')
      number = words[-2].to_i
      in_file.close
    end

    number + 1
  end

  def clean
    out_file = open(@file_name, 'w')
    out_file.write("== TEST #{@run_number} ==\n")
    out_file.close
  end

  def write(line)
    out_file = open(@file_name, 'a')
    out_file.write("#{line}\n")
  end
end
