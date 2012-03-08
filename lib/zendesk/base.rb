# encoding: utf-8

module Zendesk
  module Definitions
    def self.included base
      base.send :extend, ClassMethods
      base.send :include, InstanceMethods
    end
    
    module ClassMethods
      include NamedParameters
      
      def format value = nil
        value ? @format = value : @format
      end
      
      def base_uri value = nil
        value ? @base_uri = value : @base_uri
      end

      has_named_parameters :put, :required => :path, :optional => [ :optional, :transform ]
      def put name, options = { }
        synthesize_method name, :put, options.merge(with_payload: true)
      end
      
      has_named_parameters :post, :required => :path, :optional => [ :optional, :transform ]
      def post name, options = { }
        synthesize_method name, :post, options.merge(with_payload: true)
      end
      
      has_named_parameters :delete, :required => :path, :optional => [ :optional ]
      def delete name, options = { }
        synthesize_method name, :delete, options
      end
      
      has_named_parameters :get, :required => :path, :optional => [ :optional ]
      def get name, options = { }
        synthesize_method name, :get, options
      end
      
      private
      def compose_parameter_definitions options
        params = Hash[options.slice(:required, :optional).map{ |k, v| [ k, (v.respond_to?(:each) ?  v : [ v ]) ] }]
        params.tap{ |params| params[:optional] << :as unless (params[:optional] ||= []).include?(:as) }
      end
      
      def required_parameters path
        { required: path.split("/").select{ |n| n =~ /^:/ }.map{ |n| n[1..-1].to_sym } }
      end
      
      def synthesize_method name, action, options
        mname   = :"#{action}_#{name}"
        options = options.merge(required_parameters options[:path])
        has_named_parameters mname, compose_parameter_definitions(options)
        define_method mname do |*args|
          payload = args.first if options[:with_payload]
          params  = args.last
          if transform = options[:transform]
            payload = transform[payload]
          end
          payload = payload.to_xml if payload.is_a? Hash
          path    = compose_request_path(options[:path], params)
          margs   = [ path, payload, params[:as] ].compact
          send action, *margs
        end
      end
    end
    
    module InstanceMethods
      def compose_request_path template, params
        path = template.split("/").map{ |part| part.start_with?(":") ? part[1..-1].to_sym : part }
        params.each do |k, v|
          i = path.index k
          path[i] = v if i
        end
        self.class.base_uri + path.join("/")
      end
    end
  end
  
  class Base
    include Zendesk::Definitions

    recognizes :email, :domain, :password
    def initialize options = { }
      @credentials = Credentials.new(options)
      self.class.base_uri "http://#{@credentials.domain}"
    end
    
    def credentials
      @credentials.clone
    end
    
    attr_reader :status
    
    def delete path, proxy = nil
      resource(path, on_behalf_of: proxy).delete do |response, request, result, &block|
        case response.code
        when 200 then true
        when 302 then response.follow_redirection(request, result, &block)
        else 
          set_status result, response
          false
        end
      end
    end
    
    def get path, proxy = nil
      resource(path, on_behalf_of: proxy).get do |response, request, result, &block|
        case response.code
        when 200 then Crack::XML.parse(response) # TODO: cache response 
        when 503 then nil                        # TODO: return cached response
        when 302 then response.follow_redirection(request, result, &block)
        else 
          set_status result, response
          nil
        end
      end
    end
    
    def post path, payload, proxy = nil
      resource(path, headers: { content_type: "application/xml" }, on_behalf_of: proxy).post(payload) do |response, request, result, &block|
        case response.code
        when 201 then true # result['location']
        when 302 then response.follow_redirection(request, result, &block)
        else 
          set_status result, response
          false
        end
      end
    end

    def put path, payload, proxy = nil
      resource(path, headers: { content_type: "application/xml" }, on_behalf_of: proxy).put(payload) do |response, request, result, &block|
        case response.code
        when 200 then true
        when 302 then response.follow_redirection(request, result, &block)
        else 
          set_status result, response
          false
        end
      end
    end

    def resource path, options = { }
      options = options.merge(user: @credentials.email, password: @credentials.password)
      unless options[:on_behalf_of].nil?
        (options[:headers] ||= {}).merge!("X-On-Behalf-Of" => options[:on_behalf_of])
        options.delete(:on_behalf_of)
      end
      RestClient::Resource.new(path, options)
    end
    
    def set_status result, response
      data    = Crack::XML.parse(response)
      # we do this because error messages in response body could be formatted differently sometimes
      message = if data["errors"]
        data["errors"]["error"]
      else
        data = data["error"]
        "#{data["title"]} #{data["message"]}"
      end
      @status = OpenStruct.new(code: result.code, message: "#{data["title"]} #{data["message"]}")
    end
  end
end
