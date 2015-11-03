

class Die
  def initialize(sides = 6)
    @sides = sides
  end

  def roll
    rand(@sides) + 1
  end
end

class GameLogger
  LOG_FILE = { odds: 'odds', battle: 'battle' }
  LOG_EXT = '.log'
  LOG_DIR = 'log/'

  def initialize(file_name = 'log')
    @file_name = "#{LOG_DIR}#{file_name}#{LOG_EXT}"
    @run_number = parse_run
  end

  def parse_run
    number = 0

    if File.file?(@file_name)
      File.open(@file_name, 'r') do |in_file|
        header = in_file.readline
        words = header.split(' ')
        number = words[-2].to_i
      end
    end

    number + 1
  end

  def clean
    File.open(@file_name, 'w') { |out_file| out_file.write("== TEST #{@run_number} ==\n") }
  end

  def write(line)
    File.open(@file_name, 'a') { |out_file| out_file.write("#{line}\n") }
  end
end

class GameStatsLogger < GameLogger
  def initialize(file_name)
    super(file_name)
    clean
  end

  def append(stats)
    File.open(@file_name, 'a') do |out_file|
      stats.each do |hero|
        h_stats = stats[hero]

        out_file.write("::: #{hero} :::\n")
        h_stats.each do |mon|
          m_stats = h_stats[mon]
          win = m_stats['win']
          lose = m_stats['lose']
          draw = m_stats['draw']
          tot = win + lose + draw

          out_file.write("  :: #{mon} ::\n")
          out_file.write("    W %3d  |  L %3d  |  D %3d  |  T %3d\n".format(win, lose, draw, tot))
          out_file.write("      %3d%% |    %3d%% |    %3d%%\n".format(100.0 * win / tot, 100.0 * lose / tot, 100.0 * draw / tot))
          out_file.write("\n")
        end
      end
      out_file.write("\n\n\n\n::: DUMP :::\n#{stats}")
    end
  end
end
