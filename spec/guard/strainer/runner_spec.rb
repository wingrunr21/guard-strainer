require 'spec_helper'

describe Guard::Strainer::Runner do
  subject { described_class.new({}) }

  let(:paths) { ['spec/fixtures/cookbooks/git/recipes/default.rb',
                 'spec/fixtures/cookbooks/sudo/metadata.rb',
                 'spec/fixtures/cookbooks/tmux/metadata.rb'] }
  let(:strainerfile) { File.join(@fixture_path, 'Strainerfile') }
  let(:cookbooks) { [Pathname.new('git'), Pathname.new('sudo'), Pathname.new('tmux')] }
  let(:runner)    { mock(::Strainer::Runner) }

  before do
    ::Guard::Dsl.stub(:options) { {"guardfile_path" => File.join(@fixture_path, 'fixtures')} }
    ::Strainer::Runner.stub(:new => runner)
    runner.stub(:run!)

    # Do this so the runner is using the correct shell
    ::Thor::Base.shell = ::Strainer::Shell
  end

  describe '#initialize' do
    it 'creates an empty cabinet' do
      expect(subject.cabinet).to be_empty
    end
  end

  describe '#run_all!' do
    before do
      @paths = paths
      @paths[0] = 'spec/fixtures/cookbooks/git/metadata.rb'
    end
    it 'should strain all of the cookbooks' do
      subject.should_receive(:run!).with(@paths)

      subject.run_all!
    end
  end

  describe '#run!' do
    context 'the first time a given cookbook set is run' do
      before do
        subject.cabinet.clear
      end

      it 'should create a new Strainer::Runner and store it in the cabinet' do
        ::Strainer::Runner.should_receive(:new).with(cookbooks, {:strainer_file => strainerfile})

        subject.run!(paths)
      end
    end

    context 'subsequent times a given cookbook set is run' do
      before do
        subject.cabinet[cookbooks] = runner
      end

      it 'should retrieve the Strainer::Runner from the cabinet' do
        ::Strainer::Runner.should_not_receive(:new)

        subject.run!(paths)
      end
    end
  end
end
