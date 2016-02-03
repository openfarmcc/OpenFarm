class CreatePicFromUrlJob
  attr_accessor :url, :obj

  def initialize(url, obj)
    @url = url
    @obj = obj
  end

  def perform
    Picture.from_url(@url, @obj)
  end

  # def before(job)
  #   @obj.processing_pictures = @obj.processing_pictures + 1
  #   @obj.save
  # end

  def after(job)
    @obj.processing_pictures = @obj.processing_pictures - 1
    @obj.save
  end

  def queue_name
    'pictures_queue'
  end
end
