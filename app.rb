require 'optparse'

class App
	def initialize(brainfuck)
		@bf = brainfuck
	end

	def open(file)
		raw = nil
		handle_error(lambda { raw = File.read(file) })
		self.load(raw)
	end

	def interact
		puts "Special commands: (q) quit, (r) reset, (d) dump cells, (p) pointer value"

		loop do
			print "$ "
			input = gets.chomp
			case input
			when "q"
				break
			when "r"
				@bf.reset()
			when "d"
				puts @bf.dump_cells()
			when "p"
				puts @bf.pointer
			else
				self.load(input)
				interpret()
			end
		end
	end

	def load(raw)
		handle_error(lambda { @bf.load(raw) })
	end

	def interpret
		handle_error(lambda { @bf.interpret(); puts "" })
	end

	def handle_error(lamb)
		begin
			lamb.call
		rescue Exception => e
			puts "Error: " + e.to_s
		end
	end

	def run
		options = {}
		OptionParser.new do |opts|
			opts.banner = "Usage: run.rb [options]"
			opts.on("-f f", "--file=f", "Brainfuck file to be interpreted") do |file|
				options[:file] = file
			end
		end.parse!

		if options[:file].nil?
			interact()
		else
			open(options[:file])
			interpret()
		end
	end
end
