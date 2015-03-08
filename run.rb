require_relative 'brainfuck'
require_relative 'app'

brainfuck = Brainfuck.new
app = App.new(brainfuck)

app.run()
