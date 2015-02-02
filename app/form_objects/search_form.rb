class SearchForm < FormObjectBase
  property :query

  validates :query, presence: true
end
