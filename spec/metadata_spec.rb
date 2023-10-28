#
# TODO: HELP !!!
# I have no idea on how to test it. If you have some clue...
# please write on the dragonruby discord #oss-dr_spec
#
# For now,I think only way to do it, is with a meta test and a way to colect the runned specs list ?
#
#require 'spec_helper'
#require 'fileutils' # Assurez-vous d'inclure le module FileUtils

# NOTE tags can be array of sym or string
#spec :metadata, tags: ['levels'] do |args, assert|
spec :metadata do |args, assert|
  context "metadata can be use to filter some groupe of spec" do
    context "when there is no flag" do
      before do |args, assert|
        @metadata = DrSpecMetadata.new
      end
      # For real focus no focus method we need that dr_spec:
      # 1. can target
      # 2. can have good specific require chaine
      context "when there is no flag" do
        it "can have no focus method" do
          expect(@metadata.check).to eq({focus: false})
        end
        xit "can have focus method"
      end
    end
    context "when there is flag" do
      context "when there is some focus method" do
        xit "it has tag" do
          {spec_tags: ['player'] }
          @metadata = DrSpecMetadata.new tags: ['player']
          expect(@metadata.check).to eq({focus: false})
        end
        xit "it has same tag on cli args and spec" do
          {spec_tags: ['player'] }
          @metadata = DrSpecMetadata.new tags: ['player']
          @metadata.spec_tags = "player,levels"
          expect(@metadata.check).to eq({focus: true})
        end
        xit "todo it has different tag on cli args and spec"
      end
      context "when there is no focus method" do
      end
    end
  end
end
