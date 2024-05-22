class Customer::EntryAcceptor
  def initialize(customer)
    @customer = customer
  end

  def accept(program)
    raise if Time.current < program.application_start_time
    return :closed if Time.current >= program.application_end_time
    ActiveRecord::Base.transaction do
      program.lock!
      if program.entries.where(customer_id: @customer.id).exists?    #特定の顧客（@customer）がそのプログラムにエントリーしているかどうかを調べる,二重申し込みチェック
        return :accepted
      elsif max = program.max_number_of_participants
        if program.entries.where(canceled: false).count < max         #キャンセルされていないエントリー数が最大参加者数より少ないかどうかを確認する条件
          program.entries.create!(customer: @customer)
          return :accepted
        else
          return :full
        end
      else
        program.entries.create!(customer: @customer)
        return :accepted
      end
    end
  end
end
