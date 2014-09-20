# Not actually used by anything as of 9/2014, but useful for debugging with
# AWS SDK. This defaults to the 'untrusted' client IAM rather than the master
# bucket that Paperclip uses.
AWS.config(access_key_id: ENV['S3_ACCESS_KEY'],
           secret_access_key: ENV['S3_SECRET_KEY'])
