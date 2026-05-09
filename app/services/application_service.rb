class ApplicationService
  def self.call(*args)
    new(*args).call
  end

  def call
    raise NotImplementedError, "Subclasses must implement the call method"
  end
end

class ServiceResponse
  attr_reader :success, :payload, :errors

  def initialize(success:, payload: nil, errors: nil)
    @success = success
    @payload = payload
    @errors = errors
  end

  def self.success(payload)
    new(success: true, payload: payload)
  end

  def self.failure(errors)
    new(success: false, errors: errors)
  end

  def failure?
    errors.present?
  end

  def success?
    success
  end
end
