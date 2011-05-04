require 'aws'

module Requeus
  module Adapter
    class S3 < Filesystem
      def initialize options
        @options = options
        super 'path' => options['cache_path']
      end

      def put file
        uid = generate_id
        begin
          bucket.put(uid, open(file.path))
        rescue Aws::AwsError
          raise "S3:Failed to upload local file '#{file}' as '#{uid}' to AWS/S3 bucket '#{bucket.name}'"
        end
        uid
      end

      def delete uid
        bucket.delete_key uid
        super uid
      end

      def get uid
        key = bucket.key(uid)
        raise "S3:File 's3://#{bucket.name}/#{uid}' doesn't exists" unless key.exists?
        File.open(path_for(uid), 'w') {|f| f.write(key.data) }
        super uid
      end

      private

      def connection
        @connection ||= Aws::S3.new(@options['access_key_id'], @options['secret_access_key'])
      end
      
      def bucket
        @bucket ||= begin
          bucket = connection.bucket(@options['bucket'])
          bucket = connection.bucket(@options['bucket'], true) unless bucket.exists? #todo: permissions
          bucket
        end
      end

      Requeus::BlobStore.adapters['s3'] = self
    end
  end
end

class Aws::S3::Bucket
  def exists?
    location
    true
  rescue Aws::AwsError
    false
  end
end