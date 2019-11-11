# frozen_string_literal: true

class Picture
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  embedded_in :photographic, inverse_of: :pictures, polymorphic: true

  has_mongoid_attached_file :attachment,
                            styles: { small: ['100x100^', :jpg],
                                      medium: ['250x250', :jpg],
                                      large: ['500x500>', :jpg],
                                      canopy: ['1200', :jpg] },
                            convert_options: { all: '-background transparent -flatten +matte',
                                               small: '-gravity center -extent 100x100' }
  validates_attachment_size :attachment, in: 1.byte..25.megabytes
  validates_attachment :attachment,
                       content_type: { content_type:
                         ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] }

  # SEE: http://stackoverflow.com/a/23141483/1064917
  def self.from_url(file_location, parent)
    pic = new(photographic: parent)
    pic.do_attach(file_location)
    pic.save!
    pic
  rescue StandardError => e
    data = { file_location: file_location, parent: parent }
    ExceptionNotifier.notify_exception(e, data: data)
    raise e
  end

  def do_attach(file_location)
    if Paperclip::Attachment.default_options[:storage].to_s != 'filesystem'
      attach_via_network(file_location)
    else
      attach_via_filesystem(file_location)
    end
  end

  def attach_via_network(file_location)
    self.attachment = open(file_location)
  end

  def attach_via_filesystem(file_location)
    # if it's already on the system, or it's missing,
    # we don't need to update it.
    is_system = file_location.include?('/system/')
    is_placeholder = file_location.include?('missing.png')
    unless is_system || is_placeholder
      unless file_location.include?('http')
        file_location = "#{Rails.root.join('public')}/#{file_location}"
      end
      self.attachment = open(file_location)
    end
  end
end
