require "seed_builder/version"
require "active_record"
require "pry"

require "carrierwave" # TODO: fix to require if it exists
require "paperclip"
require "carrierwave/orm/activerecord"

require "seed_builder/core"
require "seed_builder/domain"
require "seed_builder/entity"
require "seed_builder/attribute"
require "seed_builder/type"
require "seed_builder/valid_data"
require "seed_builder/upload"
