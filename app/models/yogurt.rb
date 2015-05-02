class Yogurt < ActiveRecord::Base
  validates_presence_of :name, :calories
  validates_numericality_of :calories
end
