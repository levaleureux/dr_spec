def run_tests
  $gtk.tests&.passed.clear
  $gtk.tests&.inconclusive.clear
  $gtk.tests&.failed.clear
  puts "💨 running tests"
  $gtk.reset 100
  $gtk.log_level = :on
  $gtk.tests.start

  if $gtk.tests.failed.any?
    puts "🙀 tests failed!"
    failures = $gtk.tests.failed.uniq.map do |failure|
      "🔴 ##{failure[:m]} - #{failure[:e]}"
    end

    if $gtk.cli_arguments.keys.include?(:"exit-on-fail")
      $gtk.write_file("test-failures.txt", failures.join("\n"))
      exit(1)
    end
  else
    puts "🪩 tests passed!"
  end
end

def hello_world
  puts "Hello, world!"
end

=begin
# Définition du hook d'exécution
set_trace_func(proc { |event, file, line, id, binding, classname|
  # Affichage de l'événement, le fichier et le numéro de ligne
  puts "Event: #{event}, File: #{file}, Line: #{line}"
})

# Appel de la méthode
hello_world

# Arrêt du hook d'exécution
set_trace_func(nil)
# Gem pour parser le code source Ruby en AST
require 'parser/current'

# Méthode pour instrumenter une ligne de code dans l'AST
def instrument_line(node, line_number)
  node.updated(nil, node.children.map { |child|
    if child.is_a?(Parser::AST::Node)
      instrument_line(child, line_number)
    else
      child
    end
  }) if node.loc&.line == line_number
end

# Votre fonction à tester
def hello_world
  puts "Hello, world!"
end

# Parse le code source en AST
source_code = <<~RUBY
  def hello_world
    puts "Hello, world!"
  end
RUBY

ast = Parser::CurrentRuby.parse(source_code)

# Instrumente l'AST pour ajouter les appels à `instrument` aux lignes de code
(1..source_code.lines.count).each do |line_number|
  instrument_line(ast, line_number)
end

# Affiche l'AST instrumenté
puts ast.to_sexp

# Évaluer l'AST pour exécuter le code et enregistrer la couverture
@coverage = {}
eval(ast)
puts "Coverage: #{@coverage}"
=end
