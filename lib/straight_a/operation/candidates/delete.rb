# frozen_string_literal: true

module StraightA
  module Operation
    module Candidates
      class Delete
        attr_reader :candidate, :source

        # Use +find_by+ instead of +find+ so as not to
        # throw an ActiveRecord::RecordNotFound
        #
        def initialize(params)
          @candidate = Candidate.find_by(id: params[:id])
          @source = candidate.source
        end

        def operable?
          candidate.present?
        end

        def operate!
          candidate.destroy!
        end
      end
    end
  end
end
