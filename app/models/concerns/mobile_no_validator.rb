class MobileNoValidator < ActiveModel::Validator
  def validate(record)
    # match method is not for nil classes
    if (record[:mobile_number] == nil)
      return
    end
    # Regex specifies that mobile number must starts with +91
    if (record[:mobile_number].match(/\A[0-9]{10}\z/)) == nil
      record.errors[:mobile_number] << 'Enter valid mobile no.'
    end
  end
end
