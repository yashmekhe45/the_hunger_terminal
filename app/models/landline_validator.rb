class LandlineValidator < ActiveModel::Validator
  def validate(record)
    if(record[:landline].match(/^[0-9]\d{2,4}-\d{6,8}$/)) == nil
      record.errors[:landline] << 'Please enter valid landline number!'
    end
  end
end