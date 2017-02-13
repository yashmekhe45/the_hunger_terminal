class LandlineValidator < ActiveModel::Validator
  def validate(record)
    if (record[:landline] == nil)
      return
    end
    if (record[:landline].match(/\A(0\d{2}-\d{8})|(0\d{3}-\d{7})|(0\d{4}-\d{6})\z/) == nil)
      record.errors[:landline] << 'please enter valid landline no eg.022-20316523'
    end
  end
end