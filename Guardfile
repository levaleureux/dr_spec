# Guardfile
require 'guard/shell'

# Définition du groupe de garde
guard :shell do
  watch(%r{^spec/.*_spec\.rb$}) do |m|
    #system('ls -la') # Remplacez 'your_command_here' par votre commande
    system('../dragonruby . --eval app/tests.rb --no-tick --spec-tags player,levels')
  end
end

