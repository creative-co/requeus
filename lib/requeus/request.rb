require 'tempfile'
require 'net/http'
require 'net/http/post/multipart'

# Stub for running outside Rails
module ActionDispatch; module Http; class UploadedFile; end; end; end

module Requeus
  class Request
    def initialize method, path, params, headers, file_uids = nil
      @method = method
      @path = path
      @params  = params.reject{|_, v| as_file(v)}
      @headers = headers
      
      if file_uids
        @files = file_uids
      else
        @files = params.reject{|_, v| !as_file(v)}
        @files.each {|k, v| @files[k] = upload_file(as_file(v)) if as_file(v)}
      end
    end
    
    def self.from_json json
      r = JSON.parse(json)
      new r['method'], r['path'], r['params'], r['headers'], r['files']
    end
    
    def do_request endpoint
      uri = URI.parse endpoint + @path

      req_klass = case @method.upcase
        when 'GET'
          Net::HTTP::Get
        when 'POST'
          Net::HTTP::Post
        when 'PUT'
          Net::HTTP::Put
        when 'DELETE'
          Net::HTTP::Delete
      end

      res = Net::HTTP.start uri.host, uri.port do |http|
        if @files.present?
          params = @params.dup
          @files.each do |k, uid|
            params[k] = UploadIO.new(download_file(uid), "application/octet-stream")
          end
          req = req_klass::Multipart.new uri.path, params
        else
          req = req_klass.new uri.path
          req.form_data = to_http_data(@params) if req_klass::REQUEST_HAS_BODY
        end
        
        @headers.each{|k,v| req.add_field(k, v)}
        
        http.request req
      end
      
      if res.is_a? Net::HTTPOK
        true
      else
        puts "Error #{res.code} returned for request:"
        puts self.to_json
        false
      end
    end
    
    def delete_files
      @files.each do |_, uid|
        blob_sequence.any?{|bs| bs.delete uid}
      end
    end
    
    private
    
    def upload_file file
      blob_sequence.each do |bs|
        uid = bs.put file
        return uid if uid
      end
    end

    def download_file uid
      blob_sequence.each do |bs|
        file = bs.get uid
        return file if file
      end
    end

    def blob_sequence
      Requeus::Impl.instance.blob_sequence
    end
    
    def as_file param
      case param
        when File, Tempfile
          param
        when ActionDispatch::Http::UploadedFile
          param.tempfile
        else
          nil
      end
    end

    #todo: make recursion
    def to_http_data params
      result = {}
      params.each do |k, v|
        if v.is_a?(Hash)
          v.each do |k1, v1|
            result["#{k.to_s}[#{k1.to_s}]"] = v1
          end
        else
          result[k.to_s] = v
        end
      end
      result
    end
  end
end
