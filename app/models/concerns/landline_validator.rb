class LandlineValidator < ActiveModel::Validator
  def validate(record)

    # match method is not for nil classes
    if (record[:landline] == nil)
      return
    end
    if (record[:landline].match(/\A0[0-9]{10}\z/)) == nil    
      record.errors[:landline] << 'please enter valid landline no.'
    end
  end
end
