Admin.controllers :base do

  get :index, :map => "/" do
  	@callsheets = Callsheet.where(:conditions => {:call_time.gte =>Time.now, :account_ids => current_account.id })
  	logger.info "THIS IS OPEN ASSIGMENTS = #{@callsheets.to_json}"
    @un_assigments= Assigment.all(:conditions => {:account_id => current_account.id, :settled => "false"})
    logger.info "this is UNPAID = #{@un_assigments.to_json}" 

    render "base/index"
  end
end
