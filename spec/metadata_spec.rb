#
# TODO: HELP !!!
# I have no idea on how to test it. If you have some clue...
# please write on the dragonruby discord #oss-dr_spec
#
# For now,I think only way to do it, is with a meta test and a way to colect the runned specs list ?
#
#require 'spec_helper'
#require 'fileutils' # Assurez-vous d'inclure le module FileUtils

spec :metadata do
  #include FileUtils # Inclure le module FileUtils pour utiliser ses méthodes

  context "metadata can be use to filter some groupe of spec" do
    let(:command){"../dragonruby . --eval app/tests.rb --no-tick #{tag_filter}"}
    context "when there is no flag" do
      let(:tag_filter){""}
      before(:each) do
      end
      # For real focus no focus method we need that dr_spec:
      # 1. can target
      # 2. can have good specific require chaine
      context "when there is some focus method" do
        it "run the command" do
          system "echo '#{command}'"
          system command
          system "command done"
        end
      end
      context "when there is no focus method" do
      end
    end
    context "when there is flag" do
      let(:tag_filter){"spec-focus-tags player,levels"}
      context "when there is some focus method" do
        it "run the command" do
          system "echo '#{command}'"
          system command
          system "command done"
        end
      end
      context "when there is no focus method" do
      end
    end
  end
end
