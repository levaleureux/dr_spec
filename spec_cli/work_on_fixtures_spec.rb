#require 'spec_helper'
#require 'fileutils' # Assurez-vous d'inclure le module FileUtils

describe 'Manipulation de fichiers' do
	include FileUtils # Inclure le module FileUtils pour utiliser ses méthodes

  before(:each) do
    # Copie du fichier fixture dans un répertoire de travail temporaire
    @temp_dir      = 'spec/tmp'
    @original_file = 'spec/fixtures/a_basic_fixture.rb'
    @res_file      = 'spec/fixtures/a_basic_fixture_res.rb'

    # Construction du chemin complet du fichier temporaire
    @temp_file_path = File.join(@temp_dir, File.basename(@original_file))
    puts @temp_file_path
    puts "@temp_file_path"
    # Copie du fichier fixture dans le répertoire temporaire
    #copy(File.join('spec/fixtures', @original_file), @temp_file_path)
    copy(@original_file, @temp_file_path)
    #FileUtils.copy(@original_file, @temp_file_path)

    # Suppression de la première ligne du fichier temporaire
		File.open(@temp_file_path, 'r+') do |file|
			# Lire la première ligne (la sauter essentiellement)
			file.gets
			# Lire le reste du fichier
			content = file.read
			# Rembobiner le fichier à la position de départ
			file.rewind
			# Écrire le contenu (sans la première ligne) dans le fichier
			file.write(content)
			# Tronquer le fichier pour supprimer le contenu restant
			file.truncate(file.pos)
		end
	end

	it 'le fichier a une ligne de moins' do
		original_line_count = File.readlines(@original_file).count
		modified_line_count = File.readlines(@temp_file_path).count

		compare_files(@temp_file_path, @res_file)
		expect(modified_line_count).to eq(original_line_count - 1)
	end

	after(:each) do
		# Suppression du fichier temporaire après chaque test
		FileUtils.remove(@temp_file_path)
	end
end

