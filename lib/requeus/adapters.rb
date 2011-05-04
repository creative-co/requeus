%w(filesystem rabbit s3 sqs).each do |file|
  require "requeus/adapter/#{file}"
end
