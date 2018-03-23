class GuideSearch
  attr_reader :filter
  attr_reader :order
  attr_reader :query

  def initialize
    @filter = {}
    @order = { _score: :desc }
    @query = '*'
  end

  def self.search(query = '*')
    new.search(query)
  end

  def search(query = '*')
    @query = query

    self
  end

  def ignore_drafts()
    filter[:draft] = false

    self
  end

  def for_crops(crops)
    filter[:crop_id] = Array(crops).map do |crop|
      crop.respond_to?(:id) ? crop.id : crop
    end

    self
  end

  def with_user(user)
    return self unless user

    @order = {
      'compatibilities.score' => {
        order: 'desc',
        nested_filter: {
          term: { 'compatibilities.user_id' => user.id }
        }
      }
    }

    self
  end

  # Methods for Enumeration.
  def results
    results = Guide.search(query, where: filter, order: order)
    results
  end

  def method_missing(meth, *args, &block)
    if results.respond_to?(meth)
      results.send(meth, *args, &block)
    else
      super
    end
  end

  def respond_to?(meth)
    results.respond_to?(meth)
  end
end
