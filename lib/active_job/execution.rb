require 'active_support/rescuable'
require 'active_job/arguments'

module ActiveJob
  module Execution
    extend ActiveSupport::Concern

    included do
      include ActiveSupport::Rescuable
    end

    def execute(job_id, *serialized_args)
      self.job_id    = job_id
      self.arguments = Arguments.deserialize(serialized_args)

      run_callbacks :perform do
        perform *arguments
      end
    rescue => exception
      rescue_with_handler(exception) || raise(exception)
    end

    def perform(*)
      raise NotImplementedError
    end
  end
end
