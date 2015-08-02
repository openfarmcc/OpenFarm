class Picture
  include Mongoid::Document
  include Mongoid::Paperclip

  embedded_in :photographic, inverse_of: :pictures, polymorphic: true

  has_mongoid_attached_file :attachment,
    styles: { small:  ['100x100^', :jpg],
              medium: ['250x250',  :jpg],
              large:    ['500x500>', :jpg] },
    convert_options: { all: '-background transparent -flatten +matte',
                       small: '-gravity center -extent 100x100' }
  validates_attachment_size :attachment, in: 1.byte..25.megabytes
  validates_attachment :attachment,
                       content_type: { content_type:
                         ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] }

  # SEE: http://stackoverflow.com/a/23141483/1064917
  class << self
    def from_url(url, parent)
      pic = new(photographic: parent)
      pic.attachment = open(url)
      pic.save!
      pic
    end

    handle_asynchronously :from_url
  end
end
