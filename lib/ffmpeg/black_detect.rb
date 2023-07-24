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
      command = "#{FFMPEG.ffprobe_binary} -hide_banner -analyzeduration 10000000 -probesize 10000000 -f lavfi -i \"movie=#{Shellwords.escape(@movie.path)},blackdetect[out0]\" -show_entries tags=lavfi.black_start,lavfi.black_end -of default=nw=1 -v quiet"
      std_output = ''
      std_error = ''

      Open3.popen3(command) do |stdin, stdout, stderr|
        std_output = stdout.read unless stdout.nil?
        std_error = stderr.read unless stderr.nil?
      end

      fix_encoding(std_output)
      fix_encoding(std_error)

      @times = []

      start_tag = 'TAG:lavfi.black_start='
      end_tag = 'TAG:lavfi.black_end='

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
  end
end
