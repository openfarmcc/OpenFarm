class Picture
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  embedded_in :photographic, inverse_of: :pictures, polymorphic: true

  has_mongoid_attached_file :attachment,
    styles: { small:  ['100x100^', :jpg],
              medium: ['250x250',  :jpg],
              large:  ['500x500>', :jpg],
              canopy: ['1200', :jpg] },
    convert_options: { all: '-background transparent -flatten +matte',
                       small: '-gravity center -extent 100x100' }
  validates_attachment_size :attachment, in: 1.byte..25.megabytes
  validates_attachment :attachment,
                       content_type: { content_type:
                         ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] }

  # SEE: http://stackoverflow.com/a/23141483/1064917
  class << self
    def from_url(file_location, parent)
      puts parent
      pic = new(photographic: parent)
      if Paperclip::Attachment.default_options[:storage].to_s != 'filesystem'
        pic.attachment = open(file_location)
      else # it's a filesystem update
        # if it's already on the system, or it's missing,
        # we don't need to update it.
        unless file_location.include?('/system/') ||
               file_location.include?('missing.png')
          unless file_location.include?('http')
            file_location = "#{Rails.root.join('public')}/#{file_location}"
          end
          puts file_location
          pic.attachment = open(file_location)
        end
      end
      pic.save!
      pic
    end
  end
end
