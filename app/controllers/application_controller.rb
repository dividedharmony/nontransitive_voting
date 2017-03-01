class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery with: :exception

  def run(operation_class, success: nil, failure: nil)
    @operation = operation_class.new(params)
    if @operation.operable?
      @operation.operate!
      method(success) if success
    elsif failure
      method(failure).call
    end
  end

  def form(formula_class, failure: nil)
    @formula = formula_class.new(params)
    if @formula.formable?
      @formula.formulate!
    elsif failure
      method(failure).call
    end
  end
end
