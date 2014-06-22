class Uranai
  include Mongoid::Document
  include Mongoid::Timestamps
  field :all, type: String
  field :date, type: String
  field :rank, type: Integer
  field :constellation, type: String
  field :comment, type: String
  field :lucky, type: String
  field :advice, type: String
end
