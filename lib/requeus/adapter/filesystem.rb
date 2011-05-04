require 'fileutils'

module Requeus
  module Adapter
    class Filesystem
      def initialize opts
        @path = opts['path']
        ensure_path
      end

      def put file
        uid = generate_id
        FileUtils.copy file.path, path_for(uid)
        FileUtils.chmod 0666, path_for(uid)
        uid
      end

      def get uid
        return nil unless File.exists?(path_for(uid))
        File.new path_for(uid)
      end
      
      def delete uid
        FileUtils.remove path_for(uid)
        true
      end
      
      private
      
      def path_for uid
        File.join @path, uid
      end
      
      def ensure_path
        FileUtils.mkdir_p(@path) unless File.exists?(@path)
        raise "Path '#{@path}' is not writable" unless File.writable?(@path)
      end

      def generate_id
        UUIDTools::UUID.timestamp_create().to_s
      end

      Requeus::BlobStore.adapters['filesystem'] = self
    end
  end
end
