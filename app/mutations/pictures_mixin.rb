module PicturesMixin

  # Complexity of this method is way too high. Let's refactor some time.
  #   - @RickCarlino
  def validate_images (images, obj=nil)
    images && images.each do |pic|
      pic_id = "#{pic[:id]}" if pic[:id].present?
      pictures = obj.pictures if obj

      outcome = Pictures::CreatePicture.validate(url: pic[:image_url],
                                                 id: pic_id,
                                                 pictures: pictures)
      unless outcome.success?
        add_error :images,
                  :bad_format,
                  outcome.errors.message_list.to_sentence
      end
    end
  end

  def set_images (images, obj)
    # Delete all pictures
    # This is much simpler, less ping pong than what it was
    # and probably okay for now. However, this only works when S3
    # is enabled, because paperclip normally stores on system, not on URLs.
    new_images = choose_images_to_delete images, obj

    obj.processing_pictures = new_images.count
    obj.save
    new_images && new_images.each do |img|

      Delayed::Job.enqueue CreatePicFromUrlJob.new(img[:image_url], obj)
      # Picture.from_url(img[:image_url],
      #                obj)
    end
  end

  def choose_images_to_delete (images, obj)
    unless images
      images = []
    end

    image_ids = images.map do |img|
      img[:id].to_s
    end

    delete_ids_array = []

    obj.pictures.each do |pic|
      if !image_ids.include? pic[:id].to_s
        delete_ids_array.push(pic[:id])
      end
    end
    obj.pictures.where(:id.in => delete_ids_array).delete

    images.select { |img| !img[:id] }
  end
end
