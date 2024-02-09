module FFMPEG
  class BlackDetect
    attr_reader :times, :output

    def initialize(movie)
      @movie = movie
      @times = []
      @invalid = true
      @output = ''
    end

    def valid?
      not @invalid
    end

    def run
      # ffmpeg will output to stderr
      command = "#{@movie.ffprobe_command} -f lavfi -i \"movie=#{@movie.path},blackdetect[out0]\" -show_entries tags=lavfi.black_start,lavfi.black_end -of default=nw=1 -v quiet"
      std_output = ''
      std_error = ''

      fix_encoding(std_output)
      fix_encoding(std_error)

      @times = []

      start_tag = 'TAG:lavfi.black_start='
      end_tag = 'TAG:lavfi.black_end='

      std_output.split("\n").uniq.each do |line|
        tokens = line.split("=")
        next if tokens.length < 2

        time = tokens[1].to_f

        if line.include?(start_tag)
          @times << {:start => time}
        elsif line.include?(end_tag)
          @times.last[:end] = time
        end
      end

      pair = {:start => nil, :end => nil}

      @output = std_output

      std_output.split("\n").uniq.each do |line|
        tokens = line.split("=")
        next if tokens.length < 2

        time = tokens[1].to_f

        if line.include?(start_tag)
          pair[:start] = time
        elsif line.include?(end_tag)
          pair[:end] = time
        end

        if !pair[:start].nil? && !pair[:end].nil?
          @times << pair
          pair = {:start => nil, :end => nil}
        end
      end

      if std_error != ''
        @invalid = true
        FFMPEG.logger.error(std_error)
      end

      raise Error, "Failed to detect black frames: #{std_output} :: #{std_error}" if std_error != ''

      return @times
    end

    def fix_encoding(output)
      output[/test/] # Running a regexp on the string throws error if it's not UTF-8
    rescue ArgumentError
      output.force_encoding("ISO-8859-1")
    end

    # TODO: delete this
    def uncovered
      if @times.empty?
        [{:start => 0, :end => @movie.duration}]
      else
        uncovered = [test]
        uncovered << {:start => 0, :end => @times.first[:start]} if @times.first[:start] > 0
        @times.each_with_index do |time, index|
          uncovered << {:start => time[:end], :end => @times[index + 1][:start]} if @times[index + 1]
        end
        uncovered << {:start => @tsimes.last[:end], :end => @movie.duration} if @times.last[:end] < @movie.duration
        uncovered

      end
    end

    def uncovered_two
      (0..@times.length).each do |i|
        print i
      end
    end
  end
end
