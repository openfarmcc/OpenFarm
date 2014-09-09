module Api
  # A controller that handles all the non-restful stuff for AWS.
  class AwsController < Api::Controller
    def s3_access_token
      render json: {
        policy:    upload_policy,
        signature: upload_signature,
        key:       ENV['S3_ACCESS_KEY']
      }
    end

    private

    def upload_policy
      @p ||= Base64.encode64(
        { 'expiration' => 1.hour.from_now.utc.xmlschema,
          'conditions' => [
           { 'bucket' =>  ENV['S3_BUCKET_NAME'] },
           ['starts-with', '$key', ''],
           { 'acl' => 'public-read' },
           { success_action_status: '201' },
           ['starts-with', '$Content-Type', ''],
           ['content-length-range', 1, 4 * 1024 * 1024]
         ] }.to_json).gsub(/\n/, '')
    end

    def upload_signature
      sha    = OpenSSL::Digest.new('sha1')
      digest = OpenSSL::HMAC.digest(sha, ENV['S3_SECRET_KEY'], upload_policy)
      Base64.encode64(digest).gsub('\n', '')
    end
  end
end
