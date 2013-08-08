require 'spec_helper'

describe Guard::Strainer do
  let(:default_options) do
    {
      :all_on_pass => true, :all_on_start => true, :fail_fast => true,
      :standalone => false
    }
  end
  subject { described_class.new }

  let(:runner)    { mock(described_class::Runner, :set_rspec_version => nil, :rspec_version => nil) }
  let(:paths)     { ['cookbooks/foobar', 'cookbooks/banjo', 'cookbooks/kerbam'] }

  before do
    described_class::Runner.stub(:new => runner)
  end

  describe '#initialize' do
    it 'creates a runner' do
      described_class::Runner.should_receive(:new).with(default_options.merge(:foo => :bar))
      described_class.new([], :foo => :bar)
    end
  end

  describe '#start' do
    it "calls #run_all" do
      subject.should_receive(:run_all)
      subject.start
    end

    context ':all_on_start option is false' do
      let(:subject) { subject = described_class.new([], :all_on_start => false) }

      it "doesn't call #run_all" do
        subject.should_not_receive(:run_all)
        subject.start
      end
    end
  end

  describe '#run_all' do
    it 'strains all cookbooks' do
      runner.should_receive(:run_all!) { true }

      subject.run_all
    end

    it 'throws task_has_failed if the strain fails' do
      runner.should_receive(:run_all!) { false }

      expect { subject.run_all }.to throw_symbol :task_has_failed
    end
  end

  describe '#run' do
    before do
      runner.stub(:run_all!)
    end

    it 'strains cookbooks for the given paths' do
      runner.should_receive(:run!).with(paths) { true }

      subject.run(paths)
    end

    it 'calls #run_all on success' do
      runner.should_receive(:run!) { true }

      subject.run(paths)
    end

    it 'throws task_has_failed if the strain fails' do
      runner.should_receive(:run!).with(paths) { false }

      expect { subject.run(paths) }.to throw_symbol :task_has_failed
    end

    context ':all_on_pass option is false' do
      let(:subject) { subject = described_class.new([], :all_on_pass => false) }

      it 'should not run_all on success' do
        runner.should_receive(:run!) { true }
        subject.should_not_receive(:run_all)

        subject.run(paths)
      end
    end
  end

  describe '#run_on_additions' do
    it 'delegates to run' do
      subject.should_receive(:run).with(paths).once

      subject.run_on_additions(paths)
    end
  end

  describe '#run_on_modifications' do
    it 'delegates to run' do
      subject.should_receive(:run).with(paths).once

      subject.run_on_modifications(paths)
    end
  end

  describe '#run_on_removals' do
    it 'delegates to run' do
      subject.should_receive(:run).with(paths).once

      subject.run_on_removals(paths)
    end
  end
end
