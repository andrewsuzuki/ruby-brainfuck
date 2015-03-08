class Brainfuck
	attr_reader :commands, :cells, :pointer, :code, :code_pointer, :loops

	def initialize(size = 30_000)
		@commands = ["<", ">", "+", "-", "[", "]", ".", ","]
		reset(size)
	end

	def reset(size = 30_000)
		@cells = Array.new(size, 0)
		@pointer = 0

		@code = []
		@code_pointer = 0
		@loops = Hash.new 
	end

	# Loading and interpreting

	def load(raw)
		code = raw.split("")

		clean = []

		loops = []

		non_matching_loops = lambda {|bracket| raise "Non-matching loops (extra \"" + bracket +"\")." }

		code.each_with_index do |command, index|
			next unless valid_command(command) # skip if not valid
			clean.push(command)

			if command == "[" then loops[index] = -1 end
			if command == "]"
				found = false

				loops.to_enum.with_index.reverse_each do |close, open|
					if close == -1
						found = true
						loops[open] = index
						break
					end
				end

				non_matching_loops.call("]") unless found
			end
		end

		loops.each {|close| non_matching_loops.call("[") if close == -1 }

		loops.each_with_index {|close, open| @loops[open + @code.length] = close + @code.length unless close.nil? }

		@code += clean
	end

	def interpret
		until @code_pointer >= @code.length
			case @code[@code_pointer] 
			when "<" then left
			when ">" then right
			when "+" then plus
			when "-" then minus
			when "[" then bracket_open
			when "]" then bracket_close
			when "." then period
			when "," then comma
			end

			@code_pointer += 1
		end
	end

	# Debugging

	def dump_cells
		print "[ " + cells.join(" ") + " ]\n"
	end

	# Helpers

	def valid_command(command)
		commands.include? command
	end

	def cell_zero?
		cell == 0
	end

	def cell
		@cells[@pointer]
	end

	# Brainfuck Commands

	def left
		if @pointer == 0 then raise "Out of cell range" end
		@pointer -= 1
	end

	def right
		if @pointer == (cells.length - 1) then raise "Out of cell range" end
		@pointer += 1
	end

	def plus
		@cells[@pointer] += 1
	end

	def minus
		@cells[@pointer] -= 1
	end

	def bracket_open
		if cell_zero? then @code_pointer = @loops[@code_pointer] end
	end

	def bracket_close
		@code_pointer = @loops.key(@code_pointer) - 1
	end

	def period
		print @cells[@pointer].chr rescue Exception
	end

	def comma
		@cells[@pointer] = gets.chomp.to_i
	end
end
