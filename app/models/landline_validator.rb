class LandlineValidator < ActiveModel::Validator
  def validate(record)
    if record[:landline].match(/^[0-9]\d{2,4}-\d{6,8}$/) == nil
      record.errors[:landline] << 'please enter valid landline no ex.022-203165'
    end
  end
end