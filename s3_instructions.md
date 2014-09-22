# Setup an amazon S3 bucket for use with OpenFarm

## About the Openfarm setup

 OpenFarm uses Amazon S3 for storage of media files such as profile and guide images.

 OpenFarm has a a server side permission policy that is used by Rails and PaperClip for deleting / updating images and a 'client side' policy for users to dump unprocessed media into.

## Why?

 This setup is slightly more complicated than a direct upload setup, but creates a number of benefits such as:

  * Freeing web workers from the resource intensive task of accepting large file uploads.
  * Allows OpenFarm to be hosted on services like Heroku, where there is a 30 second request timeout.
  * Allows the API to accept URLs of files hosted elsewhere (not just S3, but services like Imgur/Wordpress Etc..)
  * POSTing URLs instead of files means we can defer the process of downloading/cropping/resizing images to a background worker which creates a better experience for API and Website users.
  * We can pay a third party (currently S3) to manage the file storage infastructure, which frees up developers to work on more pertinent tasks and features.

## How Do Uploads Work Client Side?

### The Easy Way

 1. Host the image somewhere else (Imgur, Photobucket, Flickr, whatever...)

 2. Post the fully formed image URL to `api/guides` within the `{featured_image: "http://..."}` field.

### The Less Easy Way

 1. Make an authenticated GET request to `/api/aws`. The response contains the following fields:
   * A security signature ("signature" field)
   * A security policy ("policy" field)
   * An AWS public access key ("key" field)

 2. Do an HTTP Form post with the following fields:
   * `success_action_status` set to `201`. If not set, AWS will not give you an XML response, which is needed to know the fully formed URL of your temp file.
   * `key` set to `temp/SOME_UNIQUE_IDENTIFIER.jpg`. This is the filename of your tempfile. Client side users are only allowed to put files into the `temp/` folder.
   * `acl` key set to `public-read`.
   * `Content-Type` usually set to something such as `image/jpeg`
   * `AWSAccessKeyId` set to the `key` given in step 1.
   * `policy` set using the `policy` key in step 1.
   * `signature` set using security signature from step 1.
   * `file` the binary image you are uploading.

 3. Parse the URL out of the XML response from step 2. You have 24 hours to POST this URL as the `featured_image` field of a guide.

## Client Side Setup

1. Create a new S3 bucket.
2. Paste the config listed under "CORS Config" by clicking "Edit CORS config" under "Permissions" within the Bucket settings panel.
3. Create an IAM user for the S3 bucket. BE SURE TO COPY THE CREDENTIALS NOW. IT IS YOUR ONLY CHANCE TO DO SO.
4. Paste the credentials into `app_environment_variables.rb` See `app_environment_variables.rb.example` for more info.
5. Create the IAM permissions listed in "IAM Policy - Client" below.
6. Create the IAM permissions listed in "IAM Policy - Client" below.
6. Your bucket should be ready to take uploads at this point.
7. (Suggested, not required) Under the 'lifecycle' tab, set objects within `temp/` to expire after a day.

### CORS Config

```xml
<?xml version="1.0" encoding="UTF-8"?>
<CORSConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
    <CORSRule>
        <AllowedOrigin>*</AllowedOrigin>
        <AllowedMethod>POST</AllowedMethod>
        <AllowedMethod>PUT</AllowedMethod>
        <AllowedHeader>*</AllowedHeader>
    </CORSRule>
</CORSConfiguration>
```

### IAM Policy - Client

**Note:** You need to replace the part that says `YOUR_NAME_HERE`.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": ["s3:PutObject", "s3:PutObjectAcl"],
            "Resource": "arn:aws:s3:::YOUR_NAME_HERE/temp/*"
        }
    ]
}
```

### IAM Policy - Server

**Note:** You need to replace the part that says `YOUR_NAME_HERE`.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:DeleteObject",
        "s3:DeleteObjectVersion",
        "s3:GetObject",
        "s3:GetObjectAcl",
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": [
        "arn:aws:s3:::YOUR_NAME_HERE/*"
      ]
    }
  ]
}
```