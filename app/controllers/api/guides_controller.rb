module Api
  class GuidesController < Api::Controller
    def create
      crop = Guide.new(guide_params)
      if crop.save
        render json: crop
      else
        render json: crop.errors, status: :unprocessable_entity
      end
    end

    def s3
      # AKIAJ6RMTJ4UZZLRJS7A
      # GKy7MnL4EbLboLUqL/p2NTbRR5AyS8IrmhiS1ms+
      render json: {
        policy:    s3_upload_policy,
        signature: s3_upload_signature,
        key:       'AKIAJ6RMTJ4UZZLRJS7A'
      }
    end
private
    def guide_params
      output           = params.permit(:crop_id, :name, :overview)
      output[:user_id] = current_user
      output
    end
# = = = = =

    def s3_upload_policy
      @p ||= Base64.encode64(
        {
          "expiration" => 1.hour.from_now.utc.xmlschema,
          "conditions" => [ 
            { "bucket" =>  'farmbot' },
            [ "starts-with", "$key", "" ],
            { "acl" => "public-read" },
            [ "starts-with", "$Content-Type", "" ],
            [ "content-length-range", 0, 10 * 1024 * 1024 ]
          ]
        }.to_json).gsub(/\n/,'')
    end

    def s3_upload_signature
      Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), 'AKIAJ6RMTJ4UZZLRJS7A', s3_upload_policy)).gsub("\n","")
    end
# = = = = =
  end
end
