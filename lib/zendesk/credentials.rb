module Zendesk
  class Credentials
    attr_reader :domain, :email, :password

    def initialize params = { }
      @domain   = params[:domain]
      @email    = params[:email]
      @password = params[:password]

      fall_back_on_env
      fall_back_on_yaml(File.expand_path('.zendesk.yml', Dir.pwd))
      fall_back_on_yaml(File.expand_path('.zendesk.yml', ENV['HOME']))
    end

    private

    def fall_back_on_env
      @domain   ||= ENV['ZENDESK_DOMAIN']
      @email    ||= ENV['ZENDESK_EMAIL']
      @password ||= ENV['ZENDESK_PASSWORD']
    end

    def fall_back_on_yaml(path)
      return unless File.exists?(path)
      cfg = YAML.load_file(path)
      return unless cfg.respond_to?(:[])
      @domain   ||= cfg['domain']
      @email    ||= cfg['email']
      @password ||= cfg['password']
    end
  end
 end