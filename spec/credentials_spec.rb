# encoding: utf-8

require "spec_helper"

describe Zendesk::Credentials do

  before do
    FakeFS.activate!
    ENV['ZENDESK_DOMAIN'] = nil
    ENV['ZENDESK_EMAIL'] = nil
    ENV['ZENDESK_PASSWORD'] = nil
  end

  after do
    FakeFS.deactivate!
  end

  context 'credentials from ~/.zendesk.yml' do

    let(:dir) { File.expand_path('/tmp/foo', __FILE__) }
    let(:home) { ENV['HOME'] }
    subject { Dir.chdir(dir) { Zendesk::Credentials.new } }

    before do
      ENV['ZENDESK_DOMAIN'] = 'env.example.com'

      FileUtils.mkdir_p dir
      File.open(File.join(dir, '/.zendesk.yml'), 'w') do |f|
        f << YAML.dump({ 'domain' => 'cwd.zendesk.com', 'email' => 'cwd@example.com' })
      end

      FileUtils.mkdir_p home
      File.open(File.join(home, '/.zendesk.yml'), 'w') do |f|
        f << YAML.dump({ 'domain' => 'home.zendesk.com', 'email' => 'home@example.com', 'password' => 'homepassword' })
      end
    end

    it('first looks in ENV') { subject.domain.should == 'env.example.com' }
    it('then looks in CWD')  { subject.email.should == 'cwd@example.com' }
    it('then looks in HOME') { subject.password.should == 'homepassword' }
  end
end