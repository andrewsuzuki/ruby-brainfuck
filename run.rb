require_relative "brainfuck.rb"
require_relative "app.rb"

brainfuck = Brainfuck.new
app = App.new(brainfuck)

app.run()
